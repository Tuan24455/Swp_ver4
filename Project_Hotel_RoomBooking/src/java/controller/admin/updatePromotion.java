/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.PromotionDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import model.Promotion;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@MultipartConfig
@WebServlet(name = "updatePromotion", urlPatterns = {"/updatePromotion"})
public class updatePromotion extends HttpServlet {

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
            out.println("<title>Servlet updatePromotion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet updatePromotion at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        response.setContentType("text/plain");
        request.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String percentageStr = request.getParameter("percentage");
            String startAtStr = request.getParameter("start_at");
            String endAtStr = request.getParameter("end_at");

            double percentage = Double.parseDouble(percentageStr);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startAt = new java.sql.Date(sdf.parse(startAtStr).getTime());
            Date endAt = new java.sql.Date(sdf.parse(endAtStr).getTime());

            PromotionDao dao = new PromotionDao();

            // Validate mô tả
            if (description == null || description.length() < 10 || description.length() > 100) {
                response.getWriter().write("blankDescription");
                return;
            }

            // Kiểm tra tên có bị trùng ở promotion khác không
            if (dao.checkPromotionTitleExistsForUpdate(id, title)) {
                response.getWriter().write("duplicate");
                return;
            }

//            // Kiểm tra khoảng thời gian có trùng với promotion khác không
//            if (dao.checkPromotionOverlapForUpdate(id, startAt, endAt)) {
//                response.getWriter().write("overlap");
//                return;
//            }
            if (!startAt.before(endAt)) {
                response.getWriter().write("invalidDateRange");
                return;
            }

            Date lastEnd = dao.getLastPromotionEndDateForUpdate(id);
            if (lastEnd != null) {
                if(startAt.after(lastEnd)){
                    response.getWriter().write("startMustAfterLastEnd");
                    return;
                }
            }

            // 5️⃣ Kiểm tra không trùng thời gian với promotion khác
            if (dao.checkPromotionOverlapForUpdate(id, startAt, endAt)) {
                response.getWriter().write("overlap");
                return;
            }

            // Update
            Promotion p = new Promotion(id, title, percentage, startAt, endAt, description);
            dao.updatePromotion(id, title, percentage, startAt, endAt, description);
            response.getWriter().write("success");

        } catch (NumberFormatException e) {
            response.getWriter().write("invalidPercentage");
        } catch (ParseException e) {
            response.getWriter().write("invalidDate");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
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
