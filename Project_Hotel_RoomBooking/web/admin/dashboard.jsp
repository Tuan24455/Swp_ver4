<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.google.gson.Gson" %>
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
                <!-- Removed refresh and export report buttons as requested -->
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
          </div>          <!-- Revenue Comparison Chart -->
          <div class="row g-4 mb-4">
            <div class="col-xl-8">
              <div class="chart-card">                <div class="d-flex justify-content-between align-items-center mb-3">
                  <h5 class="card-title mb-0">Doanh Thu Đặt Phòng vs Doanh Thu Dịch Vụ</h5>
                  <div class="chart-legend d-flex gap-3">
                    <div class="d-flex align-items-center">
                      <div class="legend-color" style="width: 12px; height: 12px; background-color: #ff6b9d; margin-right: 5px;"></div>
                      <small>Doanh Thu Đặt Phòng</small>
                    </div>
                    <div class="d-flex align-items-center">
                      <div class="legend-color" style="width: 12px; height: 12px; background-color: #4ecdc4; margin-right: 5px;"></div>
                      <small>Doanh Thu Dịch Vụ</small>
                    </div>
                  </div>
                </div>
                <div class="chart-container" style="position: relative; width: 100%; height: 400px;">
                  <canvas id="revenueComparisonChart"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Bookings -->
          <div class="row g-4 mb-4">
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>    <script src="js/dashboard.js"></script>    <script>
      // Initialize revenue comparison chart
      document.addEventListener('DOMContentLoaded', function() {
          const ctx = document.getElementById('revenueComparisonChart').getContext('2d');
          
          // Prepare chart data with server data or fallback to sample data
          var labels = [], roomAmounts = [], serviceAmounts = [];
          
          // Check if we have server data
          <c:choose>
            <c:when test="${not empty yearlyRevenueData and not empty yearlyRevenueData.years}">
              // Use server data
              <c:forEach var="year" items="${yearlyRevenueData.years}">
                labels.push("${year}");
              </c:forEach>
              <c:forEach var="amount" items="${yearlyRevenueData.roomAmounts}">
                roomAmounts.push(${amount});
              </c:forEach>
              <c:forEach var="amount" items="${yearlyRevenueData.serviceAmounts}">
                serviceAmounts.push(${amount});
              </c:forEach>
            </c:when>
            <c:otherwise>
              // Fallback sample data if no server data
              labels = ['2020', '2021', '2022', '2023', '2024'];
              roomAmounts = [53000000, 117000000, 79000000, 56000000, 45000000];
              serviceAmounts = [43000000, 105000000, 76000000, 50000000, 33000000];
            </c:otherwise>
          </c:choose>
          
          const chartData = {
              labels: labels,
              datasets: [{
                  label: 'Doanh Thu Đặt Phòng',
                  data: roomAmounts,
                  backgroundColor: '#ff6b9d',
                  borderColor: '#ff6b9d',
                  borderWidth: 1
              }, {
                  label: 'Doanh Thu Dịch Vụ',
                  data: serviceAmounts,
                  backgroundColor: '#4ecdc4',
                  borderColor: '#4ecdc4',
                  borderWidth: 1
              }]
          };

          const config = {
              type: 'bar',
              data: chartData,
              options: {
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                      legend: {
                          display: false
                      },
                      title: {
                          display: true,
                          text: 'Doanh Thu Đặt Phòng vs Doanh Thu Dịch Vụ',
                          font: {
                              size: 16,
                              weight: 'normal'
                          },
                          color: '#6c757d'
                      }
                  },
                  scales: {
                      y: {
                          beginAtZero: true,
                          ticks: {
                              stepSize: 20000000,
                              font: {
                                  size: 12
                              },
                              color: '#6c757d',
                              callback: function(value) {
                                  return (value / 1000000).toLocaleString() + 'M đ';
                              }
                          },
                          grid: {
                              color: '#e9ecef'
                          }
                      },
                      x: {
                          ticks: {
                              font: {
                                  size: 12
                              },
                              color: '#6c757d'
                          },
                          grid: {
                              display: false
                          }
                      }
                  },
                  elements: {
                      bar: {
                          borderRadius: 2
                      }
                  },
                  interaction: {
                      intersect: false,
                      mode: 'index'
                  }
              }
          };

          new Chart(ctx, config);
      });
    </script>
    <script>
      // Calculate and display total revenue
      document.addEventListener('DOMContentLoaded', function() {
          // Get room revenue and service revenue values from server
          var roomRevenue = ${roomRevenue != null ? roomRevenue : 0};
          var serviceRevenue = ${serviceRevenue != null ? serviceRevenue : 0};
          
          // Calculate total revenue
          var totalRevenue = roomRevenue + serviceRevenue;
          
          // Format the total revenue as Vietnamese currency
          var formattedTotal = new Intl.NumberFormat('vi-VN', {
              style: 'currency',
              currency: 'VND',
              maximumFractionDigits: 0
          }).format(totalRevenue);
          
          // Find the total revenue display element and update it
          var totalRevenueElement = document.querySelector('h3.h4.mb-1');
          if (totalRevenueElement) {
              totalRevenueElement.textContent = formattedTotal;
          }
      });
    </script><!-- Room Status Modals -->
    <!-- Occupied Rooms Modal -->
    <div class="modal fade" id="occupiedModal" tabindex="-1" aria-labelledby="occupiedModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="occupiedModalLabel">Phòng Đã Đặt</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <c:choose>
              <c:when test="${not empty occupiedRoomsList}">
                <table class="table">
                  <thead>
                    <tr><th>Số phòng</th><th>Tầng</th><th>Tên khách hàng</th></tr>
                  </thead>
                  <tbody>
                    <c:forEach var="room" items="${occupiedRoomsList}">
                      <tr>
                        <td>${room.roomNumber}</td>
                        <td>${room.floor}</td>
                        <td>${room.customerName}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="text-center py-4">
                  <i class="fas fa-bed fa-3x text-muted mb-3"></i>
                  <p class="text-muted">Hiện tại không có phòng nào đã được đặt.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <!-- Vacant Rooms Modal -->
    <div class="modal fade" id="vacantModal" tabindex="-1" aria-labelledby="vacantModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="vacantModalLabel">Phòng Trống</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <c:choose>
              <c:when test="${not empty vacantRoomsList}">
                <table class="table">
                  <thead>
                    <tr><th>Số phòng</th><th>Tầng</th></tr>
                  </thead>
                  <tbody>
                    <c:forEach var="room" items="${vacantRoomsList}">
                      <tr>
                        <td>${room.roomNumber}</td>
                        <td>${room.floor}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="text-center py-4">
                  <i class="fas fa-door-open fa-3x text-muted mb-3"></i>
                  <p class="text-muted">Hiện tại không có phòng trống.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <!-- Maintenance Rooms Modal -->
    <div class="modal fade" id="maintenanceModal" tabindex="-1" aria-labelledby="maintenanceModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="maintenanceModalLabel">Phòng Bảo Trì</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <c:choose>
              <c:when test="${not empty maintenanceRoomsList}">
                <table class="table">
                  <thead>
                    <tr><th>Số phòng</th><th>Tầng</th></tr>
                  </thead>
                  <tbody>
                    <c:forEach var="room" items="${maintenanceRoomsList}">
                      <tr>
                        <td>${room.roomNumber}</td>
                        <td>${room.floor}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="text-center py-4">
                  <i class="fas fa-tools fa-3x text-muted mb-3"></i>
                  <p class="text-muted">Hiện tại không có phòng đang bảo trì.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

