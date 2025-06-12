/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.RoomDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
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
@WebServlet(name = "updateRoom", urlPatterns = {"/updateRoom"})
public class updateRoom extends HttpServlet {

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
            out.println("<title>Servlet updateRoom</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet updateRoom at " + request.getContextPath() + "</h1>");
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

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String roomNumber = request.getParameter("roomNumber");
            String roomTypeName = request.getParameter("roomType");
            double price = Double.parseDouble(request.getParameter("price"));
            String status = request.getParameter("status");
            String capStr = request.getParameter("capacity");
            if (capStr == null || capStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá trị capacity không hợp lệ!");
            }
            int capacity = Integer.parseInt(capStr);

            String description = request.getParameter("description");
            String oldImageUrl = request.getParameter("oldImageUrl");
            String floorStr = request.getParameter("floor");
            if (floorStr == null || floorStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá trị floor không hợp lệ!");
            }
            int floor = Integer.parseInt(floorStr);

            // Lấy ảnh mới nếu có
            Part filePart = request.getPart("roomImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String imageUrl;
            if (fileName == null || fileName.trim().isEmpty()) {
                imageUrl = oldImageUrl; // giữ ảnh cũ
            } else {
                String uploadPath = getServletContext().getRealPath("/") + "images/rooms";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = "images/rooms/" + fileName;
            }

            // Lấy room_type_id từ tên
            RoomDao dao = new RoomDao();
            int roomTypeId = dao.getRoomTypeIdByName(roomTypeName);

            Room room = new Room();
            room.setId(roomId);
            room.setRoomNumber(roomNumber);
            room.setRoomTypeId(roomTypeId);
            room.setRoomPrice(price);
            room.setRoomStatus(status);
            room.setCapacity(capacity);
            room.setFloor(floor);
            room.setDescription(description);
            room.setImageUrl(imageUrl);

            boolean updated = dao.updateRoom(room);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/roomList?success=1");
            } else {
                request.setAttribute("error", "Cập nhật phòng thất bại.");
                request.getRequestDispatcher("admin/roomlist.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi cụ thể ra console

            // Gửi lỗi cụ thể về trang JSP
            String errorMessage = "Đã xảy ra lỗi trong quá trình cập nhật phòng: " + e.getClass().getSimpleName() + " - " + e.getMessage();

            // Đặt thuộc tính lỗi để hiển thị trong JSP
            request.setAttribute("error", errorMessage);

            // Gửi về lại trang danh sách kèm lỗi
            request.getRequestDispatcher("admin/roomlist.jsp").forward(request, response);
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
