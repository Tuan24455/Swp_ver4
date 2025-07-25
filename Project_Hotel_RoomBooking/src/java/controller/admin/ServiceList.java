/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.ServiceDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Service;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@WebServlet(name = "ServiceList", urlPatterns = {"/serviceList"})
public class ServiceList extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ServiceList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServiceList at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String searchQuery = request.getParameter("searchQuery");

        // Xử lý chuỗi tìm kiếm để loại bỏ các dấu cách (khoảng trắng)
        if (searchQuery != null) {
            searchQuery = searchQuery.trim();
            searchQuery = searchQuery.replaceAll("\\s+", " ");
        }

        String type = request.getParameter("type");
        String minRaw = request.getParameter("minPrice");
        String maxRaw = request.getParameter("maxPrice");
        String pageParam = request.getParameter("page");

        // Nếu không có tham số page, mặc định trang là 1
        int pageNumber = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 10;  // Số lượng dịch vụ mỗi trang

        // Chuyển đổi các tham số giá trị
        Double min = (minRaw != null && !minRaw.isEmpty()) ? Double.parseDouble(minRaw) : null;
        Double max = (maxRaw != null && !maxRaw.isEmpty()) ? Double.parseDouble(maxRaw) : null;

        ServiceDao dao = new ServiceDao();
        List<Service> services = dao.filterServicesWithSearchAndPagination(searchQuery, type, min, max, pageNumber, pageSize);

        if (services.isEmpty()) {
            request.setAttribute("noResultsMessage", "Không tìm thấy dịch vụ nào khớp với tìm kiếm của bạn.");
        }

        int totalServices = dao.getTotalServices(searchQuery, type, min, max);

        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalServices / pageSize);

        // Gửi dữ liệu đến JSP
        request.setAttribute("services", services);
        request.setAttribute("totalServices", totalServices);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("paramSearchQuery", searchQuery);  // Truyền giá trị tìm kiếm vào request

        // Truyền các tham số bộ lọc vào JSP để giữ lại dữ liệu sau khi tìm kiếm
        request.setAttribute("paramType", type);
        request.setAttribute("paramMinPrice", min);
        request.setAttribute("paramMaxPrice", max);

        // Forward request đến JSP
        request.getRequestDispatcher("admin/serviceList.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
