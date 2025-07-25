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
import java.util.Set;
import java.util.TreeSet;

public class DashboardAdminDAO {

    // Method to get total revenue from room bookings
    public double getRoomRevenue() {
        String sql = "SELECT SUM(total_prices) AS [Tổng Doanh Thu Từ Tất Cả Bookings] " +
                     "FROM Bookings " +
                     "WHERE status = 'Confirmed'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double revenue = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : revenue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get total revenue from service bookings
    public double getServiceRevenue() {
        String sql = "SELECT SUM(total_amount) AS [Tổng Doanh Thu Từ Dịch Vụ] " +
                     "FROM ServiceBookings " +
                     "WHERE status = 'Confirmed'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double revenue = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : revenue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get total revenue (combined room + service)
    public double getTotalRevenue() {
        return getRoomRevenue() + getServiceRevenue();
    }

    // Method to get room status counts (giữ nguyên, OK)
    public Map<String, Integer> getRoomStatusCounts() {
        Map<String, Integer> roomStats = new HashMap<>();
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

    // Method to get total number of rooms (thêm lọc isDelete = 0)
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE isDelete = 0";
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

    // Method to get average room rating (sửa: xử lý null, bỏ cast không cần)
    public double getAverageRoomRating() {
        String sql = "SELECT AVG(quality * 1.0) FROM RoomReviews";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : avg;  // Xử lý null nếu không có review
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get average service rating (tương tự)
    public double getAverageServiceRating() {
        String sql = "SELECT AVG(quality * 1.0) FROM ServiceReviews";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : avg;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Method to get recent bookings (sửa: query join trực tiếp, không dùng view)
    public List<Map<String, Object>> getRecentBookings(int limit) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT TOP(?) " +
                     "r.room_number AS [Tên Phòng], " +
                     "r.floor AS [Tầng], " +
                     "rt.room_type AS [Loại Phòng], " +
                     "u.full_name AS [Tên Khách Hàng], " +
                     "brd.check_in_date AS [Ngày Đặt], " +
                     "brd.check_out_date AS [Ngày Trả], " +
                     "b.total_prices AS [Tổng Tiền] " +
                     "FROM BookingRoomDetails brd " +
                     "INNER JOIN Rooms r ON brd.room_id = r.id " +
                     "INNER JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                     "INNER JOIN Bookings b ON brd.booking_id = b.id " +
                     "INNER JOIN Users u ON b.user_id = u.id " +
                     "WHERE r.isDelete = 0 AND b.status IN (N'Pending', N'Confirmed') " +
                     "ORDER BY brd.check_in_date DESC";  // Sort by Ngày Đặt (check_in_date) DESC để lấy recent

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

    // Method để lấy data cho chart theo period (với fix đồng bộ labels, fill 0 cho missing)
    public Map<String, Object> getRevenueAndBookingData(String period) {
        Map<String, Object> data = new HashMap<>();
        Map<String, Double> revenueMap = new HashMap<>();  // Để lưu revenue theo label
        Map<String, Integer> bookingMap = new HashMap<>(); // Để lưu bookings theo label
        Set<String> allLabels = new TreeSet<>();  // Để merge labels unique và sort

        String sqlRevenue = "";
        String sqlBooking = "";

        if ("weekly".equals(period)) {
            // Doanh thu và booking theo 7 ngày gần nhất
            sqlRevenue = "SELECT CONVERT(VARCHAR(10), transaction_date, 120) AS label, SUM(amount) AS revenue " +
                         "FROM Transactions WHERE status = 'Paid' AND transaction_date >= DATEADD(DAY, -7, GETDATE()) " +
                         "GROUP BY CONVERT(VARCHAR(10), transaction_date, 120) ORDER BY label";
            sqlBooking = "SELECT CONVERT(VARCHAR(10), created_at, 120) AS label, COUNT(*) AS bookings " +
                         "FROM Bookings WHERE status = 'Confirmed' AND created_at >= DATEADD(DAY, -7, GETDATE()) " +
                         "GROUP BY CONVERT(VARCHAR(10), created_at, 120) ORDER BY label";
        } else if ("monthly".equals(period)) {
            // Theo 12 tháng gần nhất
            sqlRevenue = "SELECT CONVERT(VARCHAR(7), transaction_date, 120) AS label, SUM(amount) AS revenue " +
                         "FROM Transactions WHERE status = 'Paid' AND transaction_date >= DATEADD(MONTH, -12, GETDATE()) " +
                         "GROUP BY CONVERT(VARCHAR(7), transaction_date, 120) ORDER BY label";
            sqlBooking = "SELECT CONVERT(VARCHAR(7), created_at, 120) AS label, COUNT(*) AS bookings " +
                         "FROM Bookings WHERE status = 'Confirmed' AND created_at >= DATEADD(MONTH, -12, GETDATE()) " +
                         "GROUP BY CONVERT(VARCHAR(7), created_at, 120) ORDER BY label";
        } else if ("yearly".equals(period)) {
            // Theo 5 năm gần nhất
            sqlRevenue = "SELECT YEAR(transaction_date) AS label, SUM(amount) AS revenue " +
                         "FROM Transactions WHERE status = 'Paid' AND transaction_date >= DATEADD(YEAR, -5, GETDATE()) " +
                         "GROUP BY YEAR(transaction_date) ORDER BY label";
            sqlBooking = "SELECT YEAR(created_at) AS label, COUNT(*) AS bookings " +
                         "FROM Bookings WHERE status = 'Confirmed' AND created_at >= DATEADD(YEAR, -5, GETDATE()) " +
                         "GROUP BY YEAR(created_at) ORDER BY label";
        } else {
            return data;  // Period không hợp lệ
        }

        try (Connection conn = new DBContext().getConnection()) {
            // Query revenue
            try (PreparedStatement ps = conn.prepareStatement(sqlRevenue);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label = rs.getString("label");
                    revenueMap.put(label, rs.getDouble("revenue"));
                    allLabels.add(label);
                }
            }
            // Query bookings
            try (PreparedStatement ps = conn.prepareStatement(sqlBooking);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label = rs.getString("label");
                    bookingMap.put(label, rs.getInt("bookings"));
                    allLabels.add(label);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Chuyển allLabels thành list sort
        List<String> labels = new ArrayList<>(allLabels);
        List<Double> revenueData = new ArrayList<>();
        List<Integer> bookingData = new ArrayList<>();

        // Fill data, dùng 0 nếu missing
        for (String label : labels) {
            revenueData.add(revenueMap.getOrDefault(label, 0.0));
            bookingData.add(bookingMap.getOrDefault(label, 0));
        }

        data.put("labels", labels);
        data.put("revenue", revenueData);
        data.put("bookings", bookingData);
        return data;
    }

    // Method to get yearly room revenue data from Transactions table
    public Map<String, Object> getYearlyRoomRevenueData() {
        Map<String, Object> data = new HashMap<>();
        List<String> years = new ArrayList<>();
        List<Double> amounts = new ArrayList<>();
          String sql = "SELECT YEAR(transaction_date) as year, SUM(amount) as total_amount " +
                     "FROM Transactions " +
                     "WHERE status IN ('Confirmed', 'Paid') " +
                     "GROUP BY YEAR(transaction_date) " +
                     "ORDER BY YEAR(transaction_date)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                years.add(String.valueOf(rs.getInt("year")));
                amounts.add(rs.getDouble("total_amount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        data.put("years", years);
        data.put("amounts", amounts);
        return data;
    }
    
    // Method to get yearly service revenue data from ServiceBookings table
    public Map<String, Object> getYearlyServiceRevenueData() {
        Map<String, Object> data = new HashMap<>();
        List<String> years = new ArrayList<>();
        List<Double> amounts = new ArrayList<>();
        
        String sql = "SELECT YEAR(booking_date) as year, SUM(total_amount) as total_amount " +
                     "FROM ServiceBookings " +
                     "WHERE status = 'Confirmed' " +
                     "GROUP BY YEAR(booking_date) " +
                     "ORDER BY YEAR(booking_date)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                years.add(String.valueOf(rs.getInt("year")));
                amounts.add(rs.getDouble("total_amount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        data.put("years", years);
        data.put("amounts", amounts);
        return data;
    }
      // Method to get combined yearly revenue data for chart
    @SuppressWarnings("unchecked")
    public Map<String, Object> getCombinedYearlyRevenueData() {
        Map<String, Object> roomData = getYearlyRoomRevenueData();
        Map<String, Object> serviceData = getYearlyServiceRevenueData();
        
        // Get all unique years
        Set<String> allYears = new TreeSet<>();
        allYears.addAll((List<String>) roomData.get("years"));
        allYears.addAll((List<String>) serviceData.get("years"));
        
        // Create maps for easy lookup
        Map<String, Double> roomAmountMap = new HashMap<>();
        List<String> roomYears = (List<String>) roomData.get("years");
        List<Double> roomAmounts = (List<Double>) roomData.get("amounts");
        for (int i = 0; i < roomYears.size(); i++) {
            roomAmountMap.put(roomYears.get(i), roomAmounts.get(i));
        }
        
        Map<String, Double> serviceAmountMap = new HashMap<>();
        List<String> serviceYears = (List<String>) serviceData.get("years");
        List<Double> serviceAmounts = (List<Double>) serviceData.get("amounts");
        for (int i = 0; i < serviceYears.size(); i++) {
            serviceAmountMap.put(serviceYears.get(i), serviceAmounts.get(i));
        }
        
        // Build final data
        List<String> finalYears = new ArrayList<>(allYears);
        List<Double> finalRoomAmounts = new ArrayList<>();
        List<Double> finalServiceAmounts = new ArrayList<>();
        
        for (String year : finalYears) {
            finalRoomAmounts.add(roomAmountMap.getOrDefault(year, 0.0));
            finalServiceAmounts.add(serviceAmountMap.getOrDefault(year, 0.0));
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("years", finalYears);
        result.put("roomAmounts", finalRoomAmounts);
        result.put("serviceAmounts", finalServiceAmounts);
        return result;
    }
      // Method to get total amount from Transactions with status = 'Confirmed'
    public double getRoomRevenueFromTransactions() {
        String sql = "SELECT SUM(amount) AS total_amount " +
                     "FROM Transactions " +
                     "WHERE status IN ('Confirmed', 'Paid')";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double amount = rs.getDouble("total_amount");
                return rs.wasNull() ? 0.0 : amount;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}