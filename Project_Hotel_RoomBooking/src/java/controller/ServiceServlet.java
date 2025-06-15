package controller;

import dao.ServiceDao;
import model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/service"})
public class ServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 8;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        ServiceDao dao = new ServiceDao();
        List<Service> all = dao.getAllServices();

        int totalItems = all.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        List<Service> paginated = all.subList(start, end);

        request.setAttribute("serviceList", paginated);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("service.jsp").forward(request, response);
    }
}
