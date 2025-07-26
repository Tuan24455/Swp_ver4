<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Đặt Phòng - Hệ Thống Quản Lý Khách Sạn</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      .avatar-sm {
        width: 40px;
        height: 40px;
      }
    </style>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <!-- Sidebar -->
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="bookingreport" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <jsp:include page="includes/navbar.jsp" />

        <div class="container-fluid py-4">
          <!-- Bộ lọc tìm kiếm -->
          <div class="card shadow-sm mb-4">
            <div class="card-body bg-light">
              <div class="row g-3 align-items-center">
                <div class="col-md-3">
                  <label for="fromDate" class="form-label">Từ Ngày</label>
                  <div class="input-group">
                    <input type="date" class="form-control" id="fromDate">
                  </div>
                </div>
                <div class="col-md-3">
                  <label for="toDate" class="form-label">Đến Ngày</label>
                  <div class="input-group">
                    <input type="date" class="form-control" id="toDate">
                  </div>
                </div>
                <div class="col-md-4">
                  <label for="roomType" class="form-label">Loại Phòng</label>
                  <div class="input-group">
                    <select class="form-select" id="roomType">
                      <option value="" ${selectedRoomType == null ? 'selected' : ''}>Tất Cả Loại Phòng</option>
                      <c:forEach items="${roomTypes}" var="type">
                        <option value="${type.id}" ${selectedRoomType == type.id ? 'selected' : ''}>${type.roomType}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                  <button class="btn btn-primary w-100" id="filterButton">Lọc</button>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Thống kê chi tiết phòng -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">
                <i class="fas fa-chart-bar me-2"></i>Chi Tiết Thống Kê Phòng
              </h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered">
                  <thead class="table-light">
                    <tr>
                      <th>Trạng Thái Phòng</th>
                      <th>Số Lượng</th>
                      <th>Mô Tả</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${roomStatistics}" var="entry">
                      <tr>
                        <td>${entry.key}</td>
                        <td>${entry.value.count}</td>
                        <td>${entry.value.description}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          
          <!-- Current Bookings Table -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">
                <i class="fas fa-users me-2"></i>Danh Sách Khách Hàng Đang Thuê
              </h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                  <thead class="table-light">
                    <tr>
                      <th><i class="fas fa-door-closed me-1"></i>Tên Phòng</th>
                      <th><i class="fas fa-layer-group me-1"></i>Tầng</th>
                      <th><i class="fas fa-bed me-1"></i>Loại Phòng</th>
                      <th><i class="fas fa-users me-1"></i>Sức Chứa</th>
                      <th><i class="fas fa-user me-1"></i>Tên Khách Hàng</th>
                      <th>
                        <i class="fas fa-calendar-check me-1"></i>Ngày Đặt
                      </th>
                      <th>
                        <i class="fas fa-calendar-times me-1"></i>Ngày Trả
                      </th>
                      <th>
                        <i class="fas fa-money-bill-wave me-1"></i>Tổng Tiền
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${currentBookings}" var="booking">
                      <tr>
                        <td>
                          <strong class="text-primary"
                            >${booking.roomNumber}</strong
                          >
                        </td>
                        <td>
                          <span class="badge bg-info"
                            >Tầng ${booking.floor}</span
                          >
                        </td>
                        <td>${booking.roomType}</td>
                        <td>
                          <span class="text-muted"
                            >${booking.capacity} người</span
                          >
                        </td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div
                              class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-2"
                            >
                              <i class="fas fa-user text-white"></i>
                            </div>
                            <div>
                              <strong>${booking.customerName}</strong>
                            </div>
                          </div>
                        </td>
                        <td>
                          <span class="text-success"
                            ><fmt:formatDate
                              value="${booking.checkInDate}"
                              pattern="dd/MM/yyyy"
                          /></span>
                        </td>
                        <td>
                          <span class="text-danger"
                            ><fmt:formatDate
                              value="${booking.checkOutDate}"
                              pattern="dd/MM/yyyy"
                          /></span>
                        </td>
                        <td>
                          <strong class="text-success"
                            ><fmt:formatNumber
                              value="${booking.totalPrice}"
                              type="currency"
                              currencySymbol="đ"
                              maxFractionDigits="0"
                          /></strong>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- Summary Footer -->
              <div class="row mt-3 pt-3 border-top">
                <div class="col-md-6">
                  <!-- Phần tử này sẽ được cập nhật bởi JavaScript -->
                </div>
                <div class="col-md-6 text-end">
                  <!-- Phần tử này sẽ được cập nhật bởi JavaScript -->
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/bookingreport.js"></script>
  </body>
</html>