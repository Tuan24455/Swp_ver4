package controller.admin;

import dao.DashboardAdminDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "Dashboard", urlPatterns = {"/admin/dashboard"})
public class Dashboard extends HttpServlet {

        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardAdminDAO dao = new DashboardAdminDAO();

        // Get data from DAO
        String totalRevenue = dao.getTotalRevenue();
        Map<String, Integer> roomStatusCounts = dao.getRoomStatusCounts();
        int totalRooms = dao.getTotalRooms();
        double avgRoomRating = dao.getAverageRoomRating();
        double avgServiceRating = dao.getAverageServiceRating();
        List<Map<String, Object>> recentBookings = dao.getRecentBookings(5); // Get top 5 recent bookings

        // Set attributes for JSP
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("roomStatusCounts", roomStatusCounts);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("avgRoomRating", avgRoomRating);
        request.setAttribute("avgServiceRating", avgServiceRating);
        request.setAttribute("recentBookings", recentBookings);

        // Forward to JSP
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}