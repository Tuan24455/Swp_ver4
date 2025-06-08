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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.StockItem;

public class StockDao {
    private static final Logger LOGGER = Logger.getLogger(StockDao.class.getName());
    
    private static final String SQL =
            "SELECT i.id, i.item_name, i.category, i.unit_price, " +
            "COALESCE(i.min_required, 0) AS min_required, " +
            "COALESCE(MAX(sr.remaining_stock), 0) AS remaining_stock " +
            "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
            "WHERE i.isDeleted = 0 " +
            "GROUP BY i.id, i.item_name, i.category, i.unit_price, i.min_required";

    public List<StockItem> getAll() {
        List<StockItem> list = new ArrayList<>();
        LOGGER.info("Attempting to fetch all stock items");
        
        try (Connection conn = new DBContext().getConnection()) {
            LOGGER.info("Database connection established successfully");
            
            try (PreparedStatement ps = conn.prepareStatement(SQL);
                 ResultSet rs = ps.executeQuery()) {
                
                LOGGER.info("Executing query: " + SQL);
                
                while (rs.next()) {
                    StockItem s = new StockItem();
                    s.setId(rs.getInt("id"));
                    s.setItemName(rs.getString("item_name"));
                    s.setCategory(rs.getString("category"));
                    s.setUnitPrice(rs.getDouble("unit_price"));
                    s.setMinRequired(rs.getInt("min_required"));
                    s.setRemainingStock(rs.getInt("remaining_stock"));
                    list.add(s);
                    
                    LOGGER.info("Found item: " + s.getItemName() + " (ID: " + s.getId() + ") - Stock: " + s.getRemainingStock());
                }
                
                LOGGER.info("Successfully fetched " + list.size() + " stock items");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching stock items", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching stock items", e);
        }
        
        return list;
    }

    // Get KPI metrics for summary cards
    public Map<String, Object> getKPIMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        try (Connection conn = new DBContext().getConnection()) {
            // Total Remaining Stock Quantity (instead of total items)
            String totalStockSql = "SELECT SUM(COALESCE(MAX(sr.remaining_stock), 0)) as total_remaining_stock " +
                                  "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
                                  "WHERE i.isDeleted = 0 " +
                                  "GROUP BY i.id";
            try (PreparedStatement ps = conn.prepareStatement(totalStockSql);
                 ResultSet rs = ps.executeQuery()) {
                int totalRemainingStock = 0;
                while (rs.next()) {
                    totalRemainingStock += rs.getInt("total_remaining_stock");
                }
                metrics.put("totalRemainingStock", totalRemainingStock);
            }
            
            // Low Stock Items Count
            String lowStockSql = "SELECT COUNT(*) as low_stock_count " +
                                "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
                                "WHERE i.isDeleted = 0 AND i.min_required > 0 " +
                                "GROUP BY i.id, i.min_required " +
                                "HAVING COALESCE(MAX(sr.remaining_stock), 0) <= i.min_required";
            try (PreparedStatement ps = conn.prepareStatement(lowStockSql);
                 ResultSet rs = ps.executeQuery()) {
                int lowStockCount = 0;
                while (rs.next()) {
                    lowStockCount++;
                }
                metrics.put("lowStockCount", lowStockCount);
            }
            
            // Total Stock Value
            String stockValueSql = "SELECT SUM(i.unit_price * COALESCE(MAX(sr.remaining_stock), 0)) as total_value " +
                                  "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
                                  "WHERE i.isDeleted = 0 " +
                                  "GROUP BY i.id, i.unit_price";
            try (PreparedStatement ps = conn.prepareStatement(stockValueSql);
                 ResultSet rs = ps.executeQuery()) {
                double totalValue = 0;
                while (rs.next()) {
                    totalValue += rs.getDouble("total_value");
                }
                metrics.put("totalStockValue", totalValue);
            }
            
            // Monthly Usage (simulated - sum of stock_out this month)
            String monthlyUsageSql = "SELECT SUM(sr.stock_out * i.unit_price) as monthly_usage " +
                                    "FROM StockReports sr " +
                                    "JOIN InventoryItems i ON sr.item_id = i.id " +
                                    "WHERE i.isDeleted = 0 AND sr.stock_date >= DATEADD(month, -1, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(monthlyUsageSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("monthlyUsage", rs.getDouble("monthly_usage"));
                } else {
                    metrics.put("monthlyUsage", 0.0);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching KPI metrics", e);
            // Set default values on error
            metrics.put("totalRemainingStock", 0);
            metrics.put("lowStockCount", 0);
            metrics.put("totalStockValue", 0.0);
            metrics.put("monthlyUsage", 0.0);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching KPI metrics", e);
            // Set default values on error
            metrics.put("totalRemainingStock", 0);
            metrics.put("lowStockCount", 0);
            metrics.put("totalStockValue", 0.0);
            metrics.put("monthlyUsage", 0.0);
        }
        
