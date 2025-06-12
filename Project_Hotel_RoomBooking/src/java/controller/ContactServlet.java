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

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    // THÔNG TIN CẤU HÌNH EMAIL
    // RẤT QUAN TRỌNG: KHÔNG NÊN HARDCODE MẬT KHẨU NHƯ THẾ NÀY TRONG ỨNG DỤNG THỰC TẾ.
    // HÃY LẤY TỪ BIẾN MÔI TRƯỜNG, FILE CẤU HÌNH HOẶC CƠ SỞ DỮ LIỆU.
    private final String SENDER_EMAIL = "tdpoke412@gmail.com"; // Email của bạn (email sẽ dùng để gửi)
    private final String SENDER_PASSWORD = "cdnyzdpnrpxflcme";   // Mật khẩu ứng dụng của email trên (KHÔNG phải mật khẩu chính)
    private final String RECEIVER_EMAIL = "yenlaem412@gmail.com"; // Email nhận mail (là email của bạn: yenlaem412@gmail.com)

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String messageContent = request.getParameter("message");

        // Cấu hình properties cho mail server (ví dụ: Gmail SMTP)
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com"); // Host của SMTP server
        properties.put("mail.smtp.port", "587"); // Cổng SMTP TLS/STARTTLS
        properties.put("mail.smtp.auth", "true"); // Bật xác thực
        properties.put("mail.smtp.starttls.enable", "true"); // Bật STARTTLS
//        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Tạo đối tượng Session với Authenticator (dùng để xác thực tài khoản gửi mail)
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            // Tạo đối tượng MimeMessage
            MimeMessage message = new MimeMessage(session);

            // Đặt người gửi (From)
            String encodedPersonalName = MimeUtility.encodeText("Người dùng liên hệ từ Website", "UTF-8", "B");
            message.setFrom(new InternetAddress(SENDER_EMAIL, encodedPersonalName));
            // Đặt người nhận (To)
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(RECEIVER_EMAIL));
            // Đặt tiêu đề (Subject)
            // Thêm thông tin người gửi vào tiêu đề để dễ theo dõi
            String rawSubject = "[LIÊN HỆ] " + subject + " - Từ: " + name + " (" + email + ")";
            String encodedSubject = MimeUtility.encodeText(rawSubject, "UTF-8", "B"); // "B" cho Base64 encoding
            message.setSubject(encodedSubject);

            // Đặt nội dung email
            // Dùng MimeBodyPart và Multipart để có thể gửi HTML hoặc văn bản thuần túy
            MimeBodyPart messageBodyPart = new MimeBodyPart();
            String fullMessage = "Tên người gửi: " + name + "\n"
                    + "Email người gửi: " + email + "\n"
                    + "Chủ đề: " + subject + "\n\n"
                    + "Nội dung tin nhắn:\n" + messageContent;
            messageBodyPart.setText(fullMessage, "UTF-8", "plain"); // Gửi nội dung dạng văn bản thuần túy

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            message.setContent(multipart);

            // Gửi email
            Transport.send(message);

            // Đặt thông báo thành công vào request và chuyển tiếp về trang JSP
            request.setAttribute("message", "Tin nhắn của bạn đã được gửi thành công!");
            request.setAttribute("messageType", "success"); // Dùng cho CSS

        } catch (MessagingException e) {
            e.printStackTrace(); // In lỗi ra console để debug

            // Đặt thông báo lỗi vào request và chuyển tiếp về trang JSP
            request.setAttribute("message", "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
            request.setAttribute("messageType", "error"); // Dùng cho CSS
            request.setAttribute("errorMessageDetail", e.toString()); // Cụ thể lỗi hơn
        }

        // Chuyển tiếp yêu cầu trở lại trang JSP của form
        // Đảm bảo đường dẫn này đúng với vị trí file JSP của bạn (ví dụ: /index.jsp)
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}
