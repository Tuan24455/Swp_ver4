/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import util.EmailUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "OTPVerificationServlet", urlPatterns = {"/otpVerification"})
public class OTPVerificationServlet extends HttpServlet {

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
            out.println("<title>Servlet OTPVerificationServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OTPVerificationServlet at " + request.getContextPath() + "</h1>");
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
        String keyword = request.getParameter("keyword");
        System.out.println(keyword);
        String otp = EmailUtil.generate8DigitCode();

        UserDao dao = new UserDao();
        User ufound = dao.findAccount(keyword);

        try {
            EmailUtil.sendOtpEmail(ufound.getEmail(), otp);
        } catch (MessagingException | UnsupportedEncodingException ex) {
            Logger.getLogger(OTPVerificationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);

        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
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
//        processRequest(request, response);
        String keyword = request.getParameter("keyword");
        String otpstr = request.getParameter("otp");
        HttpSession session = request.getSession();
        String otpverifi = (String) session.getAttribute("otp");
        if (otpstr.equals(otpverifi)) {
            session.removeAttribute("otp");
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }else{
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
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
