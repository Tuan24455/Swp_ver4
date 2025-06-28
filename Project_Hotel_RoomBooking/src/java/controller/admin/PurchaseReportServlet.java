package controller.admin;

import dao.RoomDao;
import model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PurchaseReportServlet", urlPatterns = {"/purchasereport", "/admin/purchasereport"})
public class PurchaseReportServlet extends HttpServlet {
    
    private RoomDao roomDao;
    
    @Override
    public void init() throws ServletException {
        roomDao = new RoomDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy số lượng phòng theo trạng thái
            Map<String, Integer> statusCounts = roomDao.getRoomStatusCounts();
            
            // Tính tổng số phòng
            int totalRooms = 0;
            for (Integer count : statusCounts.values()) {
                totalRooms += count;
            }
            
            // Lấy số phòng theo từng trạng thái
            // Lưu ý: Bạn cần kiểm tra tên trạng thái trong database của bạn
            // Có thể là "Occupied", "Available", "Maintenance" hoặc tiếng Việt
            int occupiedRooms = statusCounts.getOrDefault("Occupied", 0);
            int availableRooms = statusCounts.getOrDefault("Available", 0);
            int maintenanceRooms = statusCounts.getOrDefault("Maintenance", 0);
            
            // Nếu database dùng tiếng Việt, có thể là:
            // int occupiedRooms = statusCounts.getOrDefault("Đang sử dụng", 0);
            // int availableRooms = statusCounts.getOrDefault("Trống", 0);
            // int maintenanceRooms = statusCounts.getOrDefault("Bảo trì", 0);
            
            // Set attributes để JSP có thể sử dụng
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("maintenanceRooms", maintenanceRooms);
            
            // Debug: In ra console để kiểm tra
            System.out.println("Room Status Counts: " + statusCounts);
            System.out.println("Total Rooms: " + totalRooms);
            System.out.println("Occupied: " + occupiedRooms);
            System.out.println("Available: " + availableRooms);
            System.out.println("Maintenance: " + maintenanceRooms);
            
            // Forward đến JSP
            request.getRequestDispatcher("/admin/purchasereport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading report: " + e.getMessage());
            request.getRequestDispatcher("/admin/purchasereport.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}