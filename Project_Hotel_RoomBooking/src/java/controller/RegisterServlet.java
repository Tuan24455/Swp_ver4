package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import valid.InputValidator;
import valid.Encrypt;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!InputValidator.isValidUsername(userName)) {
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

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu phải trùng khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải dài từ 8–16 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và không chứa ký tự đặc biệt.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 🔐 Mã hóa mật khẩu trước khi gửi qua trang tiếp theo
        String encryptedPassword = Encrypt.encrypt(password);

        request.setAttribute("userName", userName);
        request.setAttribute("password", encryptedPassword); // Gửi mật khẩu đã mã hóa
        request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
    }
}
