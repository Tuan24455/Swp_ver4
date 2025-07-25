<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="todayDate" class="java.util.Date" scope="page" />
<fmt:formatDate value="${todayDate}" pattern="yyyy-MM-dd" var="today" />
<fmt:formatDate value="${todayDate}" pattern="dd/MM/yyyy" var="todayFormatted" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Bookings Management - Hotel Management System</title>
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
            />
        <link
            href="${pageContext.request.contextPath}/css/style.css"
            rel="stylesheet"
            />
        <style>
            :root {
                --primary-color: #e53e3e;
                --primary-hover: #c53030;
                --secondary-color: #3182ce;
                --success-color: #38a169;
                --danger-color: #e53e3e;
                --warning-color: #d69e2e;
                --light-gray: #f7fafc;
                --medium-gray: #edf2f7;
                --dark-gray: #2d3748;
                --border-color: #e2e8f0;
                --text-primary: #1a202c;
                --text-secondary: #718096;
            }
            body {
                background-color: var(--light-gray);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                color: var(--text-primary);
            }            #alert-container {
                position: fixed;
                position: fixed;
                top: 100px;
                right: 20px;
                width: 720px;
                z-index: 10150;
            }
            .section-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 25px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
                overflow: hidden;
                transition: all 0.3s ease;
            }
            .section-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 35px rgba(0,0,0,0.15);
            }
            .section-header {
                background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
                padding: 1.5rem 2rem;
                color: white;
                font-weight: 700;
                font-size: 1.2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .section-content {
                padding: 2rem;
            }
            .booking-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: white;
                border-radius: 12px;
                overflow: hidden;
            }
            .booking-table th {
                background: linear-gradient(135deg, #9aafc3, #f1f5f9);
                padding: 1rem 1.5rem;
                text-align: left;
                font-weight: 700;
                color: var(--text-primary);
                text-transform: uppercase;
                font-size: 0.8rem;
                letter-spacing: 0.5px;
                border: none;
            }
            .booking-table td {
                padding: 1.2rem 1.5rem;
                border-bottom: 1px solid var(--border-color);
                vertical-align: middle;
            }
            .booking-table tbody tr {
                transition: all 0.3s ease;
            }
            .booking-table tbody tr:hover {
                background-color: rgba(102, 126, 234, 0.05);
                transform: scale(1.01);
            }
            .booking-table tbody tr:last-child td {
                border-bottom: none;
            }
            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
            }
            .status-confirmed {
                background-color: #d4edda;
                color: #155724;
            }
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-completed {
                background-color: #d1ecf1;
                color: #0c5460;
            }
            .status-checkin {
                background-color: var(--success-color);
                color: white;
            }
            .status-checkout {
                background-color: var(--danger-color);
                color: white;
            }
            .btn-action {
                padding: 5px 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                text-decoration: none;
                display: inline-block;
                margin: 2px;
            }
            .btn-view {
                background-color: var(--secondary-color);
                color: white;
            }
            .btn-edit {
                background-color: var(--warning-color);
                color: white;
            }
            .btn-cancel {
                background-color: var(--danger-color);
                color: white;
            }
        </style>
    </head>
    <body>
        <div id="alert-container"></div>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="bookings" />
            </jsp:include>            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">             

                <!-- Thông báo từ servlet -->
                <c:if test="${not empty message}">
                    <div class="alert alert-${messageType} alert-dismissible fade show m-3" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show m-3" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Filter Section -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select">
                                    <option value="">All Status</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="pending">Pending</option>
                                    <option value="cancelled">Cancelled</option>
                                    <option value="completed">Completed</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">&nbsp;</label>
                                <div class="d-grid">
                                    <button class="btn btn-outline-primary">
                                        <i class="fas fa-search me-2"></i>Filter
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bookings Table -->
                <div class="section-card">
                    <div class="section-header">
                        <span>Quản lý đặt phòng</span>
                    </div>
                    <div class="section-content">
                        <div class="table-responsive">
                            <table class="booking-table">
                                <thead>
                                    <tr>
                                        <th>Mã đặt phòng</th>
                                        <th>Tên khách</th>
                                        <th>Loại phòng</th>
                                        <th>Nhận phòng</th>
                                        <th>Trả phòng</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${bookings}">
                                        <fmt:parseDate value="${booking.checkIn}" pattern="yyyy-MM-dd" var="bookingCheckInDate" />
                                        <fmt:formatDate value="${bookingCheckInDate}" pattern="dd/MM/yyyy" var="bookingCheckInFormatted" />
                                        <tr>
                                            <td>#${booking.id}</td>
                                            <td>${booking.customer}</td>
                                            <td>${booking.roomNumber}</td>
                                            <td>${booking.checkIn}</td>
                                            <td>${booking.checkOut}</td>
                                            <td><fmt:formatNumber value="${booking.totalPrices}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td>
                                                <span class="status-badge ${booking.statusClass}">
                                                    ${booking.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${booking.status eq 'pending' or booking.status eq 'Pending Payment'}">
                                                        <button type="button" class="btn-action btn-view" title="Check-in" 
                                                            onclick="showAlert('Booking #${booking.id} đang chờ thanh toán, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-in-alt"></i> Check-in
                                                        </button>
                                                        <button type="button" class="btn-action btn-cancel" title="Check-out"
                                                            onclick="showAlert('Booking #${booking.id} đang chờ thanh toán, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Payment Failed'}">
                                                        <button type="button" class="btn-action btn-view" title="Check-in"
                                                            onclick="showAlert('Booking #${booking.id} thanh toán thất bại, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-in-alt"></i> Check-in
                                                        </button>
                                                        <button type="button" class="btn-action btn-cancel" title="Check-out"
                                                            onclick="showAlert('Booking #${booking.id} thanh toán thất bại, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                                        </button>
                                                    </c:when>                                                    <c:when test="${booking.status eq 'confirmed' or booking.status eq 'Confirmed' or 
                                                                  booking.status eq 'Check-in' or booking.status eq 'checkin' or
                                                                  booking.status eq 'Check-out' or booking.status eq 'checkout' or
                                                                  booking.status eq 'completed' or booking.status eq 'Completed'}">
                                                        <c:choose>
                                                            <c:when test="${bookingCheckInDate.time <= todayDate.time}">
                                                                <form action="${pageContext.request.contextPath}/bookingList" method="post" style="display: inline;">
                                                                    <input type="hidden" name="action" value="checkin"/>
                                                                    <input type="hidden" name="bookingId" value="${booking.id}"/>
                                                                    <button type="submit" class="btn-action btn-view" title="Check-in">
                                                                        <i class="fas fa-sign-in-alt"></i> Check-in
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn-action btn-view" title="Check-in"
                                                                    onclick="showAlert('Booking #${booking.id} đang có lịch check-in là ${bookingCheckInFormatted} và hôm nay là ${todayFormatted}, không cho phép check-in trước ngày khách đặt')">
                                                                    <i class="fas fa-sign-in-alt"></i> Check-in
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <!-- Replace checkout form with conditional logic -->
                                                        <c:choose>
                                                            <c:when test="${booking.status eq 'Check-in' or booking.status eq 'checkin'}">
                                                                <form action="${pageContext.request.contextPath}/bookingList" method="post" style="display: inline;">
                                                                    <input type="hidden" name="action" value="checkout"/>
                                                                    <input type="hidden" name="bookingId" value="${booking.id}"/>
                                                                    <button type="submit" class="btn-action btn-cancel" title="Check-out">
                                                                        <i class="fas fa-sign-out-alt"></i> Check-out
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn-action btn-cancel" title="Check-out"
                                                                    onclick="showAlert('Booking #${booking.id} chỉ cho phép check-out khi phòng đang ở trạng thái check-in')">
                                                                    <i class="fas fa-sign-out-alt"></i> Check-out
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn-action btn-view" title="Check-in" disabled>
                                                            <i class="fas fa-sign-in-alt"></i> Check-in
                                                        </button>
                                                        <button type="button" class="btn-action btn-cancel" title="Check-out" disabled>
                                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty bookings}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                <i class="fas fa-calendar-times fs-4 mb-3 d-block"></i>
                                                Không có booking nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                
                <div class="modal-body">
                    <form>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Guest Name</label>
                                <input type="text" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone</label>
                                <input type="tel" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Room Type</label>
                                <select class="form-select" required>
                                    <option value="">Select Room Type</option>
                                    <option value="standard">Standard Room</option>
                                    <option value="deluxe">Deluxe Room</option>
                                    <option value="suite">Suite</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Number of Guests</label>
                                <select class="form-select" required>
                                    <option value="">Select</option>
                                    <option value="1">1 Guest</option>
                                    <option value="2">2 Guests</option>
                                    <option value="3">3 Guests</option>
                                    <option value="4">4 Guests</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Total Amount</label>
                                <input
                                    type="number"
                                    class="form-control"
                                    step="0.01"
                                    required
                                    />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Special Requests</label>
                                <textarea class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                        >
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary">
                        Create Booking
                    </button>
                </div>
            </div>
        </div>
    </div>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to show alerts
        function showAlert(message) {
            const container = document.getElementById('alert-container');
            // Clear existing alerts to prevent stacking
            container.innerHTML = '';
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show m-3';
            alertDiv.setAttribute('role', 'alert');
            alertDiv.innerHTML = message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
            container.appendChild(alertDiv);
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                alertDiv.classList.remove('show');
                alertDiv.classList.add('hide');
                setTimeout(() => alertDiv.remove(), 150);
            }, 5000);
        }

        // Initialize clock when DOM is loaded
        document.addEventListener("DOMContentLoaded", function() {
            // Initialize immediately
            updateDateTime();
            // Update time every second
            setInterval(updateDateTime, 1000);
        });
    </script>
</body>
</html>
