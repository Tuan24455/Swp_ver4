/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Promotion;

public class PromotionDao {

    // Lấy tất cả promotion
    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String SQL_SELECT_ALL = "SELECT * FROM Promotion";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT_ALL); ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPromotions: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy theo id
    public Promotion getPromotionById(int id) {
        String SQL_SELECT = "SELECT * FROM Promotion WHERE id = ?";
        Promotion p = null;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
            }
        } catch (SQLException e) {
            System.err.println("Error in getPromotionById: " + e.getMessage());
            e.printStackTrace();
        }
        return p;
    }

    // Thêm mới
    public boolean insertPromotion(Promotion p) {
        String SQL_INSERT = "INSERT INTO Promotion (title, percentage, start_at, end_at, description, isDeleted) VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_INSERT)) {

            pstmt.setString(1, p.getTitle());
            pstmt.setDouble(2, p.getPercentage());
            pstmt.setDate(3, new java.sql.Date(p.getStartAt().getTime()));
            pstmt.setDate(4, new java.sql.Date(p.getEndAt().getTime()));
            pstmt.setString(5, p.getDescription());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in insertPromotion: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật
    public boolean updatePromotion(int id, String title, double percentage, Date startAt, Date endAt, String description) {
        String sql = "UPDATE Promotion SET title = ?, percentage = ?, start_at = ?, end_at = ?, description = ? WHERE id = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, title);
            pstmt.setDouble(2, percentage);
            pstmt.setDate(3, new java.sql.Date(startAt.getTime()));
            pstmt.setDate(4, new java.sql.Date(endAt.getTime()));
            pstmt.setString(5, description);
            pstmt.setInt(6, id);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mềm
    public boolean deletePromotion(int id) {
        String SQL_DELETE = "UPDATE Promotion SET isDeleted = 1 WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_DELETE)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in deletePromotion: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Lọc trạng thái khuyến mãi
    public List<Promotion> filterPromotions(String status, Date startDate, Date endDate) {
        List<Promotion> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Promotion WHERE isDeleted = 0");

        if (status != null && !status.isEmpty()) {
            if (status.equals("active")) {
                sql.append(" AND start_at <= GETDATE() AND end_at >= GETDATE()");
            } else if (status.equals("expired")) {
                sql.append(" AND end_at < GETDATE()");
            } else if (status.equals("upcoming")) {
                sql.append(" AND start_at > GETDATE()");
            }
        }

        if (startDate != null) {
            sql.append(" AND start_at >= ?");
        }
        if (endDate != null) {
            sql.append(" AND end_at <= ?");
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (startDate != null) {
                ps.setDate(index++, new java.sql.Date(startDate.getTime()));
            }
            if (endDate != null) {
                ps.setDate(index++, new java.sql.Date(endDate.getTime()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Kiểm tra trùng tên khi Thêm mới
    public boolean checkPromotionTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM Promotion WHERE title = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra trùng tên khi Edit - loiaj nó ra
    public boolean checkPromotionTitleExistsForUpdate(int id, String title) {
        String sql = "SELECT COUNT(*) FROM Promotion WHERE title = ? AND id <> ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra trùng thời gian cho Thêm mới
public boolean checkPromotionOverlap(Date startDate, Date endDate) {
    String sql = "SELECT COUNT(*) FROM Promotion WHERE isDeleted = 0 AND NOT (end_at < ? OR start_at > ?)";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setDate(1, new java.sql.Date(startDate.getTime())); // kết thúc cũ < bắt đầu mới
        ps.setDate(2, new java.sql.Date(endDate.getTime()));   // bắt đầu cũ > kết thúc mới

        ResultSet rs = ps.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            return true;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}


    public Date getLastPromotionEndDateForUpdate(int id) {
        Date latestEnd = null;
        String sql = "SELECT MAX(end_at) FROM Promotion WHERE id <> ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                latestEnd = rs.getDate(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return latestEnd;
    }

    // Lấy ngày kết thúc cuối cùng
    public Date getLastPromotionEndDate() {
        Date latestEnd = null;
        String sql = "SELECT MAX(end_at) FROM Promotion WHERE isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                latestEnd = rs.getDate(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return latestEnd;
    }

    public boolean checkPromotionOverlapForUpdate(int id, Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) FROM Promotion "
                + "WHERE isDeleted = 0 AND id <> ? "
                + "AND ((start_at < ? AND end_at > ?) OR (start_at < ? AND end_at > ?))";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ps.setDate(3, new java.sql.Date(startDate.getTime()));
            ps.setDate(4, new java.sql.Date(startDate.getTime()));
            ps.setDate(5, new java.sql.Date(endDate.getTime()));

            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Promotion> searchFilterPaginate(String title, Date startDate, Date endDate, int offset, int pageSize) {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotion WHERE isDeleted = 0"
                + (title != null && !title.isEmpty() ? " AND title LIKE ?" : "")
                + (startDate != null ? " AND start_at >= ?" : "")
                + (endDate != null ? " AND end_at <= ?" : "")
                + " ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (title != null && !title.isEmpty()) {
                ps.setString(idx++, "%" + title + "%");
            }
            if (startDate != null) {
                ps.setDate(idx++, new java.sql.Date(startDate.getTime()));
            }
            if (endDate != null) {
                ps.setDate(idx++, new java.sql.Date(endDate.getTime()));
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTotal(String title, Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) FROM Promotion WHERE isDeleted = 0"
                + (title != null && !title.isEmpty() ? " AND title LIKE ?" : "")
                + (startDate != null ? " AND start_at >= ?" : "")
                + (endDate != null ? " AND end_at <= ?" : "");
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (title != null && !title.isEmpty()) {
                ps.setString(idx++, "%" + title + "%");
            }
            if (startDate != null) {
                ps.setDate(idx++, new java.sql.Date(startDate.getTime()));
            }
            if (endDate != null) {
                ps.setDate(idx++, new java.sql.Date(endDate.getTime()));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tất cả promotion đang active (trong thời gian hiệu lực)
    public List<Promotion> getActivePromotions() {
        List<Promotion> list = new ArrayList<>();
        String SQL_SELECT_ACTIVE = "SELECT * FROM Promotion WHERE start_at <= GETDATE() AND end_at >= GETDATE()";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT_ACTIVE); ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error in getActivePromotions: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy promotion theo title (mã giảm giá)
    public Promotion getPromotionByTitle(String title) {
        String SQL_SELECT = "SELECT * FROM Promotion WHERE title = ? AND start_at <= GETDATE() AND end_at >= GETDATE()";
        Promotion p = null;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT)) {

            pstmt.setString(1, title);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at"));
                p.setEndAt(rs.getDate("end_at"));
                p.setDescription(rs.getString("description"));
            }
        } catch (SQLException e) {
            System.err.println("Error in getPromotionByTitle: " + e.getMessage());
            e.printStackTrace();
        }
        return p;
    }

    public Promotion getLastAddedValidPromotion() {
        Promotion latestPromotion = null;
        // SQL để lấy promotion cuối cùng (giả sử ID tăng dần) và chưa bị xóa
        // Corrected SQL for SQL Server: Use TOP 1 instead of LIMIT 1
        String SQL_SELECT_LAST = "SELECT TOP 1 * FROM Promotion WHERE isDeleted = 0 ORDER BY id DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT_LAST); ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) { // Only one result expected
                Promotion p = new Promotion();
                p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setPercentage(rs.getDouble("percentage"));
                p.setStartAt(rs.getDate("start_at")); // SQL Date
                p.setEndAt(rs.getDate("end_at"));     // SQL Date
                p.setDescription(rs.getString("description"));

                // Chuyển đổi java.sql.Date sang java.util.Date để so sánh dễ hơn
                // Note: For more robust date/time handling, consider java.time API (LocalDate, LocalDateTime)
                // and java.sql.Timestamp if your database stores time components.
                Date promoStart = new Date(p.getStartAt().getTime());
                Date promoEnd = new Date(p.getEndAt().getTime());
                Date currentTime = new Date(); // Thời điểm hiện tại

                // Kiểm tra xem thời điểm hiện tại có nằm trong thời gian hiệu lực không
                // Using .after() and .before() means the promotion is not valid *on* the start/end exact timestamp.
                // If it should be inclusive, you might consider:
                // (currentTime.compareTo(promoStart) >= 0 && currentTime.compareTo(promoEnd) <= 0)
                if (currentTime.after(promoStart) && currentTime.before(promoEnd)) {
                    latestPromotion = p; // Promotion hợp lệ
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getLastAddedValidPromotion: " + e.getMessage());
            e.printStackTrace();
        }
        return latestPromotion;
    }
}
