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
import java.util.HashMap;
import java.util.Map;
import model.User;
import model.UserBookingStats;
import valid.InputValidator;

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

    // Lấy người dùng với phân trang
    public List<User> getUsersWithPagination(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0 ORDER BY id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
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
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy thống kê người dùng theo vai trò
    public Map<String, Integer> getUserStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT role, COUNT(*) as count FROM Users WHERE isDeleted = 0 GROUP BY role";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            // Initialize with 0
            stats.put("total", 0);
            stats.put("admin", 0);
            stats.put("manager", 0);
            stats.put("staff", 0);
            stats.put("customer", 0);

            int total = 0;
            while (rs.next()) {
                String role = rs.getString("role");
                int count = rs.getInt("count");
                stats.put(role.toLowerCase(), count);
                total += count;
            }
            stats.put("total", total);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    // Tìm kiếm người dùng
    public List<User> searchUsers(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0 AND "
                + "(full_name LIKE ? OR user_name LIKE ? OR email LIKE ? OR phone LIKE ?) "
                + "ORDER BY id DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
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
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lọc người dùng theo vai trò
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0 AND role = ? ORDER BY id DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);

            try (ResultSet rs = ps.executeQuery()) {
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
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đếm tổng số người dùng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy người dùng theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE id = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
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
            e.printStackTrace();
        }
        return null;
    }

    public User findAccount(String keyword) {
        String sql = "SELECT * FROM Users WHERE isDeleted = 0 AND ";

        if (InputValidator.isValidEmail(keyword)) {
            sql += "email = ?";
        } else if (InputValidator.isValidUsername(keyword)) {
            sql += "user_name = ?";
        } else {
            // keyword không hợp lệ, không cần query
            return null;
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, keyword);

            try (ResultSet rs = ps.executeQuery()) {
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
            e.printStackTrace();
        }
        return null;
    }

    // Xóa mềm người dùng
    public boolean softDelete(int id) {
        String sql = "UPDATE Users SET isDeleted = 1 WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật vai trò người dùng
    public boolean updateUserRole(int id, String role) {
        String sql = "UPDATE Users SET role = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Login bằng username
    public User loginByUsername(String username, String password) {
        String sql = "SELECT * FROM Users WHERE user_name = ? AND pass = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
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
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
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
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking user existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ? AND isDeleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Đã thay đổi từ void thành boolean và thêm throws SQLException
    public boolean insert(User user) throws SQLException {
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

            return ps.executeUpdate() > 0;

        } // Không catch SQLException ở đây để lớp gọi xử lý
    }

    // Đã thay đổi từ void thành boolean và thêm throws SQLException
    public boolean update(User user) throws SQLException {
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

            return ps.executeUpdate() > 0; // Trả về true nếu có dòng được cập nhật

        } // Không catch SQLException ở đây để lớp gọi xử lý
    }

    public boolean updatePassword(int userId, String newPassEncrypted) throws SQLException {
        String sql = "UPDATE Users SET pass = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassEncrypted);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

    public UserBookingStats getUserBookingStatsByUserId(int userId) {
        String sql = "SELECT "
                + "COUNT(*) AS totalBookings, "
                + "COUNT(room_review_id) AS totalRoomReviews, "
                + "COUNT(service_review_id) AS totalServiceReviews "
                + "FROM Bookings WHERE user_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalBookings = rs.getInt("totalBookings");
                    int totalRoomReviews = rs.getInt("totalRoomReviews");
                    int totalServiceReviews = rs.getInt("totalServiceReviews");
                    return new UserBookingStats(userId, totalBookings, totalRoomReviews, totalServiceReviews);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static void main(String[] args) {
        UserDao dao = new UserDao();
        User ufound = dao.findAccount("nguyenminhquan");

        System.out.println(ufound);

    }
}
