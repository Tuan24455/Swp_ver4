package dao;

import dal.DBContext;
import model.ServiceBooking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceBookingDao extends DBContext {
    
    public int createServiceBooking(ServiceBooking booking) {
        int bookingId = -1;
        String sql = "INSERT INTO ServiceBookings (user_id, service_id, booking_date, quantity, note, total_amount, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getServiceId());
            ps.setDate(3, booking.getBookingDate());
            ps.setInt(4, booking.getQuantity());
            ps.setString(5, booking.getNote());
            ps.setDouble(6, booking.getTotalAmount());
            ps.setString(7, booking.getStatus());
            ps.setTimestamp(8, booking.getCreatedAt());
            
            ps.executeUpdate();
            
            // Get generated booking ID
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingId;
    }
    
    public boolean updateServiceBookingStatus(int bookingId, String status) {
        String sql = "UPDATE ServiceBookings SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ServiceBooking> getServiceBookingsByUserId(int userId) {
        List<ServiceBooking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM ServiceBookings WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ServiceBooking booking = new ServiceBooking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setServiceId(rs.getInt("service_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setQuantity(rs.getInt("quantity"));
                booking.setNote(rs.getString("note"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public ServiceBooking getServiceBookingById(int id) {
        String sql = "SELECT * FROM ServiceBookings WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ServiceBooking booking = new ServiceBooking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setServiceId(rs.getInt("service_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setQuantity(rs.getInt("quantity"));
                booking.setNote(rs.getString("note"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
