package controller.reception;

import com.google.gson.Gson;
import dao.DashboardReceptionDAO;
import model.Booking;
import util.JsonEscapeUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class DashboardReceptionServlet extends HttpServlet {

    private final DashboardReceptionDAO dao = new DashboardReceptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== DashboardReceptionServlet: doGet method started ===");
        
        try {
            // Set response content type
            response.setContentType("text/html;charset=UTF-8");
            
            Map<String, List<Booking>> roomBookings = dao.getAllRoomBookings();
            System.out.println("DashboardReceptionServlet: DAO returned roomBookings: " + 
                             (roomBookings != null ? roomBookings.size() + " rooms" : "null"));

            if (roomBookings == null || roomBookings.isEmpty()) {
                System.out.println("DashboardReceptionServlet: No room bookings data found from DAO.");
                request.setAttribute("errorMessage", "Không có dữ liệu đặt phòng để hiển thị.");
                request.setAttribute("roomBookings", new HashMap<String, List<Booking>>());
                request.setAttribute("roomBookingsJson", "{}");
            } else {
                System.out.println("DashboardReceptionServlet: Found " + roomBookings.size() + " rooms with bookings.");
                
                // Set roomBookings attribute
                request.setAttribute("roomBookings", roomBookings);
                System.out.println("DashboardReceptionServlet: Set roomBookings attribute");

                // Create and set JSON string
                String roomBookingsJson = new Gson().toJson(roomBookings);
                String escapedJson = JsonEscapeUtil.escapeJsonForJSP(roomBookingsJson);
                request.setAttribute("roomBookingsJson", escapedJson);
                System.out.println("DashboardReceptionServlet: Set roomBookingsJson attribute");
                System.out.println("DashboardReceptionServlet: Original JSON length: " + roomBookingsJson.length());
                System.out.println("DashboardReceptionServlet: Escaped JSON length: " + escapedJson.length());
                System.out.println("DashboardReceptionServlet: Original JSON first 200 chars: " + 
                                 roomBookingsJson.substring(0, Math.min(200, roomBookingsJson.length())));
                System.out.println("DashboardReceptionServlet: Escaped JSON first 200 chars: " + 
                                 escapedJson.substring(0, Math.min(200, escapedJson.length())));
            }

            System.out.println("DashboardReceptionServlet: About to forward to /reception/dashboard.jsp");
            
            // Check if we should use simple dashboard for debugging
            String debug = request.getParameter("debug");
            String targetJsp = "/reception/dashboard.jsp";
            if ("simple".equals(debug)) {
                targetJsp = "/reception/simple-dashboard.jsp";
                System.out.println("DashboardReceptionServlet: Using simple dashboard for debugging");
            }
            
            request.getRequestDispatcher(targetJsp).forward(request, response);
            System.out.println("DashboardReceptionServlet: Successfully forwarded to " + targetJsp);

        } catch (Exception e) {
            System.err.println("DashboardReceptionServlet: Exception occurred: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Lỗi tải dữ liệu từ DB: " + e.getMessage());
            request.setAttribute("roomBookings", new HashMap<String, List<Booking>>());
            request.setAttribute("roomBookingsJson", "{}");
            
            String debug = request.getParameter("debug");
            String targetJsp = "/reception/dashboard.jsp";
            if ("simple".equals(debug)) {
                targetJsp = "/reception/simple-dashboard.jsp";
            }
            
            request.getRequestDispatcher(targetJsp).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for reception dashboard: Loads booking data from DB and forwards to JSP";
    }
}