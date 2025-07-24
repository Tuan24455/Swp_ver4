package dao;

import dal.DBContext;
import model.ServiceBooking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ServiceBookingDao class for handling service booking database operations
 */
public class ServiceBookingDao extends DBContext {
    
    /**
     * Create a new service booking
     * @param serviceBooking The service booking to create
     * @return The generated booking ID, or -1 if failed
     */
    public int createServiceBooking(ServiceBooking serviceBooking) {
        int bookingId = -1;
        String sql = "INSERT INTO ServiceBookings (user_id, service_id, booking_date, usage_date, quantity, total_amount, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: userId=" + serviceBooking.getUserId() + 
                             ", serviceId=" + serviceBooking.getServiceId() + 
                             ", quantity=" + serviceBooking.getQuantity() + 
                             ", amount=" + serviceBooking.getTotalAmount());
            
            ps.setInt(1, serviceBooking.getUserId());
            ps.setInt(2, serviceBooking.getServiceId());
            ps.setTimestamp(3, new Timestamp(serviceBooking.getBookingDate().getTime()));
            ps.setDate(4, new java.sql.Date(serviceBooking.getUsageDate().getTime()));
            ps.setInt(5, serviceBooking.getQuantity());
            ps.setDouble(6, serviceBooking.getTotalAmount());
            ps.setString(7, serviceBooking.getStatus());
            ps.setTimestamp(8, new Timestamp(serviceBooking.getCreatedAt().getTime()));
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookingId = rs.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.out.println("SQL Error in createServiceBooking: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("General Error in createServiceBooking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookingId;
    }
    
    /**
     * Get service bookings by user ID
     * @param userId The user ID
     * @return List of service bookings
     */
    public List<ServiceBooking> getServiceBookingsByUserId(int userId) {
        List<ServiceBooking> bookings = new ArrayList<>();
        String sql = "SELECT sb.*, s.service_name, s.service_price " +
                     "FROM ServiceBookings sb " +
                     "JOIN Services s ON sb.service_id = s.id " +
                     "WHERE sb.user_id = ? " +
                     "ORDER BY sb.booking_date DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceBooking booking = new ServiceBooking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingDate(rs.getTimestamp("booking_date"));
                    booking.setUsageDate(rs.getDate("usage_date"));
                    booking.setQuantity(rs.getInt("quantity"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setServiceName(rs.getString("service_name"));
                    booking.setUnitPrice(rs.getDouble("service_price"));
                    
                    bookings.add(booking);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    /**
     * Get service booking history for user with search and pagination
     * @param userId The user ID (logged-in user)
     * @param search Search term for service name or status
     * @param page Page number (starting from 1)
     * @param pageSize Number of records per page
     * @return List of service bookings for history display
     */
    public List<ServiceBooking> getServiceBookingHistoryByUserId(int userId, String search, int page, int pageSize) {
        List<ServiceBooking> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP (?) ");
        sql.append("sb.booking_date AS booking_date, ");
        sql.append("s.service_name AS service_name, ");
        sql.append("sb.quantity AS quantity, ");
        sql.append("sb.usage_date AS usage_date, ");
        sql.append("sb.total_amount AS total_amount, ");
        sql.append("sb.status AS status, ");
        sql.append("sb.id AS id, ");
        sql.append("sb.user_id AS user_id, ");
        sql.append("sb.service_id AS service_id, ");
        sql.append("sb.created_at AS created_at ");
        sql.append("FROM ServiceBookings sb ");
        sql.append("JOIN Services s ON sb.service_id = s.id ");
        sql.append("JOIN Users u ON sb.user_id = u.id ");
        sql.append("WHERE sb.user_id = ? ");
        
        // Add search condition if provided
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (s.service_name LIKE ? OR sb.status LIKE ?) ");
        }
        
        sql.append("ORDER BY sb.booking_date DESC ");
        
        // Add pagination with OFFSET
        if (page > 1) {
            sql.append("OFFSET ? ROWS ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, pageSize); // TOP clause
            ps.setInt(paramIndex++, userId);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            if (page > 1) {
                ps.setInt(paramIndex++, (page - 1) * pageSize); // OFFSET
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceBooking booking = new ServiceBooking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingDate(rs.getTimestamp("booking_date"));
                    booking.setUsageDate(rs.getDate("usage_date"));
                    booking.setQuantity(rs.getInt("quantity"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setServiceName(rs.getString("service_name"));
                    
                    bookings.add(booking);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    /**
     * Get total count of service bookings for a user (for pagination)
     * @param userId The user ID
     * @param search Search term for service name or status
     * @return Total count of matching bookings
     */
    public int getServiceBookingCountByUserId(int userId, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM ServiceBookings sb ");
        sql.append("JOIN Services s ON sb.service_id = s.id ");
        sql.append("WHERE sb.user_id = ? ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (s.service_name LIKE ? OR sb.status LIKE ?) ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, userId);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Update service booking status
     * @param bookingId The booking ID
     * @param status The new status
     * @return true if update successful, false otherwise
     */
    public boolean updateServiceBookingStatus(int bookingId, String status) {
        String sql = "UPDATE ServiceBookings SET status = ? WHERE id = ?";
        
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
    
    /**
     * Get service booking by ID
     * @param bookingId The booking ID
     * @return ServiceBooking object or null if not found
     */
    public ServiceBooking getServiceBookingById(int bookingId) {
        String sql = "SELECT sb.*, s.service_name, s.service_price, u.full_name " +
                     "FROM ServiceBookings sb " +
                     "JOIN Services s ON sb.service_id = s.id " +
                     "JOIN Users u ON sb.user_id = u.id " +
                     "WHERE sb.id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ServiceBooking booking = new ServiceBooking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingDate(rs.getTimestamp("booking_date"));
                    booking.setUsageDate(rs.getDate("usage_date"));
                    booking.setQuantity(rs.getInt("quantity"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setServiceName(rs.getString("service_name"));
                    booking.setUnitPrice(rs.getDouble("service_price"));
                    booking.setCustomerName(rs.getString("full_name"));
                    
                    return booking;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all service bookings with pagination
     * @param page Page number (starting from 1)
     * @param pageSize Number of records per page
     * @return List of service bookings
     */
    public List<ServiceBooking> getAllServiceBookings(int page, int pageSize) {
        List<ServiceBooking> bookings = new ArrayList<>();
        String sql = "SELECT sb.*, s.service_name, s.service_price, u.full_name " +
                     "FROM ServiceBookings sb " +
                     "JOIN Services s ON sb.service_id = s.id " +
                     "JOIN Users u ON sb.user_id = u.id " +
                     "ORDER BY sb.booking_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceBooking booking = new ServiceBooking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingDate(rs.getTimestamp("booking_date"));
                    booking.setUsageDate(rs.getDate("usage_date"));
                    booking.setQuantity(rs.getInt("quantity"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setServiceName(rs.getString("service_name"));
                    booking.setUnitPrice(rs.getDouble("service_price"));
                    booking.setCustomerName(rs.getString("full_name"));
                    
                    bookings.add(booking);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    /**
     * Get total count of service bookings
     * @return Total count
     */
    public int getTotalServiceBookingsCount() {
        String sql = "SELECT COUNT(*) FROM ServiceBookings";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
} 