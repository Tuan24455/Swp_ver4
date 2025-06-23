package controller;

import dao.RoomDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Room;
import model.RoomType;
import model.User;
import valid.InputValidator;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html><head><title>Servlet HomeServlet</title></head>");
            out.println("<body><h1>Servlet HomeServlet at " + request.getContextPath() + "</h1></body></html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        checkCookie(request);
        RoomDao dao = new RoomDao();

        List<RoomType> roomtypelist = dao.getAllRoomTypes();
        List<Room> roomlist = dao.getAllRooms();

        int pageSize = 9;
        int page = InputValidator.parseIntegerOrDefault(request.getParameter("page"), 1);

        int totalRooms = roomlist.size();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalRooms);

        List<Room> paginatedRooms = roomlist.subList(start, end);

        request.setAttribute("roomlist", paginatedRooms);
        request.setAttribute("roomtypelist", roomtypelist);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        checkCookie(request);
        RoomDao dao = new RoomDao();

        List<RoomType> roomtypelist = dao.getAllRoomTypes();
        request.setAttribute("roomtypelist", roomtypelist);

        String[] typeArr = request.getParameterValues("roomType");
        List<Integer> typeIds = new ArrayList<>();
        if (typeArr != null) {
            for (String typeId : typeArr) {
                Integer id = InputValidator.parseIntegerOrNull(typeId);
                if (id != null) {
                    typeIds.add(id);
                }
            }
        }
        request.setAttribute("selectedRoomTypeIds", typeIds);

        Double priceFrom = InputValidator.parseDoubleOrNull(request.getParameter("priceFrom"));
        Double priceTo = InputValidator.parseDoubleOrNull(request.getParameter("priceTo"));
        Integer capacity = InputValidator.parseIntegerOrNull(request.getParameter("capacity"));
        String sortOrder = request.getParameter("sort");

        List<Room> filteredRooms = dao.filterRoomsAdvanced(typeIds, priceFrom, priceTo, capacity, sortOrder);

        int pageSize = 9;
        int page = InputValidator.parseIntegerOrDefault(request.getParameter("page"), 1);
        int totalRooms = filteredRooms.size();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalRooms);

        List<Room> paginatedRooms = filteredRooms.subList(start, end);

        request.setAttribute("roomlist", paginatedRooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    private void checkCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String username = null;
            String pass = null;
            for (Cookie cookie : cookies) {
                switch (cookie.getName()) {
                    case "username" ->
                        username = cookie.getValue();
                    case "pass" ->
                        pass = cookie.getValue();
                }
            }
            if (username != null && pass != null) {
                UserDao dao = new UserDao();
                User user = dao.loginByUsername(username, pass);
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                }
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
