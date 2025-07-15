/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.SQLException;
import java.util.Date;
import model.User;
import valid.Encrypt;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "EditUserServlet", urlPatterns = {"/editUser"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 2, // 2MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class EditUserServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditUserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy thông tin người dùng từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String userName = request.getParameter("userName");
            String birthStr = request.getParameter("birth");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String address = request.getParameter("address");
            String password = request.getParameter("password"); // optional
            System.out.println(password);
            // 2. Parse ngày sinh
            Date birth = null;
            if (birthStr != null && !birthStr.isEmpty()) {
                birth = java.sql.Date.valueOf(birthStr); // yyyy-MM-dd
            }

            // 3. Xử lý ảnh đại diện
            Part avatarPart = request.getPart("avatar");
            String avatarFileName = null;
            String uploadPath = getServletContext().getRealPath("/uploads");

            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submittedFileName = avatarPart.getSubmittedFileName();
                avatarFileName = System.currentTimeMillis() + "_" + submittedFileName;

                // Đảm bảo thư mục tồn tại
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lưu file
                avatarPart.write(uploadPath + File.separator + avatarFileName);
            }

            // 4. Lấy thông tin user cũ để giữ avatar cũ nếu không thay đổi
            UserDao userDAO = new UserDao();
            User existingUser = userDAO.getUserById(id);
            String avatarUrl = (avatarFileName != null)
                    ? "uploads/" + avatarFileName
                    : existingUser.getAvatarUrl();

            // 5. Cập nhật thông tin người dùng
            User user = new User();
            user.setId(id);
            user.setFullName(fullName);
            user.setUserName(userName);
            user.setBirth(birth);
            user.setGender(gender);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setAddress(address);
            user.setAvatarUrl(avatarUrl);

            // Cập nhật mật khẩu nếu được nhập (có thể hash nếu muốn)
            if (password != null && !password.isEmpty()) {
                user.setPass(Encrypt.encrypt(password)); // bạn nên mã hóa trước khi lưu
            } else {
                user.setPass(existingUser.getPass()); // giữ mật khẩu cũ
            }

            boolean updated = userDAO.update(user);
            if (updated) {
                response.sendRedirect("userList");
            } else {
                response.sendRedirect("userList");
            }

        } catch (ServletException | IOException | NumberFormatException | SQLException e) {
            response.sendRedirect("userList");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
