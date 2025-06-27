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

        UserDao dao = new UserDao();

        // Kiểm tra email hợp lệ
        if (!InputValidator.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ.");
            backToForm(request, response, username, password);
            return;
        }

        // Email đã tồn tại?
        if (dao.isEmailExist(email)) {
            request.setAttribute("error", "Email đã được sử dụng.");
            backToForm(request, response, username, password);
            return;
        }

        // Kiểm tra số điện thoại hợp lệ
        if (!InputValidator.isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại phải bắt đầu bằng 0 và đủ 10 chữ số.");
            backToForm(request, response, username, password);
            return;
        }

        // SĐT đã tồn tại?
        if (dao.isPhoneExist(phone)) {
            request.setAttribute("error", "Số điện thoại đã được sử dụng.");
            backToForm(request, response, username, password);
            return;
        }

        // Kiểm tra ngày sinh hợp lệ
        Date birth;
        try {
            birth = InputValidator.parseDate(birthStr);
            if (!InputValidator.isAtLeast18YearsOld(birth)) {
                request.setAttribute("error", "Bạn phải đủ 18 tuổi để đăng ký.");
                backToForm(request, response, username, password);
                return;
            }
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ.");
            backToForm(request, response, username, password);
            return;
        }

        // Tạo user
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
                "images/user/default_avatar.png",
                false
        );

        // Lưu vào DB
        dao.insert(user);

        response.sendRedirect("login.jsp");
    }

    private void backToForm(HttpServletRequest request, HttpServletResponse response,
            String username, String password) throws ServletException, IOException {
        request.setAttribute("userName", username);
        request.setAttribute("password", password);
        request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
    }
}
