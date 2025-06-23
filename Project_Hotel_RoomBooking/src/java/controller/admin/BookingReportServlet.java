package controller.admin;

import dao.UserDao;
import model.Booking;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "BookingReportServlet", urlPatterns = {"/bookingreport", "/admin/bookingreport"})
public class BookingReportServlet extends HttpServlet {
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is admin
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get date range parameters
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            // Set default date range if not provided (last 30 days)
            if (startDate == null || startDate.isEmpty()) {
                startDate = LocalDate.now().minusDays(30).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            if (endDate == null || endDate.isEmpty()) {
                endDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            
            // Get booking data (using available data)
            List<User> users = userDao.getAll();
            List<Booking> bookings = new ArrayList<>(); // Placeholder for booking data
            
            // Calculate summary statistics
            Map<String, Object> summary = calculateSummary(bookings, users);
            
            // Set attributes for JSP
            request.setAttribute("bookings", bookings);
            request.setAttribute("users", users);
            request.setAttribute("summary", summary);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            
            // Forward to JSP
            request.getRequestDispatcher("admin/bookingreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading booking report: " + e.getMessage());
            request.getRequestDispatcher("admin/bookingreport.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private Map<String, Object> calculateSummary(List<Booking> bookings, List<User> users) {
        Map<String, Object> summary = new HashMap<>();
        
        int totalBookings = bookings.size();
        int totalUsers = users.size();
        int customerCount = 0;
        int adminCount = 0;
        int receptionCount = 0;
        
        // Count users by role
        for (User user : users) {
            String role = user.getRole();
            if ("customer".equalsIgnoreCase(role)) {
                customerCount++;
            } else if ("admin".equalsIgnoreCase(role)) {
                adminCount++;
            } else if ("reception".equalsIgnoreCase(role)) {
                receptionCount++;
            }
        }
        
        summary.put("totalBookings", totalBookings);
        summary.put("totalUsers", totalUsers);
        summary.put("customerCount", customerCount);
        summary.put("adminCount", adminCount);
        summary.put("receptionCount", receptionCount);
        summary.put("averageBookingsPerUser", totalUsers > 0 ? (double)totalBookings / totalUsers : 0);
        
        return summary;
    }
}