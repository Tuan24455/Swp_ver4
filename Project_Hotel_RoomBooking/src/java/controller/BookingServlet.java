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
            
            // Save booking
            BookingDao bookingDao = new BookingDao();
            int bookingId = bookingDao.createBooking(booking, roomId, checkIn, checkOut, selectedServices);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (bookingId > 0) {
                // Booking successful
                response.getWriter().write("{\"success\": true, \"message\": \"Đặt phòng thành công!\"}");
            } else {
                // Booking failed
                response.getWriter().write("{\"success\": false, \"message\": \"Đặt phòng không thành công\"}");
            }
            
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
        }
    }
}
