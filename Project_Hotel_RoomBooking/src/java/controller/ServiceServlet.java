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

    private static final int PAGE_SIZE = 9; // Định nghĩa số lượng dịch vụ trên mỗi trang

    /**
     * Xử lý các yêu cầu HTTP GET. Khi người dùng truy cập trang lần đầu hoặc
     * chuyển trang/lọc, phương thức này sẽ được gọi. Nó gọi processRequest để
     * xử lý tất cả logic chính.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Xử lý các yêu cầu HTTP POST. Khi người dùng nhấn nút "Áp dụng lọc", form
     * sẽ gửi yêu cầu POST. Phương thức này sẽ lấy các tham số lọc, tạo một URL
     * mới và chuyển hướng (redirect) người dùng trở lại trang với yêu cầu GET,
     * đảm bảo các tham số lọc được lưu trên URL.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạo một đối tượng StringBuilder để xây dựng URL mới
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/service?");

        // Lấy tất cả các tham số từ yêu cầu POST (để xử lý cả checkbox)
        Map<String, String[]> parameterMap = request.getParameterMap();

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String paramName = entry.getKey();
            String[] paramValues = entry.getValue();

            // Loại bỏ tham số "page" để tránh xung đột khi chuyển hướng
            if (!"page".equals(paramName)) {
                for (String paramValue : paramValues) {
                    // Thêm từng cặp khóa-giá trị vào URL mới
                    redirectUrl.append(paramName).append("=").append(paramValue).append("&");
                }
            }
        }

        // Xóa ký tự '&' cuối cùng nếu có
        if (redirectUrl.charAt(redirectUrl.length() - 1) == '&') {
            redirectUrl.deleteCharAt(redirectUrl.length() - 1);
        }

        // Chuyển hướng trình duyệt đến URL mới.
        // Đây là điểm mấu chốt để các tham số lọc được giữ lại trên URL.
        response.sendRedirect(redirectUrl.toString());
    }

    /**
     * Phương thức chính chứa toàn bộ logic xử lý yêu cầu. Nó được gọi từ doGet,
     * do đó cả yêu cầu GET ban đầu và yêu cầu GET sau khi lọc đều được xử lý
     * tại đây.
     */
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ServiceDao serviceDao = new ServiceDao();

        // Bước 1: Lấy danh sách dịch vụ đã được lọc.
        // Hàm này lấy các tham số lọc từ URL (cả GET và POST đều được chuyển về GET)
        List<Service> services = getFilteredServices(request, serviceDao);

        // Bước 2: Sắp xếp danh sách dịch vụ nếu có yêu cầu từ tham số "sort".
        String sortOrder = request.getParameter("sort");
        if (sortOrder != null && !sortOrder.isEmpty()) {
            sortServices(services, sortOrder);
        }

        // Bước 3: Lấy danh sách loại dịch vụ và thông tin khuyến mãi để hiển thị trên giao diện.
        Map<Integer, String> serviceTypes = serviceDao.getDistinctServiceTypes();
        PromotionDao pdao = new PromotionDao();
        Promotion promotion = pdao.getLastAddedValidPromotion();

        // Bước 4: Xử lý logic phân trang.
        // Tính tổng số trang dựa trên tổng số dịch vụ đã được lọc và số dịch vụ trên mỗi trang.
        int totalItems = services.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        int currentPage = getCurrentPage(request, totalPages);

        // Tạo danh sách dịch vụ chỉ cho trang hiện tại.
        int start = (currentPage - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalItems);
        List<Service> pagedList = services.subList(start, end);

        // Bước 5: Đặt các thuộc tính vào request để truyền sang trang JSP.
        setRequestAttributes(request, serviceTypes, pagedList, currentPage, totalPages, totalItems, promotion);

        // Chuyển tiếp yêu cầu và các thuộc tính đã đặt đến file JSP để hiển thị.
        request.getRequestDispatcher("service.jsp").forward(request, response);
    }

    /**
     * Phương thức lấy danh sách dịch vụ dựa trên các tham số lọc từ request.
     * Các tham số này có thể là: typeId (checkbox), priceFrom, priceTo.
     */
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

        // Lưu lại các giá trị lọc vào request để giữ trạng thái trên giao diện người dùng
        request.setAttribute("selectedTypes", selectedTypes);
        request.setAttribute("priceFrom", priceFromStr);
        request.setAttribute("priceTo", priceToStr);

        return serviceDao.filterServices(selectedTypes, priceFrom, priceTo);
    }

    /**
     * Phương thức sắp xếp danh sách dịch vụ theo giá.
     */
    private void sortServices(List<Service> services, String sortOrder) {
        if ("asc".equals(sortOrder)) { // Sắp xếp tăng dần
            Collections.sort(services, Comparator.comparingDouble(Service::getPrice));
        } else if ("desc".equals(sortOrder)) { // Sắp xếp giảm dần
            Collections.sort(services, Comparator.comparingDouble(Service::getPrice).reversed());
        }
    }

    /**
     * Phương thức lấy số trang hiện tại từ request và đảm bảo nó hợp lệ.
     */
    private int getCurrentPage(HttpServletRequest request, int totalPages) {
        int currentPage = 1;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) { // Đảm bảo trang không nhỏ hơn 1
                    currentPage = 1;
                }
                if (currentPage > totalPages) { // Đảm bảo trang không vượt quá tổng số trang
                    currentPage = totalPages;
                }
            }
        } catch (NumberFormatException ignored) {
        }
        return currentPage;
    }

    /**
     * Phương thức đặt các thuộc tính cần thiết vào request để JSP có thể hiển
     * thị.
     */
    private void setRequestAttributes(HttpServletRequest request,
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
