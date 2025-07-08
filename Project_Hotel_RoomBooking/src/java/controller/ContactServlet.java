package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.EmailUtil;
import valid.InputValidator;

import java.io.IOException;
import jakarta.mail.MessagingException;
import java.io.UnsupportedEncodingException;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String messageContent = request.getParameter("message");
        String privacy = request.getParameter("privacy");

        // Giữ lại các giá trị để hiển thị lại nếu lỗi
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("subject", subject);
        request.setAttribute("message", messageContent);
        request.setAttribute("privacyChecked", privacy != null);

        // VALIDATION
        if (name == null || name.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()
                || messageContent == null || messageContent.trim().isEmpty()
                || privacy == null) {
            request.setAttribute("message", "Vui lòng điền đầy đủ thông tin và đồng ý chính sách.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidEmail(email)) {
            request.setAttribute("message", "Email không hợp lệ.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && !InputValidator.isValidPhone(phone)) {
            request.setAttribute("message", "Số điện thoại không hợp lệ. Phải bắt đầu bằng 0 và có đúng 10 số.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        // Gửi email qua EmailUtil
        try {
            String fullMessage = """
                    ===== THÔNG TIN LIÊN HỆ =====
                    Họ và tên     : %s
                    Email         : %s
                    Số điện thoại : %s
                    Chủ đề        : %s
                    Đồng ý chính sách: %s
                    -----------------------------
                    NỘI DUNG TIN NHẮN:
                    %s
                    ============================="""
                    .formatted(
                            name,
                            email,
                            (phone != null && !phone.trim().isEmpty() ? phone : "Không cung cấp"),
                            subject,
                            (privacy != null ? "Có" : "Không"),
                            messageContent
                    );

            EmailUtil.sendContactEmail(name, email, subject, fullMessage);

            request.setAttribute("message", "Tin nhắn của bạn đã được gửi thành công!");
            request.setAttribute("messageType", "success");

        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
            request.setAttribute("messageType", "error");
            request.setAttribute("errorMessageDetail", e.getMessage());
        }

        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}
