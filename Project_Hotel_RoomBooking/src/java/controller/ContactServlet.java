package controller;

import java.io.IOException;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.mail.internet.MimeUtility;
import valid.InputValidator;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    private final String SENDER_EMAIL = "tdpoke412@gmail.com";
    private final String SENDER_PASSWORD = "cdnyzdpnrpxflcme";
    private final String RECEIVER_EMAIL = "yenlaem412@gmail.com";

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

        // Cấu hình gửi mail
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);

            String encodedSenderName = MimeUtility.encodeText("Người dùng liên hệ từ Website", "UTF-8", "B");
            message.setFrom(new InternetAddress(SENDER_EMAIL, encodedSenderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(RECEIVER_EMAIL));

            String rawSubject = "[LIÊN HỆ] " + subject + " - Từ: " + name + " (" + email + ")";
            String encodedSubject = MimeUtility.encodeText(rawSubject, "UTF-8", "B");
            message.setSubject(encodedSubject);

            String fullMessage = ""
                    + "===== THÔNG TIN LIÊN HỆ =====\n"
                    + "Họ và tên     : " + name + "\n"
                    + "Email         : " + email + "\n"
                    + "Số điện thoại : " + (phone != null && !phone.trim().isEmpty() ? phone : "Không cung cấp") + "\n"
                    + "Chủ đề        : " + subject + "\n"
                    + "Đồng ý chính sách: " + (privacy != null ? "Có" : "Không") + "\n"
                    + "-----------------------------\n"
                    + "NỘI DUNG TIN NHẮN:\n"
                    + messageContent + "\n"
                    + "=============================";

            MimeBodyPart bodyPart = new MimeBodyPart();
            bodyPart.setText(fullMessage, "UTF-8", "plain");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(bodyPart);
            message.setContent(multipart);

            Transport.send(message);

            request.setAttribute("message", "Tin nhắn của bạn đã được gửi thành công!");
            request.setAttribute("messageType", "success");

        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
            request.setAttribute("messageType", "error");
            request.setAttribute("errorMessageDetail", e.getMessage());
        }

        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}
