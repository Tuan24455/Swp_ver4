package controller;

import dao.UserDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ.");
            request.setAttribute("userName", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Validate phone
        if (!isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại phải là chuỗi gồm đúng 10 chữ số.");
            request.setAttribute("userName", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Validate ngày sinh
        Date birth = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            birth = sdf.parse(birthStr);
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

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^\\d{10}$");
    }
}
