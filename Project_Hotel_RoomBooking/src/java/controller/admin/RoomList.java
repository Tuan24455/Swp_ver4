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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Room;

/**
 *
 * @author Phạm Quốc Tuấn
 */
@WebServlet(name = "RoomList", urlPatterns = {"/roomList"})
public class RoomList extends HttpServlet {

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
            out.println("<title>Servlet RoomList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RoomList at " + request.getContextPath() + "</h1>");
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
        doPost(request, response);
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
        response.setContentType("text/html;charset=UTF-8");

        try {
            String roomType = request.getParameter("roomType");
            String roomStatus = request.getParameter("roomStatus");
            String floorStr = request.getParameter("floor");
            String roomNumberSearch = request.getParameter("roomNumberSearch");
            String pageStr = request.getParameter("page");

            Integer floor = (floorStr != null && !floorStr.isEmpty()) ? Integer.parseInt(floorStr) : null;
            int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
            int pageSize = 10;

            RoomDao dao = new RoomDao();
            int countAll = dao.getTotalRooms();

            List<Room> filteredRooms = dao.filterRooms(roomType, roomStatus, floor, roomNumberSearch);
            int totalFiltered = filteredRooms.size();
            int totalPages = (int) Math.ceil((double) totalFiltered / pageSize);

            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalFiltered);

            List<Room> paginatedRooms = new ArrayList<>();
            if (fromIndex < totalFiltered) {
                paginatedRooms = filteredRooms.subList(fromIndex, toIndex);
            }

            Map<String, Integer> statusCounts = dao.getRoomStatusCounts();

            request.setAttribute("rooms", paginatedRooms);
            request.setAttribute("roomTypes", dao.getAllRoomTypes());
            request.setAttribute("statusCounts", statusCounts);
            request.setAttribute("totalRooms", totalFiltered);
            request.setAttribute("countAll", countAll);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("paramRoomType", roomType);
            request.setAttribute("paramRoomStatus", roomStatus);
            request.setAttribute("paramFloor", floorStr);
            request.setAttribute("paramRoomNumberSearch", roomNumberSearch);

            request.getRequestDispatcher("admin/roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("Lỗi server: " + e.getMessage());
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