<script>
  // Calculate and display total revenue
  document.addEventListener('DOMContentLoaded', function() {
      // Get room revenue and service revenue values from server
      var roomRevenue = <c:out value="${roomRevenue != null ? roomRevenue : 0}" />;
      var serviceRevenue = <c:out value="${serviceRevenue != null ? serviceRevenue : 0}" />;
      
      // Calculate total revenue
      var totalRevenue = roomRevenue + serviceRevenue;
      
      // Format the total revenue as Vietnamese currency
      var formattedTotal = new Intl.NumberFormat('vi-VN', {
          style: 'currency',
          currency: 'VND',
          maximumFractionDigits: 0
      }).format(totalRevenue);
      
      // Find the total revenue display element and update it
      var totalRevenueElement = document.querySelector('h3.h4.mb-1');
      if (totalRevenueElement) {
          totalRevenueElement.textContent = formattedTotal;
      }
  });
</script>

<script>
  function showRoomsModal(status) {
    console.log('Clicked on:', status); // Debug log
    var modalId = status + 'Modal';
    var modalEl = document.getElementById(modalId);
    console.log('Modal element:', modalEl); // Debug log
    if (modalEl) {
      var modal = new bootstrap.Modal(modalEl);
      modal.show();
    } else {
      console.error('Modal not found:', modalId);
    }
  }
</script>
  </body>
</html>
