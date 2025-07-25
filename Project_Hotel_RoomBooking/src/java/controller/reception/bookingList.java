package controller.reception;

import dao.BookingDao;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

@WebServlet(name = "BookingListServlet", urlPatterns = {"/bookingList"})
public class bookingList extends HttpServlet {

    private static final int PAGE_SIZE = 8; // 8 bookings per page    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingDao dao = new BookingDao(); // DAO for bookings
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");
          // Parse dates if provided
        Date checkInDate = null;
        Date checkOutDate = null;
        try {
            if (checkInDateStr != null && !checkInDateStr.isEmpty()) {
                checkInDate = Date.valueOf(checkInDateStr);
            }
            if (checkOutDateStr != null && !checkOutDateStr.isEmpty()) {
                checkOutDate = Date.valueOf(checkOutDateStr);
            }
            
            // Validate that check-out date is after check-in date
            if (checkInDate != null && checkOutDate != null) {
                if (checkOutDate.before(checkInDate)) {
                    request.setAttribute("error", "Check-out date must be after check-in date");
                    checkOutDate = null; // Reset the checkout date to avoid invalid search
                }
            }
        } catch (Exception e) {
            // Handle date parsing errors
            request.setAttribute("error", "Invalid date format");
        }
        
        // Get pagination parameters
        int pageNumber = 1; // Default page number
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1) pageNumber = 1;
            }
        } catch (NumberFormatException e) {
            // Ignore and use default page number
        }
        
        // Get filtered bookings count for pagination
        int totalBookings = dao.getFilteredBookingsCount(statusFilter, checkInDate, checkOutDate);
        int totalPages = (int) Math.ceil((double) totalBookings / PAGE_SIZE);
        
        // Make sure pageNumber is valid
        if (pageNumber > totalPages && totalPages > 0) {
            pageNumber = totalPages;
        }
        
        // Get bookings for current page with filters
        List<Booking> bookings = dao.getFilteredBookingsWithPagination(pageNumber, PAGE_SIZE, statusFilter, checkInDate, checkOutDate);
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
            } else if ("check-in".equalsIgnoreCase(status) || "checkin".equalsIgnoreCase(status)) {
                css = "status-checkin";
            } else if ("check-out".equalsIgnoreCase(status) || "checkout".equalsIgnoreCase(status)) {
                css = "status-checkout";
            }
            b.setStatusClass(css);
        }
        
        // Set pagination and filter attributes
        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("checkInDate", checkInDateStr);
        request.setAttribute("checkOutDate", checkOutDateStr);
        
        request.getRequestDispatcher("/reception/bookingsList.jsp").forward(request, response);
    }    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String msg = null;
        String msgType = "success";
        
        // Retrieve the current page and filter parameters to maintain state
        String currentPage = request.getParameter("currentPage");
        String statusFilter = request.getParameter("statusFilter");
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDao dao = new BookingDao();
            boolean ok = false;
            if ("checkin".equals(action)) {
                ok = dao.updateBookingStatus(bookingId, "Check-in");
                msg = ok ? "Booking #" + bookingId + " checked in successfully." : "Failed to check in booking #" + bookingId + ".";
            } else if ("checkout".equals(action)) {
                ok = dao.updateBookingStatus(bookingId, "Check-out");
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
        
        // Redirect to maintain pagination and filter state
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/bookingList?");
        if (currentPage != null && !currentPage.isEmpty()) {
            redirectUrl.append("page=").append(currentPage);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            redirectUrl.append("&status=").append(statusFilter);
        }
        if (checkInDate != null && !checkInDate.isEmpty()) {
            redirectUrl.append("&checkInDate=").append(checkInDate);
        }
        if (checkOutDate != null && !checkOutDate.isEmpty()) {
            redirectUrl.append("&checkOutDate=").append(checkOutDate);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }
}