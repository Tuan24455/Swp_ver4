package controller.admin;

import dao.DashboardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet hiển thị trang Dashboard Admin với KPI động.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            double totalRevenue = dashboardDao.getTotalRevenue();
            int[] occ = dashboardDao.getRoomOccupancy();
            int occupiedRooms = occ[0];
            int totalRooms = occ[1];
            int todayBookings = dashboardDao.getTodayBookings();
            int totalUsers = dashboardDao.getTotalUsers();

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("todayBookings", todayBookings);
            request.setAttribute("totalUsers", totalUsers);

        } catch (Exception e) {
            // Nếu có lỗi, đặt giá trị mặc định để trang vẫn render
            request.setAttribute("totalRevenue", 0);
            request.setAttribute("occupiedRooms", 0);
            request.setAttribute("totalRooms", 0);
            request.setAttribute("todayBookings", 0);
            request.setAttribute("totalUsers", 0);
        }
        // Chuyển tới JSP
        request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
