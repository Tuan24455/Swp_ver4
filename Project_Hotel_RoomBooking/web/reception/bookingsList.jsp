<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
            }            .btn-cancel {
                background-color: var(--danger-color);
                color: white;
            }
            
            /* Date validation styling */
            .invalid-feedback {
                display: none;
                color: #dc3545;
                font-size: 80%;
                margin-top: 4px;
            }
            .is-invalid {
                border-color: #dc3545;
                padding-right: calc(1.5em + 0.75rem);
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right calc(0.375em + 0.1875rem) center;
                background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
            }
            
            /* Pagination Styling */
            .pagination-container {
                padding: 1rem 0;
                font-size: 0.9rem;
            }
            .pagination {
                margin-bottom: 0;
            }
            .pagination .page-link {
                color: var(--text-primary);
                border-radius: 4px;
                margin: 0 2px;
                transition: all 0.2s ease;
            }
            .pagination .page-item.active .page-link {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                color: white;
            }
            .pagination .page-item.disabled .page-link {
                color: var(--text-secondary);
                opacity: 0.6;
            }
            .pagination .page-link:hover {
                background-color: var(--medium-gray);
                transform: translateY(-2px);
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .pagination .page-item.active .page-link:hover {
                background-color: var(--primary-hover);
            }
            .pagination-info {
                color: var(--text-secondary);
            }
        </style>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="bookings" />
            </jsp:include>

            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <nav
                    class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
                    >
                    <div class="container-fluid">
                        <div class="d-flex align-items-center gap-3">
                            <span id="current-date" class="fw-semibold text-muted">Thứ Ba, 24 tháng 6, 2025</span>
                            <span id="current-time" class="fw-semibold">16:56:28</span>
                        </div>
                    </div>
                </nav>

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
                </c:if>                <!-- Filter Section -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/bookingList" method="get">                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Status</label>                                    <select class="form-select" name="status">
                                        <option value="">All Status</option>
                                        <option value="confirmed" ${statusFilter eq 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                        <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Pending</option>
                                        <option value="Pending Payment" ${statusFilter eq 'Pending Payment' ? 'selected' : ''}>Pending Payment</option>
                                        <option value="Payment Failed" ${statusFilter eq 'Payment Failed' ? 'selected' : ''}>Payment Failed</option>
                                        <option value="cancelled" ${statusFilter eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                        <option value="completed" ${statusFilter eq 'completed' ? 'selected' : ''}>Completed</option>
                                        <option value="check-in" ${statusFilter eq 'check-in' ? 'selected' : ''}>Check-in</option>
                                        <option value="check-out" ${statusFilter eq 'check-out' ? 'selected' : ''}>Check-out</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Check-in Date</label>
                                    <input type="date" class="form-control" id="checkInDateFilter" name="checkInDate" value="${checkInDate}" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Check-out Date</label>
                                    <input type="date" class="form-control" id="checkOutDateFilter" name="checkOutDate" value="${checkOutDate}" />
                                    <div class="invalid-feedback" id="dateErrorMsg">
                                        Check-out date must be after check-in date
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid">
                                        <button type="submit" id="filterButton" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-2"></i>Filter
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <!-- Keep current page if set -->
                            <c:if test="${not empty currentPage}">
                                <input type="hidden" name="page" value="${currentPage}" />
                            </c:if>
                        </form>
                    </div>
                </div>

                <!-- Bookings Table -->
                <div class="section-card">
                    <div class="section-header">
                        <span>Quản lý đặt phòng</span>
                        <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addBookingModal">
                            <i class="fas fa-plus me-2"></i>Thêm đặt phòng mới
                        </button>
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
                                                            onclick="alert('Booking #${booking.id} đang chờ thanh toán, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-in-alt"></i> Check-in
                                                        </button>
                                                        <button type="button" class="btn-action btn-cancel" title="Check-out"
                                                            onclick="alert('Booking #${booking.id} đang chờ thanh toán, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Payment Failed'}">
                                                        <button type="button" class="btn-action btn-view" title="Check-in"
                                                            onclick="alert('Booking #${booking.id} thanh toán thất bại, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-in-alt"></i> Check-in
                                                        </button>
                                                        <button type="button" class="btn-action btn-cancel" title="Check-out"
                                                            onclick="alert('Booking #${booking.id} thanh toán thất bại, không cho phép checkin hoặc checkout')">
                                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                                        </button>
                                                    </c:when>                                                    <c:when test="${booking.status eq 'confirmed' or booking.status eq 'Confirmed' or 
                                                                  booking.status eq 'Check-in' or booking.status eq 'checkin' or
                                                                  booking.status eq 'Check-out' or booking.status eq 'checkout' or
                                                                  booking.status eq 'completed' or booking.status eq 'Completed'}">                                                        <form action="${pageContext.request.contextPath}/bookingList" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="checkin"/>
                                                            <input type="hidden" name="bookingId" value="${booking.id}"/>
                                                            <input type="hidden" name="currentPage" value="${currentPage}"/>
                                                            <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                                            <input type="hidden" name="checkInDate" value="${checkInDate}"/>
                                                            <input type="hidden" name="checkOutDate" value="${checkOutDate}"/>
                                                            <button type="submit" class="btn-action btn-view" title="Check-in">
                                                                <i class="fas fa-sign-in-alt"></i> Check-in
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/bookingList" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="checkout"/>
                                                            <input type="hidden" name="bookingId" value="${booking.id}"/>
                                                            <input type="hidden" name="currentPage" value="${currentPage}"/>
                                                            <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                                            <input type="hidden" name="checkInDate" value="${checkInDate}"/>
                                                            <input type="hidden" name="checkOutDate" value="${checkOutDate}"/>
                                                            <button type="submit" class="btn-action btn-cancel" title="Check-out">
                                                                <i class="fas fa-sign-out-alt"></i> Check-out
                                                            </button>
                                                        </form>
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
                                        </tr>                                    </c:forEach>
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
                        
                        <!-- Pagination Controls -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container mt-4 d-flex justify-content-between align-items-center">
                                <div class="pagination-info">
                                    Hiển thị <strong>${(currentPage-1)*8 + 1}</strong> - <strong>${(currentPage-1)*8 + bookings.size()}</strong> 
                                    trong tổng số <strong>${totalBookings}</strong> booking
                                </div>
                                <div class="pagination-buttons">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination mb-0">                            <!-- Previous button -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/bookingList?page=${currentPage - 1}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty checkInDate ? '&checkInDate='.concat(checkInDate) : ''}${not empty checkOutDate ? '&checkOutDate='.concat(checkOutDate) : ''}" aria-label="Previous">
                                                    <span aria-hidden="true">&laquo;</span>
                                                </a>
                                            </li>
                                            
                                            <!-- Page numbers -->
                                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/bookingList?page=${pageNum}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty checkInDate ? '&checkInDate='.concat(checkInDate) : ''}${not empty checkOutDate ? '&checkOutDate='.concat(checkOutDate) : ''}">${pageNum}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <!-- Next button -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/bookingList?page=${currentPage + 1}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty checkInDate ? '&checkInDate='.concat(checkInDate) : ''}${not empty checkOutDate ? '&checkOutDate='.concat(checkOutDate) : ''}" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Booking</h5>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        ></button>
                </div>
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
        // Sidebar toggle functionality
        document
                .getElementById("menu-toggle")
                .addEventListener("click", function () {
                    document
                            .getElementById("sidebar-wrapper")
                            .classList.toggle("toggled");
                });
        
        // Date validation for filter form
        document.addEventListener('DOMContentLoaded', function() {
            const checkInDateInput = document.getElementById('checkInDateFilter');
            const checkOutDateInput = document.getElementById('checkOutDateFilter');
            const filterForm = checkInDateInput.closest('form');
            const dateErrorMsg = document.getElementById('dateErrorMsg');
            
            // Function to validate dates
            function validateDates() {
                if (checkInDateInput.value && checkOutDateInput.value) {
                    const checkInDate = new Date(checkInDateInput.value);
                    const checkOutDate = new Date(checkOutDateInput.value);
                    
                    if (checkOutDate < checkInDate) {
                        checkOutDateInput.classList.add('is-invalid');
                        dateErrorMsg.style.display = 'block';
                        return false;
                    } else {
                        checkOutDateInput.classList.remove('is-invalid');
                        dateErrorMsg.style.display = 'none';
                        return true;
                    }
                }
                return true; // If either date is not set, validation passes
            }
            
            // Add event listeners
            checkInDateInput.addEventListener('change', validateDates);
            checkOutDateInput.addEventListener('change', validateDates);
            
            // Form submission validation
            filterForm.addEventListener('submit', function(event) {
                if (!validateDates()) {
                    event.preventDefault(); // Prevent form submission if validation fails
                }
            });
            
            // Initial validation
            validateDates();
        });
    </script>
</body>
</html>
