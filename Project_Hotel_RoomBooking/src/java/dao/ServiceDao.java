/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDao {

    // Lấy tất cả dịch vụ (chỉ những dịch vụ chưa bị xóa), kèm tên loại dịch vụ
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, st.service_type "
                + "FROM Services s "
                + "JOIN ServiceTypes st ON s.service_type_id = st.id "
                + "WHERE s.isDeleted = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("service_name"));
                s.setTypeId(rs.getInt("service_type_id"));
                s.setTypeName(rs.getString("service_type")); // tên loại
                s.setPrice(rs.getDouble("service_price"));
                s.setDescription(rs.getString("description"));
                s.setImageUrl(rs.getString("image_url"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy dịch vụ theo ID
    public Service getServiceById(int id) {
        String sql = "SELECT s.*, st.service_type "
                + "FROM Services s "
                + "JOIN ServiceTypes st ON s.service_type_id = st.id "
                + "WHERE s.id = ? AND s.isDeleted = 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("id"),
                            rs.getString("service_name"),
                            rs.getInt("service_type_id"),
                            rs.getDouble("service_price"),
                            rs.getString("description"),
                            rs.getString("image_url"),
                            rs.getString("service_type") // typeName
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm mới dịch vụ
    public void insertService(Service s) {
        String sql = "INSERT INTO Services (service_name, service_type_id, service_price, description, image_url, isDeleted) "
                + "VALUES (?, ?, ?, ?, ?, 0)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setInt(2, s.getTypeId());
            ps.setDouble(3, s.getPrice());
            ps.setString(4, s.getDescription());
            ps.setString(5, s.getImageUrl());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật dịch vụ
    public void updateService(Service s) {
        String sql = "UPDATE Services SET service_name = ?, service_type_id = ?, service_price = ?, description = ?, image_url = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setInt(2, s.getTypeId());
            ps.setDouble(3, s.getPrice());
            ps.setString(4, s.getDescription());
            ps.setString(5, s.getImageUrl());
            ps.setInt(6, s.getId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa mềm
    public void deleteService(int id) {
        String sql = "UPDATE Services SET isDeleted = 1 WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Service> filterServices(String type, Double minPrice, Double maxPrice) {
        List<Service> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.*, st.service_type FROM Services s "
                + "JOIN ServiceTypes st ON s.service_type_id = st.id "
                + "WHERE s.isDeleted = 0"
        );

        List<Object> params = new ArrayList<>();

        if (type != null && !type.isEmpty()) {
            sql.append(" AND st.service_type = ?");
            params.add(type);
        }

        if (minPrice != null) {
            sql.append(" AND s.service_price >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND s.service_price <= ?");
            params.add(maxPrice);
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("service_name"));
                    s.setTypeId(rs.getInt("service_type_id"));
                    s.setTypeName(rs.getString("service_type"));
                    s.setPrice(rs.getDouble("service_price"));
                    s.setDescription(rs.getString("description"));
                    s.setImageUrl(rs.getString("image_url"));
                    list.add(s);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public boolean checkNameExists(String name) {
    String sql = "SELECT COUNT(*) FROM Services WHERE service_name = ? AND isDeleted = 0";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, name);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1) > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
        public boolean checkNameExistsExceptId(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Services WHERE service_name = ? AND isDeleted = 0 AND id != ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    


    // test thử 
    public static void main(String[] args) {
        ServiceDao dao = new ServiceDao();
        List<Service> list = dao.getAllServices();

        if (list.isEmpty()) {
            System.out.println(" Không có dữ liệu nào được trả về.");
        } else {
            for (Service s : list) {
                System.out.println("Dịch vụ: " + s.getName()
                        + " | Loại: " + s.getTypeName()
                        + " | Giá: " + s.getPrice());
            }
        }
    }

}
