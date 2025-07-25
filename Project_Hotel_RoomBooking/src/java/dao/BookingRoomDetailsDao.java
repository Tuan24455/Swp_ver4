package dao;

import dal.DBContext;
import model.BookingRoomDetails;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class BookingRoomDetailsDao {      public List<Map<String, Object>> getCurrentBookings() {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT " +
                "r.room_number AS [Tên Phòng], " +
                "r.floor AS [Tầng], " +
                "rt.room_type AS [Loại Phòng], " +
                "r.capacity AS [Sức Chứa], " +
                "u.full_name AS [Tên Khách Hàng], " +
                "b.created_at AS [Ngày Đặt], " +
                "brd.check_out_date AS [Ngày Trả], " +
                "b.total_prices AS [Tổng Tiền], " +
                "t.status AS [Status] " +
            "FROM BookingRoomDetails brd " +
            "INNER JOIN Rooms r ON brd.room_id = r.id " +
            "INNER JOIN RoomTypes rt ON r.room_type_id = rt.id " +
            "INNER JOIN Bookings b ON brd.booking_id = b.id " +
            "INNER JOIN Users u ON b.user_id = u.id " +
            "INNER JOIN Transactions t ON b.id = t.booking_id " +
            "WHERE r.isDelete = 0 AND u.isDeleted = 0 AND t.status = 'Confirmed' " +
            "ORDER BY r.room_number";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("roomNumber", rs.getString("Tên Phòng"));
                booking.put("floor", rs.getInt("Tầng"));
                booking.put("roomType", rs.getString("Loại Phòng"));
                booking.put("capacity", rs.getInt("Sức Chứa"));
                booking.put("customerName", rs.getString("Tên Khách Hàng"));
                booking.put("checkInDate", rs.getTimestamp("Ngày Đặt"));
                booking.put("checkOutDate", rs.getDate("Ngày Trả"));
                booking.put("totalPrice", rs.getDouble("Tổng Tiền"));
                booking.put("status", rs.getString("Status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.out.println("Error in BookingRoomDetailsDao: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }      public List<Map<String, Object>> getFilteredBookings(String startDate, String endDate, Integer roomTypeId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT ");
        sqlBuilder.append("r.room_number AS [Tên Phòng], ");
        sqlBuilder.append("r.floor AS [Tầng], ");
        sqlBuilder.append("rt.room_type AS [Loại Phòng], ");
        sqlBuilder.append("r.capacity AS [Sức Chứa], ");
        sqlBuilder.append("u.full_name AS [Tên Khách Hàng], ");
        sqlBuilder.append("b.created_at AS [Ngày Đặt], ");
        sqlBuilder.append("brd.check_out_date AS [Ngày Trả], ");
        sqlBuilder.append("b.total_prices AS [Tổng Tiền], ");
        sqlBuilder.append("t.status AS [Status] ");
        sqlBuilder.append("FROM BookingRoomDetails brd ");
        sqlBuilder.append("INNER JOIN Rooms r ON brd.room_id = r.id ");
        sqlBuilder.append("INNER JOIN RoomTypes rt ON r.room_type_id = rt.id ");
        sqlBuilder.append("INNER JOIN Bookings b ON brd.booking_id = b.id ");
        sqlBuilder.append("INNER JOIN Users u ON b.user_id = u.id ");
        sqlBuilder.append("INNER JOIN Transactions t ON b.id = t.booking_id ");
        sqlBuilder.append("WHERE r.isDelete = 0 AND u.isDeleted = 0 AND t.status = 'Confirmed' ");

        List<Object> params = new ArrayList<>();
        if (startDate != null && !startDate.isEmpty()) {
            sqlBuilder.append("AND b.created_at >= ? ");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sqlBuilder.append("AND brd.check_out_date <= ? ");
            params.add(endDate);
        }
        if (roomTypeId != null) {
            sqlBuilder.append("AND rt.id = ? ");
            params.add(roomTypeId);
        }
        sqlBuilder.append("ORDER BY r.room_number");

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("roomNumber", rs.getString("Tên Phòng"));
                    booking.put("floor", rs.getInt("Tầng"));
                    booking.put("roomType", rs.getString("Loại Phòng"));
                    booking.put("capacity", rs.getInt("Sức Chứa"));
                    booking.put("customerName", rs.getString("Tên Khách Hàng"));
                    booking.put("checkInDate", rs.getTimestamp("Ngày Đặt"));
                    booking.put("checkOutDate", rs.getDate("Ngày Trả"));
                    booking.put("totalPrice", rs.getDouble("Tổng Tiền"));
                    booking.put("status", rs.getString("Status"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getFilteredBookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }      public Map<String, Object> getBookingSummary() {
        Map<String, Object> summary = new HashMap<>();
        String sql = "SELECT COUNT(*) as totalCustomers, SUM(b.total_prices) as totalRevenue " +
                     "FROM BookingRoomDetails brd " +
                     "INNER JOIN Rooms r ON brd.room_id = r.id " +
                     "INNER JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                     "INNER JOIN Bookings b ON brd.booking_id = b.id " +
                     "INNER JOIN Users u ON b.user_id = u.id " +
                     "INNER JOIN Transactions t ON b.id = t.booking_id " +
                     "WHERE r.isDelete = 0 AND u.isDeleted = 0 AND t.status = 'Confirmed'";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                summary.put("totalCustomers", rs.getInt("totalCustomers"));
                summary.put("totalRevenue", rs.getDouble("totalRevenue"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting booking summary: " + e.getMessage());
            e.printStackTrace();
        }
        
        return summary;
    }
      public Map<String, Object> getFilteredBookingSummary(String startDate, String endDate, Integer roomTypeId) {
        Map<String, Object> summary = new HashMap<>();
          StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT COUNT(*) as totalCustomers, SUM(b.total_prices) as totalRevenue ");
        sqlBuilder.append("FROM BookingRoomDetails brd ");
        sqlBuilder.append("INNER JOIN Rooms r ON brd.room_id = r.id ");
        sqlBuilder.append("INNER JOIN RoomTypes rt ON r.room_type_id = rt.id ");
        sqlBuilder.append("INNER JOIN Bookings b ON brd.booking_id = b.id ");
        sqlBuilder.append("INNER JOIN Users u ON b.user_id = u.id ");
        sqlBuilder.append("INNER JOIN Transactions t ON b.id = t.booking_id ");
        sqlBuilder.append("WHERE r.isDelete = 0 AND u.isDeleted = 0 AND t.status = 'Confirmed' ");
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc theo ngày
        if (startDate != null && !startDate.isEmpty()) {
            sqlBuilder.append("AND b.created_at >= ? ");
            params.add(startDate);
        }
        
        if (endDate != null && !endDate.isEmpty()) {
            sqlBuilder.append("AND brd.check_out_date <= ? ");
            params.add(endDate);
        }
        
        // Thêm điều kiện lọc theo loại phòng
        if (roomTypeId != null) {
            sqlBuilder.append("AND rt.id = ? ");
            params.add(roomTypeId);
        }
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            // Thiết lập các tham số
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.put("totalCustomers", rs.getInt("totalCustomers"));
                    summary.put("totalRevenue", rs.getDouble("totalRevenue"));
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getFilteredBookingSummary: " + e.getMessage());
            e.printStackTrace();
        }
        
        return summary;
    }
    
    /**
     * Create a new booking room details record
     * @param bookingRoomDetails The booking room details to create
     * @return The generated booking room details ID, or -1 if failed
     */
    public int createBookingRoomDetails(BookingRoomDetails bookingRoomDetails) {
        int id = -1;
        String sql = "INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date, quantity, prices) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, bookingRoomDetails.getBookingId());
            ps.setInt(2, bookingRoomDetails.getRoomId());
            ps.setDate(3, new java.sql.Date(bookingRoomDetails.getCheckInDate().getTime()));
            ps.setDate(4, new java.sql.Date(bookingRoomDetails.getCheckOutDate().getTime()));
            ps.setInt(5, bookingRoomDetails.getQuantity());
            ps.setDouble(6, bookingRoomDetails.getPrices());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        id = rs.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error creating booking room details: " + e.getMessage());
            e.printStackTrace();
        }
        
        return id;
    }
}