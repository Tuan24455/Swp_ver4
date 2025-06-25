/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.ReviewDao;
import dao.RoomDao;
import dao.ServiceDao;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet for handling review reports
 * @author Admin
 */
@WebServlet(urlPatterns = {"/reviewreport", "/admin/reviewreport"})
public class ReviewReportServlet extends HttpServlet {
    
    private ReviewDao reviewDao;
    private RoomDao roomDao;
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reviewDao = new ReviewDao();
        roomDao = new RoomDao();
        serviceDao = new ServiceDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get filter parameters
            String filterType = request.getParameter("filterType"); // "all", "room", "service"
            String roomIdParam = request.getParameter("roomId");
            String serviceIdParam = request.getParameter("serviceId");
            String qualityParam = request.getParameter("quality");
            
            // Get all rooms and services for filter dropdowns
            List<Room> rooms = roomDao.getAllRooms();
            List<Service> services = serviceDao.getAllServices();
            
            // Get review data based on filters
            List<RoomReview> roomReviews = new ArrayList<>();
            List<ServiceReview> serviceReviews = new ArrayList<>();
            
            // Default to show all data if no filter is specified
            if (filterType == null) {
                filterType = "all";
            }
            
            if ("all".equals(filterType) || "room".equals(filterType)) {
                if (roomIdParam != null && !roomIdParam.isEmpty()) {
                    int roomId = Integer.parseInt(roomIdParam);
                    roomReviews = reviewDao.getRoomReviewsByRoomId(roomId);
                } else {
                    roomReviews = reviewDao.getAllRoomReviews();
                }
                
                // Filter by quality if specified
                if (qualityParam != null && !qualityParam.isEmpty()) {
                    int quality = Integer.parseInt(qualityParam);
                    roomReviews = roomReviews.stream()
                        .filter(review -> review.getQuality() == quality)
                        .collect(Collectors.toList());
                }
            }
            
            if ("all".equals(filterType) || "service".equals(filterType)) {
                if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
                    int serviceId = Integer.parseInt(serviceIdParam);
                    serviceReviews = reviewDao.getServiceReviewsByServiceId(serviceId);
                } else {
                    serviceReviews = reviewDao.getAllServiceReviews();
                }
                
