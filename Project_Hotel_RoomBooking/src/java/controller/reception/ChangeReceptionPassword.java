/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reception;

import dao.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import valid.Encrypt;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ChangeReceptionPassword", urlPatterns = {"/changeReceptionPassword"})
public class ChangeReceptionPassword extends HttpServlet {

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
            out.println("<title>Servlet ChangeReceptionPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangeReceptionPassword at " + request.getContextPath() + "</h1>");
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

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            out.print("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        try {
            String decryptedCurrentPassword = Encrypt.decrypt(user.getPass());

            if (!currentPassword.equals(decryptedCurrentPassword)) {
                out.print("{\"success\": false, \"message\": \"Mật khẩu hiện tại không đúng\"}");
                return;
            }

            // Regex: 8–16 ký tự, ít nhất 1 hoa, 1 thường, 1 số
            String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,16}$";
            if (!newPassword.matches(passwordRegex)) {
                out.print("{\"success\": false, \"message\": \"Mật khẩu mới không hợp lệ\"}");
                return;
            }

            // Update mật khẩu
            String encryptedNewPass = Encrypt.encrypt(newPassword);
            boolean updated = new UserDao().updatePassword(user.getId(), encryptedNewPass);

            if (updated) {
                session.setAttribute("user", user); // cập nhật lại session
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"Cập nhật mật khẩu thất bại\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi máy chủ\"}");
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
