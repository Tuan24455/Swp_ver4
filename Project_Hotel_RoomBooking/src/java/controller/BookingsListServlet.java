package controller;

import dao.BookingDao;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingsListServlet", urlPatterns = {"/reception/bookingsList"})
public class BookingsListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingDao bookingDao = new BookingDao();
        List<Booking> bookings = bookingDao.getAllBookingsWithDetails();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/reception/bookingsList.jsp").forward(request, response);
    }
}
