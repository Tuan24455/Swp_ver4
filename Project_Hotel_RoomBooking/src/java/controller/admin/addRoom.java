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

    try (PrintWriter out = response.getWriter()) {
        // Lấy dữ liệu từ form
        String roomNumberRaw = request.getParameter("roomNumber");
        String roomTypeRaw = request.getParameter("roomType");
        String floorRaw = request.getParameter("floor");
        String capacityRaw = request.getParameter("capacity");
        String priceRaw = request.getParameter("price");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        Part filePart = request.getPart("roomImage");

        // Kiểm tra xem roomNumber có null hoặc rỗng không
        if (roomNumberRaw == null || roomNumberRaw.isEmpty()) {
            response.getWriter().write("invalidRoomNumber"); // Trả về lỗi nếu số phòng null hoặc rỗng
            return;
        }

        // Kiểm tra giá trị roomType, floor, capacity, price, description có null không
        if (roomTypeRaw == null || roomTypeRaw.isEmpty()) {
            response.getWriter().write("invalidRoomType");
            return;
        }
        if (floorRaw == null || floorRaw.isEmpty()) {
            response.getWriter().write("invalidFloor");
            return;
        }
        if (capacityRaw == null || capacityRaw.isEmpty()) {
            response.getWriter().write("invalidCapacity");
            return;
        }
        if (priceRaw == null || priceRaw.isEmpty()) {
            response.getWriter().write("invalidPrice");
            return;
        }
        if (description == null || description.trim().isEmpty()) {
            response.getWriter().write("emptyDescription");
            return;
        }

        // Chuyển đổi các giá trị sang kiểu đúng
        int roomTypeId = Integer.parseInt(roomTypeRaw);
        int floor = Integer.parseInt(floorRaw);
        int capacity = Integer.parseInt(capacityRaw);
        double price = Double.parseDouble(priceRaw);

        // Lấy ảnh phòng
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

        // Validate ảnh
        if (!fileExtension.equals("jpg") && !fileExtension.equals("jpeg") && !fileExtension.equals("png")) {
            response.getWriter().write("invalidImage");
            return;
        }

        // Validate số phòng
        int roomNumber;
        try {
            roomNumber = Integer.parseInt(roomNumberRaw);
            if (roomNumber < 100 || roomNumber > 999) {
                response.getWriter().write("invalidRoomNumber");
                return;
            }
            if (floor == 1 && (roomNumber < 100 || roomNumber >= 200)) {
                response.getWriter().write("invalidRoomFloor");
                return;
            }
            if (floor == 2 && (roomNumber < 200 || roomNumber >= 300)) {
                response.getWriter().write("invalidRoomFloor");
                return;
            }
            if (floor == 3 && (roomNumber < 300 || roomNumber >= 400)) {
                response.getWriter().write("invalidRoomFloor");
                return;
            }
            if (floor == 4 && (roomNumber < 400 || roomNumber >= 500)) {
                response.getWriter().write("invalidRoomFloor");
                return;
            }
            if (floor == 5 && (roomNumber < 500 || roomNumber >= 600)) {
                response.getWriter().write("invalidRoomFloor");
                return;
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("invalidRoomNumber");
            return;
        }

        RoomDao dao = new RoomDao();

        // Kiểm tra trùng số phòng
        if (dao.isRoomNumberExists(roomNumber)) {
            response.getWriter().write("roomNumberExists");
            return;
        }

        // Validate giá phòng
        if (price < 500000) {
            response.getWriter().write("invalidPrice");
            return;
        }

        // Lưu ảnh vào server
        String uploadPath = request.getServletContext().getRealPath("/images/rooms");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);
        String imageUrl = "images/rooms/" + fileName;

        // Tạo đối tượng Room và insert vào DB
        Room room = new Room(String.valueOf(roomNumber), roomTypeId, price, status, capacity, description, imageUrl, floor);
//        room.setRoomNumber(String.valueOf(roomNumber));
//        room.setRoomTypeId(roomTypeId);
//        room.setFloor(floor);
//        room.setCapacity(capacity);
//        room.setRoomPrice(price);
//        room.setRoomStatus(status);
//        room.setDescription(description);
//        room.setImageUrl(imageUrl);

        boolean isSuccess = dao.insertRoom(room);
        if (isSuccess) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }

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
