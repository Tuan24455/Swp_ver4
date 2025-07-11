/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.RoomDao;
import dao.ServiceDao;
import dao.ReviewDao;
import model.Room;
import model.Service;
import model.RoomReview;
import model.ServiceReview;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet for handling rating reports
 * @author Admin
 */
@WebServlet(urlPatterns = {"/ratingreport", "/admin/ratingreport"})
public class RatingReportServlet extends HttpServlet {
    
    private RoomDao roomDao;
    private ServiceDao serviceDao;
    private ReviewDao reviewDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        roomDao = new RoomDao();
        serviceDao = new ServiceDao();
        reviewDao = new ReviewDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số lọc
            String filterType = request.getParameter("filterType");
            String qualityStr = request.getParameter("quality");
            
            // Thiết lập giá trị mặc định nếu tham số là null
            if (filterType == null || filterType.isEmpty()) {
                filterType = "all";
            }
            
            Integer quality = null;
            if (qualityStr != null && !qualityStr.isEmpty()) {
                try {
                    quality = Integer.parseInt(qualityStr);
                } catch (NumberFormatException e) {
                    quality = null;
                }
            }
            
            // Lấy tất cả phòng và dịch vụ
            List<Room> rooms = roomDao.getAllRooms();
            List<Service> services = serviceDao.getAllServices();
            
            // Tạo map phòng để tra cứu nhanh (roomId -> roomNumber)
            Map<Integer, String> roomMap = new HashMap<>();
            for (Room room : rooms) {
                roomMap.put(room.getId(), room.getRoomNumber());
            }
            
            // Tạo map dịch vụ để tra cứu nhanh (serviceId -> serviceName)
            Map<Integer, String> serviceMap = new HashMap<>();
            for (Service service : services) {
                serviceMap.put(service.getId(), service.getName());
            }
            
            // Lấy dữ liệu đánh giá dựa trên bộ lọc
            List<RoomReview> roomReviews = new ArrayList<>();
            List<ServiceReview> serviceReviews = new ArrayList<>();
            
            if ("all".equals(filterType) || "room".equals(filterType)) {
                roomReviews = reviewDao.getAllRoomReviews();
                // Lọc theo chất lượng nếu có
                if (quality != null) {
                    final Integer finalQuality = quality;
                    roomReviews = roomReviews.stream()
                        .filter(review -> review.getQuality() == finalQuality)
                        .collect(Collectors.toList());
                }
            }
            
            if ("all".equals(filterType) || "service".equals(filterType)) {
                serviceReviews = reviewDao.getAllServiceReviews();
                // Lọc theo chất lượng nếu có
                if (quality != null) {
                    final Integer finalQuality = quality;
                    serviceReviews = serviceReviews.stream()
                        .filter(review -> review.getQuality() == finalQuality)
                        .collect(Collectors.toList());
                }
            }
            
            // Tính toán thống kê tổng quan
            Map<String, Object> summary = calculateRatingSummary(roomReviews, serviceReviews);
            
            // Tính toán phân phối đánh giá
            Map<String, Object> ratingDistribution = calculateRatingDistribution(roomReviews, serviceReviews);
            
            // Set thuộc tính cho JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("services", services);
            request.setAttribute("roomReviews", roomReviews);
            request.setAttribute("serviceReviews", serviceReviews);
            request.setAttribute("summary", summary);
            request.setAttribute("ratingDistribution", ratingDistribution);
            request.setAttribute("roomMap", roomMap);
            request.setAttribute("serviceMap", serviceMap);
            request.setAttribute("currentFilterType", filterType);
            request.setAttribute("currentQuality", qualityStr);
            request.setAttribute("now", new java.util.Date());
            
            // Chuyển tiếp tới JSP
            request.getRequestDispatcher("/admin/ratingreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Lỗi khi tạo báo cáo đánh giá: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // Hàm tính toán thống kê tổng quan đánh giá
    private Map<String, Object> calculateRatingSummary(List<RoomReview> roomReviews, 
                                                       List<ServiceReview> serviceReviews) {
        Map<String, Object> summary = new HashMap<>();
        
        // Thống kê đánh giá phòng
        if (!roomReviews.isEmpty()) {
            double avgRoomRating = roomReviews.stream()
                .mapToInt(RoomReview::getQuality)
                .average()
                .orElse(0.0);
            summary.put("avgRoomRating", Math.round(avgRoomRating * 100.0) / 100.0);
            summary.put("totalRoomReviews", roomReviews.size());
        } else {
            summary.put("avgRoomRating", 0.0);
            summary.put("totalRoomReviews", 0);
        }
        
        // Thống kê đánh giá dịch vụ
        if (!serviceReviews.isEmpty()) {
            double avgServiceRating = serviceReviews.stream()
                .mapToInt(ServiceReview::getQuality)
                .average()
                .orElse(0.0);
            summary.put("avgServiceRating", Math.round(avgServiceRating * 100.0) / 100.0);
            summary.put("totalServiceReviews", serviceReviews.size());
        } else {
            summary.put("avgServiceRating", 0.0);
            summary.put("totalServiceReviews", 0);
        }
        
        // Thống kê tổng hợp
        int totalReviews = roomReviews.size() + serviceReviews.size();
        summary.put("totalReviews", totalReviews);
        
        if (totalReviews > 0) {
            double overallRating = (roomReviews.stream().mapToInt(RoomReview::getQuality).sum() +
                                   serviceReviews.stream().mapToInt(ServiceReview::getQuality).sum()) 
                                   / (double) totalReviews;
            summary.put("avgRating", Math.round(overallRating * 100.0) / 100.0);
        } else {
            summary.put("avgRating", 0.0);
        }
        
        return summary;
    }
    
    // Hàm tính toán phân phối đánh giá
    private Map<String, Object> calculateRatingDistribution(List<RoomReview> roomReviews, 
                                                           List<ServiceReview> serviceReviews) {
        Map<String, Object> distribution = new HashMap<>();
        Map<Integer, Integer> ratingMap = new HashMap<>();
        
        // Khởi tạo số lượng đánh giá cho từng mức điểm
        for (int i = 1; i <= 5; i++) {
            ratingMap.put(i, 0);
        }
        
        // Đếm số lượng đánh giá phòng theo điểm
        for (RoomReview review : roomReviews) {
            int rating = review.getQuality();
            ratingMap.put(rating, ratingMap.get(rating) + 1);
        }
        
        // Đếm số lượng đánh giá dịch vụ theo điểm
        for (ServiceReview review : serviceReviews) {
            int rating = review.getQuality();
            ratingMap.put(rating, ratingMap.get(rating) + 1);
        }
        
        distribution.put("ratingMap", ratingMap);
        return distribution;
    }
}