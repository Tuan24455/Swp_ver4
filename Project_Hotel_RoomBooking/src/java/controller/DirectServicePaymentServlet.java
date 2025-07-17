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

@WebServlet(name = "DirectServicePaymentServlet", urlPatterns = {"/direct-service-payment"})
public class DirectServicePaymentServlet extends HttpServlet {
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
            
            // Get and validate payment parameters
            String serviceIdParam = request.getParameter("serviceId");
            String bookingDate = request.getParameter("bookingDate");
            String quantityParam = request.getParameter("quantity");
            String note = request.getParameter("note");
            String totalAmountParam = request.getParameter("totalAmount");
            String serviceName = request.getParameter("serviceName");
            
            // Debug logging
            System.out.println("DirectServicePaymentServlet - Received parameters:");
            System.out.println("ServiceId: " + serviceIdParam);
            System.out.println("BookingDate: " + bookingDate);
            System.out.println("Quantity: " + quantityParam);
            System.out.println("TotalAmount: " + totalAmountParam);
            System.out.println("ServiceName: " + serviceName);
            System.out.println("User: " + user.getFullName() + " (ID: " + user.getId() + ")");
            
            // Validate required parameters
            if (serviceIdParam == null || bookingDate == null || quantityParam == null || totalAmountParam == null) {
                throw new ServletException("Missing required parameters");
            }
            
            int serviceId = Integer.parseInt(serviceIdParam);
            int quantity = Integer.parseInt(quantityParam);
            double totalAmount = Double.parseDouble(totalAmountParam);
            
            // Create ServiceBooking object
            ServiceBooking serviceBooking = new ServiceBooking();
            serviceBooking.setUserId(user.getId());
            serviceBooking.setServiceId(serviceId);
            serviceBooking.setBookingDate(Date.valueOf(bookingDate));
            serviceBooking.setQuantity(quantity);
            serviceBooking.setNote(note != null ? note : "");
            serviceBooking.setTotalAmount(totalAmount);
            serviceBooking.setStatus("Pending");
            serviceBooking.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            
            // Save the service booking to database
            System.out.println("Attempting to save service booking...");
            int bookingId = serviceBookingDao.createServiceBooking(serviceBooking);
            System.out.println("Returned booking ID: " + bookingId);
            
            if (bookingId <= 0) {
                throw new ServletException("Failed to create service booking - returned ID: " + bookingId);
            }
            
            // Create a unique booking reference for service booking
            String serviceBookingRef = "SVC_" + bookingId;
            
            // Store service booking ID in session for later processing
            session.setAttribute("pendingServiceBookingId", bookingId);
            
            // Create VNPay payment URL for service booking
            long amountInVND = (long) totalAmount;
            String paymentUrl = VNPayService.createServicePaymentUrl(request, serviceBookingRef, amountInVND, serviceName);
            
            System.out.println("Redirecting to payment URL: " + paymentUrl);
            
            // Redirect to VNPay payment page
            response.sendRedirect(paymentUrl);
            
        } catch (NumberFormatException e) {
            System.err.println("Number format error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Invalid number format: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            System.err.println("Date format error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Invalid date format: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error in DirectServicePaymentServlet: " + e.getMessage());
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