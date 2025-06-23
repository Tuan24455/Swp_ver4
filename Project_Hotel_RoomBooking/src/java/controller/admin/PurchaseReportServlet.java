package controller.admin;

import dao.StockDao;
import model.StockItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "PurchaseReportServlet", urlPatterns = {"/purchasereport", "/admin/purchasereport"})
public class PurchaseReportServlet extends HttpServlet {
    
    private StockDao stockDao;
    
    @Override
    public void init() throws ServletException {
        stockDao = new StockDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is admin
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get date range parameters
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            // Set default date range if not provided (last 30 days)
            if (startDate == null || startDate.isEmpty()) {
                startDate = LocalDate.now().minusDays(30).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            if (endDate == null || endDate.isEmpty()) {
                endDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            
            // Get stock data for purchase report
            List<StockItem> stockItems = stockDao.getAll();
            
            // Calculate summary statistics
            Map<String, Object> summary = calculateSummary(stockItems);
            
            // Set attributes for JSP
            request.setAttribute("stockItems", stockItems);
            request.setAttribute("summary", summary);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            
            // Forward to JSP
            request.getRequestDispatcher("admin/purchasereport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading purchase report: " + e.getMessage());
            request.getRequestDispatcher("admin/purchasereport.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private Map<String, Object> calculateSummary(List<StockItem> stockItems) {
        Map<String, Object> summary = new HashMap<>();
        
        double totalValue = 0;
        int totalItems = stockItems.size();
        Map<String, Integer> categoryCount = new HashMap<>();
        Map<String, Double> categoryValue = new HashMap<>();
        int lowStockItems = 0;
        
        for (StockItem item : stockItems) {
            double itemValue = item.getUnitPrice() * item.getRemainingStock();
            totalValue += itemValue;
            
            String category = item.getCategory();
            categoryCount.put(category, categoryCount.getOrDefault(category, 0) + 1);
            categoryValue.put(category, categoryValue.getOrDefault(category, 0.0) + itemValue);
            
            if (item.getRemainingStock() <= item.getMinRequired()) {
                lowStockItems++;
            }
        }
        
        summary.put("totalValue", totalValue);
        summary.put("totalItems", totalItems);
        summary.put("averageValue", totalItems > 0 ? totalValue / totalItems : 0);
        summary.put("categoryCount", categoryCount);
        summary.put("categoryValue", categoryValue);
        summary.put("lowStockItems", lowStockItems);
        
        return summary;
    }
}