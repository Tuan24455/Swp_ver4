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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ServiceDao {

    // Lấy dịch vụ theo ID
    public Service getServiceById(int id) {
        String sql = "SELECT s.id, s.service_name, s.service_type_id, t.service_type AS service_type_name, "
                + "s.service_price, s.description, s.image_url "
                + "FROM Services s JOIN ServiceTypes t ON s.service_type_id = t.id WHERE s.id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service service = new Service();
                    service.setId(rs.getInt("id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setServiceTypeId(rs.getInt("service_type_id"));
                    service.setServiceTypeName(rs.getString("service_type_name"));
                    service.setServicePrice(rs.getDouble("service_price"));
                    service.setDescription(rs.getString("description"));
                    service.setImageUrl(rs.getString("image_url"));
                    return service;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy các dịch vụ liên quan theo loại, loại trừ chính nó, giới hạn số lượng
    public List<Service> getRelatedServices(int serviceTypeId, int excludeId, int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " s.id, s.service_name, s.service_type_id, t.service_type AS service_type_name, "
                + "s.service_price, s.description, s.image_url "
                + "FROM Services s JOIN ServiceTypes t ON s.service_type_id = t.id "
                + "WHERE s.service_type_id = ? AND s.id <> ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceTypeId);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setId(rs.getInt("id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setServiceTypeId(rs.getInt("service_type_id"));
                    service.setServiceTypeName(rs.getString("service_type_name"));
                    service.setServicePrice(rs.getDouble("service_price"));
                    service.setDescription(rs.getString("description"));
                    service.setImageUrl(rs.getString("image_url"));
                    list.add(service);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả dịch vụ từ bảng Services và ServiceTypes
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.id, s.service_name, s.service_type_id, t.service_type AS service_type_name, "
                + "s.service_price, s.description, s.image_url "
                + "FROM Services s JOIN ServiceTypes t ON s.service_type_id = t.id";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setServiceName(rs.getString("service_name"));
                service.setServiceTypeId(rs.getInt("service_type_id"));
                service.setServiceTypeName(rs.getString("service_type_name"));
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

    public List<Service> filterServices(List<Integer> typeIds, Double priceFrom, Double priceTo) {
        List<Service> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.id, s.service_name, s.service_type_id, t.service_type AS service_type_name, "
                + "s.service_price, s.description, s.image_url "
                + "FROM Services s JOIN ServiceTypes t ON s.service_type_id = t.id WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        // Lọc theo loại dịch vụ
        if (typeIds != null && !typeIds.isEmpty()) {
            sql.append(" AND s.service_type_id IN (");
            sql.append("?,".repeat(typeIds.size()));
            sql.setLength(sql.length() - 1);
            sql.append(")");
            params.addAll(typeIds);
        }

        // Lọc theo khoảng giá
        if (priceFrom != null) {
            sql.append(" AND s.service_price >= ?");
            params.add(priceFrom);
        }
        if (priceTo != null) {
            sql.append(" AND s.service_price <= ?");
            params.add(priceTo);
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setServiceName(rs.getString("service_name"));
                service.setServiceTypeId(rs.getInt("service_type_id"));
                service.setServiceTypeName(rs.getString("service_type_name"));
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

    public Map<Integer, String> getDistinctServiceTypes() {
        Map<Integer, String> typeMap = new LinkedHashMap<>(); // giữ nguyên thứ tự

        String sql = "SELECT DISTINCT t.id, t.service_type "
                + "FROM ServiceTypes t JOIN Services s ON t.id = s.service_type_id";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("service_type");
                typeMap.put(id, name);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return typeMap;
    }

    public static void main(String[] args) {
        ServiceDao dao = new ServiceDao();
        Map<Integer, String> lt = dao.getDistinctServiceTypes();
        for (Map.Entry<Integer, String> entry : lt.entrySet()) {
            Object key = entry.getKey();
            Object val = entry.getValue();
            System.out.println(key+", "+val);
        }
    }
}
