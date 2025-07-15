package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Date;  // Import cho java.sql.Date (dùng trong filter)
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PurchaseReportDAO extends DBContext {

    public List<Map<String, Object>> getPurchaseReportData() {
        List<Map<String, Object>> reportData = new ArrayList<>();
        String sql = "SELECT \n"
                + "          rt.room_type AS [Loai Phong],\n"
                + "          ISNULL(SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity), 0) AS [So Dem],\n"
                + "          ISNULL(SUM(brd.prices), 0) AS [Doanh Thu],\n"
                + "          CASE \n"
                + "              WHEN SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity) > 0 \n"
                + "              THEN SUM(brd.prices) / SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity) \n"
                + "              ELSE 0 \n"
                + "          END AS [Gia Trung Binh]\n"
                + "      FROM \n"
                + "          RoomTypes rt\n"
                + "          LEFT JOIN Rooms r ON rt.id = r.room_type_id AND r.isDelete = 0\n"
                + "          LEFT JOIN BookingRoomDetails brd ON r.id = brd.room_id\n"
                + "          LEFT JOIN Bookings b ON brd.booking_id = b.id\n"
                + "      WHERE b.status = N'Confirmed' OR b.status IS NULL\n"
                + "      GROUP BY \n"
                + "          rt.room_type\n"
                + "      ORDER BY \n"
                + "          rt.room_type;";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            ResultSetMetaData md = rs.getMetaData();
            int columns = md.getColumnCount();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= columns; i++) {
                    row.put(md.getColumnLabel(i), rs.getObject(i));
                }
                reportData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reportData;
    }

    public List<Map<String, Object>> getInvoiceReportData(Date dateFrom, Date dateTo, String roomType, String paymentStatus, String guestType) {
        List<Map<String, Object>> invoiceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    b.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    r.room_number AS [Phòng],\n"
                + "    brd.check_in_date AS [Nhận Phòng],\n"
                + "    brd.check_out_date AS [Trả Phòng],\n"
                + "    brd.prices AS [Phí Phòng],\n"
                + "    ISNULL(SUM(bsd.prices), 0) AS [Dịch Vụ Bổ Sung],\n"
                + "    b.total_prices AS [Tổng Tiền],\n"
                + "    t.status AS [Trạng Thái]\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"  // Thêm để lọc loại phòng
                + "    LEFT JOIN BookingServiceDetail bsd ON b.id = bsd.booking_id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    (? IS NULL OR brd.check_in_date >= ?) \n"  // Từ Ngày
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"  // Đến Ngày
                + "    AND (? = '' OR rt.room_type = ?) \n"  // Loại Phòng
                + "    AND (? = '' OR t.status = ?) \n"  // Trạng Thái Thanh Toán
                + "    AND (? = '' OR u.role = ?) \n"  // Loại Khách (dựa trên role)
                + "GROUP BY \n"
                + "    b.id, u.full_name, r.room_number, brd.check_in_date, brd.check_out_date, brd.prices, b.total_prices, t.status, b.created_at\n"
                + "ORDER BY \n"
                + "    b.created_at DESC;";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters cho filter
            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, roomType);
            ps.setString(6, roomType);
            ps.setString(7, paymentStatus);
            ps.setString(8, paymentStatus);
            ps.setString(9, guestType);
            ps.setString(10, guestType);

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int columns = md.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columns; i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    invoiceData.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoiceData;
    }

    // Method lấy list loại phòng cho dropdown
    public List<String> getAllRoomTypes() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT room_type FROM RoomTypes ORDER BY room_type ASC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("room_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Method lấy list trạng thái thanh toán cho dropdown
    public List<String> getAllTransactionStatuses() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM Transactions ORDER BY status ASC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Method lấy list loại khách cho dropdown (dựa trên role)
    public List<String> getAllGuestTypes() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT role FROM Users WHERE isDeleted = 0 ORDER BY role ASC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalServiceCount() {
        int total = 0;
        String sql = "SELECT COUNT(DISTINCT s.service_name) FROM Services s WHERE s.isDeleted = 0";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Map<String, Object>> getTopAdditionalServicesData(int page, int pageSize) {
        List<Map<String, Object>> servicesData = new ArrayList<>();
        String sql = "SELECT\n"
                + "    s.service_name               AS [Dịch Vụ],\n"
                + "    ISNULL(COUNT(bsd.id), 0)     AS [Số Lần Sử Dụng],\n"
                + "    ISNULL(SUM(bsd.prices), 0)   AS [Doanh Thu],\n"
                + "    s.service_price              AS [Giá Trung Bình]\n"
                + "FROM Services s\n"
                + "LEFT JOIN BookingServiceDetail bsd ON s.id = bsd.service_id\n"
                + "WHERE s.isDeleted = 0\n"
                + "GROUP BY s.service_name, s.service_price\n"
                + "ORDER BY [Doanh Thu] DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int columns = md.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columns; i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    servicesData.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return servicesData;
    }

    // Method đếm tổng số hóa đơn (có filter)
    public int getTotalInvoiceCount(Date dateFrom, Date dateTo, String roomType, String paymentStatus, String guestType) {
        int total = 0;
        String sql = "SELECT COUNT(DISTINCT b.id) FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN BookingServiceDetail bsd ON b.id = bsd.booking_id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    (? IS NULL OR brd.check_in_date >= ?) \n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"
                + "    AND (? = '' OR rt.room_type = ?) \n"
                + "    AND (? = '' OR t.status = ?) \n"
                + "    AND (? = '' OR u.role = ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, roomType);
            ps.setString(6, roomType);
            ps.setString(7, paymentStatus);
            ps.setString(8, paymentStatus);
            ps.setString(9, guestType);
            ps.setString(10, guestType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // Method lấy dữ liệu hóa đơn có phân trang
    public List<Map<String, Object>> getInvoiceReportDataPaginated(Date dateFrom, Date dateTo, String roomType, String paymentStatus, String guestType, int page, int pageSize) {
        List<Map<String, Object>> invoiceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    b.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    r.room_number AS [Phòng],\n"
                + "    brd.check_in_date AS [Nhận Phòng],\n"
                + "    brd.check_out_date AS [Trả Phòng],\n"
                + "    brd.prices AS [Phí Phòng],\n"
                + "    ISNULL(SUM(bsd.prices), 0) AS [Dịch Vụ Bổ Sung],\n"
                + "    b.total_prices AS [Tổng Tiền],\n"
                + "    t.status AS [Trạng Thái]\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN BookingServiceDetail bsd ON b.id = bsd.booking_id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    (? IS NULL OR brd.check_in_date >= ?) \n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"
                + "    AND (? = '' OR rt.room_type = ?) \n"
                + "    AND (? = '' OR t.status = ?) \n"
                + "    AND (? = '' OR u.role = ?) \n"
                + "GROUP BY \n"
                + "    b.id, u.full_name, r.room_number, brd.check_in_date, brd.check_out_date, brd.prices, b.total_prices, t.status, b.created_at\n"
                + "ORDER BY \n"
                + "    b.created_at DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters cho filter
            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, roomType);
            ps.setString(6, roomType);
            ps.setString(7, paymentStatus);
            ps.setString(8, paymentStatus);
            ps.setString(9, guestType);
            ps.setString(10, guestType);
            ps.setInt(11, (page - 1) * pageSize);
            ps.setInt(12, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int columns = md.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columns; i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    invoiceData.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoiceData;
    }

    // Method lấy chi tiết hóa đơn theo ID
    public Map<String, Object> getInvoiceDetailsById(int invoiceId) {
        Map<String, Object> invoiceDetails = null;
        String sql = "SELECT \n"
                + "    b.id AS invoiceId,\n"
                + "    u.full_name AS customerName,\n"
                + "    r.room_number AS room,\n"
                + "    brd.check_in_date AS checkIn,\n"
                + "    brd.check_out_date AS checkOut,\n"
                + "    brd.prices AS roomFee,\n"
                + "    ISNULL(SUM(bsd.prices), 0) AS additionalServices,\n"
                + "    b.total_prices AS totalAmount,\n"
                + "    t.status AS status\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    LEFT JOIN BookingServiceDetail bsd ON b.id = bsd.booking_id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    b.id = ?\n"
                + "GROUP BY \n"
                + "    b.id, u.full_name, r.room_number, brd.check_in_date, brd.check_out_date, brd.prices, b.total_prices, t.status";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    invoiceDetails = new HashMap<>();
                    invoiceDetails.put("invoiceId", rs.getObject("invoiceId"));
                    invoiceDetails.put("customerName", rs.getObject("customerName"));
                    invoiceDetails.put("room", rs.getObject("room"));
                    invoiceDetails.put("checkIn", rs.getObject("checkIn"));
                    invoiceDetails.put("checkOut", rs.getObject("checkOut"));
                    invoiceDetails.put("roomFee", rs.getObject("roomFee"));
                    invoiceDetails.put("additionalServices", rs.getObject("additionalServices"));
                    invoiceDetails.put("totalAmount", rs.getObject("totalAmount"));
                    invoiceDetails.put("status", rs.getObject("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoiceDetails;
    }
}