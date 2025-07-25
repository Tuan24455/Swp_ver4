package controller;

import dao.RoomDao;
import dao.PromotionDao;
import dal.DBContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;
import model.Promotion;

@WebServlet(name = "CheckRoomAvailabilityServlet", urlPatterns = {"/check-availability"})
public class CheckRoomAvailabilityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy thông tin cơ bản
            String roomId = request.getParameter("roomId");
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            
            System.out.println("Processing room booking request:");
            System.out.println("Room ID: " + roomId);
            System.out.println("Check-in: " + checkIn);
            System.out.println("Check-out: " + checkOut);
            
            // Validate input
            if (roomId == null || checkIn == null || checkOut == null) {
                redirectWithError(response, request, roomId, "Thiếu thông tin đặt phòng");
                return;
            }
            
            // Parse dates
            LocalDate checkInDate = LocalDate.parse(checkIn);
            LocalDate checkOutDate = LocalDate.parse(checkOut);
            
            // Validate dates
            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                redirectWithError(response, request, roomId, "Ngày trả phòng phải sau ngày nhận phòng");
                return;
            }
            
            // Calculate nights
            long nights = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            
            // Check room availability
            int id = Integer.parseInt(roomId);
            RoomDao roomDAO = new RoomDao();
            Date sqlCheckIn = Date.valueOf(checkInDate);
            Date sqlCheckOut = Date.valueOf(checkOutDate);
            
            List<Room> availableRooms = roomDAO.filterRoomsAdvanced(null, null, null, null, null, sqlCheckIn, sqlCheckOut);
            
            boolean isAvailable = false;
            for (Room room : availableRooms) {
                if (room.getId() == id) {
                    isAvailable = true;
                    break;
                }
            }
            
            if (!isAvailable) {
                redirectWithError(response, request, roomId, "Phòng không có sẵn trong thời gian này");
                return;
            }
            
            // Get other parameters
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            String maxGuests = request.getParameter("maxGuests");
            String floor = request.getParameter("floor");
            String pricePerNight = request.getParameter("pricePerNight");
            String imageUrl = request.getParameter("imageUrl");
            String discountCode = request.getParameter("discountCodeSelected");
            
            // Calculate pricing
            double price = Double.parseDouble(pricePerNight);
            double originalTotal = price * nights;
            double discountAmount = 0;
            double finalTotal = originalTotal;
            String discountTitle = "";
            double discountPercentage = 0;
            
            // Apply discount if selected
            if (discountCode != null && !discountCode.trim().isEmpty()) {
                try {
                    PromotionDao promotionDao = new PromotionDao();
                    Promotion promotion = promotionDao.getPromotionByTitle(discountCode);
                    if (promotion != null) {
                        discountPercentage = promotion.getPercentage();
                        discountAmount = (originalTotal * discountPercentage) / 100;
                        finalTotal = originalTotal - discountAmount;
                        discountTitle = promotion.getTitle();
                        
                        System.out.println("Discount applied: " + discountTitle + " - " + discountPercentage + "%");
                    }
                } catch (Exception e) {
                    System.out.println("Error applying discount: " + e.getMessage());
                    // Continue without discount
                }
            }
            
            // Build redirect URL
            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.append(request.getContextPath()).append("/customer/bookingDetail.jsp");
            urlBuilder.append("?roomId=").append(roomId);
            urlBuilder.append("&roomNumber=").append(roomNumber != null ? roomNumber : "");
            urlBuilder.append("&roomType=").append(roomType != null ? roomType : "");
            urlBuilder.append("&maxGuests=").append(maxGuests != null ? maxGuests : "");
            urlBuilder.append("&floor=").append(floor != null ? floor : "");
            urlBuilder.append("&pricePerNight=").append(pricePerNight);
            urlBuilder.append("&imageUrl=").append(imageUrl != null ? imageUrl : "");
            urlBuilder.append("&checkIn=").append(checkIn);
            urlBuilder.append("&checkOut=").append(checkOut);
            urlBuilder.append("&nights=").append(nights);
            urlBuilder.append("&originalTotal=").append(originalTotal);
            urlBuilder.append("&finalTotal=").append(finalTotal);
            
            if (discountAmount > 0) {
                urlBuilder.append("&discountCode=").append(discountTitle);
                urlBuilder.append("&discountPercentage=").append(discountPercentage);
                urlBuilder.append("&discountAmount=").append(discountAmount);
            }
            
            String redirectUrl = urlBuilder.toString();
            System.out.println("Redirecting to: " + redirectUrl);
            
            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            System.out.println("Error in CheckRoomAvailabilityServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Send error page
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><title>Lỗi đặt phòng</title></head><body>");
            response.getWriter().println("<div style='text-align: center; margin-top: 50px;'>");
            response.getWriter().println("<h1>Có lỗi xảy ra khi đặt phòng</h1>");
            response.getWriter().println("<p>Lỗi: " + e.getMessage() + "</p>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/home' style='color: blue;'>Quay về trang chủ</a>");
            response.getWriter().println("</div>");
            response.getWriter().println("</body></html>");
        }
    }
    
    private void redirectWithError(HttpServletResponse response, HttpServletRequest request, 
                                 String roomId, String errorMessage) throws IOException {
        String redirectUrl = request.getContextPath() + "/room-detail?id=" + roomId + "&error=invalid";
        System.out.println("Redirecting with error: " + errorMessage);
        response.sendRedirect(redirectUrl);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<!DOCTYPE html>");
        response.getWriter().println("<html><head><title>Check Room Availability</title></head><body>");
        response.getWriter().println("<div style='text-align: center; margin-top: 50px;'>");
        response.getWriter().println("<h1>Check Room Availability</h1>");
        response.getWriter().println("<p>Servlet này chỉ chấp nhận POST requests từ form đặt phòng.</p>");
        response.getWriter().println("<a href='" + request.getContextPath() + "/home' style='color: blue;'>Quay về trang chủ</a>");
        response.getWriter().println("</div>");
        response.getWriter().println("</body></html>");
    }
}
