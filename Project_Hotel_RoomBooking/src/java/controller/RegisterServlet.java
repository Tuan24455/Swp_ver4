package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate username length
        if (userName == null || userName.length() < 8) {
            request.setAttribute("error", "Tên đăng nhập phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDao dao = new UserDao();
        if (dao.isExist(userName)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu phải trùng khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate password pattern
        if (!isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải dài từ 8–16 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và không chứa ký tự đặc biệt.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Hợp lệ -> forward sang registerDetail.jsp
        request.setAttribute("userName", userName);
        request.setAttribute("password", password);
        request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
    }

    private boolean isValidPassword(String password) {
        if (password.length() < 8 || password.length() > 16) return false;
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,16}$")) return false;
        return true;
    }
}
