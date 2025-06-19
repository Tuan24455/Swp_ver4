package controller.customer;

import dao.ServiceDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Service;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/service"})
public class ServiceServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9; // mỗi trang hiển thị 9 dịch vụ

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ServiceDao serviceDao = new ServiceDao();
        List<Service> allServices = serviceDao.getAllServices();

        // Phân trang
        int totalItems = allServices.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        int currentPage = 1;

        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) currentPage = 1;
                if (currentPage > totalPages) currentPage = totalPages;
            }
        } catch (NumberFormatException ignored) {}

        int start = (currentPage - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalItems);
        List<Service> pagedList = allServices.subList(start, end);

        // Truyền dữ liệu sang JSP
        request.setAttribute("serviceList", pagedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("service.jsp").forward(request, response);
    }
}
