package controller;

import dao.ServiceDao;
import service.VNPayService;
import model.Service;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "BookServiceServlet", urlPatterns = {"/bookService"})
public class BookServiceServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get form parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String note = request.getParameter("note");
            
            // Get service details to calculate total cost
            ServiceDao serviceDao = new ServiceDao();
            Service service = serviceDao.getServiceById(serviceId);
            
            if (service == null) {
                response.sendRedirect("error.jsp?message=Service not found");
                return;
            }
            
            // Calculate total cost
            double totalCost = service.getPrice() * quantity;
            
            // Set attributes for the payment page
            request.setAttribute("service", service);
            request.setAttribute("bookingDate", bookingDate);
            request.setAttribute("quantity", quantity);
            request.setAttribute("note", note);
            request.setAttribute("totalCost", totalCost);
            request.setAttribute("user", user);
            
            // Forward to service booking payment page
            request.getRequestDispatcher("serviceBookingPayment.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to service list
        response.sendRedirect("service");
    }
}
