package controller.customer;

import dao.UserDao;
import model.User; 
import com.google.gson.Gson; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession; 

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException; 
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet("/upload")
public class UploadProfilePictureServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String UPLOAD_DIRECTORY;
    private Gson gson = new Gson(); 

    @Override
    public void init() throws ServletException {
        String applicationPath = getServletContext().getRealPath("");
        UPLOAD_DIRECTORY = applicationPath + File.separator + "images"; 

        File uploadDir = new File(UPLOAD_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("DEBUG: Created upload directory: " + UPLOAD_DIRECTORY);
        }
        System.out.println("DEBUG: Upload directory initialized: " + UPLOAD_DIRECTORY);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        System.out.println("\n--- DEBUG: Entering UploadProfilePictureServlet doPost ---");
        System.out.println("DEBUG: Request URL: " + request.getRequestURL());
        System.out.println("DEBUG: Request URI: " + request.getRequestURI());
        System.out.println("DEBUG: Context Path: " + request.getContextPath());

        HttpSession session = request.getSession(false); 
        if (session == null) {
            System.out.println("DEBUG: Session is null.");
            sendErrorResponse(response, "Session không hợp lệ. Vui lòng đăng nhập lại.", HttpServletResponse.SC_UNAUTHORIZED); 
            return;
        }

        User currentUser = (User) session.getAttribute("user"); // Đã xác nhận key là "user"
        if (currentUser == null) {
            System.out.println("DEBUG: User object in session is null for key 'user'.");
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này.", HttpServletResponse.SC_UNAUTHORIZED); 
            return;
        }

        int userId = currentUser.getId();
        String username = currentUser.getUserName();
        System.out.println("DEBUG: Logged in user from session - User ID: " + userId + ", Username: " + username);

        if (username == null || username.trim().isEmpty() || userId == 0) { 
             System.out.println("DEBUG: Invalid user info extracted from session. userId=" + userId + ", username=" + username);
             sendErrorResponse(response, "Thông tin người dùng không hợp lệ hoặc thiếu.", HttpServletResponse.SC_BAD_REQUEST);
             return;
        }

        try {
            Part filePart = request.getPart("profilePicture");
            System.out.println("DEBUG: filePart obtained. Part name: " + filePart.getName() + ", Size: " + filePart.getSize() + " bytes");

            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("DEBUG: No file or empty file received.");
                sendErrorResponse(response, "Vui lòng chọn ảnh để tải lên.", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            String contentType = filePart.getContentType();
            System.out.println("DEBUG: Uploaded file Content-Type: " + contentType);
            if (contentType == null || !contentType.startsWith("image/")) { 
                System.out.println("DEBUG: Invalid Content-Type: " + contentType);
                sendErrorResponse(response, "Chỉ chấp nhận file ảnh.", HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE); 
                return;
            }
            
            if (filePart.getSize() > (10 * 1024 * 1024)) { // 10MB
                System.out.println("DEBUG: File size too large: " + filePart.getSize() + " bytes.");
                sendErrorResponse(response, "Kích thước ảnh không được vượt quá 10MB.", HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE); 
                return;
            }

            String safeUsername = username.replaceAll("[^a-zA-Z0-9.-]", "_"); 
            Path userSpecificUploadPath = Paths.get(UPLOAD_DIRECTORY, "user", safeUsername);
            System.out.println("DEBUG: User specific upload directory: " + userSpecificUploadPath.toAbsolutePath());
            Files.createDirectories(userSpecificUploadPath); // Đảm bảo thư mục tồn tại

            String fileName = filePart.getSubmittedFileName();
            String fileExtension = "";
            if (fileName != null && fileName.contains(".")) {
                fileExtension = fileName.substring(fileName.lastIndexOf("."));
            }
            System.out.println("DEBUG: Original file name: " + fileName + ", Extension: " + fileExtension);

            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            Path filePath = userSpecificUploadPath.resolve(uniqueFileName);
            System.out.println("DEBUG: Saving file to: " + filePath.toAbsolutePath());

            UserDao userDao = new UserDao(); 
            User userFromDb = userDao.getUserById(userId); 
            System.out.println("DEBUG: User fetched from DB: " + (userFromDb != null ? userFromDb.getUserName() : "null"));
            
            if (userFromDb != null && userFromDb.getAvatarUrl() != null && !userFromDb.getAvatarUrl().equals("images/user/default_avatar.png")) {
                if (userFromDb.getAvatarUrl().startsWith("images/")) {
                    Path oldAvatarPath = Paths.get(getServletContext().getRealPath(""), userFromDb.getAvatarUrl());
                    System.out.println("DEBUG: Old avatar path to delete: " + oldAvatarPath.toAbsolutePath());
                    if (Files.exists(oldAvatarPath)) {
                        try {
                            Files.delete(oldAvatarPath);
                            System.out.println("DEBUG: Successfully deleted old avatar: " + oldAvatarPath);
                        } catch (IOException e) {
                            System.err.println("ERROR: Could not delete old avatar: " + oldAvatarPath + " - " + e.getMessage());
                        }
                    } else {
                        System.out.println("DEBUG: Old avatar file does not exist at: " + oldAvatarPath);
                    }
                } else {
                    System.out.println("DEBUG: Old avatar URL does not start with 'images/', skipping deletion.");
                }
            }

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                System.out.println("DEBUG: File copied successfully to " + filePath.toAbsolutePath());
            }

            String newAvatarUrlInDB = "images/user/" + safeUsername + "/" + uniqueFileName;
            System.out.println("DEBUG: New avatar URL for DB: " + newAvatarUrlInDB);
            
            if (userFromDb != null) {
                userFromDb.setAvatarUrl(newAvatarUrlInDB); 
                
                boolean updateSuccess = userDao.update(userFromDb); 
                System.out.println("DEBUG: DAO update success: " + updateSuccess);
                
                if (updateSuccess) {
                    session.setAttribute("user", userFromDb); 
                    System.out.println("DEBUG: User object in session updated successfully with new avatar URL.");
                    
                    String newAvatarUrlForClient = request.getContextPath() + "/" + newAvatarUrlInDB;
                    Map<String, String> successResponse = new HashMap<>();
                    successResponse.put("message", "Tải ảnh đại diện thành công!");
                    successResponse.put("newAvatarUrl", newAvatarUrlForClient);
                    
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write(gson.toJson(successResponse));
                    System.out.println("DEBUG: Sent success JSON response.");
                } else {
                    Files.deleteIfExists(filePath); 
                    System.out.println("DEBUG: DB update failed, deleted uploaded file: " + filePath.toAbsolutePath());
                    sendErrorResponse(response, "Lỗi khi cập nhật đường dẫn ảnh vào cơ sở dữ liệu.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else {
                System.out.println("DEBUG: UserFromDb is null after fetching by ID. This should not happen if session is valid.");
                sendErrorResponse(response, "Không tìm thấy người dùng để cập nhật ảnh.", HttpServletResponse.SC_NOT_FOUND); 
            }

        } catch (SQLException e) { 
            System.err.println("ERROR: Database error during file upload: " + e.getMessage());
            e.printStackTrace(); 
            sendErrorResponse(response, "Lỗi cơ sở dữ liệu: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (ServletException e) {
            System.err.println("ERROR: ServletException during file upload: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi khi xử lý yêu cầu tải ảnh: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (IOException e) {
            System.err.println("ERROR: IOException during file upload: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi server khi tải ảnh lên: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) { 
            System.err.println("ERROR: Unexpected error during file upload: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace(); 
            sendErrorResponse(response, "Đã xảy ra lỗi không mong muốn: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        System.out.println("--- DEBUG: Exiting UploadProfilePictureServlet doPost ---\n");
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        Map<String, String> errorData = new HashMap<>();
        errorData.put("message", message);
        String jsonError = gson.toJson(errorData);
        response.getWriter().write(jsonError); 
        System.out.println("DEBUG: Sent error JSON response (Status " + statusCode + "): " + jsonError);
    }
}
