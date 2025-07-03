package controller.customer;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import valid.InputValidator;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.UserBookingStats;

@WebServlet(name = "InformationServlet", urlPatterns = {"/information"})
public class InformationServlet extends HttpServlet {

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
        request.setAttribute("statis", statis);
        request.getRequestDispatcher("/customer/customerInfor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            if (!email.equals(user.getEmail()) && dao.isEmailExist(email)) {
                request.setAttribute("error", "Email đã tồn tại");
                request.getRequestDispatcher("/customer/customerInfor.jsp").forward(request, response);
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

        request.getRequestDispatcher("/customer/customerInfor.jsp").forward(request, response);
    }
}
