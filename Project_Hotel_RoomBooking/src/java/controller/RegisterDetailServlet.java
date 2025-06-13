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

        // Nhận lại username và password từ bước trước
        String username = request.getParameter("userName");
        String password = request.getParameter("password");

        // Nhận dữ liệu chi tiết từ form
        String fName = request.getParameter("fName");
        String lName = request.getParameter("lName");
        String fullName = fName + " " + lName;
        String birthStr = request.getParameter("birth");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Xử lý ngày sinh
        Date birth = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            birth = sdf.parse(birthStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ.");
            request.getRequestDispatcher("registerDetail.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User
        User user = new User(
                username,
                password,
                fullName,
                birth,
                gender,
                email,
                phone,
                address,
                "Customer", // default role
                "", // avatar URL rỗng
                false // isDeleted = false
        );

        // Gọi DAO để lưu user
        UserDao dao = new UserDao();
        dao.insert(user);

        // Chuyển đến trang login
        response.sendRedirect("login.jsp");
    }
}
