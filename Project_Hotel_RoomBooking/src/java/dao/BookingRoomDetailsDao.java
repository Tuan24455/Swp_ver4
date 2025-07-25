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

public class BookingRoomDetailsDao {
    
    public List<Map<String, Object>> getCurrentBookings() {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT " +
                "r.room_number, " +
                "r.floor, " +
                "rt.room_type, " +
                "r.capacity, " +
                "u.full_name as customer_name, " +
                "brd.check_in_date, " +
                "brd.check_out_date, " +
                "b.total_prices, " +
                "b.status " +
            "FROM Rooms r " +
            "LEFT JOIN RoomTypes rt ON r.room_type_id = rt.id " +
            "LEFT JOIN BookingRoomDetails brd ON r.id = brd.room_id " +
            "LEFT JOIN Bookings b ON brd.booking_id = b.id " +
            "LEFT JOIN Users u ON b.user_id = u.id " +
            "WHERE r.isDelete = 0 " +
            "AND b.status IN ('Pending', 'Confirmed') " +
            "ORDER BY r.room_number";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("roomNumber", rs.getString("room_number"));
                booking.put("floor", rs.getString("floor"));
                booking.put("roomType", rs.getString("room_type"));
                booking.put("capacity", rs.getString("capacity"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("checkInDate", rs.getDate("check_in_date"));
                booking.put("checkOutDate", rs.getDate("check_out_date"));
                booking.put("totalPrice", rs.getDouble("total_prices"));
                booking.put("status", rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.out.println("Error in BookingRoomDetailsDao: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<Map<String, Object>> getFilteredBookings(String startDate, String endDate, Integer roomTypeId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT r.room_number, r.floor, rt.room_type, r.capacity, u.full_name as customer_name, brd.check_in_date, brd.check_out_date, b.total_prices, b.status ");
        sqlBuilder.append("FROM Rooms r ");
        sqlBuilder.append("LEFT JOIN RoomTypes rt ON r.room_type_id = rt.id ");
        sqlBuilder.append("LEFT JOIN BookingRoomDetails brd ON r.id = brd.room_id ");
        sqlBuilder.append("LEFT JOIN Bookings b ON brd.booking_id = b.id ");
        sqlBuilder.append("LEFT JOIN Users u ON b.user_id = u.id ");
        sqlBuilder.append("WHERE r.isDelete = 0 AND b.status IN ('Pending', 'Confirmed') ");

        List<Object> params = new ArrayList<>();
        if (startDate != null && !startDate.isEmpty()) {
            sqlBuilder.append("AND brd.check_in_date >= ? ");
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
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("roomNumber", rs.getString("room_number"));
                    booking.put("floor", rs.getString("floor"));
                    booking.put("roomType", rs.getString("room_type"));
                    booking.put("capacity", rs.getString("capacity"));
                    booking.put("customerName", rs.getString("customer_name"));
                    booking.put("checkInDate", rs.getDate("check_in_date"));
                    booking.put("checkOutDate", rs.getDate("check_out_date"));
                    booking.put("totalPrice", rs.getDouble("total_prices"));
                    booking.put("status", rs.getString("status"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getFilteredBookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
    
    public Map<String, Object> getBookingSummary() {
        Map<String, Object> summary = new HashMap<>();
        String sql = "SELECT COUNT(*) as totalCustomers, SUM(prices) as totalRevenue FROM vw_RoomBookingDetails";
        
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
        
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) as totalCustomers, SUM(prices) as totalRevenue FROM vw_RoomBookingDetails b ");
        sqlBuilder.append("JOIN Rooms r ON b.[Tên Phòng] = r.room_number ");
        sqlBuilder.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc theo ngày
        if (startDate != null && !startDate.isEmpty()) {
            sqlBuilder.append("AND b.[Ngày Đặt] >= ? ");
            params.add(startDate);
        }
        
        if (endDate != null && !endDate.isEmpty()) {
            sqlBuilder.append("AND b.[Ngày Trả] <= ? ");
            params.add(endDate);
        }
        
        // Thêm điều kiện lọc theo loại phòng
        if (roomTypeId != null) {
            sqlBuilder.append("AND r.room_type_id = ? ");
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