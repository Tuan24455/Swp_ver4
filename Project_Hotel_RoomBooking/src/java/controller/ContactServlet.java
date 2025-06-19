/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.mail.internet.MimeUtility;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    // LƯU Ý: Không nên hardcode mật khẩu như thế này trong sản phẩm thật
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

        // Cấu hình properties cho Gmail SMTP
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Tạo session có xác thực
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            // Tạo email
            MimeMessage message = new MimeMessage(session);

            String encodedSenderName = MimeUtility.encodeText("Người dùng liên hệ từ Website", "UTF-8", "B");
            message.setFrom(new InternetAddress(SENDER_EMAIL, encodedSenderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(RECEIVER_EMAIL));

            String rawSubject = "[LIÊN HỆ] " + subject + " - Từ: " + name + " (" + email + ")";
            String encodedSubject = MimeUtility.encodeText(rawSubject, "UTF-8", "B");
            message.setSubject(encodedSubject);

            // Nội dung đầy đủ
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

            // Gửi email
            System.out.println("→ Đang gửi email...");
            Transport.send(message);

            request.setAttribute("message", "Tin nhắn của bạn đã được gửi thành công!");
            request.setAttribute("messageType", "success");

        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
            request.setAttribute("messageType", "error");
            request.setAttribute("errorMessageDetail", e.getMessage()); // Đổi từ toString() sang getMessage()
        }

        // Quay lại trang contact.jsp
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}
