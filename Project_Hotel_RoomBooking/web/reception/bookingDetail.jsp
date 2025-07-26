<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Booking" %>
<%
    Booking b = (Booking) request.getAttribute("booking");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Booking Detail - Hotel Management System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="bookings" />
            </jsp:include>

            <div id="page-content-wrapper" class="flex-fill">
                <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm">
                    <div class="container-fluid">
                        <div class="d-flex align-items-center gap-3">
                            <span id="current-date" class="fw-semibold text-muted">Thứ Ba, 24 tháng 6, 2025</span>
                            <span id="current-time" class="fw-semibold">16:56:28</span>
                        </div>
                    </div>
                </nav>

                <div class="mb-4" style="background-image: url('https://images.squarespace-cdn.com/content/v1/5aadf482aa49a1d810879b88/1626698419120-J7CH9BPMB2YI728SLFPN/1.jpg'); background-size: cover; background-position: center center; background-repeat: no-repeat; padding: 20px 30px; border-radius: 0.25rem; color: white; box-shadow: inset 0 0 0 1000px rgba(0,0,0,0.4);">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb custom-breadcrumb" style="color: white;">
                            <li class="breadcrumb-item"><a href="dashboard.jsp" style="color: #ddd;">Home</a></li>
                            <li class="breadcrumb-item"><a href="bookings" style="color: #ddd;">Bookings</a></li>
                            <li class="breadcrumb-item active" aria-current="page" style="color: #fff;">Booking Detail</li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">Booking Details: #BK<%= b.getId() %></h1>
                </div>

                <div class="container-fluid mt-4">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">Booking Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <p class="mb-1 text-muted"><strong>Booking ID:</strong></p>
                                    <p class="lead">#BK<%= b.getId() %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="mb-1 text-muted"><strong>Guest User ID:</strong></p>
                                    <p class="lead">User #<%= b.getUserId() %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="mb-1 text-muted"><strong>Status:</strong></p>
                                    <p class="lead">
                                        <c:choose>
                                            <c:when test="${b.status == 'Confirmed'}">
                                                <span class="badge bg-success">Confirmed</span>
                                            </c:when>
                                            <c:when test="${b.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </c:when>
                                            <c:when test="${b.status == 'Cancelled'}">
                                                <span class="badge bg-danger">Cancelled</span>
                                            </c:when>
                                            <c:when test="${b.status == 'Completed'}">
                                                <span class="badge bg-primary">Completed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${b.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="mb-1 text-muted"><strong>Total Price:</strong></p>
                                    <p class="lead">
                                        $<fmt:formatNumber value="<%= b.getTotalPrices() %>" type="number" minFractionDigits="2" />
                                    </p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="mb-1 text-muted"><strong>Created At:</strong></p>
                                    <p class="lead">
                                        <fmt:parseDate value="<%= b.getCreatedAt().toString() %>" pattern="yyyy-MM-dd HH:mm:ss.S" var="createdAtDate" />
                                        <fmt:formatDate value="${createdAtDate}" pattern="MMM dd, yyyy hh:mm a" />
                                    </p>
                                </div>
                                </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="bookings" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                        <a href="editBooking?id=<%= b.getId() %>" class="btn btn-warning">
                            <i class="fas fa-edit me-2"></i>Edit Booking
                        </a>
                        <a href="cancelBooking?id=<%= b.getId() %>" class="btn btn-info">
                            <i class="fas fa-ban me-2"></i>Cancel Booking
                        </a>
                        <a href="deleteBooking?id=<%= b.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this booking? This action cannot be undone.')">
                            <i class="fas fa-trash me-2"></i>Delete Booking
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Script to update current date and time (from previous examples)
            function updateDateTime() {
                const now = new Date();
                const optionsDate = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                const optionsTime = { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
                document.getElementById('current-date').textContent = now.toLocaleDateString('vi-VN', optionsDate);
                document.getElementById('current-time').textContent = now.toLocaleTimeString('vi-VN', optionsTime);
            }
            setInterval(updateDateTime, 1000);
            updateDateTime(); // Initial call
        </script>
    </body>
</html>