package util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;

import java.util.Properties;
import java.util.Random;

public class EmailUtil {

    // ==== Thông tin cố định dùng để gửi mail ====
    private static final String SENDER_EMAIL = "tdpoke412@gmail.com";
    private static final String SENDER_PASSWORD = "cdnyzdpnrpxflcme";
    private static final String RECEIVER_EMAIL = "yenlaem412@gmail.com";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    // ==== GỬI EMAIL LIÊN HỆ ====
    public static boolean sendContactEmail(String senderName, String userEmail, String subject, String content)
            throws MessagingException, UnsupportedEncodingException {

        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        MimeMessage message = new MimeMessage(session);

        String encodedSenderName = MimeUtility.encodeText("Người dùng liên hệ từ Website", "UTF-8", "B");
        message.setFrom(new InternetAddress(SENDER_EMAIL, encodedSenderName));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(RECEIVER_EMAIL));

        String fullSubject = "[LIÊN HỆ] " + subject + " - Từ: " + senderName + " (" + userEmail + ")";
        message.setSubject(MimeUtility.encodeText(fullSubject, "UTF-8", "B"));

        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setText(content, "UTF-8", "plain");

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(bodyPart);
        message.setContent(multipart);

        Transport.send(message);
        return true;
    }
    
    public static boolean sendWelcomeEmail(String receiverEmail, String receiverName)
            throws MessagingException, UnsupportedEncodingException {

        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        MimeMessage message = new MimeMessage(session);

        // Set the sender, encoding the sender name for proper display
        String encodedSenderName = MimeUtility.encodeText("Hệ thống khách sạn", "UTF-8", "B"); // You can customize this sender name
        message.setFrom(new InternetAddress(SENDER_EMAIL, encodedSenderName));

        // Set the recipient
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(receiverEmail));

        // Set the email subject
        String subject = "Chào mừng bạn đến với Hệ thống của chúng tôi!"; // Customize your welcome subject
        message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));

        // Create the email content
        String content = """
                Xin chào %s,

                Chào mừng bạn đến với hệ thống của chúng tôi! Chúng tôi rất vui khi bạn tham gia.

                Bạn có thể bắt đầu khám phá các tính năng của chúng tôi ngay bây giờ.

                Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với đội ngũ hỗ trợ của chúng tôi.

                Trân trọng,
                Đội ngũ của bạn
                """.formatted(receiverName);

        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setText(content, "UTF-8", "plain"); // Use "html" for HTML content

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(bodyPart);
        message.setContent(multipart);

        // Send the email
        Transport.send(message);
        return true;
    }

    // ==== GỬI EMAIL OTP ====
    public static boolean sendOtpEmail(String recipientEmail, String otpCode)
            throws MessagingException, UnsupportedEncodingException {

        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        MimeMessage message = new MimeMessage(session);

        String encodedSenderName = MimeUtility.encodeText("Hệ thống xác thực", "UTF-8", "B");
        message.setFrom(new InternetAddress(SENDER_EMAIL, encodedSenderName));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
        message.setSubject(MimeUtility.encodeText("Mã OTP xác thực của bạn", "UTF-8", "B"));

        String content = """
        Chào bạn,

        Mã OTP của bạn là: """ + otpCode + """

        Vui lòng không chia sẻ mã này với bất kỳ ai.
        Mã sẽ hết hạn sau 5 phút.

        Trân trọng,
        Hệ thống xác thực.""";

        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setText(content, "UTF-8", "plain");

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(bodyPart);
        message.setContent(multipart);

        Transport.send(message);
        return true;
    }

    public static String generate8DigitCode() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            int digit = random.nextInt(10); // Tạo số từ 0 đến 9
            sb.append(digit);
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        System.out.println("Mã ngẫu nhiên: " + generate8DigitCode());
    }
}
