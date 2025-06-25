/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import model.ServiceReview;
import model.RoomReview;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Phạm Quốc Tuấn
 */
public class ReviewDao {

    // ==================== SERVICE REVIEW METHODS ====================
    
    // Lấy tất cả đánh giá dịch vụ
    public List<ServiceReview> getAllServiceReviews() {
        List<ServiceReview> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceReviews";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ServiceReview review = new ServiceReview();
                review.setId(rs.getInt("id"));
                review.setServiceId(rs.getInt("service_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                list.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy đánh giá dịch vụ theo service_id
    public List<ServiceReview> getServiceReviewsByServiceId(int serviceId) {
        List<ServiceReview> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceReviews WHERE service_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ServiceReview review = new ServiceReview();
                review.setId(rs.getInt("id"));
                review.setServiceId(rs.getInt("service_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                list.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy đánh giá dịch vụ theo ID
    public ServiceReview getServiceReviewById(int id) {
        String sql = "SELECT * FROM ServiceReviews WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ServiceReview review = new ServiceReview();
                review.setId(rs.getInt("id"));
                review.setServiceId(rs.getInt("service_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                return review;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm đánh giá dịch vụ mới
    public boolean addServiceReview(ServiceReview review) {
        String sql = "INSERT INTO ServiceReviews (service_id, quality, comment) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getServiceId());
            ps.setInt(2, review.getQuality());
            ps.setString(3, review.getComment());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật đánh giá dịch vụ
    public boolean updateServiceReview(ServiceReview review) {
        String sql = "UPDATE ServiceReviews SET service_id = ?, quality = ?, comment = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getServiceId());
            ps.setInt(2, review.getQuality());
            ps.setString(3, review.getComment());
            ps.setInt(4, review.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa đánh giá dịch vụ
    public boolean deleteServiceReview(int id) {
        String sql = "DELETE FROM ServiceReviews WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==================== ROOM REVIEW METHODS ====================
    
    // Lấy tất cả đánh giá phòng
    public List<RoomReview> getAllRoomReviews() {
        List<RoomReview> list = new ArrayList<>();
        String sql = "SELECT * FROM RoomReviews";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomReview review = new RoomReview();
                review.setId(rs.getInt("id"));
                review.setRoomId(rs.getInt("room_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                list.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy đánh giá phòng theo room_id
    public List<RoomReview> getRoomReviewsByRoomId(int roomId) {
        List<RoomReview> list = new ArrayList<>();
        String sql = "SELECT * FROM RoomReviews WHERE room_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RoomReview review = new RoomReview();
                review.setId(rs.getInt("id"));
                review.setRoomId(rs.getInt("room_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                list.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy đánh giá phòng theo ID
    public RoomReview getRoomReviewById(int id) {
        String sql = "SELECT * FROM RoomReviews WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomReview review = new RoomReview();
                review.setId(rs.getInt("id"));
                review.setRoomId(rs.getInt("room_id"));
                review.setQuality(rs.getInt("quality"));
                review.setComment(rs.getString("comment"));
                return review;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm đánh giá phòng mới
    public boolean addRoomReview(RoomReview review) {
        String sql = "INSERT INTO RoomReviews (room_id, quality, comment) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getRoomId());
            ps.setInt(2, review.getQuality());
            ps.setString(3, review.getComment());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật đánh giá phòng
    public boolean updateRoomReview(RoomReview review) {
        String sql = "UPDATE RoomReviews SET room_id = ?, quality = ?, comment = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getRoomId());
            ps.setInt(2, review.getQuality());
            ps.setString(3, review.getComment());
            ps.setInt(4, review.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa đánh giá phòng
    public boolean deleteRoomReview(int id) {
        String sql = "DELETE FROM RoomReviews WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==================== UTILITY METHODS ====================
    
    // Tính điểm đánh giá trung bình cho dịch vụ
    public double getAverageServiceRating(int serviceId) {
        String sql = "SELECT AVG(CAST(quality AS FLOAT)) as avg_rating FROM ServiceReviews WHERE service_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // Tính điểm đánh giá trung bình cho phòng
    public double getAverageRoomRating(int roomId) {
        String sql = "SELECT AVG(CAST(quality AS FLOAT)) as avg_rating FROM RoomReviews WHERE room_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // Đếm số lượng đánh giá cho dịch vụ
    public int getServiceReviewCount(int serviceId) {
        String sql = "SELECT COUNT(*) as review_count FROM ServiceReviews WHERE service_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("review_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Đếm số lượng đánh giá cho phòng
    public int getRoomReviewCount(int roomId) {
        String sql = "SELECT COUNT(*) as review_count FROM RoomReviews WHERE room_id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("review_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}