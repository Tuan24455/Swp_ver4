package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Serves the "Thêm Danh Mục" (Add Category) form markup for the stock report modal.
 * Returned HTML fragment will be injected into modal body via fetch on the frontend.
 */
@WebServlet(name = "AddCategoryServlet", urlPatterns = {"/addcategory"})
public class AddCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            dao.StockDao dao = new dao.StockDao();
            java.util.List<String> categories = dao.getCategories();

            // Add category form
            out.print("<form id='addCategoryForm' class='mb-4'>");
            out.print("  <div class='input-group'>");
            out.print("    <input type='text' name='categoryName' class='form-control' placeholder='Tên danh mục mới' required>");
            out.print("    <button class='btn btn-success' type='submit'>Thêm</button>");
            out.print("  </div>");
            out.print("</form>");

            // Existing categories table
            out.print("<table class='table table-striped table-hover align-middle'>");
            out.print("  <thead class='table-light'><tr><th>#</th><th>Tên danh mục</th><th class='text-end'>Hành động</th></tr></thead>");
            out.print("  <tbody>");
            int idx = 1;
            for (String c : categories) {
                out.print("    <tr>");
                out.print("      <td>" + (idx++) + "</td>");
                out.print("      <td>" + c + "</td>");
                out.print("      <td class='text-end'>");
                out.print("        <button class='btn btn-sm btn-primary me-1' onclick=\"editCategory('" + c + "')\"><i class='fas fa-edit'></i></button>");
                out.print("        <button class='btn btn-sm btn-danger' onclick=\"deleteCategory('" + c + "')\"><i class='fas fa-trash'></i></button>");
                out.print("      </td>");
                out.print("    </tr>");
            }
            out.print("  </tbody></table>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String name = req.getParameter("categoryName");
        boolean success = false;
        String message;
        if (name == null || name.trim().isEmpty()) {
            message = "Tên danh mục không được để trống";
        } else {
            dao.StockDao dao = new dao.StockDao();
            success = dao.insertCategory(name.trim());
            message = success ? "Thêm danh mục thành công" : "Thêm danh mục thất bại";
        }
        try (PrintWriter out = resp.getWriter()) {
            out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        }
    }
}
