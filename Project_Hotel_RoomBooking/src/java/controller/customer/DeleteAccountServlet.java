package controller.customer;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "DeleteAccountServlet", urlPatterns = {"/delete"})
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("{\"message\": \"Bạn chưa đăng nhập hoặc phiên đã hết hạn.\"}");
                return;
            }

            User user = (User) session.getAttribute("user");
            UserDao userDao = new UserDao();

            boolean deleted = userDao.softDelete(user.getId());

            if (deleted) {
                session.invalidate(); // Huỷ session hiện tại
                out.write("{\"message\": \"Tài khoản đã được xóa thành công.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"message\": \"Không thể xóa tài khoản. Vui lòng thử lại sau.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Đã xảy ra lỗi hệ thống.\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Xử lý yêu cầu xóa tài khoản của người dùng";
    }
}
