package controller;

import config.VNPayConfig;
import dao.BookingDao;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    private BookingDao bookingDao = new BookingDao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        Map fields = new HashMap();
        for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
            String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
          // Check checksum
        String signValue = VNPayConfig.hashAllFields(fields);
        if (signValue.equals(vnp_SecureHash)) {
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            String[] parts = vnp_TxnRef.split("_");
            
            boolean paymentSuccess = false;
            String message = "";
            
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                paymentSuccess = true;
                
                // Check if this is a service payment or room booking
                if (parts[0].startsWith("SVC")) {
                    // Handle service payment
                    message = "Thanh toán dịch vụ thành công!";
                    // TODO: Process service booking in database
                    processServicePayment(request, parts[0]);
                } else {
                    // Handle room booking payment
                    int bookingId = Integer.parseInt(parts[0]);
                    bookingDao.updateBookingStatus(bookingId, "Confirmed");
                    message = "Thanh toán đặt phòng thành công!";
                }
            } else {
                // Payment failed
                paymentSuccess = false;
                
                if (parts[0].startsWith("SVC")) {
                    message = "Thanh toán dịch vụ thất bại!";
                } else {
                    int bookingId = Integer.parseInt(parts[0]);
                    bookingDao.updateBookingStatus(bookingId, "Payment Failed");
                    message = "Thanh toán đặt phòng thất bại!";
                }
            }
            
            // Chuyển về trang chủ với thông báo
            response.sendRedirect(request.getContextPath() + "/home?message=" + URLEncoder.encode(message, "UTF-8") + "&status=" + (paymentSuccess ? "success" : "error"));
        } else {
            // Checksum failed
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Invalid signature");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processServicePayment(HttpServletRequest request, String serviceBookingRef) {
        try {
            // Get the pending service booking from session
            HttpSession session = request.getSession();
            Object pendingBooking = session.getAttribute("pendingServiceBooking");
            
            if (pendingBooking != null) {
                // Process the service booking here
                // For now, we'll just remove it from session
                // In a full implementation, you would save this to a ServiceBookings table
                session.removeAttribute("pendingServiceBooking");
                
                // Log successful service booking
                System.out.println("Service booking processed successfully: " + serviceBookingRef);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
