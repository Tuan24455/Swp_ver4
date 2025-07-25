package controller.reception;

import dao.BookingDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

@WebServlet(name = "BookingListServlet", urlPatterns = {"/bookingList"})
public class BookingListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingDao dao = new BookingDao();
        List<Booking> bookings = dao.getAllBookingsWithDetails();
        // Map status to CSS classes
        for (Booking b : bookings) {
            String status = b.getStatus();
            String css = "";
            if ("confirmed".equalsIgnoreCase(status)) {
                css = "status-confirmed";
            } else if ("pending".equalsIgnoreCase(status)) {
                css = "status-pending";
            } else if ("cancelled".equalsIgnoreCase(status)) {
                css = "status-cancelled";
            } else if ("completed".equalsIgnoreCase(status)) {
                css = "status-completed";
            }
            b.setStatusClass(css);
        }
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/reception/bookingsList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String msg = null;
        String msgType = "success";
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDao dao = new BookingDao();
            boolean ok = false;
            if ("checkin".equals(action)) {
                ok = dao.updateBookingStatus(bookingId, "confirmed");
                msg = ok ? "Booking #" + bookingId + " checked in successfully." : "Failed to check in booking #" + bookingId + ".";
            } else if ("checkout".equals(action)) {
                ok = dao.updateBookingStatus(bookingId, "completed");
                msg = ok ? "Booking #" + bookingId + " checked out successfully." : "Failed to check out booking #" + bookingId + ".";
            }
            if (!ok) {
                msgType = "danger";
            }
        } catch (Exception e) {
            msg = "Error processing request.";
            msgType = "danger";
        }
        request.setAttribute("message", msg);
        request.setAttribute("messageType", msgType);
        doGet(request, response);
    }
}