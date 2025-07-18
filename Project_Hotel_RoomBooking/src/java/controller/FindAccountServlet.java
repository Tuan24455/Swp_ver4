/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import valid.InputValidator;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "FindAccountServlet", urlPatterns = {"/findAccount"})
public class FindAccountServlet extends HttpServlet {

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
            out.println("<title>Servlet FindAccountServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FindAccountServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("findAccount.jsp").forward(request, response);
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
        
        String keyword = request.getParameter("keyword");

        // In ra giá trị keyword để debug
        System.out.println(">> [DEBUG] Keyword nhận được: " + keyword);
        
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email hoặc tên đăng nhập.");
            request.getRequestDispatcher("findAccount.jsp").forward(request, response);
            return;
        }
        
        keyword = keyword.trim(); // loại bỏ khoảng trắng đầu/cuối

        if (keyword.contains("@") && !InputValidator.isValidEmail(keyword)) {
            request.setAttribute("error", "Định dạng email không hợp lệ.");
            request.getRequestDispatcher("findAccount.jsp").forward(request, response);
            return;
        }
        
        UserDao dao = new UserDao();
        User ufound = dao.findAccount(keyword);
        
        if (ufound != null) {
            response.sendRedirect("otpVerification?keyword=" + keyword);
        } else {
            request.setAttribute("error", "Không tìm thấy tài khoản!");
            request.getRequestDispatcher("findAccount.jsp").forward(request, response);
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
