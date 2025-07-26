package controller;

import service.VNPayService;
import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet(name = "VNPayPaymentServlet", urlPatterns = {"/vnpay-payment"})
public class VNPayPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String type = request.getParameter("type");
            String idParam = request.getParameter("id");
            String amountParam = request.getParameter("amount");
            
            // Debug: Print all parameters
            System.out.println("=== VNPayPaymentServlet Debug ===");
            System.out.println("type: " + type);
            System.out.println("idParam: " + idParam);
            System.out.println("amountParam: " + amountParam);
            System.out.println("All parameters:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println("  " + key + " = " + String.join(", ", values));
            });
            System.out.println("================================");

            // Validate input parameters
            if (type == null || idParam == null || amountParam == null || type.isEmpty() || idParam.isEmpty() || amountParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing%20or%20invalid%20parameters");
                return;
            }

            // Clean amount parameter - remove commas and other formatting
            String cleanAmountParam = amountParam.replaceAll("[,\\s₫]", "");
            System.out.println("Original amount: " + amountParam);
            System.out.println("Cleaned amount: " + cleanAmountParam);

            int id = Integer.parseInt(idParam);
            
            // Handle decimal values by converting to double first, then to long
            double amountDouble = Double.parseDouble(cleanAmountParam);
            long amount = (long) amountDouble;
            
            System.out.println("Amount as double: " + amountDouble);
            System.out.println("Amount as long: " + amount);            // Handle payment logic based on type
            if ("service".equalsIgnoreCase(type)) {
                String paymentUrl = VNPayService.createServicePaymentUrl(request, id, amount, "Service Payment");
                response.sendRedirect(paymentUrl);
            } else if ("room".equalsIgnoreCase(type)) {
                // For room booking, create invoice immediately before payment processing
                String paymentMethod = request.getParameter("paymentMethod");
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");
                
                if (checkInStr == null || checkOutStr == null) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing%20booking%20dates");
                    return;
                }
                
                LocalDate checkInDate = LocalDate.parse(checkInStr);
                LocalDate checkOutDate = LocalDate.parse(checkOutStr);
                long nights = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
                
                // Create booking and invoice immediately - mark as "Pending Payment"
                int bookingId = createBookingInvoice(user.getId(), id, checkInDate, checkOutDate, 
                                                   (int)nights, amount, paymentMethod, "Pending Payment");
                
                if (bookingId == -1) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Failed%20to%20create%20booking");
                    return;
                }
                
                System.out.println("Created booking invoice with ID: " + bookingId);
                
                if ("cash".equalsIgnoreCase(paymentMethod)) {
                    // Handle cash payment - update status to completed
                    boolean success = updatePaymentStatus(bookingId, "Completed", "cash");
                    
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/payment-result.jsp?result=success&paymentMethod=cash&bookingId=" + bookingId);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Payment%20processing%20failed");
                    }
                } else {
                    // Store booking ID in session for VNPay callback
                    session.setAttribute("vnpay_booking_id", bookingId);
                    session.setAttribute("vnpay_booking_roomId", id);
                    session.setAttribute("vnpay_booking_amount", amount);
                    
                    System.out.println("Stored VNPay booking ID " + bookingId + " in session for callback");
                    
                    // Handle VNPay payment - redirect to VNPay
                    String paymentUrl = VNPayService.createPaymentUrl(request, bookingId, amount); // FIXED: use bookingId, not id (roomId)
                    response.sendRedirect(paymentUrl);
                }
            } else {
                // Default behavior for other types
                String paymentUrl = VNPayService.createPaymentUrl(request, id, amount);
                response.sendRedirect(paymentUrl);
            }
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Invalid%20number%20format:%20" + e.getMessage());
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }
      /*
     * DEPRECATED: Handle cash payment for room booking
     * This method is no longer used as we create invoice immediately in doPost()
     */
    private void handleCashPayment_DEPRECATED(HttpServletRequest request, HttpServletResponse response, int roomId, long amount) 
            throws ServletException, IOException {
        // This method is deprecated - invoice is now created immediately in doPost()
    }
    
    /**
     * Comprehensive database update for room booking payment
     * Updates three tables: Rooms, BookingRoomDetails, Transactions
     */
    private boolean updateDatabaseForPayment(int userId, int roomId, LocalDate checkInDate, LocalDate checkOutDate,
                                           int nights, long amount, String paymentMethod, String transactionStatus) {
        
        Connection conn = null;
        try {
            // Get database connection
            DBContext dbContext = new DBContext();
            conn = dbContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            System.out.println("=== Database Update Process ===");
            System.out.println("User ID: " + userId);
            System.out.println("Room ID: " + roomId);
            System.out.println("Check-in: " + checkInDate);
            System.out.println("Check-out: " + checkOutDate);
            System.out.println("Nights: " + nights);
            System.out.println("Amount: " + amount);
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Transaction Status: " + transactionStatus);
              // 1. Create Booking record first
            String sql = "INSERT INTO Bookings (user_id, created_at, status, total_prices, promotion_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, "Confirmed");
            ps.setDouble(4, amount);
            ps.setInt(5, 0);
            
            int bookingResult = ps.executeUpdate();
            int bookingId = -1;
            
            if (bookingResult > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    bookingId = rs.getInt(1);
                    System.out.println("Created booking with ID: " + bookingId);
                }
                rs.close();
            }
            ps.close();
            
            if (bookingId == -1) {
                throw new SQLException("Failed to create booking record");
            }              // IMPORTANT: We no longer update Room status here - room_status should only be changed by admin/reception
            // The commented code below is the previous implementation that updated room status, which we no longer want
            /*
            RoomDao roomDao = new RoomDao();
            Room room = roomDao.getRoomById(roomId);
            if (room != null) {
                String newRoomStatus = "Confirmed"; // Room is confirmed for booking
                room.setRoomStatus(newRoomStatus);
                
                sql = "UPDATE Rooms SET room_status = ? WHERE id = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, newRoomStatus);
                ps.setInt(2, roomId);
                
                int roomUpdateResult = ps.executeUpdate();
                ps.close();
                
                if (roomUpdateResult > 0) {
                    System.out.println("Updated room " + roomId + " status to: " + newRoomStatus);
                } else {
                    throw new SQLException("Failed to update room status");
                }
            }
            */
                
            // We only update the booking status, not the room status
            System.out.println("Booking created successfully, room status NOT changed as per requirements");
            
            // 3. Create BookingRoomDetails record
            sql = "INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date, quantity, prices) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            ps.setDate(3, java.sql.Date.valueOf(checkInDate));
            ps.setDate(4, java.sql.Date.valueOf(checkOutDate));
            ps.setInt(5, nights); // quantity = number of nights
            ps.setDouble(6, amount);
            
            int bookingDetailsResult = ps.executeUpdate();
            ps.close();
            
            if (bookingDetailsResult > 0) {
                System.out.println("Created BookingRoomDetails record for booking: " + bookingId);
            } else {
                throw new SQLException("Failed to create BookingRoomDetails record");
            }
            
            // 4. Create Transaction record
            sql = "INSERT INTO Transactions (booking_id, transaction_date, amount, payment_method, status) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setDouble(3, amount);
            ps.setString(4, paymentMethod);
            ps.setString(5, transactionStatus);
            
            int transactionResult = ps.executeUpdate();
            ps.close();
            
            if (transactionResult > 0) {
                System.out.println("Created Transaction record for booking: " + bookingId);
            } else {
                throw new SQLException("Failed to create Transaction record");
            }
            
            // Commit transaction if all operations successful
            conn.commit();
            System.out.println("=== Database Update Completed Successfully ===");
            return true;
            
        } catch (SQLException e) {
            System.out.println("Database error during payment processing: " + e.getMessage());
            e.printStackTrace();
            
            // Rollback transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back");
                } catch (SQLException rollbackEx) {
                    System.out.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            return false;
            
        } catch (Exception e) {
            System.out.println("General error during payment processing: " + e.getMessage());
            e.printStackTrace();
            return false;
            
        } finally {
            // Restore auto-commit and close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Create booking and invoice immediately when user clicks payment
     * This creates the invoice with "Pending Payment" status
     */    private int createBookingInvoice(int userId, int roomId, LocalDate checkInDate, LocalDate checkOutDate,
                                   int nights, long amount, String paymentMethod, String initialStatus) {
        
        Connection conn = null;
        try {
            System.out.println("=== Creating Booking Invoice - START ===");
            System.out.println("User ID: " + userId);
            System.out.println("Room ID: " + roomId);
            System.out.println("Check-in: " + checkInDate);
            System.out.println("Check-out: " + checkOutDate);
            System.out.println("Nights: " + nights);
            System.out.println("Amount: " + amount);
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Initial Status: " + initialStatus);
            
            // Get database connection
            System.out.println("Getting database connection...");
            DBContext dbContext = new DBContext();
            conn = dbContext.getConnection();
            
            if (conn == null) {
                System.out.println("ERROR: Database connection is null!");
                return -1;
            }
            
            System.out.println("Database connection successful. Setting autocommit to false...");
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Create Booking record first
            String sql = "INSERT INTO Bookings (user_id, created_at, status, total_prices, promotion_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, initialStatus); // "Pending Payment" initially
            ps.setDouble(4, amount);
            // Nếu không có promotion, setNull thay vì 0
            ps.setNull(5, java.sql.Types.INTEGER);
            
            int bookingResult = ps.executeUpdate();
            int bookingId = -1;
            
            if (bookingResult > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    bookingId = rs.getInt(1);
                    System.out.println("Created booking with ID: " + bookingId);
                }
                rs.close();
            }
            ps.close();
            
            if (bookingId == -1) {
                throw new SQLException("Failed to create booking record");
            }
              // 2. IMPORTANT: We no longer update Room status here - room_status should only be changed by admin/reception
            // The commented code below is the previous implementation that updated room status, which we no longer want
            /*
            sql = "UPDATE Rooms SET room_status = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "Pending Payment");
            ps.setInt(2, roomId);
            
            int roomUpdateResult = ps.executeUpdate();
            ps.close();
            
            if (roomUpdateResult > 0) {
                System.out.println("Updated room " + roomId + " status to: Pending Payment");
            } else {
                throw new SQLException("Failed to update room status");
            }
            */
            
            System.out.println("Booking created, room status NOT changed as per requirements");
            
            // 3. Create BookingRoomDetails record
            sql = "INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date, quantity, prices) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            ps.setDate(3, java.sql.Date.valueOf(checkInDate));
            ps.setDate(4, java.sql.Date.valueOf(checkOutDate));
            ps.setInt(5, nights);
            ps.setDouble(6, amount);
            
            int bookingDetailsResult = ps.executeUpdate();
            ps.close();
            
            if (bookingDetailsResult > 0) {
                System.out.println("Created BookingRoomDetails record for booking: " + bookingId);
            } else {
                throw new SQLException("Failed to create BookingRoomDetails record");
            }
            
            // 4. Create Transaction record with initial status
            sql = "INSERT INTO Transactions (booking_id, transaction_date, amount, payment_method, status) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setDouble(3, amount);
            ps.setString(4, paymentMethod);
            ps.setString(5, initialStatus); // "Pending Payment" initially
            
            int transactionResult = ps.executeUpdate();
            ps.close();
            
            if (transactionResult > 0) {
                System.out.println("Created Transaction record for booking: " + bookingId);
            } else {
                throw new SQLException("Failed to create Transaction record");
            }
            
            // Commit transaction if all operations successful
            conn.commit();
            System.out.println("=== Booking Invoice Created Successfully ===");
            return bookingId;
            
        } catch (SQLException e) {
            System.out.println("Database error during booking invoice creation: " + e.getMessage());
            e.printStackTrace();
            
            // Rollback transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back");
                } catch (SQLException rollbackEx) {
                    System.out.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            return -1;
            
        } catch (Exception e) {
            System.out.println("General error during booking invoice creation: " + e.getMessage());
            e.printStackTrace();
            return -1;
            
        } finally {
            // Restore auto-commit and close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Update payment status after successful payment
     */
    private boolean updatePaymentStatus(int bookingId, String newStatus, String paymentMethod) {
        Connection conn = null;
        try {
            DBContext dbContext = new DBContext();
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);
            
            System.out.println("=== Updating Payment Status ===");
            System.out.println("Booking ID: " + bookingId);
            System.out.println("New Status: " + newStatus);
            System.out.println("Payment Method: " + paymentMethod);
            
            // 1. Update Booking status
            String sql = "UPDATE Bookings SET status = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            
            int bookingUpdateResult = ps.executeUpdate();
            ps.close();
            
            if (bookingUpdateResult == 0) {
                throw new SQLException("Failed to update booking status");
            }
            
            // 2. Update Transaction status
            sql = "UPDATE Transactions SET status = ? WHERE booking_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            
            int transactionUpdateResult = ps.executeUpdate();
            ps.close();
            
            if (transactionUpdateResult == 0) {
                throw new SQLException("Failed to update transaction status");
            }
              // 3. IMPORTANT: We no longer update Room status here - room_status should only be changed by admin/reception
            // The commented code below is the previous implementation that updated room status, which we no longer want
            /*
            if ("Confirmed".equals(newStatus) || "Completed".equals(newStatus)) {
                // Get room ID from BookingRoomDetails
                sql = "SELECT room_id FROM BookingRoomDetails WHERE booking_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, bookingId);
                ResultSet rs = ps.executeQuery();
                int roomId = -1;
                if (rs.next()) {
                    roomId = rs.getInt("room_id");
                }
                rs.close();
                ps.close();
                if (roomId != -1) {
                    sql = "UPDATE Rooms SET room_status = 'Occupied' WHERE id = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, roomId);
                    int roomUpdateResult = ps.executeUpdate();
                    ps.close();
                    if (roomUpdateResult > 0) {
                        System.out.println("Updated room " + roomId + " status to: Occupied");
                    }
                }
            }
            */
            
            // Only admin/reception should update room status
            System.out.println("Payment status updated, room status NOT changed as per requirements");
            
            conn.commit();
            System.out.println("=== Payment Status Updated Successfully ===");
            return true;
            
        } catch (SQLException e) {
            System.out.println("Database error during payment status update: " + e.getMessage());
            e.printStackTrace();
            
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back");
                } catch (SQLException rollbackEx) {
                    System.out.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            return false;
            
        } catch (Exception e) {
            System.out.println("General error during payment status update: " + e.getMessage());
            e.printStackTrace();
            return false;
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Handle VNPay payment callback (for GET requests from VNPay)
     * This method should be called when VNPay redirects back to the application
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get VNPay response parameters
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");
            String vnpTransactionStatus = request.getParameter("vnp_TransactionStatus");
            String vnpTxnRef = request.getParameter("vnp_TxnRef");
            String vnpAmount = request.getParameter("vnp_Amount");
            
            System.out.println("=== VNPay Payment Callback ===");
            System.out.println("Response Code: " + vnpResponseCode);
            System.out.println("Transaction Status: " + vnpTransactionStatus);
            System.out.println("Transaction Ref: " + vnpTxnRef);
            System.out.println("Amount: " + vnpAmount);
            
            // Check if payment was successful
            if ("00".equals(vnpResponseCode) && "00".equals(vnpTransactionStatus)) {
                // Payment successful - update database
                handleSuccessfulVNPayPayment(request, response);
            } else {
                // Payment failed or user cancelled - update status to Cancelled
                HttpSession session = request.getSession();
                Integer bookingId = (Integer) session.getAttribute("vnpay_booking_id");
                if (bookingId != null) {
                    updatePaymentStatus(bookingId, "Cancelled", "vnpay");
                    // Clean up session attributes
                    session.removeAttribute("vnpay_booking_id");
                    session.removeAttribute("vnpay_booking_roomId");
                    session.removeAttribute("vnpay_booking_amount");
                }
                response.sendRedirect(request.getContextPath() + "/home?message=Thanh+to%C3%A1n+%C4%91%E1%BA%B7t+ph%C3%B2ng+th%E1%BA%A5t+b%E1%BA%A1i%21&status=error");
            }
            
        } catch (Exception e) {
            System.out.println("VNPay callback error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Payment%20callback%20error");
        }
    }    /**
     * Handle successful VNPay payment - update database
     */
    private void handleSuccessfulVNPayPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Retrieve booking ID from session (stored before VNPay redirect)
            Integer bookingId = (Integer) session.getAttribute("vnpay_booking_id");
            Long amount = (Long) session.getAttribute("vnpay_booking_amount");
            
            System.out.println("Retrieved VNPay booking ID from session: " + bookingId);
            System.out.println("Amount: " + amount);
            
            // Validate retrieved data
            if (bookingId == null || amount == null) {
                System.out.println("Missing booking ID or amount in session for VNPay callback");
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing%20booking%20information");
                return;
            }
            
            // Update payment status to completed for successful VNPay payment
            boolean success = updatePaymentStatus(bookingId, "Completed", "vnpay");
            
            // Clean up session attributes
            session.removeAttribute("vnpay_booking_id");
            session.removeAttribute("vnpay_booking_roomId");
            session.removeAttribute("vnpay_booking_amount");
            
            if (success) {
                // Redirect to payment success page
                response.sendRedirect(request.getContextPath() + "/payment-result.jsp?result=success&paymentMethod=vnpay&amount=" + amount + "&bookingId=" + bookingId);
            } else {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Payment%20processing%20failed");
            }
            
        } catch (Exception e) {
            System.out.println("VNPay success handler error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Payment%20processing%20error");
        }
    }

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            service.BookingPaymentTimeoutTask.start();
            System.out.println("[BookingPaymentTimeoutTask] Scheduled task started.");
        } catch (Exception e) {
            System.out.println("[BookingPaymentTimeoutTask] Failed to start: " + e.getMessage());
        }
    }
}
