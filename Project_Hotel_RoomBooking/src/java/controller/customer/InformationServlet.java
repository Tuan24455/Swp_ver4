package controller.customer;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import valid.InputValidator;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

@WebServlet(name = "InformationServlet", urlPatterns = {"/information"})
public class InformationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer/customerInfor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
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

            // Cập nhật DB
            new UserDao().update(user);

            // Cập nhật session và thông báo
            session.setAttribute("user", user);
            request.setAttribute("success", "Cập nhật thông tin thành công!");

        } catch (ParseException e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/customerInfor.jsp").forward(request, response);
    }
}
