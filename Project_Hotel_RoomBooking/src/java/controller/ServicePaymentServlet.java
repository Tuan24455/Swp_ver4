package controller;

import dao.ServiceBookingDao;
import dao.ServiceDao;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Service;
import model.ServiceBooking;
import service.VNPayService;

@WebServlet(name = "ServicePaymentServlet", urlPatterns = {"/servicePayment"})
public class ServicePaymentServlet extends HttpServlet {
    
    private ServiceBookingDao serviceBookingDao;
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        serviceBookingDao = new ServiceBookingDao();
        serviceDao = new ServiceDao();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get form parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String usageDateStr = request.getParameter("usageDate");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Validate parameters
            if (usageDateStr == null || usageDateStr.trim().isEmpty()) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=invalidDate");
                return;
            }
            
            if (quantity <= 0) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=invalidQuantity");
                return;
            }
            
            // Parse usage date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date usageDate;
            try {
                usageDate = dateFormat.parse(usageDateStr);
                
                // Check if usage date is in the future
                java.util.Date today = new java.util.Date();
                if (usageDate.before(today)) {
                    response.sendRedirect("serviceDetail?id=" + serviceId + "&error=pastDate");
                    return;
                }
            } catch (ParseException e) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=invalidDate");
                return;
            }
            
            // Get service details
            Service service = serviceDao.getServiceById(serviceId);
            if (service == null) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=serviceNotFound");
                return;
            }
            
            // Calculate total amount
            double totalAmount = service.getPrice() * quantity;
            
            // Create service booking
            ServiceBooking serviceBooking = new ServiceBooking(
                user.getId(), 
                serviceId, 
                usageDate, 
                quantity, 
                totalAmount
            );
            
            // Save service booking to database
            System.out.println("Creating service booking - User ID: " + user.getId() + ", Service ID: " + serviceId + ", Amount: " + totalAmount);
            int bookingId = serviceBookingDao.createServiceBooking(serviceBooking);
            System.out.println("Service booking created with ID: " + bookingId);
            
            if (bookingId > 0) {
                // Booking created successfully, redirect to payment
                String paymentUrl = VNPayService.createServicePaymentUrl(request, bookingId, (long)totalAmount, service.getName());
                response.sendRedirect(paymentUrl);
            } else {
                // Booking failed
                System.out.println("Service booking failed - bookingId: " + bookingId);
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=bookingFailed");
            }
            
        } catch (NumberFormatException e) {
            // Invalid number format
            String serviceId = request.getParameter("serviceId");
            if (serviceId != null) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=invalidInput");
            } else {
                response.sendRedirect("service.jsp?error=invalidInput");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String serviceId = request.getParameter("serviceId");
            if (serviceId != null) {
                response.sendRedirect("serviceDetail?id=" + serviceId + "&error=systemError");
            } else {
                response.sendRedirect("service.jsp?error=systemError");
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("history".equals(action)) {
            // Get search parameter
            String search = request.getParameter("search");
            if (search == null) search = "";
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 10; // Number of records per page
            
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Get user's service booking history with search and pagination
            java.util.List<ServiceBooking> bookings = serviceBookingDao.getServiceBookingHistoryByUserId(
                user.getId(), search, page, pageSize);
            
            // Get total count for pagination
            int totalCount = serviceBookingDao.getServiceBookingCountByUserId(user.getId(), search);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("serviceBookings", bookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("search", search);
            
            request.getRequestDispatcher("customer/service-booking-history.jsp").forward(request, response);
        } else {
            // Default action - redirect to services page
            response.sendRedirect("service.jsp");
        }
    }
} 