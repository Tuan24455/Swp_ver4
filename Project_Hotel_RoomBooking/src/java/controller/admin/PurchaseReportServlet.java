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
import java.util.ArrayList;
import java.util.HashMap;
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
        System.out.println("=== PurchaseReportServlet doGet called ===");
        String action = request.getParameter("action");
        System.out.println("Action parameter: " + action);

        if ("getInvoiceDetails".equals(action)) {
            handleGetInvoiceDetails(request, response);
            return;
        }
        
        if ("getServiceInvoiceDetails".equals(action)) {
            handleGetServiceInvoiceDetails(request, response);
            return;
        }

        try {
            System.out.println("=== Starting to load report data ===");
            // Lấy dữ liệu báo cáo doanh thu phòng
            List<Map<String, Object>> reportData = purchaseReportDAO.getPurchaseReportData();
            request.setAttribute("reportData", reportData);
            System.out.println("Loaded room report data: " + reportData.size() + " records");

            // Lấy list động cho filter dropdown (gọi DAO)
            List<String> roomTypes = purchaseReportDAO.getAllRoomTypes();
            List<String> paymentStatuses = purchaseReportDAO.getAllTransactionStatuses();
            List<String> guestTypes = purchaseReportDAO.getAllGuestTypes();
            List<String> serviceTypes = purchaseReportDAO.getAllServiceTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("paymentStatuses", paymentStatuses);
            request.setAttribute("guestTypes", guestTypes);
            request.setAttribute("serviceTypes", serviceTypes);

            // Phân trang cho hóa đơn kết hợp
            int combinedPage = 1;
            final int COMBINED_PAGE_SIZE = 5;
            if (request.getParameter("combinedPage") != null) {
                try {
                    combinedPage = Integer.parseInt(request.getParameter("combinedPage"));
                } catch (NumberFormatException e) {
                    combinedPage = 1;
                }
            }

            // Nếu combinedInvoiceData chưa được set (từ doPost), lấy mặc định
            if (request.getAttribute("combinedInvoiceData") == null) {
                List<Map<String, Object>> combinedData = purchaseReportDAO.getCombinedInvoiceReportDataPaginated(null, null, "", "", "", combinedPage, COMBINED_PAGE_SIZE);
                int totalCombined = purchaseReportDAO.getTotalCombinedInvoiceCount(null, null, "", "", "");
                int totalCombinedPages = (int) Math.ceil((double) totalCombined / COMBINED_PAGE_SIZE);

                request.setAttribute("combinedInvoiceData", combinedData);
                request.setAttribute("currentCombinedPage", combinedPage);
                request.setAttribute("totalCombinedPages", totalCombinedPages);
            }

            // Lấy dữ liệu báo cáo dịch vụ từ ServiceBooking
            List<Map<String, Object>> serviceReportData = purchaseReportDAO.getServiceReportData();
            request.setAttribute("serviceReportData", serviceReportData);

            // Phân trang cho Service Report
            int servicePage = 1;
            final int SERVICE_PAGE_SIZE = 5;
            if (request.getParameter("servicePage") != null) {
                try {
                    servicePage = Integer.parseInt(request.getParameter("servicePage"));
                } catch (NumberFormatException e) {
                    servicePage = 1;
                }
            }

            List<Map<String, Object>> topServicesData = purchaseReportDAO.getServiceReportDataPaginated(servicePage, SERVICE_PAGE_SIZE);
            int totalServices = purchaseReportDAO.getTotalServiceCount();
            int totalServicePages = (int) Math.ceil((double) totalServices / SERVICE_PAGE_SIZE);

            request.setAttribute("topServicesData", topServicesData);
            request.setAttribute("currentServicePage", servicePage);
            request.setAttribute("totalServicePages", totalServicePages);

            // Nếu serviceInvoiceData chưa được set (từ doPost), lấy mặc định
            if (request.getAttribute("serviceInvoiceData") == null) {
                int serviceInvoicePage = 1;
                final int SERVICE_INVOICE_PAGE_SIZE = 10;
                if (request.getParameter("serviceInvoicePage") != null) {
                    try {
                        serviceInvoicePage = Integer.parseInt(request.getParameter("serviceInvoicePage"));
                    } catch (NumberFormatException e) {
                        serviceInvoicePage = 1;
                    }
                }

                List<Map<String, Object>> serviceInvoiceData = purchaseReportDAO.getServiceInvoiceDetailsReport(null, null, "", "", "", serviceInvoicePage, SERVICE_INVOICE_PAGE_SIZE);
                int totalServiceInvoice = purchaseReportDAO.getTotalServiceInvoiceDetailsCount(null, null, "", "", "");
                int totalServiceInvoicePages = (int) Math.ceil((double) totalServiceInvoice / SERVICE_INVOICE_PAGE_SIZE);

                request.setAttribute("serviceInvoiceData", serviceInvoiceData);
                request.setAttribute("currentServiceInvoicePage", serviceInvoicePage);
                request.setAttribute("totalServiceInvoicePages", totalServiceInvoicePages);
            }

        } catch (Exception e) {
            System.out.println("Exception in servlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/purchasereport.jsp").forward(request, response);
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
    
    private void handleGetServiceInvoiceDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String invoiceIdStr = request.getParameter("invoiceId");
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Service Invoice ID is required.\"}");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(invoiceIdStr);
            Map<String, Object> serviceInvoiceDetails = purchaseReportDAO.getServiceInvoiceDetailsById(invoiceId);

            if (serviceInvoiceDetails == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Service Invoice not found.\"}");
                return;
            }

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            out.write(gson.toJson(serviceInvoiceDetails));
            out.flush();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid Service Invoice ID format.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"An error occurred while fetching service invoice details.\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        
        if ("combined".equals(reportType)) {
            handleCombinedFilter(request, response);
        } else if ("serviceInvoice".equals(reportType)) {
            handleServiceInvoiceFilter(request, response);
        }
        
        // Gọi doGet để load các phần còn lại
        doGet(request, response);
    }
    
    private void handleCombinedFilter(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy thông số filter từ form
            String dateFromStr = request.getParameter("dateFrom");
            String dateToStr = request.getParameter("dateTo");
            String roomTypeFilter = request.getParameter("roomTypeFilter");
            String serviceTypeFilter = request.getParameter("serviceTypeFilter");
            String paymentStatusFilter = request.getParameter("paymentStatusFilter");

            Date dateFrom = null, dateTo = null;
            if (dateFromStr != null && !dateFromStr.isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isEmpty()) {
                dateTo = Date.valueOf(dateToStr);
            }

            // Phân trang
            int combinedPage = 1;
            final int COMBINED_PAGE_SIZE = 5;
            if (request.getParameter("combinedPage") != null) {
                try {
                    combinedPage = Integer.parseInt(request.getParameter("combinedPage"));
                } catch (NumberFormatException e) {
                    combinedPage = 1;
                }
            }

            // Lấy dữ liệu filtered và phân trang
            List<Map<String, Object>> combinedData = purchaseReportDAO.getCombinedInvoiceReportDataPaginated(dateFrom, dateTo, roomTypeFilter, serviceTypeFilter, paymentStatusFilter, combinedPage, COMBINED_PAGE_SIZE);
            int totalCombined = purchaseReportDAO.getTotalCombinedInvoiceCount(dateFrom, dateTo, roomTypeFilter, serviceTypeFilter, paymentStatusFilter);
            int totalCombinedPages = (int) Math.ceil((double) totalCombined / COMBINED_PAGE_SIZE);

            // Set attributes
            request.setAttribute("combinedInvoiceData", combinedData);
            request.setAttribute("currentCombinedPage", combinedPage);
            request.setAttribute("totalCombinedPages", totalCombinedPages);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lọc báo cáo hóa đơn kết hợp: " + e.getMessage());
        }
    }

    private void handleServiceInvoiceFilter(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy thông số filter từ form
            String dateFromStr = request.getParameter("serviceInvoiceDateFrom");
            String dateToStr = request.getParameter("serviceInvoiceDateTo");
            String serviceTypeFilter = request.getParameter("serviceInvoiceTypeFilter");
            String statusFilter = request.getParameter("serviceInvoiceStatusFilter");
            String guestTypeFilter = request.getParameter("serviceInvoiceGuestFilter");

            Date dateFrom = null, dateTo = null;
            if (dateFromStr != null && !dateFromStr.isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isEmpty()) {
                dateTo = Date.valueOf(dateToStr);
            }

            // Phân trang
            int serviceInvoicePage = 1;
            final int SERVICE_INVOICE_PAGE_SIZE = 10;
            if (request.getParameter("serviceInvoicePage") != null) {
                try {
                    serviceInvoicePage = Integer.parseInt(request.getParameter("serviceInvoicePage"));
                } catch (NumberFormatException e) {
                    serviceInvoicePage = 1;
                }
            }

            // Lấy dữ liệu filtered và phân trang
            List<Map<String, Object>> serviceInvoiceData = purchaseReportDAO.getServiceInvoiceDetailsReport(dateFrom, dateTo, serviceTypeFilter, statusFilter, guestTypeFilter, serviceInvoicePage, SERVICE_INVOICE_PAGE_SIZE);
            int totalServiceInvoice = purchaseReportDAO.getTotalServiceInvoiceDetailsCount(dateFrom, dateTo, serviceTypeFilter, statusFilter, guestTypeFilter);
            int totalServiceInvoicePages = (int) Math.ceil((double) totalServiceInvoice / SERVICE_INVOICE_PAGE_SIZE);

            // Set attributes
            request.setAttribute("serviceInvoiceData", serviceInvoiceData);
            request.setAttribute("currentServiceInvoicePage", serviceInvoicePage);
            request.setAttribute("totalServiceInvoicePages", totalServiceInvoicePages);

            System.out.println("Service Invoice Filter - Records found: " + serviceInvoiceData.size());
            System.out.println("Service Invoice Filter - Total pages: " + totalServiceInvoicePages);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lọc báo cáo hóa đơn dịch vụ: " + e.getMessage());
        }
    }
}