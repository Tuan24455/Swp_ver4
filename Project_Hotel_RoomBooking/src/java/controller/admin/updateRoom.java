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
@WebServlet(name = "updateRoom", urlPatterns = {"/updateRoom"})
@MultipartConfig
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
            // Lấy roomId
            String roomIdStr = request.getParameter("roomId");
            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu roomId hoặc roomId không hợp lệ!");
            }
            int roomId = Integer.parseInt(roomIdStr);

            // roomNumber
            String roomNumber = request.getParameter("roomNumber");
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                throw new IllegalArgumentException("roomNumber không được để trống.");
            }

            // roomType
            String roomTypeName = request.getParameter("roomType");
            if (roomTypeName == null || roomTypeName.trim().isEmpty()) {
                throw new IllegalArgumentException("roomType không hợp lệ.");
            }

            // price
            String priceStr = request.getParameter("price");
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá phòng không hợp lệ.");
            }
            double price = Double.parseDouble(priceStr);

            // status
            String status = request.getParameter("status");
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Trạng thái phòng không hợp lệ.");
            }

            // capacity
            String capStr = request.getParameter("capacity");
            if (capStr == null || capStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá trị capacity không hợp lệ!");
            }
            int capacity = Integer.parseInt(capStr);

            // floor
            String floorStr = request.getParameter("floor");
            if (floorStr == null || floorStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Giá trị floor không hợp lệ!");
            }
            int floor = Integer.parseInt(floorStr);

            // description có thể nullable tùy yêu cầu
            String description = request.getParameter("description");

            // Ảnh cũ
            String oldImageUrl = request.getParameter("oldImageUrl");

            // Ảnh mới
            Part filePart = request.getPart("roomImage");
            String fileName = filePart != null ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;

            String imageUrl;
            if (fileName == null || fileName.trim().isEmpty()) {
                imageUrl = oldImageUrl;
            } else {
                String uploadPath = getServletContext().getRealPath("/") + "images/rooms";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = "images/rooms/" + fileName;
            }

            // Tìm room_type_id
            RoomDao dao = new RoomDao();
            int roomTypeId = dao.getRoomTypeIdByName(roomTypeName);
            if (roomTypeId == -1) {
                throw new IllegalArgumentException("Loại phòng '" + roomTypeName + "' không tồn tại.");
            }

            // Tạo và cập nhật phòng
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

        } catch (IllegalArgumentException e) {
            // Xử lý lỗi dữ liệu đầu vào
            request.setAttribute("error", "Lỗi dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("admin/roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            // Lỗi hệ thống khác
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getClass().getSimpleName() + " - " + e.getMessage());
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
