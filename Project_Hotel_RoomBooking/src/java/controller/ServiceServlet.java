package controller;

import dao.PromotionDao;
import dao.ServiceDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import model.Promotion;
import model.Service;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/service"})
public class ServiceServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9; // mỗi trang hiển thị 9 dịch vụ

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response, false);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response, true);
    }    private void processRequest(HttpServletRequest request, HttpServletResponse response, boolean isPost)
            throws ServletException, IOException {
        ServiceDao serviceDao = new ServiceDao();
        List<Service> services;
        Map<Integer, String> serviceTypes = serviceDao.getDistinctServiceTypes();
        PromotionDao pdao = new PromotionDao();
        Promotion promotion = pdao.getLastAddedValidPromotion();

        if (isPost) {
            // Xử lý lọc dịch vụ
            services = getFilteredServices(request, serviceDao);
        } else {
            services = serviceDao.getAllServices();
        }

        // Sắp xếp nếu có yêu cầu
        String sortOrder = request.getParameter("sort");
        if (sortOrder != null && !sortOrder.isEmpty()) {
            sortServices(services, sortOrder);
        }

        // Xử lý phân trang
        int totalItems = services.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        int currentPage = getCurrentPage(request, totalPages);

        // Tạo danh sách cho trang hiện tại
        int start = (currentPage - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalItems);
        List<Service> pagedList = services.subList(start, end);

        // Đặt thuộc tính cho JSP
        setRequestAttributes(request, serviceTypes, pagedList, currentPage, totalPages, totalItems , promotion);
        request.getRequestDispatcher("service.jsp").forward(request, response);
    }

    private List<Service> getFilteredServices(HttpServletRequest request, ServiceDao serviceDao) {
        String[] typeIdParams = request.getParameterValues("typeId");
        String priceFromStr = request.getParameter("priceFrom");
        String priceToStr = request.getParameter("priceTo");

        List<Integer> selectedTypes = new ArrayList<>();
        if (typeIdParams != null) {
            for (String idStr : typeIdParams) {
                try {
                    selectedTypes.add(Integer.valueOf(idStr));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        Double priceFrom = null, priceTo = null;
        try {
            if (priceFromStr != null && !priceFromStr.isEmpty()) {
                priceFrom = Double.valueOf(priceFromStr);
            }
            if (priceToStr != null && !priceToStr.isEmpty()) {
                priceTo = Double.valueOf(priceToStr);
            }
        } catch (NumberFormatException ignored) {
        }

        request.setAttribute("selectedTypes", selectedTypes);
        request.setAttribute("priceFrom", priceFromStr);
        request.setAttribute("priceTo", priceToStr);

        return serviceDao.filterServices(selectedTypes, priceFrom, priceTo);
    }

    private void sortServices(List<Service> services, String sortOrder) {
        if ("asc".equals(sortOrder)) {
            Collections.sort(services, Comparator.comparingDouble(Service::getPrice));
        } else if ("desc".equals(sortOrder)) {
            Collections.sort(services, Comparator.comparingDouble(Service::getPrice).reversed());
        }
    }

    private int getCurrentPage(HttpServletRequest request, int totalPages) {
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
        return currentPage;
    }    private void setRequestAttributes(HttpServletRequest request,
            Map<Integer, String> serviceTypes,
            List<Service> pagedList,
            int currentPage,
            int totalPages,
            int totalItems,
            Promotion promotion) {
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("promotion", promotion);
        request.setAttribute("serviceList", pagedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);

        String sort = request.getParameter("sort");
        if (sort != null && !sort.isEmpty()) {
            request.setAttribute("sort", sort);
        }
    }
}