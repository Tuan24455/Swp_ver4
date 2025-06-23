/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.DBContext;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for handling rating reports
 * @author Admin
 */
@WebServlet(urlPatterns = {"/ratingreport", "/admin/ratingreport"})
public class RatingReportServlet extends HttpServlet {
    
    private RoomDao roomDao;
    private ServiceDao serviceDao;
    private DBContext dbContext;
    
    @Override
    public void init() throws ServletException {
        super.init();
        roomDao = new RoomDao();
        serviceDao = new ServiceDao();
        dbContext = new DBContext();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all rooms and services
            List<Room> rooms = roomDao.getAllRooms();
            List<Service> services = serviceDao.getAllServices();
            
            // Get rating data
            List<RoomReview> roomReviews = getRoomReviews();
            List<ServiceReview> serviceReviews = getServiceReviews();
            
            // Calculate summary statistics
            Map<String, Object> summary = calculateRatingSummary(roomReviews, serviceReviews);
            
            // Set attributes for JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("services", services);
            request.setAttribute("roomReviews", roomReviews);
            request.setAttribute("serviceReviews", serviceReviews);
            request.setAttribute("summary", summary);
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/ratingreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error generating rating report: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<RoomReview> getRoomReviews() {
        List<RoomReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM RoomReview ORDER BY id DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                RoomReview review = new RoomReview();
                review.setId(rs.getInt("id"));
                review.setRoomId(rs.getInt("roomId"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            // If table doesn't exist, return empty list
            System.out.println("RoomReview table not found or error: " + e.getMessage());
        }
        
        return reviews;
    }
    
    private List<ServiceReview> getServiceReviews() {
        List<ServiceReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM ServiceReview ORDER BY id DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ServiceReview review = new ServiceReview();
                review.setId(rs.getInt("id"));
                review.setServiceId(rs.getInt("serviceId"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            // If table doesn't exist, return empty list
            System.out.println("ServiceReview table not found or error: " + e.getMessage());
        }
        
        return reviews;
    }
    
    private Map<String, Object> calculateRatingSummary(List<RoomReview> roomReviews, 
                                                       List<ServiceReview> serviceReviews) {
        Map<String, Object> summary = new HashMap<>();
        
        // Room rating statistics
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
        
        // Service rating statistics
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
        
        // Overall statistics
        int totalReviews = roomReviews.size() + serviceReviews.size();
        summary.put("totalReviews", totalReviews);
        
        if (totalReviews > 0) {
            double overallRating = (roomReviews.stream().mapToInt(RoomReview::getQuality).sum() +
                                   serviceReviews.stream().mapToInt(ServiceReview::getQuality).sum()) 
                                   / (double) totalReviews;
            summary.put("overallRating", Math.round(overallRating * 100.0) / 100.0);
        } else {
            summary.put("overallRating", 0.0);
        }
        
        return summary;
    }
}