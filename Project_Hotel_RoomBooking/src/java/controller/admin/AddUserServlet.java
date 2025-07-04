package controller.admin;

import dao.UserDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AddUserServlet", urlPatterns = {"/addUser"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 2, // 2MB
        maxRequestSize = 1024 * 1024 * 5 // 5MB
)
public class AddUserServlet extends HttpServlet {

    private static final String AVATAR_UPLOAD_DIR = "uploads/avatars";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Nhận dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String gender = request.getParameter("gender");
        String birthStr = request.getParameter("birth");
        String address = request.getParameter("address");
        String sendWelcomeEmail = request.getParameter("sendWelcomeEmail");

        // 2. Kiểm tra mật khẩu khớp
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
            return;
        }

        // 3. Xử lý upload avatar (nếu có)
        Part avatarPart = request.getPart("avatar");
        String avatarFileName = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String fileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + AVATAR_UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String savedFileName = System.currentTimeMillis() + "_" + fileName;
            avatarPart.write(uploadPath + File.separator + savedFileName);
            avatarFileName = AVATAR_UPLOAD_DIR + "/" + savedFileName;
        }

        // 4. Chuyển đổi ngày sinh
        Date birthDate = null;
        if (birthStr != null && !birthStr.isEmpty()) {
            birthDate = Date.valueOf(birthStr);
        }

        // 5. Tạo User object
        User newUser = new User();
        newUser.setUserName(userName);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setPass(password); // Bạn nên mã hóa mật khẩu trước khi lưu
        newUser.setRole(role);
        newUser.setGender(gender);
        newUser.setBirth(birthDate);
        newUser.setAddress(address);
        newUser.setAvatarUrl(avatarFileName);

        // 6. Lưu user vào database
        boolean success = false;
        try {
            success = new UserDao().insert(newUser);
        } catch (SQLException ex) {
            Logger.getLogger(AddUserServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // 7. Điều hướng sau khi lưu
        if (success) {
            // Gửi email chào mừng nếu checkbox được tick
            if (sendWelcomeEmail != null) {
                // TODO: Gửi email ở đây nếu bạn có EmailUtility
            }
            response.sendRedirect("userList?action=added");
        } else {
            request.setAttribute("error", "Thêm người dùng thất bại");
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
        }
    }
}
