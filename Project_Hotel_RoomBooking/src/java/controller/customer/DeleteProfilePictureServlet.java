package controller.customer;

import dao.UserDao;
import model.User; 
import com.google.gson.Gson; // Import Gson
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import java.sql.SQLException; // Import SQLException
import java.util.HashMap;
import java.util.Map;

@WebServlet("/deleteimg")
public class DeleteProfilePictureServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson(); // Khởi tạo Gson

    // Không cần các biến EXTERNAL_UPLOAD_BASE_DIRECTORY và CLIENT_AVATAR_CONTEXT_PATH 
    // vì chúng ta đang làm việc với thư mục trong webapp đã deploy.

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        System.out.println("\n--- DEBUG: Entering DeleteProfilePictureServlet doPost ---");
        System.out.println("DEBUG: Request URL: " + request.getRequestURL());
        System.out.println("DEBUG: Request URI: " + request.getRequestURI());
        System.out.println("DEBUG: Context Path: " + request.getContextPath());

        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("DEBUG: Session is null.");
            sendErrorResponse(response, "Session không hợp lệ. Vui lòng đăng nhập lại.", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Sửa lỗi: Lấy User từ session bằng key "user"
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            System.out.println("DEBUG: User object in session is null for key 'user'.");
            sendErrorResponse(response, "Người dùng chưa đăng nhập hoặc phiên đã hết hạn.", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int userId = currentUser.getId();
        System.out.println("DEBUG: Logged in user from session - User ID: " + userId + ", Username: " + currentUser.getUserName());

        UserDao userDao = new UserDao();
        try {
            User user = userDao.getUserById(userId);
            if (user == null) {
                System.out.println("DEBUG: User not found in DB for ID: " + userId);
                sendErrorResponse(response, "Không tìm thấy người dùng.", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String currentAvatarUrl = user.getAvatarUrl();
            System.out.println("DEBUG: Current avatar URL in DB for user " + userId + ": " + currentAvatarUrl);

            // Chỉ xóa file nếu nó không phải là ảnh mặc định và tồn tại
            if (currentAvatarUrl != null && !currentAvatarUrl.equals("images/user/default_avatar.png")) {
                // Xây dựng đường dẫn vật lý đầy đủ của file ảnh trong webapp
                // getServletContext().getRealPath("") trả về đường dẫn gốc của ứng dụng đã deploy
                Path avatarFilePath = Paths.get(getServletContext().getRealPath(""), currentAvatarUrl);
                System.out.println("DEBUG: Attempting to delete file at physical path: " + avatarFilePath.toAbsolutePath());

                if (Files.exists(avatarFilePath)) {
                    try {
                        Files.delete(avatarFilePath);
                        System.out.println("DEBUG: Successfully deleted file: " + avatarFilePath);
                    } catch (IOException e) {
                        System.err.println("ERROR: Could not delete image file: " + avatarFilePath + " - " + e.getMessage());
                        e.printStackTrace();
                        sendErrorResponse(response, "Không thể xóa file ảnh: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        return;
                    }
                } else {
                    System.out.println("DEBUG: Avatar file does not exist at: " + avatarFilePath);
                }
            } else {
                System.out.println("DEBUG: Avatar is null or default, no file to delete.");
            }

            // Cập nhật avatar_url trong DB thành đường dẫn ảnh mặc định
            String defaultAvatarUrl = "images/user/default_avatar.png";
            user.setAvatarUrl(defaultAvatarUrl); 
            boolean updateSuccess = userDao.update(user); // Phương thức update của DAO phải trả về boolean

            if (updateSuccess) {
                // Cập nhật lại đối tượng User trong Session
                session.setAttribute("user", user); 
                System.out.println("DEBUG: User object in session updated with default avatar URL.");
                
                response.setStatus(HttpServletResponse.SC_OK);
                Map<String, String> successResponse = new HashMap<>();
                successResponse.put("message", "Ảnh đại diện đã được xóa thành công!");
                successResponse.put("newAvatarUrl", request.getContextPath() + "/" + defaultAvatarUrl); // Trả về URL mặc định cho client
                response.getWriter().write(gson.toJson(successResponse));
                System.out.println("DEBUG: Sent success JSON response: " + gson.toJson(successResponse));
            } else {
                System.out.println("DEBUG: DB update failed for setting default avatar.");
                sendErrorResponse(response, "Lỗi khi cập nhật đường dẫn ảnh mặc định vào cơ sở dữ liệu.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (SQLException e) { // Bắt SQLException từ DAO
            System.err.println("ERROR: Database error during profile picture deletion: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi cơ sở dữ liệu khi xóa ảnh: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            System.err.println("ERROR: Unexpected error during profile picture deletion: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace(); 
            sendErrorResponse(response, "Đã xảy ra lỗi không xác định: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        System.out.println("--- DEBUG: Exiting DeleteProfilePictureServlet doPost ---\n");
    }

    // Phương thức gửi phản hồi lỗi với mã trạng thái HTTP tùy chỉnh và dùng Gson
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        Map<String, String> errorData = new HashMap<>();
        errorData.put("message", message);
        String jsonError = gson.toJson(errorData);
        response.getWriter().write(jsonError); 
        System.out.println("DEBUG: Sent error JSON response (Status " + statusCode + "): " + jsonError);
    }
    
    // Quá tải phương thức để giữ tương thích với sendErrorResponse cũ (chỉ có message)
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        sendErrorResponse(response, message, HttpServletResponse.SC_BAD_REQUEST);
    }
}
