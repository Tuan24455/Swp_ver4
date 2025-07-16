package controller;

import dao.ServiceDao;
import dao.ReviewDao;
import model.Service;
import model.ServiceReview;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ServiceDetailServlet", urlPatterns = {"/serviceDetail"})
public class ServiceDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy service ID từ parameter - kiểm tra cả "serviceId" và "id"
            String serviceIdParam = request.getParameter("serviceId");
            if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
                serviceIdParam = request.getParameter("id");
            }
            
            if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
                response.sendRedirect("service?error=missing_service_id");
                return;
            }
            
            int serviceId = Integer.parseInt(serviceIdParam);
            
            // Khởi tạo DAO
            ServiceDao serviceDao = new ServiceDao();
            ReviewDao reviewDao = new ReviewDao();
            
            // Lấy thông tin chi tiết dịch vụ
            Service service = serviceDao.getServiceById(serviceId);
            
            if (service == null) {
                response.sendRedirect("service?error=service_not_found");
                return;
            }
            
            // Lấy danh sách đánh giá cho dịch vụ này
            List<ServiceReview> reviews = reviewDao.getServiceReviewsByServiceId(serviceId);
            
            // Lấy danh sách dịch vụ cùng loại (để hiển thị dịch vụ tương tự)
            List<Service> relatedServices = serviceDao.getServicesByType(service.getTypeId(), serviceId, 6);
            
            // Tính toán thống kê đánh giá
            double averageRating = 0.0;
            int totalReviews = reviews.size();
            
            if (totalReviews > 0) {
                double sum = 0;
                for (ServiceReview review : reviews) {
                    sum += review.getQuality();
                }
                averageRating = sum / totalReviews;
                averageRating = Math.round(averageRating * 10.0) / 10.0; // Làm tròn 1 chữ số thập phân
            }
            
            // Set attributes cho JSP
            request.setAttribute("service", service);
            request.setAttribute("reviews", reviews);
            request.setAttribute("relatedServices", relatedServices);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalReviews", totalReviews);
            
            // Forward đến JSP
            request.getRequestDispatcher("serviceDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Service ID không hợp lệ
            response.sendRedirect("service?error=invalid_service_id");
        } catch (Exception e) {
            // Lỗi khác
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Đã xảy ra lỗi khi tải chi tiết dịch vụ: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng POST requests thành GET requests
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ServiceDetailServlet - Hiển thị chi tiết dịch vụ";
    }
}