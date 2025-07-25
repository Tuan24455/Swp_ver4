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
import java.nio.file.Paths;
import model.Service;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@MultipartConfig
@WebServlet(name = "AddService", urlPatterns = {"/addService"})
public class AddService extends HttpServlet {

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
            out.println("<title>Servlet AddService</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddService at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");

        try {
            String name = request.getParameter("service_name");
            int typeId = Integer.parseInt(request.getParameter("service_type_id"));
            double price = Double.parseDouble(request.getParameter("service_price"));
            String description = request.getParameter("description");

            // Check tên dịch vụ đã tồn tại
            ServiceDao dao = new ServiceDao();
            if (dao.checkNameExists(name)) {
                response.getWriter().write("duplicate");
                return;
            }

            // Validate giá
            if (price <= 0 || price < 100000) {
                response.getWriter().write("invalidPrice");
                return;
            }
            if (description.isEmpty() || description.isBlank()) {
                response.getWriter().write("blankDescription");
                return;
            }
            
            name  = name.trim().replaceAll("\\s{2,}", " ");
            if (!name.matches("^[\\p{L}0-9 ]+$")) {
                response.getWriter().write("invalidNameFormat");
                return;
            }
            

            // Xử lý ảnh
            Part imagePart = request.getPart("image");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String savePath = getServletContext().getRealPath("/") + "images/services";
            new File(savePath).mkdirs();
            String filePath = savePath + File.separator + System.currentTimeMillis() + "_" + fileName;
            imagePart.write(filePath);
            String imageUrl = "images/services/" + new File(filePath).getName();

            //  Lưu vào db
            Service s = new Service();
            s.setName(name);
            s.setTypeId(typeId);
            s.setPrice(price);
            s.setDescription(description);
            s.setImageUrl(imageUrl);

            dao.insertService(s);
            response.getWriter().write("success");

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
