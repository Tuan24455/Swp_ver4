package dao;

import java.sql.*;
import model.Booking;
import java.util.ArrayList;
import java.util.List;
import dal.DBContext;
import java.text.SimpleDateFormat;
import model.RoomType;
import model.User;

public class BookingDao extends DBContext {

    /**
     * Creates a new booking, including room and service details, and VNPay
     * information. This method now takes a complete Booking object and handles
     * the details for it.
     *
     * @param booking The Booking object containing all booking details.
     * @param roomId The ID of the room being booked.
     * @param quantityRoom The quantity of rooms being booked.
     * @param roomPricePerNight The price per night for the room.
     * @param selectedServices A list of service IDs selected for the booking.
     * @param servicePrices A list of corresponding prices for the selected
     * services.
     * @return The generated booking ID, or -1 if the creation failed.
     */
    public int createBooking(Booking booking, int roomId, int quantityRoom, double roomPricePerNight, List<Integer> selectedServices, List<Double> servicePrices) {
        int bookingId = -1;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert into Bookings table
            String sqlBooking = "INSERT INTO Bookings (user_id, created_at, promotion_id, total_prices, status, room_review_id, service_review_id, vnp_TxnRef, vnp_OrderInfo, vnp_ResponseCode, vnp_TransactionStatus, vnp_PayDate, vnp_TransactionNo, vnp_BankCode, vnp_Amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getUserId());
            ps.setTimestamp(2, new Timestamp(booking.getCreatedAt().getTime()));
            if (booking.getPromotionId() != 0) { // Check if promotionId is set
                ps.setInt(3, booking.getPromotionId());
            } else {
                ps.setNull(3, Types.INTEGER); // Set to NULL if no promotion
            }
            ps.setDouble(4, booking.getTotalPrices());
            ps.setString(5, booking.getStatus());
            if (booking.getRoomReviewId() != null) {
                ps.setInt(6, booking.getRoomReviewId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            if (booking.getServiceReviewId() != null) {
                ps.setInt(7, booking.getServiceReviewId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, booking.getVnp_TxnRef());
            ps.setString(9, booking.getVnp_OrderInfo());
            ps.setString(10, booking.getVnp_ResponseCode());
            ps.setString(11, booking.getVnp_TransactionStatus());
            ps.setString(12, booking.getVnp_PayDate());
            ps.setString(13, booking.getVnp_TransactionNo());
            ps.setString(14, booking.getVnp_BankCode());
            ps.setString(15, booking.getVnp_Amount()); // Store as String as per model and common practice for VNPay amounts
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);

                // 2. Insert into BookingRoomDetails table
                String sqlRoomDetails = "INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date, quantity, prices) VALUES (?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(sqlRoomDetails);
                ps.setInt(1, bookingId);
                ps.setInt(2, roomId);
                ps.setDate(3, new java.sql.Date(booking.getCheckInDate().getTime()));
                ps.setDate(4, new java.sql.Date(booking.getCheckOutDate().getTime()));
                ps.setInt(5, quantityRoom); // Assuming quantity is 1 for a single room booking, or pass as parameter
                ps.setDouble(6, roomPricePerNight); // Price for this specific room booking
                ps.executeUpdate();

                // 3. Insert into BookingServiceDetail table (Corrected table name)
                if (selectedServices != null && !selectedServices.isEmpty()) {
                    String sqlServiceDetails = "INSERT INTO BookingServiceDetail (booking_id, service_id, quantity, prices) VALUES (?, ?, ?, ?)";
                    ps = conn.prepareStatement(sqlServiceDetails);
                    for (int i = 0; i < selectedServices.size(); i++) {
                        ps.setInt(1, bookingId);
                        ps.setInt(2, selectedServices.get(i));
                        ps.setInt(3, 1); // Assuming quantity is 1 for each selected service
                        ps.setDouble(4, servicePrices.get(i)); // Price for this specific service booking
                        ps.addBatch(); // Add to batch for efficient insertion
                    }
                    ps.executeBatch(); // Execute all batched inserts
                }

                conn.commit(); // Commit transaction
            }

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback on error
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return bookingId;
    }

    /**
     * Retrieves a list of bookings for a specific user. Includes user full name
     * and room/service review IDs. Fetches check-in and check-out dates from
     * BookingRoomDetails.
     *
     * @param userId The ID of the user.
     * @return A list of Booking objects.
     */
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, brd.check_in_date, brd.check_out_date "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoomDetails brd ON b.id = brd.booking_id " // Use LEFT JOIN in case a booking doesn't have room details yet
                + "WHERE b.user_id = ? ORDER BY b.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();


                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setUserName(rs.getString("full_name"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setStatus(rs.getString("status"));
                booking.setRoomReviewId(rs.getObject("room_review_id") != null ? rs.getInt("room_review_id") : null);
                booking.setServiceReviewId(rs.getObject("service_review_id") != null ? rs.getInt("service_review_id") : null);

                // Set check-in and check-out dates from BookingRoomDetails
                booking.setCheckInDate(rs.getDate("check_in_date"));
                booking.setCheckOutDate(rs.getDate("check_out_date"));

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Updates the status of a booking.
     *
     * @param bookingId The ID of the booking to update.
     * @param status The new status.
     * @return True if the update was successful, false otherwise.
     */
    public boolean updateBookingStatus(int id, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves a paginated list of all bookings. Includes user full name and
     * room/service review IDs. Fetches check-in and check-out dates from
     * BookingRoomDetails.
     *
     * @param offset The starting offset for pagination.
     * @param limit The maximum number of records to retrieve.
     * @return A list of Booking objects.
     */
    public List<Booking> getBookingsByPage(int offset, int limit) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, brd.check_in_date, brd.check_out_date "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoomDetails brd ON b.id = brd.booking_id "
                + "ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setUserName(rs.getString("full_name"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setStatus(rs.getString("status"));
                booking.setRoomReviewId(rs.getObject("room_review_id") != null ? rs.getInt("room_review_id") : null);
                booking.setServiceReviewId(rs.getObject("service_review_id") != null ? rs.getInt("service_review_id") : null);

                // Set check-in and check-out dates
                booking.setCheckInDate(rs.getDate("check_in_date"));
                booking.setCheckOutDate(rs.getDate("check_out_date"));

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Counts the total number of bookings.
     *
     * @return The total count of bookings.
     */
    public int countAllBookings() {
        String sql = "SELECT COUNT(*) FROM Bookings";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves a paginated list of bookings filtered by status. Includes user
     * full name and room/service review IDs. Fetches check-in and check-out
     * dates from BookingRoomDetails.
     *
     * @param status The status to filter by.
     * @param offset The starting offset for pagination.
     * @param limit The maximum number of records to retrieve.
     * @return A list of Booking objects.
     */
    public List<Booking> getBookingsByStatus(String status, int offset, int intlimit) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, brd.check_in_date, brd.check_out_date "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoomDetails brd ON b.id = brd.booking_id "
                + "WHERE b.status = ? ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, intlimit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id")); // Added missing userId set
                booking.setUserName(rs.getString("full_name"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setStatus(rs.getString("status"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setRoomReviewId(rs.getObject("room_review_id") != null ? rs.getInt("room_review_id") : null);
                booking.setServiceReviewId(rs.getObject("service_review_id") != null ? rs.getInt("service_review_id") : null);

                // Set check-in and check-out dates
                booking.setCheckInDate(rs.getDate("check_in_date"));
                booking.setCheckOutDate(rs.getDate("check_out_date"));

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Counts the number of bookings filtered by status.
     *
     * @param status The status to filter by.
     * @return The count of bookings with the specified status.
     */
    public int countBookingsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Searches for bookings based on status and check-in/check-out dates.
     * Includes user full name and room/service review IDs. Fetches check-in and
     * check-out dates from BookingRoomDetails.
     *
     * @param status The booking status to filter by (can be null or empty for
     * no filter).
     * @param fromDate The start date for the check-in/check-out range (can be
     * null for no date filter).
     * @param toDate The end date for the check-in/check-out range (can be null
     * for no date filter).
     * @param offset The starting offset for pagination.
     * @param limit The maximum number of records to retrieve.
     * @return A list of Booking objects matching the criteria.
     */
    public List<Booking> searchBookings(String status, Date fromDate, Date toDate, int offset, int limit) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT b.*, u.full_name, brd.check_in_date, brd.check_out_date "
                + "FROM Bookings b "
                + "JOIN BookingRoomDetails brd ON b.id = brd.booking_id "
                + // Use JOIN as we filter by dates in BookingRoomDetails
                "JOIN Users u ON b.user_id = u.id WHERE 1=1 ");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND b.status = ? ");
        }
        if (fromDate != null && toDate != null) {
            // Corrected date logic for overlap: check_in_date <= @toDate AND check_out_date >= @fromDate
            sql.append(" AND brd.check_in_date <= ? AND brd.check_out_date >= ? ");
        }

        sql.append(" ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(i++, status);
            }
            if (fromDate != null && toDate != null) {
                ps.setDate(i++, new java.sql.Date(toDate.getTime()));   // Bind toDate first
                ps.setDate(i++, new java.sql.Date(fromDate.getTime())); // Then fromDate
            }
            ps.setInt(i++, offset);
            ps.setInt(i, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));
                b.setUserId(rs.getInt("user_id")); // Added missing userId set
                b.setUserName(rs.getString("full_name"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setStatus(rs.getString("status"));
                b.setPromotionId(rs.getInt("promotion_id"));
                b.setTotalPrices(rs.getDouble("total_prices"));
                b.setRoomReviewId(rs.getObject("room_review_id") != null ? rs.getInt("room_review_id") : null);
                b.setServiceReviewId(rs.getObject("service_review_id") != null ? rs.getInt("service_review_id") : null);

                // Set check-in and check-out dates
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));

                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Counts the number of bookings matching search criteria (status, fromDate,
     * toDate).
     *
     * @param status The booking status to filter by.
     * @param fromDate The start date for the check-in/check-out range.
     * @param toDate The end date for the check-in/check-out range.
     * @return The count of bookings matching the criteria.
     */
    public int countSearchBookings(String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT b.id) FROM Bookings b "
                + "JOIN BookingRoomDetails brd ON b.id = brd.booking_id WHERE 1=1 "); // Use JOIN for date filtering

        if (status != null && !status.isEmpty()) {
            sql.append(" AND b.status = ? ");
        }
        if (fromDate != null && toDate != null) {
            // Corrected date logic for overlap
            sql.append(" AND brd.check_in_date <= ? AND brd.check_out_date >= ? ");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(i++, status);
            }
            if (fromDate != null && toDate != null) {
                ps.setDate(i++, new java.sql.Date(toDate.getTime()));   // Bind toDate first
                ps.setDate(i++, new java.sql.Date(fromDate.getTime())); // Then fromDate
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<User> getAllUsers() throws Exception {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, full_name FROM Users WHERE isDeleted = 0";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                list.add(u);
            }
        }
        return list;
    }

    public List<String> getAllBookingStatuses() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM Bookings";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RoomType> getAllRoomTypes() throws Exception {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT id, room_type FROM RoomTypes";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setRoomType(rs.getString("room_type"));
                list.add(rt);
            }
        }
        return list;
    }

    /**
     * Retrieves a single booking by its ID, including user full name and all
     * booking details. Fetches check-in and check-out dates from
     * BookingRoomDetails.
     *
     * @param id The ID of the booking to retrieve.
     * @return The Booking object, or null if not found.
     */
    public Booking getBookingById(int id) {
        Booking booking = null;
        // Adjust JOINs to correctly retrieve room dates as part of the main booking object
        String sql = "SELECT b.*, u.full_name, brd.check_in_date, brd.check_out_date "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoomDetails brd ON b.id = brd.booking_id " // LEFT JOIN to allow bookings without room details if applicable, though typically won't happen
                + "WHERE b.id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setUserName(rs.getString("full_name"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));

                // Handle potential NULL for promotion_id
                if (rs.getObject("promotion_id") != null) {
                    booking.setPromotionId(rs.getInt("promotion_id"));
                } else {
                    booking.setPromotionId(0); // Or handle as null if that's preferred in your logic
                }

                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setStatus(rs.getString("status"));

                // Handle potential NULL for review IDs
                booking.setRoomReviewId(rs.getObject("room_review_id") != null ? rs.getInt("room_review_id") : null);
                booking.setServiceReviewId(rs.getObject("service_review_id") != null ? rs.getInt("service_review_id") : null);

                // Set check-in and check-out dates from BookingRoomDetails
                booking.setCheckInDate(rs.getDate("check_in_date"));
                booking.setCheckOutDate(rs.getDate("check_out_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

public void addBooking(Booking booking) {
    String sql = "INSERT INTO Bookings (user_id, promotion_id, total_prices, status, created_at) "
               + "VALUES (?, ?, ?, ?, GETDATE())";

    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {

        // 1. user_id
        ps.setInt(1, booking.getUserId());

        // 2. promotion_id (cho NULL nếu không có)
        if (booking.getPromotionId() > 0) {
            ps.setInt(2, booking.getPromotionId());
        } else {
            ps.setNull(2, java.sql.Types.INTEGER);
        }

        // 3. total_prices
        ps.setDouble(3, booking.getTotalPrices());

        // 4. status
        ps.setString(4, booking.getStatus());

        // Execute
        ps.executeUpdate();
        System.out.println("✅ Booking added successfully!");

    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("❌ Error when adding booking: " + e.getMessage());
    }
      /**
     * Lấy tất cả booking với thông tin phòng, khách, ngày nhận/trả, tổng tiền, trạng thái...
     */
    public List<Booking> getAllBookingsWithDetails() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.id AS booking_id, u.full_name AS customer, " +
                "STRING_AGG(r.room_number, ', ') AS room_numbers, " +
                "MIN(brd.check_in_date) AS check_in, " +
                "MAX(brd.check_out_date) AS check_out, " +
                "b.total_prices, b.status, b.created_at " +
                "FROM Bookings b " +
                "JOIN Users u ON b.user_id = u.id " +
                "JOIN BookingRoomDetails brd ON brd.booking_id = b.id " +
                "JOIN Rooms r ON brd.room_id = r.id " +
                "JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                "GROUP BY b.id, u.full_name, b.total_prices, b.status, b.created_at " +
                "ORDER BY b.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking(
                    rs.getString("room_numbers"),
                    rs.getString("customer"),
                    rs.getString("check_in"),
                    rs.getString("check_out"),
                    rs.getString("status")
                );
                booking.setId(rs.getInt("booking_id"));
                booking.setTotalPrices(rs.getDouble("total_prices"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    /**
     * Lấy booking theo phân trang với thông tin phòng, khách, ngày nhận/trả, tổng tiền, trạng thái...
     * @param pageNumber Số trang (1-based)
     * @param pageSize Số lượng booking mỗi trang
     * @return Danh sách booking theo trang
     */
    public List<Booking> getBookingsWithPagination(int pageNumber, int pageSize) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.id AS booking_id, u.full_name AS customer, " +
                "STRING_AGG(r.room_number, ', ') AS room_numbers, " +
                "MIN(brd.check_in_date) AS check_in, " +
                "MAX(brd.check_out_date) AS check_out, " +
                "b.total_prices, b.status, b.created_at " +
                "FROM Bookings b " +
                "JOIN Users u ON b.user_id = u.id " +
                "JOIN BookingRoomDetails brd ON brd.booking_id = b.id " +
                "JOIN Rooms r ON brd.room_id = r.id " +
                "JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                "GROUP BY b.id, u.full_name, b.total_prices, b.status, b.created_at " +
                "ORDER BY b.created_at DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking(
                        rs.getString("room_numbers"),
                        rs.getString("customer"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getString("status")
                    );
                    booking.setId(rs.getInt("booking_id"));
                    booking.setTotalPrices(rs.getDouble("total_prices"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    /**
     * Đếm tổng số booking trong hệ thống
     * @return Tổng số booking
     */
    public int getTotalBookingsCount() {
        String sql = "SELECT COUNT(DISTINCT b.id) AS total FROM Bookings b " +
                "JOIN BookingRoomDetails brd ON brd.booking_id = b.id";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
      /**
     * Đếm tổng số booking trong hệ thống với bộ lọc
     * @param status Trạng thái booking cần lọc (null nếu không lọc)
     * @param checkInDate Ngày check-in cần lọc (null nếu không lọc)
     * @param checkOutDate Ngày check-out cần lọc (null nếu không lọc)
     * @return Tổng số booking thỏa mãn điều kiện lọc
     */
    public int getFilteredBookingsCount(String status, java.sql.Date checkInDate, java.sql.Date checkOutDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT b.id) AS total FROM Bookings b " +
                "JOIN BookingRoomDetails brd ON brd.booking_id = b.id " +
                "JOIN Users u ON b.user_id = u.id " +
                "JOIN Rooms r ON brd.room_id = r.id " +
                "JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                "WHERE 1=1");
        
        if (status != null && !status.isEmpty()) {
            sql.append(" AND LOWER(b.status) = LOWER(?)");
        }
        
        if (checkInDate != null) {
            sql.append(" AND brd.check_in_date = ?");
        }
        
        if (checkOutDate != null) {
            sql.append(" AND brd.check_out_date = ?");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            if (checkInDate != null) {
                ps.setDate(paramIndex++, new java.sql.Date(checkInDate.getTime()));
            }
            
            if (checkOutDate != null) {
                ps.setDate(paramIndex++, new java.sql.Date(checkOutDate.getTime()));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
      /**
     * Lấy booking theo phân trang và bộ lọc với thông tin phòng, khách, ngày nhận/trả, tổng tiền, trạng thái...
     * @param pageNumber Số trang (1-based)
     * @param pageSize Số lượng booking mỗi trang
     * @param status Trạng thái booking cần lọc (null nếu không lọc)
     * @param checkInDate Ngày check-in cần lọc (null nếu không lọc)
     * @param checkOutDate Ngày check-out cần lọc (null nếu không lọc)
     * @return Danh sách booking theo trang và bộ lọc
     */
    public List<Booking> getFilteredBookingsWithPagination(int pageNumber, int pageSize, String status, 
                                                          java.sql.Date checkInDate, java.sql.Date checkOutDate) {
        List<Booking> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.id AS booking_id, u.full_name AS customer, " +
                "STRING_AGG(r.room_number, ', ') AS room_numbers, " +
                "MIN(brd.check_in_date) AS check_in, " +
                "MAX(brd.check_out_date) AS check_out, " +
                "b.total_prices, b.status, b.created_at " +
                "FROM Bookings b " +
                "JOIN Users u ON b.user_id = u.id " +
                "JOIN BookingRoomDetails brd ON brd.booking_id = b.id " +
                "JOIN Rooms r ON brd.room_id = r.id " +
                "JOIN RoomTypes rt ON r.room_type_id = rt.id " +
                "WHERE 1=1");
        
        if (status != null && !status.isEmpty()) {
            sql.append(" AND LOWER(b.status) = LOWER(?)");
        }
        
        if (checkInDate != null) {
            sql.append(" AND brd.check_in_date = ?");
        }
        
        if (checkOutDate != null) {
            sql.append(" AND brd.check_out_date = ?");
        }
        
        sql.append(" GROUP BY b.id, u.full_name, b.total_prices, b.status, b.created_at " +
                "ORDER BY b.created_at DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            if (checkInDate != null) {
                ps.setDate(paramIndex++, new java.sql.Date(checkInDate.getTime()));
            }
            
            if (checkOutDate != null) {
                ps.setDate(paramIndex++, new java.sql.Date(checkOutDate.getTime()));
            }
            
            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking(
                        rs.getString("room_numbers"),
                        rs.getString("customer"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getString("status")
                    );
                    booking.setId(rs.getInt("booking_id"));
                    booking.setTotalPrices(rs.getDouble("total_prices"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}




     public static void main(String[] args) {
        try {
            BookingDao dao = new BookingDao();
            Booking booking = new Booking();

            // ⚠️ Set đúng ID user và trạng thái có trong DB
            booking.setUserId(1); // giả sử ID = 1 là có thật
            booking.setPromotionId(0); // = 0 để test null
            booking.setTotalPrices(150.0);
            booking.setStatus("Confirmed");

            // Format ngày check-in và check-out
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            booking.setCheckInDate(sdf.parse("2025-08-01"));
            booking.setCheckOutDate(sdf.parse("2025-08-05"));

            dao.addBooking(booking);
            System.out.println("✅ Thêm booking thành công!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
