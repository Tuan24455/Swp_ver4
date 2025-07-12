package controller;

import dao.ServiceDao;
import dao.ReviewDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
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
        // Lấy tham số id của dịch vụ từ URL
        String sid = request.getParameter("id");
        if (sid == null || sid.trim().isEmpty()) {
            // Nếu không có id, chuyển hướng về trang danh sách dịch vụ
            response.sendRedirect("service");
            return;
        }
        
        try {
            // Chuyển đổi id sang kiểu số nguyên
            int id = Integer.parseInt(sid);
            ServiceDao dao = new ServiceDao();
            // Lấy thông tin dịch vụ theo id
            Service service = dao.getServiceById(id);
            if (service == null) {
                // Nếu không tìm thấy dịch vụ, chuyển hướng về trang danh sách
                response.sendRedirect("service");
                return;
            }
            
            // Lấy đánh giá của dịch vụ
            ReviewDao reviewDao = new ReviewDao();
            List<ServiceReview> reviews = reviewDao.getServiceReviewsByServiceId(id);
            
            // Lấy các dịch vụ cùng loại để hiển thị liên quan
            List<Integer> typeIds = new ArrayList<>();
            typeIds.add(service.getTypeId());
            List<Service> allSameType = dao.filterServices(typeIds, null, null);
            
            // Loại bỏ dịch vụ hiện tại và giới hạn trong 6 dịch vụ liên quan
            List<Service> related = new ArrayList<>();
            for (Service s : allSameType) {
                if (s.getId() != id && related.size() < 6) {
                    related.add(s);
                }
            }
            
            // Đặt dữ liệu vào request để hiển thị trong JSP
            request.setAttribute("service", service);
            request.setAttribute("reviews", reviews);
            request.setAttribute("relatedServices", related);
            // Chuyển đến trang hiển thị chi tiết dịch vụ
            request.getRequestDispatcher("serviceDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Nếu id không hợp lệ, chuyển hướng về trang danh sách
            response.sendRedirect("service");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý đặt dịch vụ
        String serviceId = request.getParameter("serviceId");
        String bookingDate = request.getParameter("bookingDate");
        String quantity = request.getParameter("quantity");
        String note = request.getParameter("note");
        
        // TODO: Thêm logic đặt dịch vụ ở đây
        // Hiện tại, chỉ chuyển hướng trở lại trang chi tiết dịch vụ
        response.sendRedirect("serviceDetail?id=" + serviceId);
    }
}