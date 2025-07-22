package dao;

import dal.DBContext;
import model.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardReceptionDAO extends DBContext {

    public Map<String, List<Booking>> getAllRoomBookings() {
        Map<String, List<Booking>> roomBookings = new HashMap<>();
        String sql = "SELECT r.room_number, u.full_name AS customer, brd.check_in_date, brd.check_out_date, b.status " +
                     "FROM Rooms r " +
                     "LEFT JOIN BookingRoomDetails brd ON r.id = brd.room_id " +
                     "LEFT JOIN Bookings b ON brd.booking_id = b.id " +
                     "LEFT JOIN Users u ON b.user_id = u.id " +
                     "WHERE r.isDelete = 0 " +
                     "AND (b.status IN (N'Pending', N'Confirmed', N'Check-in', N'Check-out') OR b.status IS NULL) " +
                     "ORDER BY r.room_number, brd.check_in_date;";

        try (Connection conn = getConnection()) {
            if (conn == null || conn.isClosed()) {
                throw new SQLException("Database connection is not established.");
            }
            System.out.println("Database connection established successfully.");

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                System.out.println("Executing query: " + sql);

                while (rs.next()) {
                    String roomNumber = rs.getString("room_number");
                    String customer = rs.getString("customer");
                    String checkInDate = rs.getString("check_in_date");
                    String checkOutDate = rs.getString("check_out_date");
                    String status = rs.getString("status");

                    System.out.println("Fetched data - Room: " + roomNumber + ", Customer: " + customer + ", Check-in: " + checkInDate + ", Check-out: " + checkOutDate + ", Status: " + status);

                    Booking booking = new Booking(roomNumber, customer, checkInDate, checkOutDate, status);
                    roomBookings.computeIfAbsent(roomNumber, k -> new ArrayList<>()).add(booking);
                }

                System.out.println("Total rooms fetched: " + roomBookings.size());
            }
        } catch (SQLException e) {
            System.err.println("Error while fetching room bookings: " + e.getMessage());
            e.printStackTrace();
        }

        return roomBookings;
    }
}