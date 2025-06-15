package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Serves the "Thêm Mặt Hàng" (Add Item) form markup for the stock report modal.
 * The servlet returns a Bootstrap-styled HTML fragment so it can be injected directly
 * into the modal body via fetch() on the frontend.
 *
 * NOTE: this servlet currently only returns the form UI. The actual processing
 *       of the submitted form should be implemented in a separate servlet or
 *       by extending this one to handle POST requests.
 */
@WebServlet(name = "AddItemServlet", urlPatterns = {"/additem"})
public class AddItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print("<form id='addItemForm'>");
            out.print("  <div class='mb-3'>");
            out.print("    <label class='form-label'>Tên mặt hàng</label>");
            out.print("    <input type='text' name='itemName' class='form-control' required>");
            out.print("  </div>");
            out.print("  <div class='mb-3'>");
            out.print("    <label class='form-label'>Danh mục</label>");
            out.print("    <select name='category' class='form-select' required>");
            out.print("      <option value='Thực phẩm'>Thực phẩm</option>");
            out.print("      <option value='Tiện ích phòng'>Tiện ích phòng</option>");
            out.print("      <option value='Spa'>Spa</option>");
            out.print("      <option value='Đồ uống'>Đồ uống</option>");
            out.print("    </select>");
            out.print("  </div>");
            out.print("  <div class='mb-3'>");
            out.print("    <label class='form-label'>Số lượng nhập</label>");
            out.print("    <input type='number' name='quantity' class='form-control' min='1' required>");
            out.print("  </div>");
            out.print("  <div class='mb-3'>");
            out.print("    <label class='form-label'>Đơn giá (đ)</label>");
            out.print("    <input type='number' name='unitPrice' class='form-control' min='0' required>");
            out.print("  </div>");
            out.print("  <div class='text-end'>");
            out.print("    <button type='submit' class='btn btn-primary'>Lưu</button>");
            out.print("  </div>");
            out.print("</form>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String name = request.getParameter("itemName");
        String category = request.getParameter("category");
        String qtyStr = request.getParameter("quantity");
        String priceStr = request.getParameter("unitPrice");

        boolean success = false;
        String message;
        if (name == null || category == null || qtyStr == null || priceStr == null) {
            message = "Thiếu dữ liệu";
        } else {
            try {
                int qty = Integer.parseInt(qtyStr);
                double price = Double.parseDouble(priceStr);
                dao.StockDao dao = new dao.StockDao();
                success = dao.insertItem(name, category, qty, price);
                message = success ? "Thêm mặt hàng thành công" : "Thêm mặt hàng thất bại";
            } catch (NumberFormatException ex) {
                message = "Số lượng hoặc đơn giá không hợp lệ";
            }
        }
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        }
    }
}