        return metrics;
    }

    // Fetch items with low stock (remaining_stock <= min_required)
    public List<StockItem> getLowStockItems() {
        List<StockItem> list = new ArrayList<>();
        String sql = "SELECT i.id, i.item_name, i.category, i.unit_price, " +
                     "COALESCE(i.min_required, 0) AS min_required, " +
                     "COALESCE(MAX(sr.remaining_stock), 0) AS remaining_stock " +
                     "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
                     "WHERE i.isDeleted = 0 " +
                     "GROUP BY i.id, i.item_name, i.category, i.unit_price, i.min_required " +
                     "HAVING COALESCE(MAX(sr.remaining_stock), 0) <= COALESCE(i.min_required, 0) " +
                     "AND COALESCE(i.min_required, 0) > 0 " +
                     "ORDER BY (COALESCE(MAX(sr.remaining_stock), 0) - COALESCE(i.min_required, 0)) ASC";
        
        LOGGER.info("Attempting to fetch low stock items");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            LOGGER.info("Executing query: " + sql);
            
            while (rs.next()) {
                StockItem s = new StockItem();
                s.setId(rs.getInt("id"));
                s.setItemName(rs.getString("item_name"));
                s.setCategory(rs.getString("category"));
                s.setUnitPrice(rs.getDouble("unit_price"));
                s.setMinRequired(rs.getInt("min_required"));
                s.setRemainingStock(rs.getInt("remaining_stock"));
                list.add(s);
                
                LOGGER.info("Found low stock item: " + s.getItemName() + " - Current: " + s.getRemainingStock() + ", Min: " + s.getMinRequired());
            }
            
            LOGGER.info("Successfully fetched " + list.size() + " low stock items");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching low stock items", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching low stock items", e);
        }
        
        return list;
    }

    // Fetch distinct categories for filter
    public List<String> getCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM InventoryItems WHERE isDeleted = 0";
        
        LOGGER.info("Attempting to fetch categories");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            LOGGER.info("Executing query: " + sql);
            
            while (rs.next()) {
                String category = rs.getString("category");
                categories.add(category);
                LOGGER.info("Found category: " + category);
            }
            
            LOGGER.info("Successfully fetched " + categories.size() + " categories");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching categories", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching categories", e);
        }
        
        return categories;
    }

    // Fetch items by category filter
    public List<StockItem> getByCategory(String category) {
        List<StockItem> list = new ArrayList<>();
        String sql = "SELECT i.id, i.item_name, i.category, i.unit_price, " +
                     "COALESCE(i.min_required, 0) AS min_required, " +
                     "COALESCE(MAX(sr.remaining_stock), 0) AS remaining_stock " +
                     "FROM InventoryItems i LEFT JOIN StockReports sr ON i.id = sr.item_id " +
                     "WHERE i.isDeleted = 0 AND i.category = ? " +
                     "GROUP BY i.id, i.item_name, i.category, i.unit_price, i.min_required";
        
        LOGGER.info("Attempting to fetch stock items by category: " + category);
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            LOGGER.info("Executing query: " + sql + " with parameter: " + category);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockItem s = new StockItem();
                    s.setId(rs.getInt("id"));
                    s.setItemName(rs.getString("item_name"));
                    s.setCategory(rs.getString("category"));
                    s.setUnitPrice(rs.getDouble("unit_price"));
                    s.setMinRequired(rs.getInt("min_required"));
                    s.setRemainingStock(rs.getInt("remaining_stock"));
                    list.add(s);
                    
                    LOGGER.info("Found item: " + s.getItemName() + " (ID: " + s.getId() + ") - Stock: " + s.getRemainingStock());
                }
                
                LOGGER.info("Successfully fetched " + list.size() + " stock items for category: " + category);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching stock items by category: " + category, e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching stock items by category: " + category, e);
        }
        
        return list;
    }
}
