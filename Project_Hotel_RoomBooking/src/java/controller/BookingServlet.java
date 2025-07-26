package controller;

import dao.BookingDao;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Booking;
import service.VNPayService;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Get form data
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Date checkIn = Date.valueOf(request.getParameter("checkIn"));
            Date checkOut = Date.valueOf(request.getParameter("checkOut"));
            String[] selectedServices = request.getParameterValues("selectedServices");

            // Create booking object
            Booking booking = new Booking();


            booking.setUserId(user.getId());
            booking.setCreatedAt(new Date(System.currentTimeMillis()));
            booking.setStatus("Pending");

            // Set total price
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            booking.setTotalPrices(totalAmount);

            // Save booking
            BookingDao bookingDao = new BookingDao();
            int bookingId = bookingDao.createBooking(booking, roomId, checkIn, checkOut, selectedServices);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (bookingId > 0) {
                // Booking successful, redirect to VNPay payment
                String paymentUrl = VNPayService.createPaymentUrl(request, bookingId, (long)booking.getTotalPrices());
                response.sendRedirect(paymentUrl);
            } else {
                // Booking failed
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Booking failed");
            }

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }
}
