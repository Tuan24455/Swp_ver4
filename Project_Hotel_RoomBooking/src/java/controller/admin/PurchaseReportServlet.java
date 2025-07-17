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

            // Phân trang cho Hóa đơn phòng chi tiết
            int roomInvoicePage = 1;
            final int ROOM_INVOICE_PAGE_SIZE = 5;
            if (request.getParameter("roomInvoicePage") != null) {
                try {
                    roomInvoicePage = Integer.parseInt(request.getParameter("roomInvoicePage"));
                } catch (NumberFormatException e) {
                    roomInvoicePage = 1;
                }
            }

            // Phân trang cho Hóa đơn dịch vụ chi tiết  
            int serviceInvoicePage = 1;
            final int SERVICE_INVOICE_PAGE_SIZE = 5;
            if (request.getParameter("serviceInvoicePage") != null) {
                try {
                    serviceInvoicePage = Integer.parseInt(request.getParameter("serviceInvoicePage"));
                } catch (NumberFormatException e) {
                    serviceInvoicePage = 1;
                }
            }

            // Nếu invoiceData chưa được set (từ doPost), lấy mặc định (không filter)
            if (request.getAttribute("invoiceData") == null) {
                List<Map<String, Object>> roomInvoiceData = purchaseReportDAO.getRoomInvoiceReportDataPaginated(null, null, "", "", "", roomInvoicePage, ROOM_INVOICE_PAGE_SIZE);
                int totalRoomInvoices = purchaseReportDAO.getTotalRoomInvoiceCount(null, null, "", "", "");
                int totalRoomInvoicePages = (int) Math.ceil((double) totalRoomInvoices / ROOM_INVOICE_PAGE_SIZE);

                request.setAttribute("invoiceData", roomInvoiceData);
                request.setAttribute("currentRoomInvoicePage", roomInvoicePage);
                request.setAttribute("totalRoomInvoicePages", totalRoomInvoicePages);
            }

            System.out.println("Checking serviceInvoiceData attribute: " + request.getAttribute("serviceInvoiceData"));
            if (request.getAttribute("serviceInvoiceData") == null) {
                System.out.println("serviceInvoiceData is null, loading default data...");
                
                // Load real data from database
                List<Map<String, Object>> serviceInvoiceData = purchaseReportDAO.getServiceInvoiceReportDataPaginated(null, null, "", "", "", serviceInvoicePage, SERVICE_INVOICE_PAGE_SIZE);
                int totalServiceInvoices = purchaseReportDAO.getTotalServiceInvoiceCount(null, null, "", "", "");
                int totalServiceInvoicePages = (int) Math.ceil((double) totalServiceInvoices / SERVICE_INVOICE_PAGE_SIZE);

                System.out.println("Service invoice data size: " + serviceInvoiceData.size());
                System.out.println("Total service invoices: " + totalServiceInvoices);

                request.setAttribute("serviceInvoiceData", serviceInvoiceData);
                request.setAttribute("currentServiceInvoicePage", serviceInvoicePage);
                request.setAttribute("totalServiceInvoicePages", Math.max(totalServiceInvoicePages, 1));
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

        } catch (Exception e) {
            System.out.println("Exception in servlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
        }

        System.out.println("=== Before forwarding to JSP ===");
        System.out.println("serviceInvoiceData attribute: " + request.getAttribute("serviceInvoiceData"));
        System.out.println("currentServiceInvoicePage: " + request.getAttribute("currentServiceInvoicePage"));
        System.out.println("totalServiceInvoicePages: " + request.getAttribute("totalServiceInvoicePages"));

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
        
        if ("roomInvoice".equals(reportType)) {
            handleRoomInvoiceFilter(request, response);
        } else if ("serviceInvoice".equals(reportType)) {
            handleServiceInvoiceFilter(request, response);
        } else {
            // Default behavior - handle old invoice filter for backward compatibility
            handleRoomInvoiceFilter(request, response);
        }
        
        // Gọi doGet để load các phần còn lại
        doGet(request, response);
    }
    
    private void handleRoomInvoiceFilter(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy thông số filter từ form
            String dateFromStr = request.getParameter("dateFrom");
            String dateToStr = request.getParameter("dateTo");
            String roomTypeFilter = request.getParameter("roomTypeFilter");
            String paymentStatusFilter = request.getParameter("paymentStatusFilter");
            String guestTypeFilter = request.getParameter("guestTypeFilter");

            Date dateFrom = null, dateTo = null;
            if (dateFromStr != null && !dateFromStr.isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isEmpty()) {
                dateTo = Date.valueOf(dateToStr);
            }

            // Phân trang
            int roomInvoicePage = 1;
            final int ROOM_INVOICE_PAGE_SIZE = 5;
            if (request.getParameter("roomInvoicePage") != null) {
                try {
                    roomInvoicePage = Integer.parseInt(request.getParameter("roomInvoicePage"));
                } catch (NumberFormatException e) {
                    roomInvoicePage = 1;
                }
            }

            // Lấy dữ liệu filtered và phân trang
            List<Map<String, Object>> roomInvoiceData = purchaseReportDAO.getRoomInvoiceReportDataPaginated(dateFrom, dateTo, roomTypeFilter, paymentStatusFilter, guestTypeFilter, roomInvoicePage, ROOM_INVOICE_PAGE_SIZE);
            int totalRoomInvoices = purchaseReportDAO.getTotalRoomInvoiceCount(dateFrom, dateTo, roomTypeFilter, paymentStatusFilter, guestTypeFilter);
            int totalRoomInvoicePages = (int) Math.ceil((double) totalRoomInvoices / ROOM_INVOICE_PAGE_SIZE);

            // Set attributes
            request.setAttribute("invoiceData", roomInvoiceData);
            request.setAttribute("currentRoomInvoicePage", roomInvoicePage);
            request.setAttribute("totalRoomInvoicePages", totalRoomInvoicePages);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lọc báo cáo hóa đơn phòng: " + e.getMessage());
        }
    }
    
    private void handleServiceInvoiceFilter(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy thông số filter từ form
            String dateFromStr = request.getParameter("serviceDateFrom");
            String dateToStr = request.getParameter("serviceDateTo");
            String serviceTypeFilter = request.getParameter("serviceTypeFilter");
            String servicePaymentStatusFilter = request.getParameter("servicePaymentStatusFilter");
            String serviceGuestTypeFilter = request.getParameter("serviceGuestTypeFilter");

            Date dateFrom = null, dateTo = null;
            if (dateFromStr != null && !dateFromStr.isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isEmpty()) {
                dateTo = Date.valueOf(dateToStr);
            }

            // Phân trang
            int serviceInvoicePage = 1;
            final int SERVICE_INVOICE_PAGE_SIZE = 5;
            if (request.getParameter("serviceInvoicePage") != null) {
                try {
                    serviceInvoicePage = Integer.parseInt(request.getParameter("serviceInvoicePage"));
                } catch (NumberFormatException e) {
                    serviceInvoicePage = 1;
                }
            }

            // Lấy dữ liệu filtered và phân trang
            List<Map<String, Object>> serviceInvoiceData = purchaseReportDAO.getServiceInvoiceReportDataPaginated(dateFrom, dateTo, serviceTypeFilter, servicePaymentStatusFilter, serviceGuestTypeFilter, serviceInvoicePage, SERVICE_INVOICE_PAGE_SIZE);
            int totalServiceInvoices = purchaseReportDAO.getTotalServiceInvoiceCount(dateFrom, dateTo, serviceTypeFilter, servicePaymentStatusFilter, serviceGuestTypeFilter);
            int totalServiceInvoicePages = (int) Math.ceil((double) totalServiceInvoices / SERVICE_INVOICE_PAGE_SIZE);

            // Set attributes
            request.setAttribute("serviceInvoiceData", serviceInvoiceData);
            request.setAttribute("currentServiceInvoicePage", serviceInvoicePage);
            request.setAttribute("totalServiceInvoicePages", totalServiceInvoicePages);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lọc báo cáo hóa đơn dịch vụ: " + e.getMessage());
        }
    }
}