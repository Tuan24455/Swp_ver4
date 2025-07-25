package controller;

import dao.RoomDao;
import dao.PromotionDao;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;
import model.Promotion;

@WebServlet(name = "RoomDetailServlet", urlPatterns = {"/room-detail"})
public class RoomDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sid = request.getParameter("id");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        if (sid == null || sid.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int id = Integer.parseInt(sid);
            RoomDao roomDAO = new RoomDao();
            Room room = roomDAO.getRoomById(id);

            if (room == null) {
                response.sendRedirect("error.jsp?message=Room not found");
                return;
            }

            // Set room as available by default when no dates are selected
            boolean isRoomAvailable = true;
            
            // Only check availability if dates are provided
            if (checkIn != null && !checkIn.isEmpty() && checkOut != null && !checkOut.isEmpty()) {
                try {
                    java.sql.Date checkInDate = java.sql.Date.valueOf(checkIn);
                    java.sql.Date checkOutDate = java.sql.Date.valueOf(checkOut);

                    // Get available rooms for the selected dates
                    java.util.List<Room> availableRooms = roomDAO.filterRoomsAdvanced(null, null, null, null, null, checkInDate, checkOutDate);
                    
                    // Check if the current room is in the available rooms list
                    isRoomAvailable = false; // Reset to false when checking dates
                    for (Room availableRoom : availableRooms) {
                        if (availableRoom.getId() == id) {
                            isRoomAvailable = true;
                            break;
                        }
                    }
                    
                    request.setAttribute("checkIn", checkIn);
                    request.setAttribute("checkOut", checkOut);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", "Invalid date format");
                }
            }
            
            request.setAttribute("isRoomAvailable", isRoomAvailable);

            // Load active promotions from database
            PromotionDao promotionDao = new PromotionDao();
            List<Promotion> activePromotions = promotionDao.getActivePromotions();
            System.out.println("DEBUG: Number of active promotions found: " + activePromotions.size());
            for (Promotion p : activePromotions) {
                System.out.println("DEBUG: Promotion - " + p.getTitle() + " - " + p.getPercentage() + "%");
            }
            request.setAttribute("activePromotions", activePromotions);

            request.setAttribute("room", room);
            request.getRequestDispatcher("room-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?message=Invalid room ID");
            return;
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle booking form submission here
        String roomId = request.getParameter("roomId");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        // TODO: Add booking logic here
        // For now, redirect back to the room detail page
        response.sendRedirect("room-detail?id=" + roomId);
    }
}
