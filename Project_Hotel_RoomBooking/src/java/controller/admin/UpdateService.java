/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dao.ServiceDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import model.Service;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@MultipartConfig
@WebServlet(name="UpdateService", urlPatterns={"/updateService"})
public class UpdateService extends HttpServlet {
   
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
            out.println("<title>Servlet UpdateService</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateService at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("service_name");
            String priceRaw = request.getParameter("service_price");
            String typeRaw = request.getParameter("service_type_id");
            String description = request.getParameter("description");
            String oldImageUrl = request.getParameter("oldImageUrl");

            ServiceDao dao = new ServiceDao();
            // Validate: tên không rỗng
            
            name = name.trim().replaceAll("\\s{2,}", " ");
            if(!name.matches("^[\\p{L}0-9 ]+$")){
                response.getWriter().write("invalidName");
                return;
            } 

            // Kiểm tra trùng tên (trừ chính nó)
            if (dao.checkNameExistsExceptId(name.trim(), id)) {
                response.getWriter().write("duplicate");
                return;
            }

            // Validate: giá
            double price;
            try {
                price = Double.parseDouble(priceRaw);
                if (price <= 0) {
                    response.getWriter().write("invalidPrice");
                    return;
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("invalidPrice");
                return;
            }

            // Validate: loại dịch vụ
            if (typeRaw == null || typeRaw.isEmpty()) {
                response.getWriter().write("invalidType");
                return;
            }
            int typeId = Integer.parseInt(typeRaw);

            // Validate: mô tả
            if (description == null || description.trim().isEmpty()) {
                response.getWriter().write("invalidDescription");
                return;
            }

            // Xử lý ảnh mới (nếu có)
            Part imagePart = request.getPart("image");
            String imageUrl = oldImageUrl;
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/") + "uploads";
                Files.createDirectories(Paths.get(uploadPath));
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                imagePart.write(uploadPath + File.separator + fileName);
                imageUrl = "uploads/" + fileName;
            }

            // Gọi DAO để cập nhật
            Service updated = new Service(id, name.trim(), typeId, price, description.trim(), imageUrl);
            dao.updateService(updated);

            response.getWriter().write("success");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().write("error");
        }
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
