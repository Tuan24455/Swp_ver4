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
              <div class="btn-group">
                <button
                  class="btn btn-primary"
                  onclick="exportReport('pdf')"
                >
                  <i class="fas fa-file-pdf me-2"></i>Xuất PDF
                </button>
                <button
                  class="btn btn-success"
                  onclick="exportReport('excel')"
                >
                  <i class="fas fa-file-excel me-2"></i>Xuất Excel
                </button>
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
                    <i class="fas fa-chart-line me-2"></i>Tạo Báo Cáo
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Summary Cards -->
          <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Tổng Đặt Phòng</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">1,247</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-arrow-up me-1"></i> 12% so với tháng trước
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Doanh Thu</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">$89,450</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-arrow-up me-1"></i> 18% so với tháng trước
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">
                    Thời Gian Lưu Trú TB
                  </h6>
                  <h2 class="card-title display-6 fw-bold mb-1">2.8</h2>
                  <p class="card-text text-info">
                    <i class="fas fa-calendar me-1"></i> ngày mỗi đặt phòng
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Tỷ Lệ Lấp Đầy</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">78%</h2>
                  <p class="card-text text-warning">
                    <i class="fas fa-minus me-1"></i> 2% so với tháng trước
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Charts Row -->
          <div class="row g-4 mb-4">
            <div class="col-lg-8">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Xu Hướng Đặt Phòng</h5>
                </div>
                <div class="card-body">
                  <canvas
                    id="bookingTrendsChart"
                    style="height: 300px"
                  ></canvas>
                </div>
              </div>
            </div>
            <div class="col-lg-4">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Phân Bổ Loại Phòng</h5>
                </div>
                <div class="card-body">
                  <canvas id="roomTypeChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Revenue Analysis -->
          <div class="row g-4 mb-4">
            <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Doanh Thu Hàng Tháng</h5>
                </div>
                <div class="card-body">
                  <canvas id="revenueChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
            <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Booking Status Distribution</h5>
                </div>
                <div class="card-body">
                  <canvas id="statusChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Top Performing Rooms -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">Top Performing Rooms</h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                  <thead class="table-light">
                    <tr>
                      <th>Số Phòng</th>
                      <th>Loại Phòng</th>
                      <th>Tổng Đặt Phòng</th>
                      <th>Doanh Thu Tạo Ra</th>
                      <th>Tỷ Lệ Lấp Đầy</th>
                      <th>Đánh Giá TB</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>301</strong></td>
                      <td>Phòng Tổng Thống</td>
                      <td>45</td>
                      <td>$33,750</td>
                      <td>89%</td>
                      <td>
                        <span class="text-warning">
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          4.8
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>201</strong></td>
                      <td>Phòng Suite</td>
                      <td>67</td>
                      <td>$23,450</td>
                      <td>85%</td>
                      <td>
                        <span class="text-warning">
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="far fa-star"></i>
                          4.6
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>102</strong></td>
                      <td>Phòng Cao Cấp</td>
                      <td>89</td>
                      <td>$16,020</td>
                      <td>82%</td>
                      <td>
                        <span class="text-warning">
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="far fa-star"></i>
                          4.4
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>101</strong></td>
                      <td>Phòng Tiêu Chuẩn</td>
                      <td>112</td>
                      <td>$13,440</td>
                      <td>78%</td>
                      <td>
                        <span class="text-warning">
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="far fa-star"></i>
                          4.2
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
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