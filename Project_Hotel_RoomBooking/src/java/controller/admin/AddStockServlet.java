package controller.admin;

import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * author: phạm xuân hiếu
 */
@WebServlet(name = "AddStockServlet", urlPatterns = {"/addstock"})
public class AddStockServlet extends HttpServlet {
    
    /**
     * Create JSON response safely
     */
    private void sendJsonResponse(PrintWriter out, boolean success, String message, Integer newStock) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": ").append(success);
        json.append(", \"message\": \"").append(escapeJson(message)).append("\"");
        if (newStock != null) {
            json.append(", \"newStock\": ").append(newStock);
        }
        json.append("}");
        out.println(json.toString());
    }
    
    /**
     * Escape special characters for JSON
     */
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                sendJsonResponse(out, false, "Số lượng phải lớn hơn 0", null);
                return;
            }
            
            try (Connection conn = new DBContext().getConnection()) {
                // Get current stock
                String getCurrentStockSql = "SELECT COALESCE(MAX(remaining_stock), 0) as current_stock " +
                                           "FROM StockReports WHERE item_id = ?";
                int currentStock = 0;
                try (PreparedStatement ps = conn.prepareStatement(getCurrentStockSql)) {
                    ps.setInt(1, itemId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentStock = rs.getInt("current_stock");
                        }
                    }
                }
                
                // Insert new stock entry (without remaining_stock as it's computed)
                String insertStockSql = "INSERT INTO StockReports (item_id, stock_date, stock_in, stock_out, note) " +
                                       "VALUES (?, GETDATE(), ?, 0, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertStockSql)) {
                    ps.setInt(1, itemId);
                    ps.setInt(2, quantity);
                    ps.setString(3, "Admin reorder - Added " + quantity + " units");
                    
                    int rowsAffected = ps.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        // Get item name for response
                        String getItemNameSql = "SELECT item_name FROM InventoryItems WHERE id = ?";
                        String itemName = "";
                        try (PreparedStatement namePs = conn.prepareStatement(getItemNameSql)) {
                            namePs.setInt(1, itemId);
                            try (ResultSet nameRs = namePs.executeQuery()) {
                                if (nameRs.next()) {
                                    itemName = nameRs.getString("item_name");
                                }
                            }
                        }
                        
                        // Get the new stock after insert (since remaining_stock is computed)
                        String getNewStockSql = "SELECT COALESCE(MAX(remaining_stock), 0) as new_stock " +
                                               "FROM StockReports WHERE item_id = ?";
                        int newStock = currentStock + quantity; // fallback value
                        try (PreparedStatement newStockPs = conn.prepareStatement(getNewStockSql)) {
                            newStockPs.setInt(1, itemId);
                            try (ResultSet newStockRs = newStockPs.executeQuery()) {
                                if (newStockRs.next()) {
                                    newStock = newStockRs.getInt("new_stock");
                                }
                            }
                        }
                        
                        String message = "Đã thêm " + quantity + " " + itemName + " vào kho";
                        sendJsonResponse(out, true, message, newStock);
                    } else {
                        sendJsonResponse(out, false, "Không thể cập nhật kho", null);
                    }
                }
                
            } catch (SQLException e) {
                System.err.println("Database error in AddStockServlet: " + e.getMessage());
                e.printStackTrace();
                sendJsonResponse(out, false, "Lỗi database: " + e.getMessage(), null);
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(out, false, "Dữ liệu không hợp lệ", null);
        } catch (Exception e) {
            System.err.println("Error in AddStockServlet: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(out, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }
} 