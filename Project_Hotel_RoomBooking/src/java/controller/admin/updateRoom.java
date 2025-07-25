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
        response.setContentType("text/plain;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            String roomIdRaw = request.getParameter("roomId");
            String roomNumberRaw = request.getParameter("roomNumber");
            String roomTypeRaw = request.getParameter("roomType");
            String floorRaw = request.getParameter("floor");
            String capacityRaw = request.getParameter("capacity");
            String priceRaw = request.getParameter("price");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String oldImageUrl = request.getParameter("oldImageUrl");
            Part filePart = request.getPart("roomImage");

            RoomDao dao = new RoomDao();

            int roomId = Integer.parseInt(roomIdRaw);
            Room currentRoom = dao.getRoomById(roomId);

            //  Nếu phòng Đang Trống và có lịch đặt tương lai => không được đổi sang bảo trì
            if ("Available".equals(currentRoom.getRoomStatus()) && "Maintenance".equals(status)) {
                if (dao.hasFutureBookings(roomId)) {
                    out.write("cannotChangeToMaintenanceWithBooking");
                    return;
                }
            }

            // Validate mô tả
            if (description == null || description.trim().isEmpty()) {
                out.write("emptyDescription");
                return;
            }
            if (description.length() > 1000) {
                out.write("tooLongDescription");
                return;
            }

            // Validate room number
            int roomNumber;
            try {
                roomNumber = Integer.parseInt(roomNumberRaw);
                if (roomNumber < 100 || roomNumber > 999) {
                    out.write("invalidRoomNumber");
                    return;
                }

                int floor = Integer.parseInt(floorRaw);
                if ((floor == 1 && (roomNumber < 100 || roomNumber >= 200))
                        || (floor == 2 && (roomNumber < 200 || roomNumber >= 300))
                        || (floor == 3 && (roomNumber < 300 || roomNumber >= 400))
                        || (floor == 4 && (roomNumber < 400 || roomNumber >= 500))
                        || (floor == 5 && (roomNumber < 500 || roomNumber >= 600))) {
                    out.write("invalidRoomFloor");
                    return;
                }
            } catch (NumberFormatException e) {
                out.write("invalidRoomNumber");
                return;
            }

            // Kiểm tra trùng số phòng (nếu thay đổi)
            if (!currentRoom.getRoomNumber().equals(roomNumberRaw)
                    && dao.isRoomNumberExists(Integer.parseInt(roomNumberRaw))) {
                out.write("roomNumberExists");
                return;
            }

            int roomTypeId = Integer.parseInt(roomTypeRaw);
            int floor = Integer.parseInt(floorRaw);
            int capacity = Integer.parseInt(capacityRaw);
            double price = Double.parseDouble(priceRaw);
            if (price < 500000) {
                out.write("invalidPrice");
                return;
            }

            // Ảnh
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String imageUrl = oldImageUrl;

            if (fileName != null && !fileName.isEmpty()) {
                String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                    out.write("invalidImage");
                    return;
                }
                String uploadPath = request.getServletContext().getRealPath("/images/rooms");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imageUrl = "images/rooms/" + fileName;
            }

            Room updatedRoom = new Room(String.valueOf(roomNumber), roomTypeId, price, status, capacity, description, imageUrl, floor);
            updatedRoom.setId(roomId);

            boolean updated = dao.updateRoom(updatedRoom);
            out.write(updated ? "success" : "error");

        } catch (Exception e) {
            e.printStackTrace(); // In ra lỗi cụ thể trong console server
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("exception:" + e.getMessage());
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
