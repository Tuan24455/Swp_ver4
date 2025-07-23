package controller.reception;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.DashboardReceptionDAO;
import model.Booking;
import util.JsonEscapeUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "DashboardReceptionServlet", urlPatterns = {"/reception/dashboard", "/json-test"})
public class DashboardReceptionServlet extends HttpServlet {

    private final DashboardReceptionDAO dao = new DashboardReceptionDAO();

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("=== DashboardReceptionServlet đã được khởi tạo ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== DashboardReceptionServlet: doGet method started ===");
        String path = request.getServletPath();
        System.out.println("Path yêu cầu: " + path);
        
        if ("/json-test".equals(path)) {
            // Cung cấp dữ liệu JSON trực tiếp
            serveJsonData(response);
        } else {
            // Chuyển đến trang dashboard JSP
            serveDashboardPage(request, response);
        }
    }

    private void serveJsonData(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu đặt phòng từ DAO
        Map<String, List<Booking>> roomBookings = dao.getAllRoomBookings();
        
        // Nếu không có dữ liệu từ DAO, tạo dữ liệu mẫu
        if (roomBookings == null || roomBookings.isEmpty()) {
            System.out.println("Không có dữ liệu từ DAO, sử dụng dữ liệu mẫu");
            roomBookings = generateSampleBookingData();
        }
        
        // Chuyển đổi sang JSON và gửi phản hồi
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
        String jsonData = gson.toJson(roomBookings);
        
        System.out.println("DashboardReceptionServlet: Gửi dữ liệu JSON, độ dài: " + jsonData.length());
        
        PrintWriter out = response.getWriter();
        out.print(jsonData);
        out.flush();
    }
    
    private void serveDashboardPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DashboardReceptionServlet: Chuẩn bị hiển thị trang dashboard");
        
        try {
            // Lấy dữ liệu từ DAO
            Map<String, List<Booking>> roomBookings = dao.getAllRoomBookings();
            
            if (roomBookings == null || roomBookings.isEmpty()) {
                System.out.println("DashboardReceptionServlet: Không tìm thấy dữ liệu đặt phòng từ DAO.");
                request.setAttribute("errorMessage", "Không có dữ liệu đặt phòng để hiển thị.");
                request.setAttribute("roomBookings", new HashMap<String, List<Booking>>());
                request.setAttribute("roomBookingsJson", "{}");
            } else {
                System.out.println("DashboardReceptionServlet: Tìm thấy " + roomBookings.size() + " phòng có đặt.");
                
                // Đặt thuộc tính roomBookings
                request.setAttribute("roomBookings", roomBookings);
                
                // Tạo và đặt chuỗi JSON
                Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
                String roomBookingsJson = gson.toJson(roomBookings);
                request.setAttribute("roomBookingsJson", roomBookingsJson);
                System.out.println("DashboardReceptionServlet: Độ dài JSON: " + roomBookingsJson.length());
            }
            
            // Chuyển tiếp đến trang dashboard JSP
            request.getRequestDispatcher("/reception/dashboard.jsp").forward(request, response);
            System.out.println("DashboardReceptionServlet: Đã chuyển tiếp thành công đến dashboard.jsp");
            
        } catch (Exception e) {
            System.err.println("DashboardReceptionServlet: Xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Lỗi tải dữ liệu: " + e.getMessage());
            request.setAttribute("roomBookings", new HashMap<String, List<Booking>>());
            request.setAttribute("roomBookingsJson", "{}");
            
            request.getRequestDispatcher("/reception/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Tạo dữ liệu đặt phòng mẫu để kiểm tra dashboard
     */
    private Map<String, List<Booking>> generateSampleBookingData() {
        Map<String, List<Booking>> roomBookings = new HashMap<>();
        
        // Tạo một số dữ liệu mẫu cho nhiều phòng
        createSampleBookingsForRoom(roomBookings, "101", 3);
        createSampleBookingsForRoom(roomBookings, "102", 2);
        createSampleBookingsForRoom(roomBookings, "201", 1);
        createSampleBookingsForRoom(roomBookings, "202", 2);
        createSampleBookingsForRoom(roomBookings, "301", 1);
        
        return roomBookings;
    }
    
    /**
     * Phương thức hỗ trợ để tạo đặt phòng mẫu cho một phòng cụ thể
     */
    private void createSampleBookingsForRoom(Map<String, List<Booking>> roomBookings, 
                                             String roomNumber, int count) {
        List<Booking> bookings = new ArrayList<>();
        
        // Các tùy chọn trạng thái để tạo ngẫu nhiên
        String[] statuses = {"Confirmed", "Pending", "Check-in", "Check-out"};
        String[] customerNames = {"Nguyễn Văn A", "Trần Thị B", "Lê Văn C", "Phạm Thị D", "Hoàng Văn E"};
        
        Random random = new Random();
        Calendar calendar = Calendar.getInstance();
        
        // Bắt đầu với ngày hôm nay
        calendar.setTime(new Date());
        
        for (int i = 0; i < count; i++) {
            // Tạo ngày ngẫu nhiên trong vòng 30 ngày tới
            int startOffset = random.nextInt(30);
            int duration = 1 + random.nextInt(5); // Lưu trú 1-5 ngày
            
            calendar.setTime(new Date());
            calendar.add(Calendar.DATE, startOffset);
            String checkInDate = String.format("%d-%02d-%02d", 
                    calendar.get(Calendar.YEAR),
                    calendar.get(Calendar.MONTH) + 1,
                    calendar.get(Calendar.DAY_OF_MONTH));
            
            calendar.add(Calendar.DATE, duration);
            String checkOutDate = String.format("%d-%02d-%02d", 
                    calendar.get(Calendar.YEAR),
                    calendar.get(Calendar.MONTH) + 1,
                    calendar.get(Calendar.DAY_OF_MONTH));
            
            // Chọn trạng thái và khách hàng ngẫu nhiên
            String status = statuses[random.nextInt(statuses.length)];
            String customer = customerNames[random.nextInt(customerNames.length)];
            
            // Tạo đặt phòng
            Booking booking = new Booking(roomNumber, customer, checkInDate, checkOutDate, status);
            bookings.add(booking);
        }
        
        roomBookings.put(roomNumber, bookings);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for reception dashboard: Cung cấp dữ liệu đặt phòng dưới dạng JSON và phục vụ trang dashboard";
    }
}