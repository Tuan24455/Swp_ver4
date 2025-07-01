package controller;

import dao.RoomDao;
import java.io.IOException;
import java.io.PrintWriter;
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
//        PrintWriter out = response.getWriter();
        String sid = request.getParameter("id");
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
