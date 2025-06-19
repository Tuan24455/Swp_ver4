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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.User;

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

    public void insert(User user) {
        String sql = "INSERT INTO Users (user_name, pass, full_name, birth, gender, email, phone, address, role, avatar_url, isDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUserName());
            ps.setString(2, user.getPass());
            ps.setString(3, user.getFullName());
            ps.setDate(4, new java.sql.Date(user.getBirth().getTime()));
            ps.setString(5, user.getGender());
            ps.setString(6, user.getEmail());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getAddress());
            ps.setString(9, user.getRole());
            ps.setString(10, user.getAvatarUrl());
            ps.setBoolean(11, user.isDeleted());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace(); // Có thể log ra logger thực tế
        }
    }

    public void update(User user) {
        String sql = "UPDATE Users SET full_name = ?, birth = ?, gender = ?, email = ?, phone = ?, address = ?, avatar_url = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setDate(2, new java.sql.Date(user.getBirth().getTime()));
            ps.setString(3, user.getGender());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getAvatarUrl());
            ps.setInt(8, user.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            // Tạo ngày sinh từ chuỗi
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birth = sdf.parse("2001-09-15");

            // Tạo user giả lập
            User testUser = new User(
                    "newuser123", // username
                    "123456", // password
                    "Nguyễn Văn A", // full name
                    birth,
                    "Nam",
                    "newuser123@gmail.com",
                    "0987654321",
                    "Hà Nội",
                    "Customer",
                    "", // avatar URL
                    false // isDeleted
            );

            // Gọi DAO để insert
            UserDao dao = new UserDao();
            dao.insert(testUser);

            System.out.println("✅ User inserted successfully.");

        } catch (Exception e) {
            System.err.println("❌ Error inserting user: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
