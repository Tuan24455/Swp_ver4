/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import dal.DBContext;
import model.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Phạm Quốc Tuấn
 */

public class ServiceDao {

    // Lấy tất cả dịch vụ từ bảng Services
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM Services";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setServiceName(rs.getString("service_name"));
                service.setServiceTypeId(rs.getInt("service_type_id"));
                service.setServicePrice(rs.getDouble("service_price"));
                service.setDescription(rs.getString("description"));
                service.setImageUrl(rs.getString("image_url"));
                list.add(service);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}