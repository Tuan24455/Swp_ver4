package controller;

import dal.DBContext;
import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import service.VNPayService;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    private BookingDao bookingDao;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDao = new BookingDao();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        // Use static method for validation
        boolean validPayment = VNPayService.validatePaymentResponse(request.getParameterMap());
        boolean paymentSuccess = false;
        String message = "";
        String[] parts = vnp_TxnRef.split("_");
        int bookingId = -1;
        // Robustly extract bookingId
        try {
            if (parts[0].equals("SVC")) {
                // Service booking, not room booking
            } else if (parts[0].matches("\\d+")) {
                bookingId = Integer.parseInt(parts[0]);
            } else if (parts.length > 1 && parts[1].matches("\\d+")) {
                bookingId = Integer.parseInt(parts[1]);
            }
        } catch (Exception e) {
            System.out.println("Error parsing bookingId from vnp_TxnRef: " + vnp_TxnRef);
        }
        // Fallback: try session
        if (bookingId == -1) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("vnpay_booking_id") != null) {
                try {
                    bookingId = (Integer) session.getAttribute("vnpay_booking_id");
                } catch (Exception e) {
                    System.out.println("Error getting bookingId from session: " + e.getMessage());
                }
            }
        }
        System.out.println("VNPay Return - Booking ID: " + bookingId);
        // Log payment information for debugging
        System.out.println("VNPay Return - Response Code: " + vnp_ResponseCode);
        System.out.println("VNPay Return - Transaction Reference: " + vnp_TxnRef);
        System.out.println("VNPay Return - Valid Payment: " + validPayment);
        
        if (validPayment && "00".equals(vnp_ResponseCode)) {
            // Payment successful
            paymentSuccess = true;
            
            // Check if this is a service booking
            if (parts[0].equals("SVC")) {
                // Handle service booking payment - no longer updating service status
                message = "Thanh toán dịch vụ thành công!";
            } else if (bookingId != -1) {
                boolean updateResult = bookingDao.updateBookingStatus(bookingId, "Confirmed");
                System.out.println("Update booking status to Confirmed: " + updateResult);
                try (Connection conn = new DBContext().getConnection()) {
                    String updateTrans = "UPDATE Transactions SET status = 'Confirmed' WHERE booking_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateTrans)) {
                        ps.setInt(1, bookingId);
                        ps.executeUpdate();
                    }
                    System.out.println("Updated transaction status to 'Confirmed' for booking #" + bookingId);
                } catch (SQLException e) {
                    System.out.println("Error updating transaction status: " + e.getMessage());
                }
                message = "Thanh toán đặt phòng thành công!";
            }
        } else {
            // Payment failed or was cancelled by the user
            paymentSuccess = false;
            
            // Handle different VNPay response codes
            String statusReason = "Payment Failed";
            if ("24".equals(vnp_ResponseCode)) {
                message = "Thanh toán đã bị hủy bởi người dùng!";
                statusReason = "Cancelled";
            } else {
                message = "Thanh toán thất bại!";
            }
            
            if (parts[0].equals("SVC")) {
                // Handle service booking payment failure - no longer updating service status
                message = "Thanh toán dịch vụ " + (statusReason.equals("Cancelled") ? "đã bị hủy!" : "thất bại!");
            } else if (bookingId != -1) {
                // Cập nhật trực tiếp vào database (không dùng BookingDao)
                try (Connection conn = new DBContext().getConnection()) {
                    String updateBooking = "UPDATE Bookings SET status = ? WHERE id = ?";
                    int affectedRows = 0;
                    try (PreparedStatement ps = conn.prepareStatement(updateBooking)) {
                        ps.setString(1, "Payment Failed");
                        ps.setInt(2, bookingId);
                        affectedRows = ps.executeUpdate();
                    }
                    if (affectedRows == 0) {
                        System.out.println("[VNPayReturnServlet] WARNING: No booking row updated for id=" + bookingId);
                    } else {
                        System.out.println("Directly updated booking status to 'Payment Failed' for booking #" + bookingId);
                    }
                    // Cập nhật transaction
                    String updateTrans = "UPDATE Transactions SET status = ? WHERE booking_id = ?";
                    int affectedTrans = 0;
                    try (PreparedStatement ps = conn.prepareStatement(updateTrans)) {
                        ps.setString(1, "Payment Failed");
                        ps.setInt(2, bookingId);
                        affectedTrans = ps.executeUpdate();
                    }
                    if (affectedTrans == 0) {
                        System.out.println("[VNPayReturnServlet] WARNING: No transaction row updated for booking_id=" + bookingId);
                    } else {
                        System.out.println("Updated transaction status to 'Payment Failed' for booking #" + bookingId);
                    }
                } catch (SQLException e) {
                    System.out.println("Error updating booking or transaction status: " + e.getMessage());
                }
                message = "Thanh toán đặt phòng thất bại!";
            }
        }        // Clean up session
        HttpSession session = request.getSession();
        session.removeAttribute("pendingServiceBookingId");
        
        // Set message attributes for next page
        session.setAttribute("message", message);
        session.setAttribute("messageType", paymentSuccess ? "success" : "danger");
        
        // Redirect based on payment type
        if (parts[0].equals("SVC")) {
            // For service payments, redirect to service-payment-result
            response.sendRedirect(request.getContextPath() + "/service-payment-result");
        } else if ("24".equals(vnp_ResponseCode)) {
            // Nếu là hủy thanh toán bởi người dùng, chuyển hướng đến trang thông báo hủy
            request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
            request.getRequestDispatcher("/payment-cancelled.jsp").forward(request, response);
        } else {
            // For room bookings, redirect to booking history (thanh toán thất bại)
            response.sendRedirect(request.getContextPath() + "/bookingHistory");
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
