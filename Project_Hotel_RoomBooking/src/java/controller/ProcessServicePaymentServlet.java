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
import model.ServiceBooking;
import dao.ServiceBookingDao;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(name = "ProcessServicePaymentServlet", urlPatterns = {"/process-service-payment"})
public class ProcessServicePaymentServlet extends HttpServlet {
    private ServiceBookingDao serviceBookingDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        serviceBookingDao = new ServiceBookingDao();
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
            
            // Get payment parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String bookingDate = request.getParameter("bookingDate");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String note = request.getParameter("note");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String serviceName = request.getParameter("serviceName");
            
            // Create ServiceBooking object
            ServiceBooking serviceBooking = new ServiceBooking();
            serviceBooking.setUserId(user.getId());
            serviceBooking.setServiceId(serviceId);
            serviceBooking.setBookingDate(Date.valueOf(bookingDate));
            serviceBooking.setQuantity(quantity);
            serviceBooking.setNote(note);
            serviceBooking.setTotalAmount(totalAmount);
            serviceBooking.setStatus("Pending");
            serviceBooking.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            
            // Save the service booking
            int bookingId = serviceBookingDao.createServiceBooking(serviceBooking);
            
            if (bookingId <= 0) {
                throw new ServletException("Failed to create service booking");
            }
            
            // Create a unique booking reference for service booking
            String serviceBookingRef = "SVC_" + bookingId;
            
            // Store service booking ID in session for later processing
            session.setAttribute("pendingServiceBookingId", bookingId);            // Create VNPay payment URL for service booking
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
}
