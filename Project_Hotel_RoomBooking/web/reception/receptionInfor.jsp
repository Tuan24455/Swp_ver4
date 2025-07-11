<%-- 
    Document   : receptionInfor
    Created on : Jun 29, 2025, 10:19:17 AM
    Author     : ADMIN
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<%@ page import="valid.Encrypt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Định nghĩa biến JavaScript CONTEXT_PATH
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Cài đặt tài khoản - ${user.fullName}</title>

        <!-- CSS Libraries -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

        <!-- Custom CSS -->
        <!--<link rel="stylesheet" href="customer/includes/component.css"/>-->
        <link rel="stylesheet" href="css/profile-enhanced.css"/>

        <script>
            // Biến JavaScript để lưu context path của ứng dụng
            const CONTEXT_PATH = "<%= contextPath %>";
        </script>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <div id="sidebar-wrapper">
                <jsp:include page="includes/sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard" />
                </jsp:include>
            </div>

            <!-- Page Content -->
            <div id="page-content-wrapper" class="flex-grow-1 p-3">
                
            </div>
        </div>
        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/profile-enhanced.js"></script>
    </div>
</body>
</html>
