package controller;

import service.VNPayService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProcessPaymentServlet", urlPatterns = {"/process-payment"})
public class ProcessPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ form
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            long amount = Long.parseLong(request.getParameter("totalAmount"));
            
            // Tạo URL thanh toán VNPay
            String paymentUrl = VNPayService.createPaymentUrl(request, bookingId, amount);
            
            // Chuyển hướng đến trang thanh toán VNPay
            response.sendRedirect(paymentUrl);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }
}
