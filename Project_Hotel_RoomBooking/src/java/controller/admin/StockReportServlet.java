package controller.admin;

import dao.StockDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.StockItem;

/**
 * Servlet hiển thị báo cáo tồn kho.
 */
@WebServlet(name = "StockReportServlet", urlPatterns = {"/stockreport"})
public class StockReportServlet extends HttpServlet {

    private final StockDao stockDao = new StockDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load KPI metrics for summary cards
            Map<String, Object> kpiMetrics = stockDao.getKPIMetrics();
            request.setAttribute("kpiMetrics", kpiMetrics);
            
            // Load categories for filter
            List<String> categories = stockDao.getCategories();
            request.setAttribute("categories", categories);
            System.out.println("StockReportServlet: Available categories: " + categories);
            
            // Apply category filter if present
            String categoryParam = request.getParameter("category");
            System.out.println("StockReportServlet: Category parameter: '" + categoryParam + "'");
            
            List<StockItem> stockList;
            if (categoryParam != null && !categoryParam.isEmpty()) {
                System.out.println("StockReportServlet: Filtering by category: " + categoryParam);
                stockList = stockDao.getByCategory(categoryParam);
                System.out.println("StockReportServlet: Found " + stockList.size() + " items for category: " + categoryParam);
            } else {
                System.out.println("StockReportServlet: Loading all items (no category filter)");
                stockList = stockDao.getAll();
                System.out.println("StockReportServlet: Found " + stockList.size() + " total items");
            }
            
            // Load low stock items
            List<StockItem> lowStockItems = stockDao.getLowStockItems();
            request.setAttribute("lowStockItems", lowStockItems);
            request.setAttribute("lowStockCount", lowStockItems.size());
            
            request.setAttribute("stockList", stockList);
            
            // Debug: Print KPI metrics
            System.out.println("StockReportServlet: KPI Metrics:");
            for (Map.Entry<String, Object> entry : kpiMetrics.entrySet()) {
                System.out.println("  " + entry.getKey() + ": " + entry.getValue());
            }
            
            // Debug: Print detailed item info
            System.out.println("StockReportServlet: Detailed stock list:");
            for (StockItem item : stockList) {
                System.out.println("  - ID: " + item.getId() + 
                                 ", Name: " + item.getItemName() + 
                                 ", Category: '" + item.getCategory() + "'" +
                                 ", Stock: " + item.getRemainingStock() + 
                                 ", Min: " + item.getMinRequired() +
                                 ", Price: " + item.getUnitPrice());
            }
            
            System.out.println("StockReportServlet: Low stock items count: " + lowStockItems.size());
            
            request.getRequestDispatcher("admin/stockreport.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in StockReportServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Forward to JSP even with error, let JSP handle empty data
            request.setAttribute("error", "Có lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("admin/stockreport.jsp").forward(request, response);
        }
    }
}
