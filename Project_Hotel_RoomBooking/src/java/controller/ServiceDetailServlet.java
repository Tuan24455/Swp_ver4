package controller;

import dao.ServiceDao;
import dao.ReviewDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Service;
import model.ServiceReview;

/**
 * Servlet kiểm soát trang chi tiết dịch vụ.
 */
@WebServlet(name = "ServiceDetailServlet", urlPatterns = {"/serviceDetail"})
public class ServiceDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sid = request.getParameter("id");
        if (sid == null || sid.trim().isEmpty()) {
            response.sendRedirect("service");
            return;
        }

        try {
            int id = Integer.parseInt(sid);
            ServiceDao dao = new ServiceDao();
            Service service = dao.getServiceById(id);
            if (service == null) {
                response.sendRedirect("service");
                return;
            }
            List<Service> related = dao.getRelatedServices(service.getServiceTypeId(), id, 6);

            // Lấy danh sách review cho dịch vụ này
            ReviewDao reviewDao = new ReviewDao();
            List<ServiceReview> reviews = reviewDao.getServiceReviewsByServiceId(id);

            request.setAttribute("service", service);
            request.setAttribute("relatedServices", related);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("serviceDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("service");
        }
    }
}
