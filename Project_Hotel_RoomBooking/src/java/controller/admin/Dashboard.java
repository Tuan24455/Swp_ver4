package controller.admin;

import dao.RoomDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Map;

@WebServlet(name = "Dashboard", urlPatterns = {"/admin/dashboard"})
public class Dashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Khởi tạo DAO
            RoomDao roomDao = new RoomDao();
            
            // Lấy thống kê phòng theo các phương thức mới
            int totalRooms = roomDao.getTotalRooms();
            
            // Lấy thống kê chi tiết từ Map để xác định đúng tên trạng thái
            Map<String, Integer> roomStats = roomDao.getRoomStatusCounts();
            
            // Debug: In ra tất cả trạng thái có trong database
            System.out.println("=== Room Status Debug ===");
            for (Map.Entry<String, Integer> entry : roomStats.entrySet()) {
                System.out.println("Status: '" + entry.getKey() + "' - Count: " + entry.getValue());
            }
            
            // Thử các tên trạng thái khác nhau
            int occupiedRooms = roomStats.getOrDefault("OCCUPIED", 0);
            if (occupiedRooms == 0) {
                occupiedRooms = roomStats.getOrDefault("Occupied", 0);
            }
            if (occupiedRooms == 0) {
                occupiedRooms = roomStats.getOrDefault("occupied", 0);
            }
            
            int vacantRooms = roomStats.getOrDefault("VACANT", 0);
            if (vacantRooms == 0) {
                vacantRooms = roomStats.getOrDefault("Available", 0);
            }
            if (vacantRooms == 0) {
                vacantRooms = roomStats.getOrDefault("available", 0);
            }
            if (vacantRooms == 0) {
                vacantRooms = roomStats.getOrDefault("AVAILABLE", 0);
            }
            
            int maintenanceRooms = roomStats.getOrDefault("MAINTENANCE", 0);
            if (maintenanceRooms == 0) {
                maintenanceRooms = roomStats.getOrDefault("Maintenance", 0);
            }
            if (maintenanceRooms == 0) {
                maintenanceRooms = roomStats.getOrDefault("maintenance", 0);
            }
            
            // Nếu vẫn không có phòng trống, tính toán từ tổng số phòng
            if (vacantRooms == 0 && totalRooms > 0) {
                int accountedRooms = occupiedRooms + maintenanceRooms;
                vacantRooms = totalRooms - accountedRooms;
                if (vacantRooms < 0) vacantRooms = 0;
            }
            
            System.out.println("Final counts - Total: " + totalRooms + ", Occupied: " + occupiedRooms + ", Vacant: " + vacantRooms + ", Maintenance: " + maintenanceRooms);
            System.out.println("=== End Debug ===");
            
            // Tính tổng số phòng có thể sử dụng (không tính phòng bảo trì)
            int totalUsableRooms = occupiedRooms + vacantRooms;
            
            // Tính tỷ lệ lấp đầy
            double occupancyRate = 0.0;
            if (totalUsableRooms > 0) {
                occupancyRate = (occupiedRooms * 100.0) / totalUsableRooms;
            }
            
            // Format tỷ lệ
            DecimalFormat df = new DecimalFormat("#.#");
            String formattedRate = df.format(occupancyRate);
            
            // Set attributes cho JSP
            request.setAttribute("occupancyRate", formattedRate);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("vacantRooms", vacantRooms);
            request.setAttribute("maintenanceRooms", maintenanceRooms);
            request.setAttribute("totalRooms", totalRooms);
            
            // Thêm dữ liệu mẫu cho các thống kê khác (có thể thay thế bằng dữ liệu thực từ database)
            request.setAttribute("totalRevenue", "15.8 tỷ VND");
            request.setAttribute("averageRating", "4.8/5");
            
            // Set thông báo thành công
            request.setAttribute("dashboardLoaded", true);
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Log error với thông tin chi tiết
            System.err.println("Error in Dashboard Servlet: " + e.getMessage());
            
            // Set default values để tránh lỗi trong JSP
            request.setAttribute("occupancyRate", "0.0");
            request.setAttribute("occupiedRooms", 0);
            request.setAttribute("vacantRooms", 0);
            request.setAttribute("maintenanceRooms", 0);
            request.setAttribute("totalRooms", 0);
            request.setAttribute("totalRevenue", "0 VND");
            request.setAttribute("averageRating", "0/5");
            request.setAttribute("errorMessage", "Không thể tải dữ liệu dashboard: " + e.getMessage());
            
            // Vẫn forward đến JSP với dữ liệu mặc định
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle AJAX requests if needed
        String action = request.getParameter("action");
        
        if ("refreshStats".equals(action)) {
            // Implement refresh logic here
        }
    }
}