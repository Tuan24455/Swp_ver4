package controller;

import dao.UserDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import valid.InputValidator;
import valid.Encrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html><head><title>Servlet LoginServlet</title></head>");
            out.println("<body><h1>Servlet LoginServlet at " + request.getContextPath() + "</h1></body></html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String stringlog = request.getParameter("stringlog");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        UserDao userdao = new UserDao();
        User user = null;

        if (stringlog != null && !stringlog.trim().isEmpty() && password != null) {
            String encryptedPassword = Encrypt.encrypt(password); // 🔐 mã hóa mật khẩu nhập vào

            if (InputValidator.isValidPhone(stringlog)) {
                user = userdao.loginByPhone(stringlog, encryptedPassword);
            } else if (InputValidator.isValidEmail(stringlog)) {
                user = userdao.loginByEmail(stringlog, encryptedPassword);
            } else {
                user = userdao.loginByUsername(stringlog, encryptedPassword);
            }

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                Cookie username = new Cookie("username", user.getUserName());
                Cookie pass = new Cookie("pass", user.getPass());

                if (rememberMe != null) {
                    username.setMaxAge(60 * 60 * 24 * 3);
                    pass.setMaxAge(60 * 60 * 24 * 3);
                } else {
                    username.setMaxAge(-1);
                    pass.setMaxAge(-1);
                }

                response.addCookie(username);
                response.addCookie(pass);

                response.sendRedirect("home");

            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("error", "Hãy điền tài khoản mật khẩu");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
