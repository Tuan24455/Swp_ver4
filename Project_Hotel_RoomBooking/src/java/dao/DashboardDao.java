package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO chuyên trả về các KPI cần thiết cho màn hình Dashboard của Admin / Reception.
 */
public class DashboardDao {
    private static final Logger LOGGER = Logger.getLogger(DashboardDao.class.getName());

    /**
     * Tổng doanh thu (Total Revenue) - tính tổng cột total_prices của bảng Bookings.
     */
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_prices),0) AS revenue FROM Bookings WHERE isDeleted = 0"; // phòng trường hợp có cột isDeleted
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("revenue");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy tổng doanh thu", ex);
        }
        return 0;
    }

    /**
     * Số phòng đang được sử dụng và tổng số phòng.
     * @return int[]{occupied, total}
     */
    public int[] getRoomOccupancy() {
        String sql = "SELECT \n                SUM(CASE WHEN room_status = 'Đang sử dụng' OR room_status = 'Occupied' THEN 1 ELSE 0 END) AS occupied,\n                COUNT(*) AS total\n            FROM Rooms WHERE isDelete = 0";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int occ = rs.getInt("occupied");
                int tot = rs.getInt("total");
                return new int[]{occ, tot};
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy tình trạng phòng", ex);
        }
        return new int[]{0, 0};
    }

    /**
     * Số lượt đặt phòng trong ngày hiện tại.
     */
    public int getTodayBookings() {
        String sql = "SELECT COUNT(*) AS cnt FROM Bookings WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy số booking hôm nay", ex);
        }
        return 0;
    }

    /**
     * Tổng người dùng (bao gồm nhân viên).
     */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) AS cnt FROM Users WHERE isDeleted = 0";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy tổng người dùng", ex);
        }
        return 0;
    }
}
