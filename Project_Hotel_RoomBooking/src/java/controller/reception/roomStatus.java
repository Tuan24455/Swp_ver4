/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reception;

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
@WebServlet(name = "roomStatus", urlPatterns = {"/roomStatus"})
public class roomStatus extends HttpServlet {

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
            out.println("<title>Servlet roomStatus</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet roomStatus at " + request.getContextPath() + "</h1>");
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
        RoomDao dao = new RoomDao();
        int countAll = dao.getTotalRooms();
        List<Room> room1 = new ArrayList<>();
        room1 = dao.getRoomsByFloor(1);

        List<Room> room2 = new ArrayList<>();
        room2 = dao.getRoomsByFloor(2);

        List<Room> room3 = new ArrayList<>();
        room3 = dao.getRoomsByFloor(3);

        List<Room> room4 = new ArrayList<>();
        room4 = dao.getRoomsByFloor(4);

        List<Room> room5 = new ArrayList<>();
        room5 = dao.getRoomsByFloor(5);
        Map<String, Integer> statusCounts = dao.getRoomStatusCounts();

        request.setAttribute("room1", room1);
        request.setAttribute("room2", room2);
        request.setAttribute("room3", room3);
        request.setAttribute("room4", room4);
        request.setAttribute("room5", room5);
        request.setAttribute("countAll", countAll);
        request.setAttribute("statusCounts", statusCounts);

        request.getRequestDispatcher("reception/roomstatus.jsp").forward(request, response);
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
        processRequest(request, response);
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
