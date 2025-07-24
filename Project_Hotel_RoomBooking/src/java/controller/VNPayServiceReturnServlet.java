package controller;

import dao.ServiceBookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import service.VNPayService;

@WebServlet(name = "VNPayServiceReturnServlet", urlPatterns = {"/vnpay-service-return"})
public class VNPayServiceReturnServlet extends HttpServlet {
    private ServiceBookingDao serviceBookingDao;
    private VNPayService vnPayService;

    @Override
    public void init() throws ServletException {
        super.init();
        serviceBookingDao = new ServiceBookingDao();
        vnPayService = new VNPayService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        
        // Verify payment response
        boolean validPayment = vnPayService.validatePaymentResponse(request.getParameterMap());
        
        boolean paymentSuccess = false;
        String message = "";
        String redirectUrl = "";
        
        try {
            // Extract service booking ID from transaction reference
            // Format: SVC_[serviceBookingId]_[randomNumber]
            String[] parts = vnp_TxnRef.split("_");
            if (parts.length < 2) {
                throw new IllegalArgumentException("Invalid transaction reference format");
            }
            
            int serviceBookingId = Integer.parseInt(parts[1]);
            
            if (validPayment && "00".equals(vnp_ResponseCode)) {
                // Payment successful
                boolean updateResult = serviceBookingDao.updateServiceBookingStatus(serviceBookingId, "Confirmed");
                
                if (updateResult) {
                    paymentSuccess = true;
                    message = "Thanh toán dịch vụ thành công!";
                    
                    // Store payment information for display
                    request.setAttribute("paymentSuccess", true);
                    request.setAttribute("serviceBookingId", serviceBookingId);
                    request.setAttribute("amount", Long.parseLong(vnp_Amount) / 100); // Convert back from VND cents
                    request.setAttribute("transactionNo", vnp_TransactionNo);
                    request.setAttribute("payDate", vnp_PayDate);
                    request.setAttribute("bankCode", vnp_BankCode);
                    request.setAttribute("orderInfo", vnp_OrderInfo);
                    
                } else {
                    paymentSuccess = false;
                    message = "Thanh toán thành công nhưng có lỗi cập nhật trạng thái đặt dịch vụ!";
                    request.setAttribute("paymentSuccess", false);
                    request.setAttribute("error", "Database update failed");
                }
                
            } else {
                // Payment failed
                paymentSuccess = false;
                serviceBookingDao.updateServiceBookingStatus(serviceBookingId, "Payment Failed");
                
                String errorReason = getErrorMessage(vnp_ResponseCode);
                message = "Thanh toán dịch vụ thất bại! " + errorReason;
                
                request.setAttribute("paymentSuccess", false);
                request.setAttribute("serviceBookingId", serviceBookingId);
                request.setAttribute("error", errorReason);
                request.setAttribute("responseCode", vnp_ResponseCode);
            }
            
        } catch (Exception e) {
            paymentSuccess = false;
            message = "Có lỗi xảy ra trong quá trình xử lý thanh toán: " + e.getMessage();
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("error", e.getMessage());
        }
        
        // Clean up session
        HttpSession session = request.getSession();
        session.removeAttribute("pendingServiceBookingId");
        
        // Set attributes for display
        request.setAttribute("message", message);
        request.setAttribute("isServicePayment", true);
        
        // Forward to payment result page
        request.getRequestDispatcher("service-payment-result.jsp").forward(request, response);
    }
    
    private String getErrorMessage(String responseCode) {
        switch (responseCode) {
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
            case "13":
                return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì.";
            case "79":
                return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định.";
            default:
                return "Giao dịch thất bại với mã lỗi: " + responseCode;
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