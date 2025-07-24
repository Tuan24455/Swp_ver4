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

    // Method lấy báo cáo hóa đơn dịch vụ chi tiết  
    public List<Map<String, Object>> getServiceInvoiceReportDataPaginated(Date dateFrom, Date dateTo, String serviceType, String paymentStatus, String guestType, int page, int pageSize) {
        List<Map<String, Object>> serviceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    sb.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    s.service_name AS [Dịch Vụ],\n"
                + "    sb.booking_date AS [Ngày Đặt],\n"
                + "    sb.quantity AS [Số Lượng],\n"
                + "    s.service_price AS [Đơn Giá],\n"
                + "    sb.total_amount AS [Tổng Tiền],\n"
                + "    sb.status AS [Trạng Thái]\n"
                + "FROM \n"
                + "    ServiceBookings sb\n"
                + "    INNER JOIN Users u ON sb.user_id = u.id\n"
                + "    INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE \n"
                + "    (? IS NULL OR sb.booking_date >= ?) \n"
                + "    AND (? IS NULL OR sb.booking_date <= ?) \n"
                + "    AND (? = '' OR s.service_name LIKE ?) \n"
                + "    AND (? = '' OR sb.status = ?) \n"
                + "    AND (? = '' OR u.role = ?) \n"
                + "ORDER BY \n"
                + "    sb.id DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        
        System.out.println("DAO: getServiceInvoiceReportDataPaginated called");
        System.out.println("DAO: Parameters - dateFrom: " + dateFrom + ", dateTo: " + dateTo + ", serviceType: " + serviceType + ", paymentStatus: " + paymentStatus + ", guestType: " + guestType + ", page: " + page + ", pageSize: " + pageSize);

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, serviceType);
            ps.setString(6, serviceType);
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
                    serviceData.add(row);
                }
            }
        } catch (SQLException e) {
            System.out.println("DAO: SQL Error in getServiceInvoiceReportDataPaginated: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("DAO: Returning " + serviceData.size() + " service invoice records");
        return serviceData;
    }

    // Method đếm tổng số hóa đơn dịch vụ
    public int getTotalServiceInvoiceCount(Date dateFrom, Date dateTo, String serviceType, String paymentStatus, String guestType) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM ServiceBookings sb\n"
                + "    INNER JOIN Users u ON sb.user_id = u.id\n"
                + "    INNER JOIN Services s ON sb.service_id = s.id\n"
                + "    WHERE (? IS NULL OR sb.booking_date >= ?)\n"
                + "    AND (? IS NULL OR sb.booking_date <= ?)\n"
                + "    AND (? = '' OR s.service_name LIKE ?)\n"
                + "    AND (? = '' OR sb.status = ?)\n"
                + "    AND (? = '' OR u.role = ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, serviceType);
            ps.setString(6, serviceType);
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

    // Method lấy chi tiết hóa đơn dịch vụ theo ID
    public Map<String, Object> getServiceInvoiceDetailsById(int invoiceId) {
        Map<String, Object> serviceInvoiceDetails = new HashMap<>();
        String sql = "SELECT \n"
                + "    sb.id AS invoiceId,\n"
                + "    u.full_name AS customerName,\n"
                + "    s.service_name AS serviceName,\n"
                + "    sb.booking_date AS bookingDate,\n"
                + "    sb.quantity AS quantity,\n"
                + "    s.service_price AS unitPrice,\n"
                + "    sb.total_amount AS totalAmount,\n"
                + "    sb.status AS status,\n"
                + "    '' AS note\n"
                + "FROM \n"
                + "    ServiceBookings sb\n"
                + "    INNER JOIN Users u ON sb.user_id = u.id\n"
                + "    INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE \n"
                + "    sb.id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ResultSetMetaData md = rs.getMetaData();
                    int columns = md.getColumnCount();
                    
                    for (int i = 1; i <= columns; i++) {
                        serviceInvoiceDetails.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceInvoiceDetails;
    }

    // Method lấy báo cáo hóa đơn phòng chi tiết  
    public List<Map<String, Object>> getRoomInvoiceReportDataPaginated(Date dateFrom, Date dateTo, String roomType, String paymentStatus, String guestType, int page, int pageSize) {
        List<Map<String, Object>> invoiceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    b.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    r.room_number AS [Phòng],\n"
                + "    brd.check_in_date AS [Nhận Phòng],\n"
                + "    brd.check_out_date AS [Trả Phòng],\n"
                + "    brd.prices AS [Phí Phòng],\n"
                + "    b.total_prices AS [Tổng Tiền],\n"
                + "    COALESCE(t.status, 'Pending') AS [Trạng Thái]\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    (? IS NULL OR brd.check_in_date >= ?) \n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"
                + "    AND (? = '' OR rt.room_type = ?) \n"
                + "    AND (? = '' OR t.status = ?) \n"
                + "    AND (? = '' OR u.role = ?) \n"
                + "ORDER BY \n"
                + "    b.created_at DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";

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

    // Method đếm tổng số hóa đơn phòng
    public int getTotalRoomInvoiceCount(Date dateFrom, Date dateTo, String roomType, String paymentStatus, String guestType) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "    WHERE (? IS NULL OR brd.check_in_date >= ?)\n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?)\n"
                + "    AND (? = '' OR rt.room_type = ?)\n"
                + "    AND (? = '' OR t.status = ?)\n"
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

    // Methods lấy dữ liệu cho dropdown filters
    public List<String> getAllRoomTypes() {
        List<String> roomTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT room_type FROM RoomTypes ORDER BY room_type";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                roomTypes.add(rs.getString("room_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }

    public List<String> getAllTransactionStatuses() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM Transactions WHERE status IS NOT NULL ORDER BY status";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                statuses.add(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statuses;
    }

    public List<String> getAllGuestTypes() {
        List<String> guestTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT role FROM Users WHERE role IS NOT NULL ORDER BY role";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                guestTypes.add(rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guestTypes;
    }

    public List<String> getAllServiceTypes() {
        List<String> serviceTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT s.service_name FROM Services s ORDER BY s.service_name";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                serviceTypes.add(rs.getString("service_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceTypes;
    }

    // Method lấy dữ liệu báo cáo dịch vụ (top services)
    public List<Map<String, Object>> getServiceReportData() {
        List<Map<String, Object>> serviceData = new ArrayList<>();
        String sql = "SELECT TOP 5 \n"
                + "    s.service_name AS [Dịch Vụ],\n"
                + "    ISNULL(SUM(sb.quantity), 0) AS [Số Lần Sử Dụng],\n"
                + "    ISNULL(SUM(sb.total_amount), 0) AS [Doanh Thu],\n"
                + "    CASE \n"
                + "        WHEN ISNULL(SUM(sb.quantity), 0) > 0 \n"
                + "        THEN CAST(SUM(sb.total_amount) / SUM(sb.quantity) AS DECIMAL(10, 2)) \n"
                + "        ELSE 0 \n"
                + "    END AS [Giá Trung Bình]\n"
                + "FROM \n"
                + "    Services s\n"
                + "LEFT JOIN \n"
                + "    ServiceBookings sb ON s.id = sb.service_id AND sb.status IN ('Confirmed', 'Completed')\n"
                + "WHERE \n"
                + "    s.isDeleted = 0\n"
                + "GROUP BY \n"
                + "    s.id, s.service_name\n"
                + "ORDER BY \n"
                + "    [Doanh Thu] DESC";

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
                serviceData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceData;
    }

    // Method lấy dữ liệu báo cáo dịch vụ với phân trang
    public List<Map<String, Object>> getServiceReportDataPaginated(int page, int pageSize) {
        List<Map<String, Object>> serviceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    s.service_name AS [Dịch Vụ],\n"
                + "    ISNULL(SUM(sb.quantity), 0) AS [Số Lần Sử Dụng],\n"
                + "    ISNULL(SUM(sb.total_amount), 0) AS [Doanh Thu],\n"
                + "    CASE \n"
                + "        WHEN ISNULL(SUM(sb.quantity), 0) > 0 \n"
                + "        THEN CAST(SUM(sb.total_amount) / SUM(sb.quantity) AS DECIMAL(10, 2)) \n"
                + "        ELSE 0 \n"
                + "    END AS [Giá Trung Bình]\n"
                + "FROM \n"
                + "    Services s\n"
                + "LEFT JOIN \n"
                + "    ServiceBookings sb ON s.id = sb.service_id AND sb.status IN ('Confirmed', 'Completed')\n"
                + "WHERE \n"
                + "    s.isDeleted = 0\n"
                + "GROUP BY \n"
                + "    s.id, s.service_name\n"
                + "ORDER BY \n"
                + "    [Doanh Thu] DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
                    serviceData.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceData;
    }
    
    // Method đếm tổng số services unique
    public int getTotalServiceCount() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Services WHERE isDeleted = 0";

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

    // Method lấy chi tiết hóa đơn phòng theo ID
    public Map<String, Object> getInvoiceDetailsById(int invoiceId) {
        Map<String, Object> invoiceDetails = new HashMap<>();
        String sql = "SELECT \n"
                + "    b.id AS invoiceId,\n"
                + "    u.full_name AS customerName,\n"
                + "    r.room_number AS room,\n"
                + "    brd.check_in_date AS checkIn,\n"
                + "    brd.check_out_date AS checkOut,\n"
                + "    brd.prices AS roomFee,\n"
                + "    b.total_prices AS totalAmount,\n"
                + "    COALESCE(t.status, 'Pending') AS status\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    b.id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ResultSetMetaData md = rs.getMetaData();
                    int columns = md.getColumnCount();
                    
                    for (int i = 1; i <= columns; i++) {
                        invoiceDetails.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoiceDetails;
    }

    // Method lấy dữ liệu báo cáo doanh thu phòng
    public List<Map<String, Object>> getPurchaseReportData() {
        List<Map<String, Object>> reportData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    rt.room_type AS [Loai Phong],\n"
                + "    ISNULL(SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity), 0) AS [So Dem],\n"
                + "    ISNULL(SUM(brd.prices), 0) AS [Doanh Thu],\n"
                + "    CASE \n"
                + "        WHEN SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity) > 0 \n"
                + "        THEN SUM(brd.prices) / SUM(DATEDIFF(DAY, brd.check_in_date, brd.check_out_date) * brd.quantity) \n"
                + "        ELSE 0 \n"
                + "    END AS [Gia Trung Binh]\n"
                + "FROM \n"
                + "    RoomTypes rt\n"
                + "    LEFT JOIN Rooms r ON rt.id = r.room_type_id AND r.isDelete = 0\n"
                + "    LEFT JOIN BookingRoomDetails brd ON r.id = brd.room_id\n"
                + "    LEFT JOIN Bookings b ON brd.booking_id = b.id\n"
                + "WHERE b.status = N'Confirmed' OR b.status IS NULL\n"
                + "GROUP BY \n"
                + "    rt.room_type\n"
                + "ORDER BY \n"
                + "    rt.room_type;";

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

    // Method lấy báo cáo hóa đơn kết hợp (phòng + dịch vụ) với phân trang
    public List<Map<String, Object>> getCombinedInvoiceReportDataPaginated(Date dateFrom, Date dateTo, String roomType, String serviceType, String paymentStatus, int page, int pageSize) {
        List<Map<String, Object>> combinedData = new ArrayList<>();
        String sql = "(SELECT \n"
                + "    b.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    r.room_number AS [Phòng],\n"
                + "    brd.check_in_date AS [Nhận Phòng],\n"
                + "    brd.check_out_date AS [Trả Phòng],\n"
                + "    brd.prices AS [Phí Phòng],\n"
                + "    NULL AS [Dịch Vụ],\n"
                + "    b.total_prices AS [Tổng Tiền],\n"
                + "    COALESCE(t.status, 'Pending') AS [Trạng Thái],\n"
                + "    'room' AS type\n"
                + "FROM \n"
                + "    Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE \n"
                + "    (? IS NULL OR brd.check_in_date >= ?) \n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"
                + "    AND (? = '' OR rt.room_type = ?) \n"
                + "    AND (? = '' OR t.status = ?) \n"
                + ") UNION ALL (\n"
                + "SELECT \n"
                + "    sb.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    NULL AS [Phòng],\n"
                + "    NULL AS [Nhận Phòng],\n"
                + "    NULL AS [Trả Phòng],\n"
                + "    NULL AS [Phí Phòng],\n"
                + "    s.service_name AS [Dịch Vụ],\n"
                + "    sb.total_amount AS [Tổng Tiền],\n"
                + "    sb.status AS [Trạng Thái],\n"
                + "    'service' AS type\n"
                + "FROM \n"
                + "    ServiceBookings sb\n"
                + "    INNER JOIN Users u ON sb.user_id = u.id\n"
                + "    INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE \n"
                + "    (? IS NULL OR sb.booking_date >= ?) \n"
                + "    AND (? IS NULL OR sb.booking_date <= ?) \n"
                + "    AND (? = '' OR s.service_name LIKE ?) \n"
                + "    AND (? = '' OR sb.status = ?) \n"
                + ") ORDER BY [Số Hóa Đơn] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Parameters for room part
            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, roomType);
            ps.setString(6, roomType);
            ps.setString(7, paymentStatus);
            ps.setString(8, paymentStatus);

            // Parameters for service part
            ps.setDate(9, dateFrom);
            ps.setDate(10, dateFrom);
            ps.setDate(11, dateTo);
            ps.setDate(12, dateTo);
            ps.setString(13, serviceType);
            ps.setString(14, serviceType);
            ps.setString(15, paymentStatus);
            ps.setString(16, paymentStatus);

            // Pagination
            ps.setInt(17, (page - 1) * pageSize);
            ps.setInt(18, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int columns = md.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columns; i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    combinedData.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return combinedData;
    }

    public int getTotalCombinedInvoiceCount(Date dateFrom, Date dateTo, String roomType, String serviceType, String paymentStatus) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM (\n"
                + "(SELECT b.id FROM Bookings b\n"
                + "    INNER JOIN Users u ON b.user_id = u.id\n"
                + "    INNER JOIN BookingRoomDetails brd ON b.id = brd.booking_id\n"
                + "    INNER JOIN Rooms r ON brd.room_id = r.id AND r.isDelete = 0\n"
                + "    INNER JOIN RoomTypes rt ON r.room_type_id = rt.id\n"
                + "    LEFT JOIN Transactions t ON b.id = t.booking_id\n"
                + "WHERE (? IS NULL OR brd.check_in_date >= ?) \n"
                + "    AND (? IS NULL OR brd.check_out_date <= ?) \n"
                + "    AND (? = '' OR rt.room_type = ?) \n"
                + "    AND (? = '' OR t.status = ?)) \n"
                + "UNION ALL \n"
                + "(SELECT sb.id FROM ServiceBookings sb\n"
                + "    INNER JOIN Users u ON sb.user_id = u.id\n"
                + "    INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE (? IS NULL OR sb.booking_date >= ?) \n"
                + "    AND (? IS NULL OR sb.booking_date <= ?) \n"
                + "    AND (? = '' OR s.service_name LIKE ?) \n"
                + "    AND (? = '' OR sb.status = ?))\n"
                + ") AS combined";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Room part
            ps.setDate(1, dateFrom);
            ps.setDate(2, dateFrom);
            ps.setDate(3, dateTo);
            ps.setDate(4, dateTo);
            ps.setString(5, roomType);
            ps.setString(6, roomType);
            ps.setString(7, paymentStatus);
            ps.setString(8, paymentStatus);

            // Service part
            ps.setDate(9, dateFrom);
            ps.setDate(10, dateFrom);
            ps.setDate(11, dateTo);
            ps.setDate(12, dateTo);
            ps.setString(13, serviceType);
            ps.setString(14, serviceType);
            ps.setString(15, paymentStatus);
            ps.setString(16, paymentStatus);

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

    // Method lấy báo cáo hóa đơn dịch vụ chi tiết với filter đơn giản
    public List<Map<String, Object>> getServiceInvoiceDetailsReport(Date dateFrom, Date dateTo, String serviceType, String status, String guestType, int page, int pageSize) {
        List<Map<String, Object>> serviceData = new ArrayList<>();
        String sql = "SELECT \n"
                + "    sb.id AS [Số Hóa Đơn],\n"
                + "    u.full_name AS [Tên Khách],\n"
                + "    s.service_name AS [Dịch Vụ],\n"
                + "    sb.booking_date AS [Ngày Đặt],\n"
                + "    sb.quantity AS [Số Lượng],\n"
                + "    s.service_price AS [Đơn Giá],\n"
                + "    sb.total_amount AS [Tổng Tiền],\n"
                + "    sb.status AS [Trạng Thái]\n"
                + "FROM ServiceBookings sb\n"
                + "INNER JOIN Users u ON sb.user_id = u.id\n"
                + "INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE 1=1\n";
        
        List<Object> params = new ArrayList<>();
        
        // Add date filters
        if (dateFrom != null) {
            sql += " AND sb.booking_date >= ?\n";
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql += " AND sb.booking_date <= ?\n";
            params.add(dateTo);
        }
        
        // Add service type filter
        if (serviceType != null && !serviceType.trim().isEmpty()) {
            sql += " AND s.service_name LIKE ?\n";
            params.add("%" + serviceType + "%");
        }
        
        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND sb.status = ?\n";
            params.add(status);
        }
        
        // Add guest type filter
        if (guestType != null && !guestType.trim().isEmpty()) {
            sql += " AND u.role = ?\n";
            params.add(guestType);
        }
        
        sql += "ORDER BY sb.booking_date DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        System.out.println("DAO SQL: " + sql);
        System.out.println("DAO Params: " + params);

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int columns = md.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columns; i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    serviceData.add(row);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getServiceInvoiceDetailsReport: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DAO returned " + serviceData.size() + " records");
        return serviceData;
    }

    // Method đếm tổng số service invoices với filter
    public int getTotalServiceInvoiceDetailsCount(Date dateFrom, Date dateTo, String serviceType, String status, String guestType) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM ServiceBookings sb\n"
                + "INNER JOIN Users u ON sb.user_id = u.id\n"
                + "INNER JOIN Services s ON sb.service_id = s.id\n"
                + "WHERE 1=1\n";
        
        List<Object> params = new ArrayList<>();
        
        // Add date filters
        if (dateFrom != null) {
            sql += " AND sb.booking_date >= ?\n";
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql += " AND sb.booking_date <= ?\n";
            params.add(dateTo);
        }
        
        // Add service type filter
        if (serviceType != null && !serviceType.trim().isEmpty()) {
            sql += " AND s.service_name LIKE ?\n";
            params.add("%" + serviceType + "%");
        }
        
        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND sb.status = ?\n";
            params.add(status);
        }
        
        // Add guest type filter
        if (guestType != null && !guestType.trim().isEmpty()) {
            sql += " AND u.role = ?\n";
            params.add(guestType);
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalServiceInvoiceDetailsCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return total;
    }
}
