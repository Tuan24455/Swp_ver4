/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dao.DashboardAdminDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 *
 * @author stew
 */
@WebServlet(name="RevenueChartServlet", urlPatterns={"/admin/revenue-chart"})  // Sửa URL để dễ quản lý và khớp với JS
public class RevenueChartServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Không cần in HTML nữa, vì servlet này trả JSON cho AJAX
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
        // Lấy param period từ request (default: weekly)
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "weekly";
        }

        // Gọi DAO để lấy data
        DashboardAdminDAO dao = new DashboardAdminDAO();
        Map<String, Object> data = dao.getRevenueAndBookingData(period);

        // Trả response JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(data, response.getWriter());
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);  // Gọi doGet để xử lý POST giống GET (nếu cần)
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet to provide revenue and booking data for charts in JSON format";
    }// </editor-fold>

}