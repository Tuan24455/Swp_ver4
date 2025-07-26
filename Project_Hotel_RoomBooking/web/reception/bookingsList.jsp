<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Bookings Management - Hotel Management System</title>
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
                            <li class="breadcrumb-item active" aria-current="page" style="color: #fff;">Bookings</li>
                        </ol>
                    </nav>
                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="h3 mb-0">Bookings Management</h1>
                        <a href="${pageContext.request.contextPath}/add-booking" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Add New Booking
                        </a>


                    </div>
                </div>




                <div class="container-fluid mt-4">
                    <form method="get" action="bookings">
                        <div class="card shadow-sm mb-4">
                            <div class="card-body">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-3">
                                        <label class="form-label">Status</label>
                                        <select name="status" class="form-select">
                                            <option value="" ${selectedStatus == '' ? 'selected' : ''}>All Status</option>
                                            <option value="Confirmed" ${selectedStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                            <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                            <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Check-in Date</label>
                                        <input type="date" name="checkinDate" class="form-control" value="${checkinDate}" />
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Check-out Date</label>
                                        <input type="date" name="checkoutDate" class="form-control" value="${checkoutDate}" />
                                    </div>
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-outline-primary w-100">
                                            <i class="fas fa-search me-2"></i>Filter
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>

                    <div class="card shadow-sm">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">All Bookings</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Booking ID</th>
                                            <th>Guest</th>
                                            <th>Check-in Date</th>
                                            <th>Check-out Date</th>
                                            <th>Total Amount</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="b" items="${bookings}">
                                            <tr>
                                                <td>#BK${b.id}</td>
                                                <td>${b.userName}</td>
                                                <td><fmt:formatDate value="${b.checkInDate}" pattern="yyyy-MM-dd"/></td>
                                                <td><fmt:formatDate value="${b.checkOutDate}" pattern="yyyy-MM-dd"/></td>
                                                <td>$<fmt:formatNumber value="${b.totalPrices}" type="number" minFractionDigits="2" /></td>
                                                <td>
                                                    <form action="update-booking-status" method="post" class="d-flex" style="gap: 4px;">
                                                        <input type="hidden" name="id" value="${b.id}" />
                                                        <select name="status" class="form-select form-select-sm">
                                                            <option value="Confirmed" ${b.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                            <option value="Pending" ${b.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                            <option value="Cancelled" ${b.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                            <option value="Completed" ${b.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        </select>
                                                        <button type="submit" class="btn btn-sm btn-outline-warning" title="Update Status">
                                                            <i class="fas fa-save"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="booking-detail?id=${b.id}" class="btn btn-sm btn-outline-info"><i class="fas fa-eye"></i></a>
                                                        <a href="cancelBooking?id=${b.id}" class="btn btn-sm btn-outline-secondary"><i class="fas fa-ban"></i></a>
                                                        <a href="deleteBooking?id=${b.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure?')"><i class="fas fa-trash"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                                <small class="text-muted mb-2 mb-md-0">
                                    Showing page ${currentPage} of ${totalPages}
                                </small>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="bookings?page=${currentPage - 1}&status=${selectedStatus}&checkinDate=${checkinDate}&checkoutDate=${checkoutDate}">Previous</a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="bookings?page=${i}&status=${selectedStatus}&checkinDate=${checkinDate}&checkoutDate=${checkoutDate}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="bookings?page=${currentPage + 1}&status=${selectedStatus}&checkinDate=${checkinDate}&checkoutDate=${checkoutDate}">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>



                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </div>
        </div>
    </body>
</html>
