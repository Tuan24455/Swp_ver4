<%-- 
    Document   : home
    Created on : May 22, 2025, 3:28:03 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Liên Hệ</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="customer/includes/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            main{
                display: flex;
                justify-content: center;
            }
            .containerr {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 100%;
            }
            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 25px;
            }
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
                color: #555;
            }
            input[type="text"],
            input[type="email"],
            textarea {
                width: calc(100% - 22px); /* Account for padding and border */
                padding: 10px;
                margin-bottom: 18px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
                box-sizing: border-box; /* Include padding and border in the element's total width and height */
            }
            textarea {
                resize: vertical; /* Allow vertical resizing */
                min-height: 120px;
            }
            input[type="submit"] {
                background-color: #007bff; /* A nice blue color */
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 18px;
                width: 100%;
                transition: background-color 0.3s ease;
            }
            input[type="submit"]:hover {
                background-color: #0056b3; /* Darker blue on hover */
            }
            .message {
                text-align: center;
                margin-top: 20px;
                font-size: 1.1em;
            }
            .success {
                color: green;
            }
            .error {
                color: red;
            }
        </style>
    </head>
    <body style="background-image: url(images/system/Background.jpg)">
        <jsp:include page="customer/includes/header.jsp"/>
        <main>
            <div class="containerr">
                <h1>Liên hệ với chúng tôi</h1>

                <%-- Hiển thị thông báo nếu có (từ Servlet gửi về) --%>
                <%
                    String message = (String) request.getAttribute("message");
                    String messageType = (String) request.getAttribute("messageType");
                    String detail = (String) request.getAttribute("errorMessageDetail");
                    if (message != null) {
                %>
                <p class="message <%= messageType %>"><%= message %></p>
                <%
                    }
                %>

                <form action="contact" method="post">
                    <label for="name">Tên của bạn:</label>
                    <input type="text" id="name" name="name" required>

                    <label for="email">Email của bạn:</label>
                    <input type="email" id="email" name="email" required>

                    <label for="subject">Chủ đề:</label>
                    <input type="text" id="subject" name="subject" required>

                    <label for="message">Nội dung tin nhắn:</label>
                    <textarea id="message" name="message" required></textarea>

                    <input type="submit" value="Gửi tin nhắn">
                </form>
                <c:if test="${not empty requestScope.detail}">
                    <p class="message ${requestScope.messageType}">${requestScope.detail}</p>
                </c:if>
            </div>
        </main>

        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
