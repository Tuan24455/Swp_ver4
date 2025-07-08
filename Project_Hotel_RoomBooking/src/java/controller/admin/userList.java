/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import dao.UserDao;
import model.User;

@WebServlet(name = "userList", urlPatterns = {"/userList"})
public class userList extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Xử lý các action khác nhau
        if ("search".equals(action)) {
            // Tìm kiếm người dùng
            String keyword = request.getParameter("keyword");
            List<User> userList;

            if (keyword != null && !keyword.trim().isEmpty()) {
                userList = userDao.searchUsers(keyword.trim());
                request.setAttribute("searchKeyword", keyword);
            } else {
                userList = userDao.getAllUsers();
            }

            request.setAttribute("userList", userList);

        } else if ("filter".equals(action)) {
            // Lọc theo vai trò
            String role = request.getParameter("role");
            List<User> userList;

            if (role != null && !role.trim().isEmpty()) {
                userList = userDao.getUsersByRole(role);
                request.setAttribute("selectedRole", role);
            } else {
                userList = userDao.getAllUsers();
            }

            request.setAttribute("userList", userList);
        } else if ("getUserDetails".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                User userData = userDao.getUserById(id);

                if (userData == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"error\": \"Không tìm thấy người dùng.\"}");
                    return; // ❗ BẮT BUỘC
                }

                // Xóa dữ liệu nhạy cảm
                userData.setPass(null);
                userData.setDeleted(false);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(userData, response.getWriter());

                return; // ❗ BẮT BUỘC

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\": \"ID không hợp lệ.\"}");
                return; // ❗ BẮT BUỘC
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\": \"Đã xảy ra lỗi khi lấy thông tin người dùng.\"}");
                return; // ❗ BẮT BUỘC
            }

        } else if ("delete".equals(action)) {
            // Xóa người dùng
            String idStr = request.getParameter("id");

            try {
                int id = Integer.parseInt(idStr);
                boolean success = userDao.softDelete(id);

                if (success) {
                    request.setAttribute("message", "Xóa người dùng thành công!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Không thể xóa người dùng!");
                    request.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "ID người dùng không hợp lệ!");
                request.setAttribute("messageType", "error");
            }

            // Lấy lại danh sách sau khi xóa
            List<User> userList = userDao.getAllUsers();
            request.setAttribute("userList", userList);

        } else if ("updateRole".equals(action)) {
            // Cập nhật vai trò
            String idStr = request.getParameter("id");
            String newRole = request.getParameter("newRole");

            try {
                int id = Integer.parseInt(idStr);
                boolean success = userDao.updateUserRole(id, newRole);

                if (success) {
                    request.setAttribute("message", "Cập nhật vai trò thành công!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Không thể cập nhật vai trò!");
                    request.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Dữ liệu không hợp lệ!");
                request.setAttribute("messageType", "error");
            }

            // Lấy lại danh sách sau khi cập nhật
            List<User> userList = userDao.getAllUsers();
            request.setAttribute("userList", userList);

        } else {
            // Hiển thị danh sách mặc định với phân trang
            String pageStr = request.getParameter("page");
            String pageSizeStr = request.getParameter("pageSize");

            int page = 1;
            int pageSize = 10;

            try {
                if (pageStr != null) {
                    page = Integer.parseInt(pageStr);
                }
                if (pageSizeStr != null) {
                    pageSize = Integer.parseInt(pageSizeStr);
                }
            } catch (NumberFormatException e) {
                // Sử dụng giá trị mặc định
            }

            // Lấy danh sách user với phân trang
            List<User> userList = userDao.getUsersWithPagination(page, pageSize);
            request.setAttribute("userList", userList);

            // Tính toán phân trang
            int totalUsers = userDao.getTotalUsers();
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("pageSize", pageSize);
        }

        // Lấy thống kê cho tất cả các trường hợp
        Map<String, Integer> userStats = userDao.getUserStatistics();

        request.setAttribute("userStats", userStats);

        // Chuyển tiếp tới trang JSP để hiển thị
        request.getRequestDispatcher(
                "admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST requests sang GET
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Management Servlet";
    }
}
