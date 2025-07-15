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
        String sql = "SELECT r.*, rt.room_type AS room_type_name "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.room_type_id = rt.id "
                + "WHERE r.id = ? AND r.isDelete = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    return room;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public int getRoomTypeIdByName(String roomTypeName) {
        String sql = "SELECT id FROM RoomTypes WHERE room_type = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomTypeName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // không tìm thấy
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
        String sql = "UPDATE Rooms SET room_number=?, room_type_id=?, room_price=?, room_status=?, capacity=?, description=?, image_url=?, floor=? WHERE id=?";
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mền để không ảnh hướng mấy bảng kia
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

    // Lấy tổng số phòng (không bao gồm phòng đã xóa)
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) AS total FROM Rooms WHERE isDelete = 0";
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Lấy tổng số phòng theo loại phòng
    public int getTotalRoomsByType(int roomTypeId) {
        String sql = "SELECT COUNT(*) AS total FROM Rooms WHERE room_type_id = ? AND isDelete = 0";
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roomTypeId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    // Lấy số phòng theo trạng thái cụ thể
    public int getRoomCountByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM Rooms WHERE room_status = ? AND isDelete = 0";
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Lấy số phòng theo trạng thái và loại phòng
    public int getRoomCountByStatusAndType(String status, int roomTypeId) {
        String sql = "SELECT COUNT(*) AS total FROM Rooms WHERE room_status = ? AND room_type_id = ? AND isDelete = 0";
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, roomTypeId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
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

    public List<Room> filterRooms(String roomTypeName, String status, Integer floor) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, rt.room_type AS room_type_name FROM Rooms r ");
        sql.append("JOIN RoomTypes rt ON r.room_type_id = rt.id WHERE r.isDelete = 0 ");

        if (roomTypeName != null && !roomTypeName.isEmpty()) {
            sql.append("AND rt.room_type = ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND r.room_status = ? ");
        }
        if (floor != null) {
            sql.append("AND r.floor = ? ");
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (roomTypeName != null && !roomTypeName.isEmpty()) {
                ps.setString(index++, roomTypeName);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (floor != null) {
                ps.setInt(index++, floor);
            }

            ResultSet rs = ps.executeQuery();
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
            str += (char) (fstr.charAt(i) - (fstr.length() - i));
        }
        System.out.println(str);

        System.out.println(dao.getRoomById(2).toString());
    }

    public List<Room> filterRoomsAdvanced(List<Integer> typeIds, Double priceFrom, Double priceTo, Integer capacity,
            String sortOrder, Date fromDate, Date toDate) {
        List<Room> rooms = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, rt.room_type AS room_type_name "
                + "FROM Rooms r JOIN RoomTypes rt ON r.room_type_id = rt.id "
                + "WHERE r.isDelete = 0 AND r.room_status != N'Maintenance' "
        );

        List<Object> params = new ArrayList<>();

        if (typeIds != null && !typeIds.isEmpty()) {
            sql.append("AND r.room_type_id IN (");
            for (int i = 0; i < typeIds.size(); i++) {
                sql.append("?");
                if (i < typeIds.size() - 1) {
                    sql.append(", ");
                }
                params.add(typeIds.get(i));
            }
            sql.append(") ");
        }

        if (priceFrom != null) {
            sql.append("AND r.room_price >= ? ");
            params.add(priceFrom);
        }

        if (priceTo != null) {
            sql.append("AND r.room_price <= ? ");
            params.add(priceTo);
        }

        if (capacity != null) {
            sql.append("AND r.capacity >= ? ");
            params.add(capacity);
        }

        // Lọc theo ngày nếu có
        if (fromDate != null && toDate != null) {
            sql.append(
                    "AND NOT EXISTS ( "
                    + "SELECT 1 FROM BookingRoomDetails brd "
                    + "JOIN Bookings b ON brd.booking_id = b.id "
                    + "WHERE brd.room_id = r.id "
                    + "AND b.status IN (N'Pending', N'Confirmed') "
                    + "AND (? < brd.check_out_date AND ? > brd.check_in_date) "
                    + ") "
            );
            params.add(fromDate);
            params.add(toDate);
        }

        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append("ORDER BY r.room_price ASC ");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append("ORDER BY r.room_price DESC ");
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
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
                rooms.add(room);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rooms;
    }
    // Bên lễ tân - Tuấn
    public List<Room> getRoomsByFloor(int floor) {
    List<Room> rooms = new ArrayList<>();
    String sql = "SELECT r.*, rt.room_type AS room_type_name "
               + "FROM Rooms r "
               + "JOIN RoomTypes rt ON r.room_type_id = rt.id "
               + "WHERE r.isDelete = 0 AND r.floor = ?";  // Lọc theo tầng

    try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, floor);  // Thiết lập tham số tầng

        try (ResultSet rs = ps.executeQuery()) {
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
                rooms.add(room);  // Thêm phòng vào danh sách
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return rooms;  // Trả về danh sách phòng của tầng yêu cầu
}


}
