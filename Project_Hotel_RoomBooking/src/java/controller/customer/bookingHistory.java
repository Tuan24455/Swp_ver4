package controller.customer;

import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name="bookingHistory", urlPatterns={"/bookingHistory"})
public class bookingHistory extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // We'll implement this in doGet instead
    } 

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getId();
        
        // Pagination parameters
        int page = 1;
        int recordsPerPage = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get total count for pagination
        int totalRecords = getBookingHistoryCount(userId);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Get paginated booking history
        List<Map<String, Object>> bookings = getBookingHistory(userId, page, recordsPerPage);
        
        // Set attributes for JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        
        request.getRequestDispatcher("/customer/bookingHistory.jsp").forward(request, response);
    }
      /**
     * Gets booking history for a user with pagination
     * @param userId The user's ID
     * @param page Current page number (1-based)
     * @param recordsPerPage Number of records per page
     * @return List of booking history records
     */
    private List<Map<String, Object>> getBookingHistory(int userId, int page, int recordsPerPage) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        
        // Calculate offset for pagination
        int offset = (page - 1) * recordsPerPage;
        
        String sql = "SELECT "
                + "b.id AS booking_id, "
                + "MIN(brd.check_in_date) AS check_in_date, "
                + "MAX(brd.check_out_date) AS check_out_date, "
                + "STRING_AGG(r.room_number, ', ') AS rooms, "
                + "STRING_AGG(CAST(r.floor AS NVARCHAR(10)), ', ') AS floors, "
                + "b.total_prices, "
                + "b.status, "
                + "b.created_at "
                + "FROM Bookings b "
                + "JOIN BookingRoomDetails brd ON brd.booking_id = b.id "
                + "JOIN Rooms r ON brd.room_id = r.id "
                + "WHERE b.user_id = ? "
                + "GROUP BY b.id, b.total_prices, b.status, b.created_at "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, recordsPerPage);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("bookingId", rs.getInt("booking_id"));
                    booking.put("checkInDate", rs.getDate("check_in_date"));
                    booking.put("checkOutDate", rs.getDate("check_out_date"));
                    booking.put("rooms", rs.getString("rooms"));
                    booking.put("floors", rs.getString("floors"));
                    booking.put("totalPrice", rs.getDouble("total_prices"));
                    booking.put("status", rs.getString("status"));
                    booking.put("createdAt", rs.getTimestamp("created_at"));
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    /**
     * Gets the total count of booking records for a user
     * @param userId The user's ID
     * @return Total number of booking records
     */
    private int getBookingHistoryCount(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(DISTINCT b.id) AS total "
                + "FROM Bookings b "
                + "JOIN BookingRoomDetails brd ON brd.booking_id = b.id "
                + "WHERE b.user_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking history count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return count;
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
