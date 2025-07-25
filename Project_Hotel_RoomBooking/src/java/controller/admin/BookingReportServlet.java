package controller.admin;

import dao.BookingRoomDetailsDao;
import dao.RoomDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import model.RoomType;

@WebServlet(name = "BookingReportServlet", urlPatterns = {"/bookingreport", "/admin/bookingreport"})
public class BookingReportServlet extends HttpServlet {
    
    private BookingRoomDetailsDao bookingDao;
    private RoomDao roomDao;
    
    @Override
    public void init() throws ServletException {
        bookingDao = new BookingRoomDetailsDao();
        roomDao = new RoomDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          try {
            // Get pagination parameters
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            int pageSize = 10; // Số record trên mỗi trang
            
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Get date range parameters
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String roomTypeParam = request.getParameter("roomType");
            Integer roomTypeId = null;
            
            // Chuyển đổi roomType từ String sang Integer nếu có
            if (roomTypeParam != null && !roomTypeParam.isEmpty()) {
                try {
                    roomTypeId = Integer.parseInt(roomTypeParam);
                } catch (NumberFormatException e) {
                    // Xử lý lỗi nếu không thể chuyển đổi
                    e.printStackTrace();
                }
            }
            
            // Lấy danh sách booking hiện tại theo bộ lọc với phân trang
            List<Map<String, Object>> currentBookings = bookingDao.getFilteredBookingsPaginated(startDate, endDate, roomTypeId, currentPage, pageSize);
            
            // Lấy tổng số records để tính pagination
            int totalRecords = bookingDao.getTotalFilteredBookingsCount(startDate, endDate, roomTypeId);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            
            request.setAttribute("currentBookings", currentBookings);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("pageSize", pageSize);

            // Lấy tổng khách và tổng doanh thu theo bộ lọc
            Map<String, Object> bookingSummary = bookingDao.getFilteredBookingSummary(startDate, endDate, roomTypeId);
            request.setAttribute("totalCustomers", bookingSummary.getOrDefault("totalCustomers", 0));
            request.setAttribute("totalRevenue", bookingSummary.getOrDefault("totalRevenue", 0));

            // Lấy thống kê phòng
            Map<String, Object> roomStatistics = new LinkedHashMap<>();
            int totalRooms, occupiedRooms, maintenanceRooms, vacantRooms;
            
            // Nếu có lọc theo loại phòng
            if (roomTypeId != null) {
                totalRooms = roomDao.getTotalRoomsByType(roomTypeId);
                occupiedRooms = roomDao.getRoomCountByStatusAndType("occupied", roomTypeId);
                if (occupiedRooms == 0) {
                    occupiedRooms = roomDao.getRoomCountByStatusAndType("Occupied", roomTypeId);
                }
                maintenanceRooms = roomDao.getRoomCountByStatusAndType("maintenance", roomTypeId);
                if (maintenanceRooms == 0) {
                    maintenanceRooms = roomDao.getRoomCountByStatusAndType("Maintenance", roomTypeId);
                }
            } else {
                // Không lọc theo loại phòng
                totalRooms = roomDao.getTotalRooms();
                occupiedRooms = roomDao.getRoomCountByStatus("occupied");
                if (occupiedRooms == 0) {
                    occupiedRooms = roomDao.getRoomCountByStatus("Occupied");
                }
                maintenanceRooms = roomDao.getRoomCountByStatus("maintenance");
                if (maintenanceRooms == 0) {
                    maintenanceRooms = roomDao.getRoomCountByStatus("Maintenance");
                }
            }
            
            vacantRooms = totalRooms - occupiedRooms - maintenanceRooms;
            
            roomStatistics.put("Tổng số phòng", Map.of("count", totalRooms, "description", "Tổng số phòng trong khách sạn"));
            roomStatistics.put("Phòng đã đặt", Map.of("count", occupiedRooms, "description", "Số phòng hiện đang có khách"));
            roomStatistics.put("Phòng trống", Map.of("count", vacantRooms, "description", "Số phòng sẵn sàng cho khách đặt"));
            roomStatistics.put("Phòng bảo trì", Map.of("count", maintenanceRooms, "description", "Số phòng đang được bảo trì"));
            
            // Đã thêm dữ liệu vào roomStatistics ở trên
            
            // Lấy danh sách loại phòng
            List<RoomType> roomTypes = roomDao.getAllRoomTypes();
            
            // Set attributes for JSP
            request.setAttribute("currentBookings", currentBookings);
            request.setAttribute("bookingSummary", bookingSummary);
            request.setAttribute("roomStatistics", roomStatistics);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("selectedRoomType", roomTypeId); // Lưu loại phòng đã chọn
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/bookingreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading booking report: " + e.getMessage());
            request.getRequestDispatcher("/admin/bookingreport.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
}