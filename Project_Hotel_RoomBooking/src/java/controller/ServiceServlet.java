package controller;

import dao.ServiceDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
                if (currentPage < 1) {
                    currentPage = 1;
                }
                if (currentPage > totalPages) {
                    currentPage = totalPages;
                }
            }
        } catch (NumberFormatException ignored) {
        }

        int start = (currentPage - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalItems);
        List<Service> pagedList = allServices.subList(start, end);
        Map<Integer, String> serviceTypes = serviceDao.getDistinctServiceTypes();

        // Truyền dữ liệu sang JSP
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("serviceList", pagedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("service.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ServiceDao serviceDao = new ServiceDao();

        // 1. Lấy các tham số lọc
        String[] typeIdParams = request.getParameterValues("typeId");
        String priceFromStr = request.getParameter("priceFrom");
        String priceToStr = request.getParameter("priceTo");

        // 2. Chuyển đổi dữ liệu
        List<Integer> selectedTypes = new ArrayList<>();
        if (typeIdParams != null) {
            for (String idStr : typeIdParams) {
                try {
                    selectedTypes.add(Integer.valueOf(idStr));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        Double priceFrom = null;
        Double priceTo = null;
        try {
            if (priceFromStr != null && !priceFromStr.isEmpty()) {
                priceFrom = Double.valueOf(priceFromStr);
            }
            if (priceToStr != null && !priceToStr.isEmpty()) {
                priceTo = Double.valueOf(priceToStr);
            }
        } catch (NumberFormatException ignored) {
        }

        // 3. Lọc dịch vụ
        List<Service> filteredServices = serviceDao.filterServices(selectedTypes, priceFrom, priceTo);

        // 4. Lấy danh sách tất cả loại dịch vụ (Map<Integer, String>)
        Map<Integer, String> serviceTypes = serviceDao.getDistinctServiceTypes();

        // 5. Gửi dữ liệu sang JSP
        request.setAttribute("serviceList", filteredServices);
        request.setAttribute("selectedTypes", selectedTypes);
        request.setAttribute("serviceTypes", serviceTypes);

        request.getRequestDispatcher("service.jsp").forward(request, response);
    }

}
