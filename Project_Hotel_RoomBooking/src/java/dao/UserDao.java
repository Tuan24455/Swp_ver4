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
import model.User;

/**
 *
 * @author Phạm Quốc Tuấn
 */
public class UserDao {

    // Lấy tất cả người dùng chưa bị xóa
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUserName(rs.getString("user_name"));
                user.setPass(rs.getString("pass"));
                user.setFullName(rs.getString("full_name"));
                user.setBirth(rs.getDate("birth"));
                user.setGender(rs.getString("gender"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setAvatarUrl(rs.getString("avatar_url"));
                user.setDeleted(rs.getBoolean("isDeleted"));
                list.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public User loginByUsername(String username, String password) {
        String sql = "SELECT * FROM Users WHERE user_name = ? AND pass = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username); // Set parameter 1
            ps.setString(2, password); // Set parameter 2

            try (ResultSet rs = ps.executeQuery()) { // Execute query AFTER setting parameters
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUserName(rs.getString("user_name"));
                    user.setPass(rs.getString("pass"));
                    user.setFullName(rs.getString("full_name"));
                    user.setBirth(rs.getDate("birth"));
                    user.setGender(rs.getString("gender"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                    user.setDeleted(rs.getBoolean("isDeleted"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User loginByEmail(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND pass = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); // Set parameter 1
            ps.setString(2, password); // Set parameter 2

            try (ResultSet rs = ps.executeQuery()) { // Execute query AFTER setting parameters
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUserName(rs.getString("user_name"));
                    user.setPass(rs.getString("pass"));
                    user.setFullName(rs.getString("full_name"));
                    user.setBirth(rs.getDate("birth"));
                    user.setGender(rs.getString("gender"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                    user.setDeleted(rs.getBoolean("isDeleted"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User loginByPhone(String phone, String password) {
        String sql = "SELECT * FROM Users WHERE phone = ? AND pass = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone); // Set parameter 1
            ps.setString(2, password); // Set parameter 2

            try (ResultSet rs = ps.executeQuery()) { // Execute query AFTER setting parameters
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUserName(rs.getString("user_name"));
                    user.setPass(rs.getString("pass"));
                    user.setFullName(rs.getString("full_name"));
                    user.setBirth(rs.getDate("birth"));
                    user.setGender(rs.getString("gender"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                    user.setDeleted(rs.getBoolean("isDeleted"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean isExist(String username) {
        String sql = "SELECT 1 FROM Users WHERE user_name = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu có bản ghi
            }
        } catch (SQLException e) {
            System.err.println("Error checking user existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        System.out.println(new UserDao().loginByUsername("tranthithuy", "password456"));
    }
}
