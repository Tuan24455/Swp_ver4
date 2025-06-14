/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.RoomDao;
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
import model.Room;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@MultipartConfig
@WebServlet(name = "addRoom", urlPatterns = {"/addRoom"})
public class addRoom extends HttpServlet {

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
            out.println("<title>Servlet addRoom</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addRoom at " + request.getContextPath() + "</h1>");
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
        response.setCharacterEncoding("UTF-8");

        String roomNumber = request.getParameter("roomNumber");
        String roomTypeName = request.getParameter("roomType");
        String roomPrice = request.getParameter("price");
        String roomStatus = request.getParameter("status");
        String capacity = request.getParameter("capacity");
        String description = request.getParameter("description");
        String floor = request.getParameter("floor");

        Part filePart = request.getPart("roomImage");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Đường dẫn vật lý lưu file
//        String uploadPath = getServletContext().getRealPath("/") + "images/rooms";
        String uploadPath = getServletContext().getRealPath("/images/rooms");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // ✅ Lưu file vào thư mục
        filePart.write(uploadPath + File.separator + fileName);

        // ✅ Đường dẫn lưu trong DB (trình duyệt truy cập được)
        String imageUrl = "images/rooms/" + fileName;

        RoomDao dao = new RoomDao();
        int roomTypeId = dao.getRoomTypeIdByName(roomTypeName);

        if (roomTypeId == -1) {
            request.setAttribute("error", "Loại phòng không hợp lệ.");
            request.getRequestDispatcher("admin/roomlist.jsp").forward(request, response);
            return;
        }

        Room room = new Room(roomNumber, roomTypeId, Double.parseDouble(roomPrice), roomStatus, Integer.parseInt(capacity), description, imageUrl, Integer.parseInt(floor));

        boolean success = dao.insertRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/roomList");
        } else {
            request.setAttribute("error", "Không thể thêm phòng.");
            request.getRequestDispatcher("addRoom.jsp").forward(request, response);
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
