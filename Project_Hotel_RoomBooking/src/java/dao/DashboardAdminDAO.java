package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardAdminDAO {

    // Method to get total revenue
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM Bookings WHERE status = 'PAID'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get room status counts
    public Map<String, Integer> getRoomStatusCounts() {
        Map<String, Integer> roomStats = new HashMap<>();
        // Correctly map room statuses to Occupied, Vacant, or Maintenance
        String sql = "SELECT CASE WHEN room_status = 'Occupied' THEN 'Occupied' WHEN room_status = 'Available' THEN 'Vacant' WHEN room_status = 'Maintenance' THEN 'Maintenance' WHEN room_status = 'Cleaning' THEN 'Cleaning' ELSE room_status END as status, COUNT(*) as count FROM Rooms WHERE isDelete = 0 GROUP BY room_status";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roomStats.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomStats;
    }

    // Method to get total number of rooms
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms";
        try (Connection conn = new DBContext().getConnection();
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

    // Method to get average room rating
    public double getAverageRoomRating() {
        String sql = "SELECT AVG(CAST(quality AS FLOAT)) FROM RoomReviews";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get average service rating
    public double getAverageServiceRating() {
        String sql = "SELECT AVG(CAST(quality AS FLOAT)) FROM ServiceReviews";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get recent bookings
    public List<Map<String, Object>> getRecentBookings(int limit) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT TOP(?) [Tên Phòng], [Tầng], [Loại Phòng], [Tên Khách Hàng], [Ngày Đặt], [Ngày Trả], [Tổng Tiền] " +
                     "FROM vw_RoomBookingDetails " +
                     "ORDER BY [Ngày Đặt] DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("roomNumber", rs.getString("Tên Phòng"));
                    booking.put("floor", rs.getInt("Tầng"));
                    booking.put("roomType", rs.getString("Loại Phòng"));
                    booking.put("customerName", rs.getString("Tên Khách Hàng"));
                    booking.put("checkInDate", rs.getDate("Ngày Đặt"));
                    booking.put("checkOutDate", rs.getDate("Ngày Trả"));
                    booking.put("totalPrice", rs.getDouble("Tổng Tiền"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}