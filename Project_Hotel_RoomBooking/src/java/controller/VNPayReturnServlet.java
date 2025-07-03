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
            int bookingId = Integer.parseInt(parts[0]);
            
            boolean paymentSuccess = false;
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                // Thanh toán thành công
                // Cập nhật trạng thái đơn hàng trong database
                bookingDao.updateBookingStatus(bookingId, "Confirmed");
                paymentSuccess = true;
            } else {
                // Thanh toán thất bại
                bookingDao.updateBookingStatus(bookingId, "Payment Failed");
            }
            
            // Chuyển về trang chủ với thông báo
            String message = paymentSuccess ? "Thanh toán thành công!" : "Thanh toán thất bại!";
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
}
