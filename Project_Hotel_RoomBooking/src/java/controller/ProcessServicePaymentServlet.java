package controller;

import service.VNPayService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ProcessServicePaymentServlet", urlPatterns = {"/process-service-payment"})
public class ProcessServicePaymentServlet extends HttpServlet {
    
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
            
            // Get payment parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String bookingDate = request.getParameter("bookingDate");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String note = request.getParameter("note");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String serviceName = request.getParameter("serviceName");
            
            // Create a unique booking reference for service booking
            String serviceBookingRef = "SVC_" + serviceId + "_" + System.currentTimeMillis();
            
            // Store service booking details in session for later processing
            session.setAttribute("pendingServiceBooking", new ServiceBookingDetails(
                serviceId, bookingDate, quantity, note, totalAmount, serviceName, user.getId()
            ));
            
            // Create VNPay payment URL for service booking
            long amountInVND = (long) totalAmount;
            String paymentUrl = VNPayService.createServicePaymentUrl(request, serviceBookingRef, amountInVND, serviceName);
            
            // Redirect to VNPay payment page
            response.sendRedirect(paymentUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to service list
        response.sendRedirect("service");
    }
    
    // Inner class to hold service booking details
    public static class ServiceBookingDetails {
        public final int serviceId;
        public final String bookingDate;
        public final int quantity;
        public final String note;
        public final double totalAmount;
        public final String serviceName;
        public final int userId;
        
        public ServiceBookingDetails(int serviceId, String bookingDate, int quantity, 
                String note, double totalAmount, String serviceName, int userId) {
            this.serviceId = serviceId;
            this.bookingDate = bookingDate;
            this.quantity = quantity;
            this.note = note;
            this.totalAmount = totalAmount;
            this.serviceName = serviceName;
            this.userId = userId;
        }
    }
}
