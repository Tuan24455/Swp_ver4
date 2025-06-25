package controller;

import dao.RoomDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

@WebServlet(name = "RoomDetailServlet", urlPatterns = {"/room-detail"})
public class RoomDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get room ID from request parameter
            String roomId = request.getParameter("id");
            if (roomId == null || roomId.trim().isEmpty()) {
                response.sendRedirect("home");
                return;
            }

            RoomDao roomDAO = new RoomDao();
            Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
            
            if (room == null) {
                response.sendRedirect("home");
                return;
            }

            request.setAttribute("room", room);
            request.getRequestDispatcher("/customer/room-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
