package controller;

import dal.DBContext; // Giả định DBContext nằm trong package dal
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckAvailabilityAPISimple", urlPatterns = {"/api/check-availability-simple"})
public class CheckAvailabilityAPISimple extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        try {
            String roomIdParam = request.getParameter("roomId");
            String checkInParam = request.getParameter("checkIn");
            String checkOutParam = request.getParameter("checkOut");

            System.out.println("=== CheckAvailabilityAPISimple START ===");
            System.out.println("Room: " + roomIdParam + ", CheckIn: " + checkInParam + ", CheckOut: " + checkOutParam);

            // Validate parameters
            if (roomIdParam == null || roomIdParam.trim().isEmpty() ||
                checkInParam == null || checkInParam.trim().isEmpty() ||
                checkOutParam == null || checkOutParam.trim().isEmpty()) {

                String jsonResponse = "{\"available\": false, \"message\": \"Thiếu thông tin kiểm tra\"}";
                System.out.println("Sending response: " + jsonResponse);
                response.getWriter().write(jsonResponse);
                response.getWriter().flush();
                return;
            }

            // Parse parameters with error handling
            int roomId;
            LocalDate checkInDate;
            LocalDate checkOutDate;

            try {
                roomId = Integer.parseInt(roomIdParam.trim());
                checkInDate = LocalDate.parse(checkInParam.trim());
                checkOutDate = LocalDate.parse(checkOutParam.trim());
                System.out.println("Parsed successfully - Room ID: " + roomId + ", Dates: " + checkInDate + " to " + checkOutDate);
            } catch (Exception parseEx) {
                String jsonResponse = "{\"available\": false, \"message\": \"Định dạng dữ liệu không hợp lệ\"}";
                System.out.println("Parse error: " + parseEx.getMessage());
                System.out.println("Sending response: " + jsonResponse);
                response.getWriter().write(jsonResponse);
                response.getWriter().flush();
                return;
            }

