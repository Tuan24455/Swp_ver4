package controller;

import dao.UserDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import valid.InputValidator;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

@WebServlet(name = "RegisterDetailServlet", urlPatterns = {"/registerDetail"})
public class RegisterDetailServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("userName");
        String password = request.getParameter("password");

        String fName = request.getParameter("fName");
        String lName = request.getParameter("lName");
        String fullName = fName.trim() + " " + lName.trim();

        String birthStr = request.getParameter("birth");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate email
        if (!InputValidator.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ.");
            request.setAttribute("userName", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Validate phone
        if (!InputValidator.isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại phải là chuỗi gồm đúng 10 chữ số.");
            request.setAttribute("userName", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Validate ngày sinh
        Date birth;
        try {
            birth = InputValidator.parseDate(birthStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ.");
            request.setAttribute("userName", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Tạo user object
        User user = new User(
                username,
                password,
                fullName,
                birth,
                gender,
                email,
                phone,
                address,
                "Customer",
                "",
                false
        );

        // Lưu user
        UserDao dao = new UserDao();
        dao.insert(user);

        response.sendRedirect("login.jsp");
    }
}
