<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - Hệ Thống Quản Lý Khách Sạn</title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link
      href="${pageContext.request.contextPath}/css/dashboard.css"
      rel="stylesheet"
    />
    <link
      href="${pageContext.request.contextPath}/css/admin-dashboard.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <!-- Sidebar -->
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <jsp:include page="includes/navbar.jsp" />

        <div class="container-fluid py-4">
          <!-- Error Message -->
          <c:if test="${not empty errorMessage}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Dashboard Header -->
          <div class="dashboard-header">
            <div class="row align-items-center">
              <div class="col-md-8">
                <h1 class="h2 mb-2">Dashboard Quản Lý Khách Sạn</h1>
                <p class="mb-0 opacity-75">
                  Tổng quan hoạt động kinh doanh và vận hành khách sạn
                </p>
              </div>
              <div class="col-md-4 text-end">
                <div class="d-flex justify-content-end gap-2">
                  <button
                    class="btn btn-primary btn-sm"
                    onclick="refreshData()"
                  >
                    <i class="fas fa-sync-alt"></i> Làm mới
                  </button>
                  <button
                    class="btn btn-outline-secondary btn-sm"
                    onclick="exportReport()"
                  >
                    <i class="fas fa-download"></i> Xuất báo cáo
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- KPI Cards -->
          <%-- Calculate KPI values from request attributes --%>
          <c:set var="occupiedRooms" value="${roomStatusCounts['Occupied'] != null ? roomStatusCounts['Occupied'] : 0}" />
