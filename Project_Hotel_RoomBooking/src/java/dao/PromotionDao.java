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

    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String SQL_SELECT_ALL = "SELECT * FROM Promotion";
        DBContext dbcontext = new DBContext();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Connection conn = dbcontext.getConnection();
            pstmt = conn.prepareStatement(SQL_SELECT_ALL);
            rs = pstmt.executeQuery();

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
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public Promotion getPromotionById(int id) {
        String SQL_SELECT = "SELECT * FROM Promotion WHERE id = ?";
        DBContext dbcontext = new DBContext();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Promotion p = null;

        try {
            Connection conn = dbcontext.getConnection();
            pstmt = conn.prepareStatement(SQL_SELECT);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

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
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return p;
    }

    public boolean insertPromotion(Promotion p) {
        String SQL_INSERT = "INSERT INTO Promotion (title, percentage, start_at, end_at, description) VALUES (?, ?, ?, ?, ?)";
        DBContext dbcontext = new DBContext();
        PreparedStatement pstmt = null;
        try {
            Connection conn = dbcontext.getConnection();
            pstmt = conn.prepareStatement(SQL_INSERT);
            pstmt.setString(1, p.getTitle());
            pstmt.setDouble(2, p.getPercentage());
            pstmt.setDate(3, new java.sql.Date(p.getStartAt().getTime()));
            pstmt.setDate(4, new java.sql.Date(p.getEndAt().getTime()));
            pstmt.setString(5, p.getDescription());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in insertPromotion: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean updatePromotion(Promotion p) {
        String SQL_UPDATE = "UPDATE Promotion SET title = ?, percentage = ?, start_at = ?, end_at = ?, description = ? WHERE id = ?";
        DBContext dbcontext = new DBContext();
        PreparedStatement pstmt = null;
        try {
            Connection conn = dbcontext.getConnection();
            pstmt = conn.prepareStatement(SQL_UPDATE);
            pstmt.setString(1, p.getTitle());
            pstmt.setDouble(2, p.getPercentage());
            pstmt.setDate(3, new java.sql.Date(p.getStartAt().getTime()));
            pstmt.setDate(4, new java.sql.Date(p.getEndAt().getTime()));
            pstmt.setString(5, p.getDescription());
            pstmt.setInt(6, p.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in updatePromotion: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean deletePromotion(int id) {
        String SQL_DELETE = "DELETE FROM Promotion WHERE id = ?";
        DBContext dbcontext = new DBContext();
        PreparedStatement pstmt = null;
        try {
            Connection conn = dbcontext.getConnection();
            pstmt = conn.prepareStatement(SQL_DELETE);
            pstmt.setInt(1, id);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in deletePromotion: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Promotion> filterPromotions(String status, Date startDate, Date endDate) {
        List<Promotion> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Promotion WHERE 1=1");

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
    
public boolean checkPromotionTitleExists(String title) {
    boolean exists = false;
    String sql = "SELECT COUNT(*) FROM Promotion WHERE title = ?";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, title); // Gán giá trị tên khuyến mãi vào câu lệnh SQL

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true; // Nếu tìm thấy ít nhất một khuyến mãi trùng tên
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return exists;
}

    
public boolean checkPromotionOverlap(Date startDate, Date endDate) {
    boolean exists = false;

    // Đảm bảo rằng startDate và endDate là java.sql.Date
    java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
    java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());

    String sql = "SELECT COUNT(*) FROM Promotion WHERE (start_at < ? AND end_at > ?) OR (start_at < ? AND end_at > ?)";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        // Kiểm tra khuyến mãi trùng thời gian
        ps.setDate(1, sqlEndDate);   // Điều kiện 1: Khuyến mãi kết thúc sau ngày bắt đầu của khuyến mãi mới
        ps.setDate(2, sqlStartDate); // Điều kiện 2: Khuyến mãi bắt đầu trước ngày kết thúc của khuyến mãi mới
        ps.setDate(3, sqlStartDate); // Điều kiện 3: Khuyến mãi bắt đầu trước ngày kết thúc của khuyến mãi mới
        ps.setDate(4, sqlEndDate);   // Điều kiện 4: Khuyến mãi kết thúc sau ngày bắt đầu của khuyến mãi mới

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true; // Nếu có ít nhất một khuyến mãi trùng thời gian
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return exists;
}

public Date getLastPromotionEndDate() {
    Date latestEnd = null;
    String sql = "SELECT MAX(end_at) FROM Promotion";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            latestEnd = rs.getDate(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return latestEnd;
}


}
