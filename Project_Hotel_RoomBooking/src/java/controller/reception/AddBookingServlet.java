package controller.reception;

import dao.BookingDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

@WebServlet(name = "AddBookingServlet", urlPatterns = {"/add-booking"})
public class AddBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDao dao = new BookingDao();
        try {
            // Lấy dữ liệu đổ vào dropdown
            request.setAttribute("users", dao.getAllUsers());
            request.setAttribute("statuses", dao.getAllBookingStatuses());
            request.setAttribute("roomTypes", dao.getAllRoomTypes());

            // Forward tới file JSP trong thư mục /reception/
            request.getRequestDispatcher("/reception/addBooking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String promoParam = request.getParameter("promotion_id");
            Integer promotionId = (promoParam == null || promoParam.isEmpty()) ? null : Integer.parseInt(promoParam);
            double totalPrices = Double.parseDouble(request.getParameter("total_prices"));
            String status = request.getParameter("status");

            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setPromotionId(promotionId);
            booking.setTotalPrices(totalPrices);
            booking.setStatus(status);

            BookingDao dao = new BookingDao();
            dao.addBooking(booking);

           response.sendRedirect(request.getContextPath() + "/reception/bookings");


        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "AddBookingServlet handles the creation of new bookings.";
    }
}
