package controller.reception;

import dao.ServiceDao;
import dao.ServiceBookingDao;
import model.Service;
import model.ServiceBooking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reception/serviceManagement")
public class ReceptionServiceManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is reception staff
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if (!"Reception".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Initialize DAOs
            ServiceDao serviceDao = new ServiceDao();
            ServiceBookingDao serviceBookingDao = new ServiceBookingDao();
            
            // Get pagination parameters for services
            int servicePage = 1;
            int servicePageSize = 5; // 5 services per page
            
            try {
                String pageParam = request.getParameter("servicePage");
                if (pageParam != null && !pageParam.isEmpty()) {
                    servicePage = Integer.parseInt(pageParam);
                    if (servicePage < 1) servicePage = 1;
                }
            } catch (NumberFormatException e) {
                servicePage = 1;
            }
            
            // Get paginated services
            System.out.println("Loading services for page " + servicePage + "...");
            List<Service> allServices = serviceDao.getAllServices();
            
            // Calculate pagination for services
            int totalServices = allServices != null ? allServices.size() : 0;
            int totalServicePages = (int) Math.ceil((double) totalServices / servicePageSize);
            
            // Get services for current page
            List<Service> pagedServices = new ArrayList<>();
            if (allServices != null && !allServices.isEmpty()) {
                int startIndex = (servicePage - 1) * servicePageSize;
                int endIndex = Math.min(startIndex + servicePageSize, totalServices);
                if (startIndex < totalServices) {
                    pagedServices = allServices.subList(startIndex, endIndex);
                }
            }
            
            System.out.println("Found " + totalServices + " total services, showing " + pagedServices.size() + " on page " + servicePage);
            request.setAttribute("allServices", pagedServices);
            request.setAttribute("currentServicePage", servicePage);
            request.setAttribute("totalServicePages", totalServicePages);
            request.setAttribute("totalServices", totalServices);
            
            // Get all service bookings with customer info
            System.out.println("Loading service bookings...");
            List<ServiceBooking> allServiceBookings = serviceBookingDao.getAllServiceBookings(1, 50); // Get first 50 bookings
            System.out.println("Found " + (allServiceBookings != null ? allServiceBookings.size() : 0) + " service bookings");
            request.setAttribute("allServiceBookings", allServiceBookings);
            
            // Forward to JSP
            System.out.println("Forwarding to JSP...");
            request.getRequestDispatcher("/reception/serviceManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ReceptionServiceManagementServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading service management data: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 