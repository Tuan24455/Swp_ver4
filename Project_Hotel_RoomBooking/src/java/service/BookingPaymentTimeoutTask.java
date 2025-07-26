package service;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * This class was previously used to automatically mark bookings as failed if payment was not completed within a timeout period.
 * It has been disabled as requested, and payment status updates are now handled exclusively by VNPayReturnServlet.
 */
public class BookingPaymentTimeoutTask {

    public static void start() {
        // Payment timeout functionality has been disabled.
        // Status updates are now handled exclusively by VNPayReturnServlet when users cancel payments
        System.out.println("BookingPaymentTimeoutTask is disabled - payment status updates now handled by VNPayReturnServlet");
    }

    // This method is kept for reference but is never called
    private static void markPaymentFail(Connection conn, int bookingId) throws SQLException {
        // This method is now disabled as payment failures are handled by VNPayReturnServlet
        System.out.println("BookingPaymentTimeoutTask.markPaymentFail is disabled - now handled by VNPayReturnServlet");
    }
}
