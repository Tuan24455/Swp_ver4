package controller;

import dao.RoomDao;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

@WebServlet(name = "CheckRoomAvailabilityServlet", urlPatterns = {"/check-availability"})
public class CheckRoomAvailabilityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomId = request.getParameter("roomId");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        
        // Get all other parameters to forward
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        String maxGuests = request.getParameter("maxGuests");
        String floor = request.getParameter("floor");
        String pricePerNight = request.getParameter("pricePerNight");
        String imageUrl = request.getParameter("imageUrl");

        try {
            int id = Integer.parseInt(roomId);
            Date checkInDate = Date.valueOf(checkIn);
            Date checkOutDate = Date.valueOf(checkOut);

            RoomDao roomDAO = new RoomDao();
            List<Room> availableRooms = roomDAO.filterRoomsAdvanced(null, null, null, null, null, checkInDate, checkOutDate);

            boolean isAvailable = false;
            for (Room room : availableRooms) {
                if (room.getId() == id) {
                    isAvailable = true;
                    break;
                }
            }

            if (isAvailable) {
                // Forward to booking detail page with all parameters
                response.sendRedirect(request.getContextPath() + "/customer/bookingDetail.jsp"
                    + "?roomId=" + roomId
                    + "&roomNumber=" + roomNumber
                    + "&roomType=" + roomType
                    + "&maxGuests=" + maxGuests
                    + "&floor=" + floor
                    + "&pricePerNight=" + pricePerNight
                    + "&imageUrl=" + imageUrl
                    + "&checkIn=" + checkIn
                    + "&checkOut=" + checkOut);
            } else {
                // Redirect back to room detail with error message
                response.sendRedirect(request.getContextPath() + "/room-detail?id=" + roomId 
                    + "&checkIn=" + checkIn 
                    + "&checkOut=" + checkOut 
                    + "&error=unavailable");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/room-detail?id=" + roomId + "&error=invalid");
        }
    }
}
