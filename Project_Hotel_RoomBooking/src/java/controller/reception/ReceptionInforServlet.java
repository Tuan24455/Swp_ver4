/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reception;

import controller.customer.InformationServlet;
import dao.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import model.UserBookingStats;
import valid.InputValidator;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ReceptionInforServlet", urlPatterns = {"/receptionInfor"})
public class ReceptionInforServlet extends HttpServlet {

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
            out.println("<title>Servlet ReceptionInforServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReceptionInforServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        UserDao dao = new UserDao();
        UserBookingStats statis = dao.getUserBookingStatsByUserId(user.getId());
        request.getRequestDispatcher("/reception/receptionInfor.jsp").forward(request, response);
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
        System.out.println("==== POST receptionInfor ====");
        request.getParameterMap().forEach((key, value) -> {
            System.out.println("PARAM: " + key + " = " + String.join(",", value));
        });
        System.out.println("fullName: " + request.getParameter("fullName"));
        System.out.println("email: " + request.getParameter("email"));
        System.out.println("birth: " + request.getParameter("birth"));
        System.out.println("gender: " + request.getParameter("gender"));
        System.out.println("phone: " + request.getParameter("phone"));
        System.out.println("address: " + request.getParameter("address"));

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        UserDao dao = new UserDao();
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống");
                request.getRequestDispatcher("/reception/receptionInfor.jsp").forward(request, response);
                return;
            }
            if (!email.equals(user.getEmail()) && dao.isEmailExist(email)) {
                request.setAttribute("error", "Email đã tồn tại");
                request.getRequestDispatcher("/reception/receptionInfor.jsp").forward(request, response);
                return;
            }
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String birthStr = request.getParameter("birth");
            String gender = request.getParameter("gender");

            // Parse ngày sinh
            Date birth = InputValidator.parseDate(birthStr);

            // Cập nhật lại user object
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setBirth(birth);
            user.setGender(gender);

            try {
                // Cập nhật DB
                boolean up = dao.update(user);
            } catch (SQLException ex) {
                Logger.getLogger(InformationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Cập nhật session và thông báo
            session.setAttribute("user", user);
            request.setAttribute("success", "Cập nhật thông tin thành công!");

        } catch (ParseException e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }

        request.getRequestDispatcher("/reception/receptionInfor.jsp").forward(request, response);
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
