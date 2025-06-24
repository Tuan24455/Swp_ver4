<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Đặt Phòng - Hệ Thống Quản Lý Khách Sạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
      .kpi-card {
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        border: none;
        border-radius: 12px;
      }
      .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
      }
      .page-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 12px;
        padding: 2rem;
        margin-bottom: 2rem;
      }
      .breadcrumb {
        background: rgba(255,255,255,0.1);
        border-radius: 8px;
        padding: 0.5rem 1rem;
      }
      .breadcrumb-item a {
        color: rgba(255,255,255,0.8);
        text-decoration: none;
      }
      .breadcrumb-item.active {
        color: white;
      }
      .chart-container {
        position: relative;
        height: 350px;
      }
      .avatar-sm {
        width: 40px;
        height: 40px;
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="bookingreport" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <jsp:include page="includes/navbar.jsp" />

        <div class="container-fluid py-4">


          <!-- Page Header -->
          <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h1 class="h2 mb-2">Báo Cáo Đặt Phòng</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active">Báo Cáo Đặt Phòng</li>
                  </ol>
                </nav>
              </div>

            </div>
          </div>

          <!-- Date Range Filter -->
          <div class="card shadow-sm mb-4">
            <div class="card-body">
              <div class="row g-3 align-items-end">
                <div class="col-md-3">
                  <label class="form-label">Từ Ngày</label>
                  <input
                    type="date"
                    class="form-control"
                    id="fromDate"
                    value="2025-05-01"
                  />
                </div>
                <div class="col-md-3">
                  <label class="form-label">Đến Ngày</label>
                  <input
                    type="date"
                    class="form-control"
                    id="toDate"
                    value="2025-05-25"
                  />
                </div>
                <div class="col-md-3">
                  <label class="form-label">Loại Phòng</label>
                  <select class="form-select">
                    <option value="">Tất Cả Loại Phòng</option>
                    <option value="standard">Tiêu Chuẩn</option>
                    <option value="deluxe">Cao Cấp</option>
                    <option value="suite">Phòng Suite</option>
                    <option value="presidential">Tổng Thống</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <button
                    class="btn btn-primary w-100"
                    onclick="generateReport()"
                  >
                    <i class="fas fa-chart-line me-2"></i>Lọc
                  </button>
                </div>
              </div>
            </div>
          </div>



          <!-- Room Status Details Table -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0"><i class="fas fa-bed me-2"></i>Chi Tiết Thống Kê Phòng</h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                  <thead class="table-light">
                    <tr>
                      <th><i class="fas fa-info-circle me-1"></i>Trạng Thái Phòng</th>
                      <th><i class="fas fa-hashtag me-1"></i>Số Lượng</th>

                      <th><i class="fas fa-clipboard-list me-1"></i>Mô Tả</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <span class="badge bg-info fs-6 px-3 py-2">
                          <i class="fas fa-building me-1"></i>Tổng Phòng
                        </span>
                      </td>
                      <td><strong class="fs-5 text-info">150</strong></td>

                      <td><span class="text-muted">Tổng số phòng khách sạn</span></td>
                    </tr>
                    <tr>
                      <td>
                        <span class="badge bg-success fs-6 px-3 py-2">
                          <i class="fas fa-user-check me-1"></i>Phòng Đang Dùng
                        </span>
                      </td>
                      <td><strong class="fs-5 text-success">117</strong></td>

                      <td><span class="text-muted">Phòng đang có khách sử dụng</span></td>
                    </tr>
                    <tr>
                      <td>
                        <span class="badge bg-primary fs-6 px-3 py-2">
                          <i class="fas fa-door-open me-1"></i>Phòng Trống
                        </span>
                      </td>
                      <td><strong class="fs-5 text-primary">28</strong></td>

                      <td><span class="text-muted">Sẵn sàng cho khách đặt phòng</span></td>
                    </tr>
                    <tr>
                      <td>
                        <span class="badge bg-warning fs-6 px-3 py-2">
                          <i class="fas fa-tools me-1"></i>Phòng Đang Sửa Chữa
                        </span>
                      </td>
                      <td><strong class="fs-5 text-warning">5</strong></td>

                      <td><span class="text-muted">Đang trong quá trình bảo trì</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
              

            </div>
          </div>

          <!-- Charts Row -->


          <!-- Revenue Analysis -->


          <!-- Current Guests List -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0"><i class="fas fa-users me-2"></i>Danh Sách Khách Hàng Đang Thuê</h5>
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
                      <th><i class="fas fa-calendar-check me-1"></i>Ngày Đặt</th>
                      <th><i class="fas fa-calendar-times me-1"></i>Ngày Trả</th>
                      <th><i class="fas fa-money-bill-wave me-1"></i>Tổng Tiền</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong class="text-primary">P301</strong></td>
                      <td><span class="badge bg-info">Tầng 3</span></td>
                      <td>Phòng Tổng Thống</td>
                      <td><span class="text-muted">4 người</span></td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-2">
                            <i class="fas fa-user text-white"></i>
                          </div>
                          <div>
                            <strong>Nguyễn Văn An</strong>
                            <br><small class="text-muted">0901234567</small>
                          </div>
                        </div>
                      </td>
                      <td><span class="text-success">15/01/2025</span></td>
                      <td><span class="text-danger">18/01/2025</span></td>
                      <td><strong class="text-success">2.250.000 đ</strong></td>
                    </tr>
                    <tr>
                      <td><strong class="text-primary">P201</strong></td>
                      <td><span class="badge bg-info">Tầng 2</span></td>
                      <td>Phòng Suite</td>
                      <td><span class="text-muted">3 người</span></td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="avatar-sm bg-success rounded-circle d-flex align-items-center justify-content-center me-2">
                            <i class="fas fa-user text-white"></i>
                          </div>
                          <div>
                            <strong>Trần Thị Bình</strong>
                            <br><small class="text-muted">0912345678</small>
                          </div>
                        </div>
                      </td>
                      <td><span class="text-success">14/01/2025</span></td>
                      <td><span class="text-danger">20/01/2025</span></td>
                      <td><strong class="text-success">1.800.000 đ</strong></td>
                    </tr>
                    <tr>
                      <td><strong class="text-primary">P102</strong></td>
                      <td><span class="badge bg-info">Tầng 1</span></td>
                      <td>Phòng Cao Cấp</td>
                      <td><span class="text-muted">2 người</span></td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="avatar-sm bg-warning rounded-circle d-flex align-items-center justify-content-center me-2">
                            <i class="fas fa-user text-white"></i>
                          </div>
                          <div>
                            <strong>Lê Minh Cường</strong>
                            <br><small class="text-muted">0923456789</small>
                          </div>
                        </div>
                      </td>
                      <td><span class="text-success">16/01/2025</span></td>
                      <td><span class="text-danger">19/01/2025</span></td>
                      <td><strong class="text-success">1.350.000 đ</strong></td>
                    </tr>
                    <tr>
                      <td><strong class="text-primary">P105</strong></td>
                      <td><span class="badge bg-info">Tầng 1</span></td>
                      <td>Phòng Tiêu Chuẩn</td>
                      <td><span class="text-muted">2 người</span></td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="avatar-sm bg-danger rounded-circle d-flex align-items-center justify-content-center me-2">
                            <i class="fas fa-user text-white"></i>
                          </div>
                          <div>
                            <strong>Phạm Thị Dung</strong>
                            <br><small class="text-muted">0934567890</small>
                          </div>
                        </div>
                      </td>
                      <td><span class="text-success">17/01/2025</span></td>
                      <td><span class="text-danger">21/01/2025</span></td>
                      <td><strong class="text-success">800.000 đ</strong></td>
                    </tr>
                    <tr>
                      <td><strong class="text-primary">P203</strong></td>
                      <td><span class="badge bg-info">Tầng 2</span></td>
                      <td>Phòng Cao Cấp</td>
                      <td><span class="text-muted">2 người</span></td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="avatar-sm bg-info rounded-circle d-flex align-items-center justify-content-center me-2">
                            <i class="fas fa-user text-white"></i>
                          </div>
                          <div>
                            <strong>Hoàng Văn Em</strong>
                            <br><small class="text-muted">0945678901</small>
                          </div>
                        </div>
                      </td>
                      <td><span class="text-success">15/01/2025</span></td>
                      <td><span class="text-danger">22/01/2025</span></td>
                      <td><strong class="text-success">1.575.000 đ</strong></td>
                    </tr>
                  </tbody>
                </table>
              </div>
              
              <!-- Summary Footer -->
              <div class="row mt-3 pt-3 border-top">
                <div class="col-md-6">
                  <div class="d-flex align-items-center">
                    <i class="fas fa-users text-primary me-2"></i>
                    <span class="text-muted">Tổng khách đang lưu trú: <strong class="text-primary">5 khách hàng</strong></span>
                  </div>
                </div>
                <div class="col-md-6 text-end">
                  <div class="d-flex align-items-center justify-content-end">
                    <i class="fas fa-money-bill-wave text-success me-2"></i>
                    <span class="text-muted">Tổng doanh thu dự kiến: <strong class="text-success">7.775.000 đ</strong></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Sidebar toggle functionality
      document
        .getElementById("menu-toggle")
        .addEventListener("click", function () {
          document
            .getElementById("sidebar-wrapper")
            .classList.toggle("toggled");
        });

      // Booking Trends Chart
      const bookingTrendsCtx = document
        .getElementById("bookingTrendsChart")
        .getContext("2d");
      const bookingTrendsChart = new Chart(bookingTrendsCtx, {
        type: "line",
        data: {
          labels: [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ],
          datasets: [
            {
              label: "Bookings",
              data: [85, 92, 78, 105, 120, 135, 150, 142, 128, 115, 98, 88],
              borderColor: "rgb(54, 162, 235)",
              backgroundColor: "rgba(54, 162, 235, 0.1)",
              tension: 0.4,
              fill: true,
            },
            {
              label: "Revenue ($000)",
              data: [
                6.8, 7.4, 6.2, 8.4, 9.6, 10.8, 12.0, 11.4, 10.2, 9.2, 7.8, 7.0,
              ],
              borderColor: "rgb(255, 99, 132)",
              backgroundColor: "rgba(255, 99, 132, 0.1)",
              tension: 0.4,
              fill: true,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: "top",
            },
          },
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });

      // Room Type Distribution Chart
      const roomTypeCtx = document
        .getElementById("roomTypeChart")
        .getContext("2d");
      const roomTypeChart = new Chart(roomTypeCtx, {
        type: "doughnut",
        data: {
          labels: ["Tiêu Chuẩn", "Cao Cấp", "Suite", "Tổng Thống"],
          datasets: [
            {
              data: [45, 30, 20, 5],
              backgroundColor: [
                "rgba(54, 162, 235, 0.8)",
                "rgba(255, 99, 132, 0.8)",
                "rgba(255, 205, 86, 0.8)",
                "rgba(75, 192, 192, 0.8)",
              ],
              borderWidth: 2,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: "bottom",
            },
          },
        },
      });

      // Revenue Chart
      const revenueCtx = document
        .getElementById("revenueChart")
        .getContext("2d");
      const revenueChart = new Chart(revenueCtx, {
        type: "bar",
        data: {
          labels: ["Jan", "Feb", "Mar", "Apr", "May"],
          datasets: [
            {
              label: "Doanh Thu ($)",
              data: [6800, 7400, 6200, 8400, 9600],
              backgroundColor: "rgba(75, 192, 192, 0.8)",
              borderColor: "rgba(75, 192, 192, 1)",
              borderWidth: 1,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false,
            },
          },
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });

      // Status Distribution Chart
      const statusCtx = document.getElementById("statusChart").getContext("2d");
      const statusChart = new Chart(statusCtx, {
        type: "pie",
        data: {
          labels: ["Confirmed", "Pending", "Cancelled", "Completed"],
          datasets: [
            {
              data: [60, 15, 5, 20],
              backgroundColor: [
                "rgba(40, 167, 69, 0.8)",
                "rgba(255, 193, 7, 0.8)",
                "rgba(220, 53, 69, 0.8)",
                "rgba(13, 110, 253, 0.8)",
              ],
              borderWidth: 2,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: "bottom",
            },
          },
        },
      });

      // Export functions
      function exportReport(format) {
        alert(`Exporting report in ${format.toUpperCase()} format...`);
        // Implementation for actual export functionality would go here
      }

      function generateReport() {
        const fromDate = document.getElementById("fromDate").value;
        const toDate = document.getElementById("toDate").value;
        alert(`Generating report from ${fromDate} to ${toDate}...`);
        // Implementation for actual report generation would go here
      }
    </script>
  </body>
</html>