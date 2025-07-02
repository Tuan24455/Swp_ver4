package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        
        String sql = "SELECT * FROM vw_RoomBookingDetails";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("roomNumber", rs.getString("Tên Phòng"));
                booking.put("floor", rs.getString("Tầng"));
                booking.put("roomType", rs.getString("Loại Phòng"));
                booking.put("capacity", rs.getString("Sức Chứa"));
                booking.put("customerName", rs.getString("Tên Khách Hàng"));
                booking.put("checkInDate", rs.getDate("Ngày Đặt"));
                booking.put("checkOutDate", rs.getDate("Ngày Trả"));
                booking.put("totalPrice", rs.getDouble("Tổng Tiền"));
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
        
        StringBuilder sqlBuilder = new StringBuilder("SELECT b.* FROM vw_RoomBookingDetails b ");
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
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("roomNumber", rs.getString("Tên Phòng"));
                    booking.put("floor", rs.getString("Tầng"));
                    booking.put("roomType", rs.getString("Loại Phòng"));
                    booking.put("capacity", rs.getString("Sức Chứa"));
                    booking.put("customerName", rs.getString("Tên Khách Hàng"));
                    booking.put("checkInDate", rs.getDate("Ngày Đặt"));
                    booking.put("checkOutDate", rs.getDate("Ngày Trả"));
                    booking.put("totalPrice", rs.getDouble("Tổng Tiền"));
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
}