package dao;

import java.sql.*;
import model.Booking;
import java.util.ArrayList;
import java.util.List;
import dal.DBContext;

public class BookingDao extends DBContext {
    
    public int createBooking(Booking booking, int roomId, Date checkIn, Date checkOut, String[] selectedServices) {
        int bookingId = -1;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);  // Start transaction
            
            // Insert into Bookings table
            String sql = "INSERT INTO Bookings (user_id, created_at, status, total_prices) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getUserId());
            ps.setTimestamp(2, new Timestamp(booking.getCreatedAt().getTime()));
            ps.setString(3, booking.getStatus());
            ps.setDouble(4, booking.getTotalPrices());
            ps.executeUpdate();
            
            // Get generated booking ID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);
                
                // Insert into BookingRoomDetails
                sql = "INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, bookingId);
                ps.setInt(2, roomId);
                ps.setDate(3, checkIn);
                ps.setDate(4, checkOut);
                ps.executeUpdate();
                
                // Insert selected services if any
                if (selectedServices != null && selectedServices.length > 0) {
                    sql = "INSERT INTO BookingServiceDetails (booking_id, service_id) VALUES (?, ?)";
                    ps = conn.prepareStatement(sql);
                    for (String serviceId : selectedServices) {
                        ps.setInt(1, bookingId);
                        ps.setInt(2, Integer.parseInt(serviceId));
                        ps.executeUpdate();
                    }
                }
                
                conn.commit();  // Commit transaction
            }
            
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();  // Rollback on error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return bookingId;
    }
    
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setStatus(rs.getString("status"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setRoomReviewId(rs.getInt("room_review_id"));
                booking.setServiceReviewId(rs.getInt("service_review_id"));
                bookings.add(booking);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
