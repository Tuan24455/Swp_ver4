/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reception;

import dao.BookingDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;
import java.sql.Date;

import model.Booking;

/**
 *
 * @author Admin
 */
@WebServlet(name = "BookingListServlet", urlPatterns = {"/reception/bookings"})
public class BookingListServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 5;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingListServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        final int RECORDS_PER_PAGE = 5;
        int page = 1;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy giá trị filter
        String status = req.getParameter("status");
        String checkin = req.getParameter("checkinDate");
        String checkout = req.getParameter("checkoutDate");

        // Chuyển đổi ngày
        Date checkinDate = null;
        Date checkoutDate = null;
        try {
            if (checkin != null && !checkin.isEmpty()) {
                checkinDate = Date.valueOf(checkin);
            }
            if (checkout != null && !checkout.isEmpty()) {
                checkoutDate = Date.valueOf(checkout);
            }
        } catch (IllegalArgumentException e) {
            // Handle invalid date format
            e.printStackTrace();
        }

        int offset = (page - 1) * RECORDS_PER_PAGE;

        BookingDao dao = new BookingDao();
        List<Booking> bookings;
        int totalRecords;

        // Kiểm tra có đang lọc không
        boolean filterByStatus = status != null && !status.isEmpty();
        boolean filterByDate = checkinDate != null && checkoutDate != null;

        if (!filterByStatus && !filterByDate) {
            bookings = dao.getBookingsByPage(offset, RECORDS_PER_PAGE);
            totalRecords = dao.countAllBookings();
        } else {
            bookings = dao.searchBookings(status, checkinDate, checkoutDate, offset, RECORDS_PER_PAGE);
            totalRecords = dao.countSearchBookings(status, checkinDate, checkoutDate);
        }

        int totalPages = (int) Math.ceil(totalRecords * 1.0 / RECORDS_PER_PAGE);

        // Gửi dữ liệu sang JSP
        req.setAttribute("bookings", bookings);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("selectedStatus", status != null ? status : "");
        req.setAttribute("checkinDate", checkin);
        req.setAttribute("checkoutDate", checkout);

        req.getRequestDispatcher("/reception/bookingsList.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
