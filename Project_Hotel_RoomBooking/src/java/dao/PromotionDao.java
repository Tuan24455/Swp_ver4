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
import java.util.List;
import model.Promotion;

/**
 *
 * @author Phạm Quốc Tuấn
 */
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
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
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
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
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
                if(pstmt != null) pstmt.close();
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
                if(pstmt != null) pstmt.close();
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
                if(pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