            // Validate dates
            LocalDate today = LocalDate.now();
            if (checkInDate.isBefore(today)) {
                String jsonResponse = "{\"available\": false, \"message\": \"Ngày nhận phòng không thể là ngày trong quá khứ\"}";
                System.out.println("Sending response: " + jsonResponse);
                response.getWriter().write(jsonResponse);
                response.getWriter().flush();
                return;
            }

            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                 String jsonResponse = "{\"available\": false, \"message\": \"Ngày trả phòng phải sau ngày nhận phòng\"}";
                 System.out.println("Sending response: " + jsonResponse);
                 response.getWriter().write(jsonResponse);
                 response.getWriter().flush();
                 return;
             }


            // --- Thực hiện kiểm tra thực tế từ cơ sở dữ liệu ---
            boolean isAvailable = checkRoomAvailability(roomId, checkInDate, checkOutDate);

            String jsonResponse;
            if (isAvailable) {
                jsonResponse = "{\"available\": true, \"message\": \"Phòng có sẵn trong thời gian này. Giờ nhận phòng: 12:00, giờ trả phòng: 11:00.\"}";
            } else {
                jsonResponse = "{\"available\": false, \"message\": \"Phòng đã có người đặt trong thời gian này hoặc không sẵn sàng. Vui lòng chọn ngày khác.\"}";
            }

            System.out.println("Actual availability check result: " + isAvailable);
            System.out.println("Sending response: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            response.getWriter().flush();
            System.out.println("=== CheckAvailabilityAPISimple END ===");

        } catch (Exception e) {
            System.out.println("=== ERROR in CheckAvailabilityAPISimple ===");
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();

            String errorResponse = "{\"available\": false, \"message\": \"Lỗi hệ thống khi kiểm tra phòng\"}";
            System.out.println("Sending error response: " + errorResponse);

            try {
                response.getWriter().write(errorResponse);
                response.getWriter().flush();
            } catch (IOException ioEx) {
                System.out.println("Failed to send error response: " + ioEx.getMessage());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Kiểm tra tính sẵn có của phòng bằng cách truy vấn cơ sở dữ liệu.
     * Sử dụng logic từ câu truy vấn SQL mẫu.
     * @param roomId ID của phòng cần kiểm tra.
     * @param checkInDate Ngày nhận phòng.
     * @param checkOutDate Ngày trả phòng.
     * @return true nếu phòng có sẵn, false nếu không.
     */
    private boolean checkRoomAvailability(int roomId, LocalDate checkInDate, LocalDate checkOutDate) {
        // Câu truy vấn SQL tương ứng với logic mẫu bạn cung cấp
        // Lấy thông tin phòng và kiểm tra xem có đặt phòng nào xung đột không
        String sql = """
            SELECT
                r.id AS RoomId,
                r.room_number,
                r.room_status,
                r.isDelete,
                CASE
                    WHEN r.room_status = N'Maintenance' THEN 1
                    ELSE 0
                END AS IsMaintenance,
                CASE
                    WHEN EXISTS (
                        SELECT 1
                        FROM BookingRoomDetails brd
                        INNER JOIN Bookings b ON brd.booking_id = b.id
                        WHERE
                            brd.room_id = r.id
                            AND b.status IN (N'Pending', N'Confirmed')
                            AND (
                                ? < brd.check_out_date
                                AND ? > brd.check_in_date
                            )
                    ) THEN 1
                    ELSE 0
                END AS IsBooked
            FROM Rooms r
            WHERE
                r.id = ?
                AND r.isDelete = 0
                AND r.room_status != N'Maintenance';
            """;

        System.out.println("Attempting database connection...");
        DBContext dbContext = new DBContext(); // Giả định bạn có lớp DBContext để quản lý kết nối
        try (Connection conn = dbContext.getConnection(); // Giả định phương thức getConnection()
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Database connection successful!");

            // Set parameters for the query
            // Tham số 1 và 2 cho điều kiện xung đột thời gian
            ps.setDate(1, java.sql.Date.valueOf(checkInDate)); // ? < brd.check_out_date
            ps.setDate(2, java.sql.Date.valueOf(checkOutDate)); // ? > brd.check_in_date
            // Tham số 3 cho điều kiện WHERE r.id = ?
            ps.setInt(3, roomId);

            System.out.println("Executing availability query (based on provided SQL logic):");
            System.out.println("Room ID: " + roomId);
            System.out.println("Check-in: " + checkInDate);
            System.out.println("Check-out: " + checkOutDate);
            // In SQL query với placeholder (cho mục đích debug, không nên in trực tiếp giá trị vì lý do bảo mật)
            System.out.println("SQL Template: " + sql);

            try (ResultSet rs = ps.executeQuery()) {
                 // Kiểm tra xem có dòng kết quả nào trả về không
                 if (rs.next()) {
                     // Có dòng trả về nghĩa là phòng tồn tại, không bị xóa và không trong trạng thái Maintenance
                     int isBooked = rs.getInt("IsBooked"); // Lấy giá trị cột IsBooked (0 hoặc 1)
                     System.out.println("DEBUG: Room found. IsBooked flag: " + isBooked); // Log giá trị IsBooked

                     // Nếu IsBooked = 0, nghĩa là không có booking xung đột -> Phòng có sẵn
                     // Nếu IsBooked = 1, nghĩa là có booking xung đột -> Phòng không có sẵn
                     return (isBooked == 0);
                 } else {
                     // Không có dòng trả về nghĩa là phòng không tồn tại, bị xóa hoặc đang bảo trì
                     System.out.println("DEBUG: No room found matching criteria (might not exist, deleted, or under maintenance).");
                     return false; // Phòng không sẵn sàng
                 }
            }
        } catch (Exception e) {
            System.out.println("Error checking room availability in DB: " + e.getMessage());
            e.printStackTrace();
             // Trong trường hợp lỗi DB, bạn có thể chọn trả về false (an toàn hơn) hoặc ném exception
             // Ở đây tôi chọn trả về false và log lỗi
        }
        System.out.println("DEBUG: Returning false due to DB error or unexpected condition."); // Log nếu có lỗi
        return false; // Default to unavailable if error occurs or no rows returned unexpectedly
    }
}