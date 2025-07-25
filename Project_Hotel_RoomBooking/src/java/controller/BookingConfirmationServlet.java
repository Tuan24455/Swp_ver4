package controller;

import dao.RoomDao;
import dao.PromotionDao;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Room;
import model.Promotion;
import model.User;

@WebServlet(name = "BookingConfirmationServlet", urlPatterns = {"/booking-confirmation"})
public class BookingConfirmationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp?redirect=room-detail&id=" + request.getParameter("roomId"));
            return;
        }
        
        try {
            System.out.println("=== BookingConfirmationServlet START ===");
            
            // Get form parameters
            String roomId = request.getParameter("roomId");
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            String maxGuests = request.getParameter("maxGuests");
            String floor = request.getParameter("floor");
            String pricePerNight = request.getParameter("pricePerNight");
            String imageUrl = request.getParameter("imageUrl");
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            String discountCode = request.getParameter("discountCodeSelected");
            
            System.out.println("BookingConfirmationServlet - Processing booking:");
            System.out.println("Room ID: " + roomId + ", Check-in: " + checkIn + ", Check-out: " + checkOut);
            System.out.println("Discount code: " + discountCode);
            System.out.println("Price per night: " + pricePerNight);
            System.out.println("User logged in: " + (user != null ? user.getFullName() : "null"));
            
            // Validate input
            if (roomId == null || checkIn == null || checkOut == null || pricePerNight == null) {
                response.sendRedirect("room-detail?id=" + roomId + "&error=missing_data");
                return;
            }
            
            // Parse and validate dates
            LocalDate checkInDate = LocalDate.parse(checkIn);
            LocalDate checkOutDate = LocalDate.parse(checkOut);
            
            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                response.sendRedirect("room-detail?id=" + roomId + "&error=invalid_dates");
                return;
            }
            
            // Remove backend room availability check as per new requirements
            // boolean isAvailable = checkRoomAvailabilityFromBookings(id, checkInDate, checkOutDate);
            // System.out.println("Room availability result: " + isAvailable);
            
            // if (!isAvailable) {
            //     System.out.println("Room not available, redirecting...");
            //     response.sendRedirect("room-detail?id=" + roomId + "&error=room_unavailable");
            //     return;
            // }
            
            // Get room details for display
            RoomDao roomDAO = new RoomDao();
            Room selectedRoom = roomDAO.getRoomById(Integer.parseInt(roomId));
            
            // Calculate pricing
            long nights = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            double price = Double.parseDouble(pricePerNight);
            double originalTotal = price * nights;
            double discountAmount = 0;
            double finalTotal = originalTotal;
            String discountTitle = "";
            double discountPercentage = 0;
            String discountDescription = "";
            
            // Apply discount if selected
            if (discountCode != null && !discountCode.trim().isEmpty()) {
                try {
                    PromotionDao promotionDao = new PromotionDao();
                    Promotion promotion = promotionDao.getPromotionByTitle(discountCode);
                    if (promotion != null) {
                        discountPercentage = promotion.getPercentage();
                        discountAmount = (originalTotal * discountPercentage) / 100;
                        finalTotal = originalTotal - discountAmount;
                        discountTitle = promotion.getTitle();
                        discountDescription = promotion.getDescription();
                        
                        System.out.println("Discount applied: " + discountTitle + " - " + discountPercentage + "%");
                    }
                } catch (Exception e) {
                    System.out.println("Error applying discount: " + e.getMessage());
                    // Continue without discount
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("user", user);
            request.setAttribute("selectedRoom", selectedRoom);
            request.setAttribute("roomId", roomId);
            request.setAttribute("roomNumber", roomNumber);
            request.setAttribute("roomType", roomType);
            request.setAttribute("maxGuests", maxGuests);
            request.setAttribute("floor", floor);
            request.setAttribute("pricePerNight", price);
            request.setAttribute("imageUrl", imageUrl);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("nights", nights);
            request.setAttribute("originalTotal", originalTotal);
            request.setAttribute("finalTotal", finalTotal);
            
            if (discountAmount > 0) {
                request.setAttribute("discountCode", discountTitle);
                request.setAttribute("discountPercentage", discountPercentage);
                request.setAttribute("discountAmount", discountAmount);
                request.setAttribute("discountDescription", discountDescription);
            }
              // Forward to confirmation page
            System.out.println("All data processed successfully, forwarding to confirmation page");
            request.getRequestDispatcher("bookingConfirmation.jsp").forward(request, response);
            System.out.println("=== BookingConfirmationServlet END ===");
            
        } catch (Exception e) {
            System.out.println("=== ERROR in BookingConfirmationServlet ===");
            System.out.println("Error message: " + e.getMessage());
            System.out.println("Error class: " + e.getClass().getName());
            e.printStackTrace();
            
            // Send detailed error to response for debugging
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><title>BookingConfirmationServlet Error</title></head><body>");
            response.getWriter().println("<h1>BookingConfirmationServlet Error</h1>");
            response.getWriter().println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            response.getWriter().println("<p><strong>Error Type:</strong> " + e.getClass().getName() + "</p>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/room-detail?id=" + request.getParameter("roomId") + "'>Back to Room Detail</a>");
            response.getWriter().println("</body></html>");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("home");
    }
}

// IMPORTANT: Do NOT update room_status in the Rooms table here.
// Room status changes (e.g., to 'Occupied') must only be done by admin/reception, not by booking or payment flow.
// This ensures that booking a room never changes its status in the Rooms table.