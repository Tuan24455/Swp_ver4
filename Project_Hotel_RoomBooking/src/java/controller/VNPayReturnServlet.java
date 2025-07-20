package controller;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import service.VNPayService;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    private BookingDao bookingDao;
    private VNPayService vnPayService;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDao = new BookingDao();
        vnPayService = new VNPayService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        
        // Verify payment response
        boolean validPayment = vnPayService.validatePaymentResponse(request.getParameterMap());
        
        boolean paymentSuccess = false;
        String message = "";
        String[] parts = vnp_TxnRef.split("_");
        
        if (validPayment && "00".equals(vnp_ResponseCode)) {
            // Payment successful
            paymentSuccess = true;
            
            // Check if this is a service booking
            if (parts[0].equals("SVC")) {
                // Handle service booking payment
                int serviceBookingId = Integer.parseInt(parts[1]);
                // serviceBookingDao.updateServiceBookingStatus(serviceBookingId, "Confirmed"); // This line was removed
                message = "Thanh toán dịch vụ thành công!";
            } else {
                // Handle room booking payment
                int bookingId = Integer.parseInt(parts[0]);
                bookingDao.updateBookingStatus(bookingId, "Confirmed");
                message = "Thanh toán đặt phòng thành công!";
            }
        } else {
            // Payment failed
            paymentSuccess = false;
            if (parts[0].equals("SVC")) {
                int serviceBookingId = Integer.parseInt(parts[1]);
                // serviceBookingDao.updateServiceBookingStatus(serviceBookingId, "Payment Failed"); // This line was removed
                message = "Thanh toán dịch vụ thất bại!";
            } else {
                int bookingId = Integer.parseInt(parts[0]);
                bookingDao.updateBookingStatus(bookingId, "Payment Failed");
                message = "Thanh toán đặt phòng thất bại!";
            }
        }

        // Clean up session
        HttpSession session = request.getSession();
        session.removeAttribute("pendingServiceBookingId");
        
        // Redirect with status message
        response.sendRedirect(request.getContextPath() + "/home?message=" + 
            URLEncoder.encode(message, "UTF-8") + "&status=" + 
            (paymentSuccess ? "success" : "error"));
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
}