<c:set var="vacantRooms" value="${roomStatusCounts['Vacant'] != null ? roomStatusCounts['Vacant'] : 0}" />
<c:set var="maintenanceRooms" value="${roomStatusCounts['Maintenance'] != null ? roomStatusCounts['Maintenance'] : 0}" />
<c:set var="cleaningRooms" value="${roomStatusCounts['Cleaning'] != null ? roomStatusCounts['Cleaning'] : 0}" />
          <c:if test="${totalRooms > 0}">
            <c:set var="occupancyRate">
                <fmt:formatNumber value="${(occupiedRooms / totalRooms) * 100}" maxFractionDigits="1" />
            </c:set>
          </c:if>
          <c:if test="${totalRooms == 0}">
              <c:set var="occupancyRate" value="0" />
          </c:if>

          <div class="row g-4 mb-4">
            <!-- Tổng Doanh Thu -->
            <div class="col-xl-3 col-md-6">
              <div class="kpi-card">
                <div class="d-flex justify-content-between align-items-start">
                  <div class="w-100">
                    <div class="kpi-icon bg-primary bg-opacity-10">
                      <i class="fas fa-dollar-sign text-primary"></i>
                    </div>
                    <h3 class="h4 mb-1"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></h3>
                    <p class="text-muted mb-2">Tổng Doanh Thu</p>
                    <div class="revenue-breakdown">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <small class="text-muted">Tổng Doanh Thu Đặt Phòng</small>
                        <small class="fw-bold"><fmt:formatNumber value="${roomRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></small>
                      </div>
                      <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">Tổng Doanh Thu Dịch Vụ</small>
                        <small class="fw-bold"><fmt:formatNumber value="${serviceRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></small>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Tỷ Lệ Lấp Đầy -->
            <div class="col-xl-3 col-md-6">
              <div class="kpi-card">
                <div class="d-flex justify-content-between align-items-start">
                  <div>
                    <div class="kpi-icon bg-success bg-opacity-10">
                      <i class="fas fa-bed text-success"></i>
                    </div>
                    <h3 class="h4 mb-1">${occupancyRate}%</h3>
                    <p class="text-muted mb-2">Tỷ Lệ Lấp Đầy</p>
                    <div class="d-flex align-items-center">
                      <small class="text-muted"
                        >${occupiedRooms}/${totalRooms}
                        phòng</small
                      >
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Tổng Phòng -->
            <div class="col-xl-3 col-md-6">
              <div class="kpi-card">
                <div class="d-flex justify-content-between align-items-start">
                  <div>
                    <div class="kpi-icon bg-info bg-opacity-10">
                      <i class="fas fa-door-open text-info"></i>
                    </div>
                    <h3 class="h4 mb-1">${totalRooms}</h3>
                    <p class="text-muted mb-2">Tổng Số Phòng</p>
                    <div class="d-flex align-items-center">
                      <small class="text-success me-2"
                        >${occupiedRooms} đang sử dụng</small
                      >
                      <small class="text-warning">${vacantRooms} trống</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Đánh Giá Trung Bình -->
            <div class="col-xl-3 col-md-6">
              <div class="kpi-card">
                <div class="d-flex justify-content-between align-items-start">
                  <div>
                    <div class="kpi-icon bg-warning bg-opacity-10">
                      <i class="fas fa-star text-warning"></i>
                    </div>
                    <div class="d-flex gap-3">
                      <div>
                        <h3 class="h4 mb-1"><fmt:formatNumber value="${avgRoomRating}" maxFractionDigits="1" />/5</h3>
                        <p class="text-muted mb-2">Đánh Giá Phòng</p>
                      </div>
                      <div>
                        <h3 class="h4 mb-1"><fmt:formatNumber value="${avgServiceRating}" maxFractionDigits="1" />/5</h3>
                        <p class="text-muted mb-2">Đánh Giá Service</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Charts Row -->
          <div class="row g-4 mb-4">
            <!-- Revenue Chart -->
            <div class="col-xl-8">
              <div class="chart-card">
                <div
                  class="d-flex justify-content-between align-items-center mb-3"
                >
                  <h5 class="card-title mb-0">
                    Phân Tích Doanh Thu & Đặt Phòng
                  </h5>
                  <div class="btn-group" role="group">
                    <button
                      type="button"
                      class="btn btn-outline-primary btn-period active"
                      onclick="updateChart('weekly')"
                    >
                      Tuần
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-primary btn-period"
                      onclick="updateChart('monthly')"
                    >
                      Tháng
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-primary btn-period"
                      onclick="updateChart('yearly')"
                    >
                      Năm
                    </button>
                  </div>
                </div>
                <div class="chart-container">
                  <canvas id="revenueChart"></canvas>
                </div>
              </div>
            </div>

            <!-- Room Status Chart -->
            <div class="col-xl-4">
              <div class="chart-card">
                <h5 class="card-title mb-3">Trạng Thái Phòng</h5>
                <div class="chart-container" style="height: 300px">
                  <canvas id="roomStatusChart"></canvas>
                </div>
                <div class="mt-3">
                  <div class="row text-center">
                    <div class="col-4">
                      <div class="text-success">
                        <strong>${occupiedRooms}</strong>
                        <small class="d-block text-muted">Đã Đặt</small>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="text-primary">
                        <strong>${vacantRooms}</strong>
                        <small class="d-block text-muted">Trống</small>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="text-warning">
                        <strong>${maintenanceRooms}</strong>
                        <small class="d-block text-muted">Bảo Trì</small>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Stats & Recent Activity -->
          <div class="row g-4 mb-4">


            <!-- Recent Bookings -->
            <div class="col-xl-8">
              <div class="table-card">
                <div class="card-header bg-white border-0 pb-0">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <h5 class="mb-0">Đặt Phòng Gần Đây</h5>
                    <a
                      href="bookings.jsp"
                      class="btn btn-sm btn-outline-primary"
                      >Xem Tất Cả</a
                    >
                  </div>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-hover">
                      <thead class="table-light">
                        <tr>
                          <th>Số phòng</th>
                          <th>Tầng</th>
                          <th>Loại phòng</th>
                          <th>Tên khách hàng</th>
                          <th>Ngày đặt</th>
                          <th>Ngày trả</th>
                          <th>Tổng tiền</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach items="${recentBookings}" var="booking">
                          <tr>
                            <td><strong>${booking.roomNumber}</strong></td>
                            <td>
                              <span class="badge bg-info"
                                >Tầng ${booking.floor}</span
                              >
                            </td>
                            <td>${booking.roomType}</td>
                            <td>
                              <div class="d-flex align-items-center">
                                <div
                                  class="avatar-sm bg-primary bg-opacity-10 rounded-circle me-2 d-flex align-items-center justify-content-center"
                                >
                                  <i class="fas fa-user text-primary"></i>
                                </div>
                                <div>
                                  <div class="fw-semibold">
                                    ${booking.customerName}
                                  </div>
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
                </div>
              </div>
              <!-- Summary Footer -->


        </div>
      </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
      <div id="notificationToast" class="toast" role="alert">
        <div class="toast-header">
          <i class="fas fa-bell text-primary me-2"></i>
          <strong class="me-auto">Thông Báo</strong>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="toast"
          ></button>
        </div>
        <div class="toast-body" id="toastMessage">
          <!-- Toast message will be inserted here -->
        </div>
      </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="js/dashboard.js"></script>

    <script>
      // Initialize room status chart with server data after page load
      document.addEventListener('DOMContentLoaded', function() {
          // Wait for dashboard.js to initialize charts, then update with server data
          setTimeout(() => {
              if (window.initRoomStatusWithServerData) {
                  window.initRoomStatusWithServerData(${occupiedRooms}, ${vacantRooms}, ${maintenanceRooms});
              }
          }, 500);
      });
    </script>
  </body>
</html>
