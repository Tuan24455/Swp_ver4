package controller;

import dao.PromotionDao;
import dao.ServiceDao;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion;
import model.Service;

@WebServlet(name = "BookingDetailServlet", urlPatterns = {"/booking-detail"})
public class BookingDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy tất cả parameters từ URL
        String roomId = request.getParameter("roomId");
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        String maxGuests = request.getParameter("maxGuests");
        String floor = request.getParameter("floor");
        String pricePerNight = request.getParameter("pricePerNight");
        String imageUrl = request.getParameter("imageUrl");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        
        try {
            // Tính số đêm
            Date checkInDate = Date.valueOf(checkIn);
            Date checkOutDate = Date.valueOf(checkOut);
            long diffInMillies = checkOutDate.getTime() - checkInDate.getTime();
            int nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
            
            // Lấy các mã khuyến mãi còn hiệu lực
            PromotionDao promotionDao = new PromotionDao();
            List<Promotion> validPromotions = promotionDao.getCurrentValidPromotions();
            
            // Lấy các dịch vụ có sẵn
            ServiceDao serviceDao = new ServiceDao();
            List<Service> availableServices = serviceDao.getAllServices();
            
            // Set tất cả parameters làm request attributes
            request.setAttribute("roomId", roomId);
            request.setAttribute("roomNumber", roomNumber);
            request.setAttribute("roomType", roomType);
            request.setAttribute("maxGuests", maxGuests);
            request.setAttribute("floor", floor);
            request.setAttribute("pricePerNight", pricePerNight);
            request.setAttribute("imageUrl", imageUrl);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("nights", nights);
            request.setAttribute("validPromotions", validPromotions);
            request.setAttribute("availableServices", availableServices);
            
            // Debug logging
            System.out.println("=== BOOKING DETAIL DEBUG ===");
            System.out.println("Valid promotions found: " + validPromotions.size());
            for (Promotion p : validPromotions) {
                System.out.println("- " + p.getTitle() + " (" + p.getPercentage() + "%)");
            }
            System.out.println("Available services found: " + availableServices.size());
            for (Service s : availableServices) {
                System.out.println("- " + s.getName() + " (" + s.getPrice() + " VND)");
            }
            
            // Forward đến JSP
            request.getRequestDispatcher("/customer/bookingDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }
}
