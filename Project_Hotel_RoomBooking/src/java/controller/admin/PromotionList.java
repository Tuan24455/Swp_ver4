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
import java.util.Date;
import java.util.List;
import model.Promotion;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@WebServlet(name="PromotionList", urlPatterns={"/promotionList"})
public class PromotionList extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<h1>Servlet PromotionList at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    String status = request.getParameter("status");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String pageStr = request.getParameter("page");

    Date startDate = null;
    Date endDate = null;
    try {
        if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = java.sql.Date.valueOf(startDateStr);
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = java.sql.Date.valueOf(endDateStr);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
    int pageSize = 10;

    PromotionDao dao = new PromotionDao();
    List<Promotion> filtered = dao.filterPromotions(status, startDate, endDate);

    int total = filtered.size();
    int totalPages = (int) Math.ceil((double) total / pageSize);
    int fromIndex = (page - 1) * pageSize;
    int toIndex = Math.min(fromIndex + pageSize, total);
    List<Promotion> paginated = filtered.subList(fromIndex, toIndex);

    request.setAttribute("pro", paginated);
    request.setAttribute("totalPromotions", total);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("pageSize", pageSize);

    // giữ filter khi hiển thị lại
    request.setAttribute("paramStatus", status);
    request.setAttribute("paramStartDate", startDateStr);
    request.setAttribute("paramEndDate", endDateStr);

        request.getRequestDispatcher("admin/promotionsList.jsp").forward(request, response);

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
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
