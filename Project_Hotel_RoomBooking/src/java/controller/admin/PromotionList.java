/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.PromotionDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import model.Promotion;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@WebServlet(name = "PromotionList", urlPatterns = {"/promotionList"})
public class PromotionList extends HttpServlet {

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
            out.println("<title>Servlet PromotionList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PromotionList at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        String searchQuery = request.getParameter("searchQuery");
        if (searchQuery != null) {
            searchQuery = searchQuery.trim(); // Bỏ qua khoảng trắng
            if (searchQuery.isEmpty()) {
                searchQuery = null;
            }
            session.setAttribute("promotionSearchQuery", searchQuery);
        } else {
            searchQuery = (String) session.getAttribute("promotionSearchQuery");
        }

        String startDateRaw = request.getParameter("startDate");
        String endDateRaw = request.getParameter("endDate");

        Date startDate = null, endDate = null;
        try {
            if (startDateRaw != null && !startDateRaw.isEmpty()) {
                startDate = java.sql.Date.valueOf(startDateRaw);
            }
            if (endDateRaw != null && !endDateRaw.isEmpty()) {
                endDate = java.sql.Date.valueOf(endDateRaw);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        int pageSize = 5;
        int offset = (page - 1) * pageSize;

        PromotionDao dao = new PromotionDao();
        List<Promotion> promotions = dao.searchFilterPaginate(searchQuery, startDate, endDate, offset, pageSize);
        int total = dao.countTotal(searchQuery, startDate, endDate);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        if (promotions.isEmpty() && searchQuery != null) {
            request.setAttribute("noResultsMessage", "Không tìm thấy kết quả phù hợp.");
        }

        request.setAttribute("pro", promotions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalServices", total);
        request.setAttribute("param.searchQuery", searchQuery);
        request.setAttribute("paramStartDate", startDateRaw);
        request.setAttribute("paramEndDate", endDateRaw);

        request.getRequestDispatcher("admin/promotionsList.jsp").forward(request, response);

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
