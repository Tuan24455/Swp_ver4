package controller;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Booking;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Gọi DAO để lấy toàn bộ lịch sử đặt phòng
        BookingDao bookingDao = new BookingDao();
        List<Booking> bookings = bookingDao.getAllBookingsWithDetails();

        // Gửi dữ liệu sang JSP
        req.setAttribute("bookings", bookings);

        // Không phân trang nữa
        req.setAttribute("currentPage", 1);
        req.setAttribute("totalPages", 1);

        // Chuyển tiếp đến trang hiển thị
        req.getRequestDispatcher("order-history.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị toàn bộ lịch sử đặt phòng của tất cả người dùng (không phân trang)";
    }
}
