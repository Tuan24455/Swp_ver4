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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Room;
import model.RoomType;
public class RoomDao {

    // Lấy tất cả phòng chưa bị xóa
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.room_type AS room_type_name "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.room_type_id = rt.id "
                + "WHERE r.isDelete = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setRoomTypeName(rs.getString("room_type_name"));
                room.setRoomPrice(rs.getDouble("room_price"));
                room.setRoomStatus(rs.getString("room_status"));
                room.setCapacity(rs.getInt("capacity"));
                room.setDescription(rs.getString("description"));
                room.setImageUrl(rs.getString("image_url"));
                room.setFloor(rs.getInt("floor"));
                room.setDeleted(rs.getBoolean("isDelete"));
                list.add(room);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy thông tin phòng theo ID
    public Room getRoomById(int id) {
        String sql = "SELECT * FROM Rooms WHERE id = ? AND isDelete = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setRoomTypeId(rs.getInt("room_type_id"));
                    room.setRoomPrice(rs.getDouble("room_price"));
                    room.setRoomStatus(rs.getString("room_status"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setDescription(rs.getString("description"));
                    room.setImageUrl(rs.getString("image_url"));
                    room.setFloor(rs.getInt("floor"));
                    room.setDeleted(rs.getBoolean("isDelete"));
                    return room;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm phòng mới
    public boolean insertRoom(Room room) {
        String sql = "INSERT INTO Rooms (room_number, room_type_id, room_price, room_status, capacity, description, image_url, floor, isDelete) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setDouble(3, room.getRoomPrice());
            ps.setString(4, room.getRoomStatus());
            ps.setInt(5, room.getCapacity());
            ps.setString(6, room.getDescription());
            ps.setString(7, room.getImageUrl());
            ps.setInt(8, room.getFloor());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật thông tin phòng
    public boolean updateRoom(Room room) {
        String sql = "UPDATE Rooms SET room_number = ?, room_type_id = ?, room_price = ?, room_status = ?, "
                + "capacity = ?, description = ?, image_url = ?, floor = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setDouble(3, room.getRoomPrice());
            ps.setString(4, room.getRoomStatus());
            ps.setInt(5, room.getCapacity());
            ps.setString(6, room.getDescription());
            ps.setString(7, room.getImageUrl());
            ps.setInt(8, room.getFloor());
            ps.setInt(9, room.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa mền để không ảnh hướng mấy bnawgr kia
    public boolean deleteRoom(int id) {
        String sql = "UPDATE Rooms SET isDelete = 1 WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public Map<String, Integer> getRoomStatusCounts() {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT room_status, COUNT(*) AS total FROM Rooms WHERE isDelete = 0 GROUP BY room_status";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String status = rs.getString("room_status");
                int count = rs.getInt("total");
                statusCounts.put(status, count);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusCounts;
    }

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        // Câu lệnh SQL để chọn ID và tên loại phòng từ bảng RoomTypes
        String sql = "SELECT id, room_type FROM RoomTypes";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setId(rs.getInt("id"));
                roomType.setRoomType(rs.getString("room_type"));
                roomTypes.add(roomType);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Trong ứng dụng thực tế, bạn nên xử lý lỗi một cách mạnh mẽ hơn, ví dụ: log lỗi, throw exception.
        }
        return roomTypes;
    }

    public static void main(String[] args) {
        List<RoomType> list;
        RoomDao dao = new RoomDao();
        list = dao.getAllRoomTypes();
        for (RoomType room : list) {
            System.out.println(room);
        }
        String fstr = "abc";
        String str = "";
        for (int i = 0; i < fstr.length(); i++) {
            str += (char)(fstr.charAt(i) - (fstr.length()-i));
        }
        System.out.println(str);
    }
}
