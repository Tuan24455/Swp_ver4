package controller.admin;

import com.google.gson.Gson;
import dao.PurchaseReportDAO;
import dao.RoomDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PurchaseReportServlet", urlPatterns = {"/purchasereport", "/admin/purchasereport"})
public class PurchaseReportServlet extends HttpServlet {
    
    private RoomDao roomDao;
    private PurchaseReportDAO purchaseReportDAO;
    
    @Override
    public void init() throws ServletException {
        roomDao = new RoomDao();
        purchaseReportDAO = new PurchaseReportDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getInvoiceDetails".equals(action)) {
            handleGetInvoiceDetails(request, response);
            return;
        }

        try {
            // Lấy dữ liệu báo cáo doanh thu phòng
            List<Map<String, Object>> reportData = purchaseReportDAO.getPurchaseReportData();
            request.setAttribute("reportData", reportData);

            // Lấy list động cho filter dropdown (gọi DAO)
            List<String> roomTypes = purchaseReportDAO.getAllRoomTypes();
            List<String> paymentStatuses = purchaseReportDAO.getAllTransactionStatuses();
            List<String> guestTypes = purchaseReportDAO.getAllGuestTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("paymentStatuses", paymentStatuses);
            request.setAttribute("guestTypes", guestTypes);            // Phân trang cho Hóa đơn chi tiết
            int invoicePage = 1;
            final int INVOICE_PAGE_SIZE = 5;
            if (request.getParameter("invoicePage") != null) {
                try {
                    invoicePage = Integer.parseInt(request.getParameter("invoicePage"));
                } catch (NumberFormatException e) {
                    invoicePage = 1;
                }
            }

            // Nếu invoiceData chưa được set (từ doPost), lấy mặc định (không filter)
            if (request.getAttribute("invoiceData") == null) {
                int totalInvoices = purchaseReportDAO.getTotalInvoiceCount(null, null, "", "", "");
                int totalInvoicePages = (int) Math.ceil((double) totalInvoices / INVOICE_PAGE_SIZE);
                
                List<Map<String, Object>> invoiceData = purchaseReportDAO.getInvoiceReportDataPaginated(null, null, "", "", "", invoicePage, INVOICE_PAGE_SIZE);
                request.setAttribute("invoiceData", invoiceData);
                request.setAttribute("totalInvoicePages", totalInvoicePages);
                request.setAttribute("currentInvoicePage", invoicePage);
            }

            // Phân trang cho Dịch vụ bổ sung
            int servicePage = 1;
            final int SERVICE_PAGE_SIZE = 3;
            if (request.getParameter("servicePage") != null) {
                servicePage = Integer.parseInt(request.getParameter("servicePage"));
            }
            int totalServices = purchaseReportDAO.getTotalServiceCount();
            int totalServicePages = (int) Math.ceil((double) totalServices / SERVICE_PAGE_SIZE);

            List<Map<String, Object>> topServicesData = purchaseReportDAO.getTopAdditionalServicesData(servicePage, SERVICE_PAGE_SIZE);
            request.setAttribute("topServicesData", topServicesData);
            request.setAttribute("totalServicePages", totalServicePages);
            request.setAttribute("currentServicePage", servicePage);

            // Lấy số lượng phòng theo trạng thái
            Map<String, Integer> statusCounts = roomDao.getRoomStatusCounts();
            
            // Tính tổng số phòng
            int totalRooms = 0;
            for (Integer count : statusCounts.values()) {
                totalRooms += count;
            }
            
            // Lấy số phòng theo từng trạng thái
            int occupiedRooms = statusCounts.getOrDefault("Occupied", 0);
            int availableRooms = statusCounts.getOrDefault("Available", 0);
            int maintenanceRooms = statusCounts.getOrDefault("Maintenance", 0);
            
            // Set attributes để JSP có thể sử dụng
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("maintenanceRooms", maintenanceRooms);
            
            // Forward đến JSP
            request.getRequestDispatcher("/admin/purchasereport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading report: " + e.getMessage());
            request.getRequestDispatcher("/admin/purchasereport.jsp").forward(request, response);
        }
    }
    
    private void handleGetInvoiceDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String invoiceIdStr = request.getParameter("invoiceId");
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invoice ID is required.\"}");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(invoiceIdStr);
            Map<String, Object> invoiceDetails = purchaseReportDAO.getInvoiceDetailsById(invoiceId);

            if (invoiceDetails == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Invoice not found.\"}");
                return;
            }

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            out.write(gson.toJson(invoiceDetails));
            out.flush();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid Invoice ID format.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"An error occurred while fetching invoice details.\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý filter từ form POST
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");
        String roomTypeFilter = request.getParameter("roomTypeFilter");
        String paymentStatusFilter = request.getParameter("paymentStatusFilter");
        String guestTypeFilter = request.getParameter("guestTypeFilter");
        
        // Chuyển đổi string thành java.sql.Date (nếu không rỗng, иначе null)
        Date dateFrom = null;
        Date dateTo = null;
        try {
            if (dateFromStr != null && !dateFromStr.isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isEmpty()) {
                dateTo = Date.valueOf(dateToStr);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format.");
            doGet(request, response);
            return;
        }
          // Phân trang cho Hóa đơn chi tiết với filter
        int invoicePage = 1;
        final int INVOICE_PAGE_SIZE = 5;
        if (request.getParameter("invoicePage") != null) {
            try {
                invoicePage = Integer.parseInt(request.getParameter("invoicePage"));
            } catch (NumberFormatException e) {
                invoicePage = 1;
            }
        }
        
        // Lấy tổng số hóa đơn với filter
        int totalInvoices = purchaseReportDAO.getTotalInvoiceCount(dateFrom, dateTo, roomTypeFilter, paymentStatusFilter, guestTypeFilter);
        int totalInvoicePages = (int) Math.ceil((double) totalInvoices / INVOICE_PAGE_SIZE);
        
        // Lấy invoiceData đã lọc từ DAO với phân trang
        List<Map<String, Object>> invoiceData = purchaseReportDAO.getInvoiceReportDataPaginated(dateFrom, dateTo, roomTypeFilter, paymentStatusFilter, guestTypeFilter, invoicePage, INVOICE_PAGE_SIZE);
        request.setAttribute("invoiceData", invoiceData);
        request.setAttribute("totalInvoicePages", totalInvoicePages);
        request.setAttribute("currentInvoicePage", invoicePage);
        
        // Gọi doGet để load các phần còn lại
        doGet(request, response);
    }
}