                // Filter by quality if specified
                if (qualityParam != null && !qualityParam.isEmpty()) {
                    int quality = Integer.parseInt(qualityParam);
                    serviceReviews = serviceReviews.stream()
                        .filter(review -> review.getQuality() == quality)
                        .collect(Collectors.toList());
                }
            }
            
            // Calculate summary statistics
            Map<String, Object> summary = calculateReviewSummary(roomReviews, serviceReviews);
            
            // Calculate rating distribution
            Map<String, Object> ratingDistribution = calculateRatingDistribution(roomReviews, serviceReviews);
            
            // Get top rated rooms and services
            Map<String, Object> topRated = getTopRatedItems();
            
            // Set attributes for JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("services", services);
            request.setAttribute("roomReviews", roomReviews);
            request.setAttribute("serviceReviews", serviceReviews);
            request.setAttribute("summary", summary);
            request.setAttribute("ratingDistribution", ratingDistribution);
            request.setAttribute("topRated", topRated);
            
            // Set current filter values
            request.setAttribute("currentFilterType", filterType);
            request.setAttribute("currentRoomId", roomIdParam);
            request.setAttribute("currentServiceId", serviceIdParam);
            request.setAttribute("currentQuality", qualityParam);
            
            // Set current time for display
            request.setAttribute("now", new Date());
            
            // Forward to JSP
        request.getRequestDispatcher("/admin/ratingreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error generating review report: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private Map<String, Object> calculateReviewSummary(List<RoomReview> roomReviews, 
                                                       List<ServiceReview> serviceReviews) {
        Map<String, Object> summary = new HashMap<>();
        
        // Room review statistics
        if (!roomReviews.isEmpty()) {
            double avgRoomRating = roomReviews.stream()
                .mapToInt(RoomReview::getQuality)
                .average()
                .orElse(0.0);
            summary.put("avgRoomRating", Math.round(avgRoomRating * 100.0) / 100.0);
            summary.put("totalRoomReviews", roomReviews.size());
            
            // Find highest and lowest rated room reviews
            int maxRoomRating = roomReviews.stream().mapToInt(RoomReview::getQuality).max().orElse(0);
            int minRoomRating = roomReviews.stream().mapToInt(RoomReview::getQuality).min().orElse(0);
            summary.put("maxRoomRating", maxRoomRating);
            summary.put("minRoomRating", minRoomRating);
        } else {
            summary.put("avgRoomRating", 0.0);
            summary.put("totalRoomReviews", 0);
            summary.put("maxRoomRating", 0);
            summary.put("minRoomRating", 0);
        }
        
        // Service review statistics
        if (!serviceReviews.isEmpty()) {
            double avgServiceRating = serviceReviews.stream()
                .mapToInt(ServiceReview::getQuality)
                .average()
                .orElse(0.0);
            summary.put("avgServiceRating", Math.round(avgServiceRating * 100.0) / 100.0);
            summary.put("totalServiceReviews", serviceReviews.size());
            
            // Find highest and lowest rated service reviews
            int maxServiceRating = serviceReviews.stream().mapToInt(ServiceReview::getQuality).max().orElse(0);
            int minServiceRating = serviceReviews.stream().mapToInt(ServiceReview::getQuality).min().orElse(0);
            summary.put("maxServiceRating", maxServiceRating);
            summary.put("minServiceRating", minServiceRating);
        } else {
            summary.put("avgServiceRating", 0.0);
            summary.put("totalServiceReviews", 0);
            summary.put("maxServiceRating", 0);
            summary.put("minServiceRating", 0);
        }
        
        // Overall statistics
        int totalReviews = roomReviews.size() + serviceReviews.size();
        summary.put("totalReviews", totalReviews);
        
        if (totalReviews > 0) {
            double overallRating = (roomReviews.stream().mapToInt(RoomReview::getQuality).sum() +
                                   serviceReviews.stream().mapToInt(ServiceReview::getQuality).sum()) 
                                   / (double) totalReviews;
            summary.put("overallRating", Math.round(overallRating * 100.0) / 100.0);
            summary.put("avgRating", Math.round(overallRating * 100.0) / 100.0); // Add avgRating for JSP
        } else {
            summary.put("overallRating", 0.0);
            summary.put("avgRating", 0.0);
        }
        
        return summary;
    }
    
    private Map<String, Object> calculateRatingDistribution(List<RoomReview> roomReviews, 
                                                            List<ServiceReview> serviceReviews) {
        Map<String, Object> distribution = new HashMap<>();
        
        // Initialize counters for ratings 1-5
        int[] roomRatingCounts = new int[6]; // Index 0 unused, 1-5 for ratings
        int[] serviceRatingCounts = new int[6];
        int[] totalRatingCounts = new int[6];
        
        // Count room ratings
        for (RoomReview review : roomReviews) {
            roomRatingCounts[review.getQuality()]++;
            totalRatingCounts[review.getQuality()]++;
        }
        
        // Count service ratings
        for (ServiceReview review : serviceReviews) {
            serviceRatingCounts[review.getQuality()]++;
            totalRatingCounts[review.getQuality()]++;
        }
        
        distribution.put("roomRatingCounts", roomRatingCounts);
        distribution.put("serviceRatingCounts", serviceRatingCounts);
        distribution.put("totalRatingCounts", totalRatingCounts);
        
        // Create a map for easy access in JSP (1-5 star ratings)
        Map<Integer, Integer> ratingMap = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            ratingMap.put(i, totalRatingCounts[i]);
        }
        distribution.put("ratingMap", ratingMap);
        
        return distribution;
    }
    
    private Map<String, Object> getTopRatedItems() {
        Map<String, Object> topRated = new HashMap<>();
        
        try {
            // Get all rooms and calculate their average ratings
            List<Room> rooms = roomDao.getAllRooms();
            List<Map<String, Object>> topRooms = new ArrayList<>();
            
            for (Room room : rooms) {
                double avgRating = reviewDao.getAverageRoomRating(room.getId());
                int reviewCount = reviewDao.getRoomReviewCount(room.getId());
                
                if (reviewCount > 0) { // Only include rooms with reviews
                    Map<String, Object> roomData = new HashMap<>();
                    roomData.put("room", room);
                    roomData.put("avgRating", Math.round(avgRating * 100.0) / 100.0);
                    roomData.put("reviewCount", reviewCount);
                    topRooms.add(roomData);
                }
            }
            
            // Sort by average rating (descending) and take top 5
            topRooms.sort((a, b) -> Double.compare(
                (Double) b.get("avgRating"), (Double) a.get("avgRating")));
            if (topRooms.size() > 5) {
                topRooms = topRooms.subList(0, 5);
            }
            
            // Get all services and calculate their average ratings
            List<Service> services = serviceDao.getAllServices();
            List<Map<String, Object>> topServices = new ArrayList<>();
            
            for (Service service : services) {
                double avgRating = reviewDao.getAverageServiceRating(service.getId());
                int reviewCount = reviewDao.getServiceReviewCount(service.getId());
                
                if (reviewCount > 0) { // Only include services with reviews
                    Map<String, Object> serviceData = new HashMap<>();
                    serviceData.put("service", service);
                    serviceData.put("avgRating", Math.round(avgRating * 100.0) / 100.0);
                    serviceData.put("reviewCount", reviewCount);
                    topServices.add(serviceData);
                }
            }
            
            // Sort by average rating (descending) and take top 5
            topServices.sort((a, b) -> Double.compare(
                (Double) b.get("avgRating"), (Double) a.get("avgRating")));
            if (topServices.size() > 5) {
                topServices = topServices.subList(0, 5);
            }
            
            topRated.put("topRooms", topRooms);
            topRated.put("topServices", topServices);
            
        } catch (Exception e) {
            e.printStackTrace();
            topRated.put("topRooms", new ArrayList<>());
            topRated.put("topServices", new ArrayList<>());
        }
        
        return topRated;
    }
}