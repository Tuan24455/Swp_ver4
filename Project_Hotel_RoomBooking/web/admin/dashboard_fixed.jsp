<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Hotel Management</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <link
      href="${pageContext.request.contextPath}/css/style.css"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <nav
          class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
        >
          <div class="container-fluid">
            <button class="btn btn-outline-secondary" id="menu-toggle">
              <i class="fas fa-bars"></i>
            </button>
          </div>
        </nav>

        <div class="container-fluid py-4">
          <!-- Page Header -->
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">Dashboard</h1>
            <div class="btn-group">
              <button class="btn btn-outline-primary">
                <i class="fas fa-download me-2"></i>Export Report
              </button>
            </div>
          </div>

          <!-- Summary Cards -->
          <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Total Rooms</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">150</h2>
                  <p class="card-text text-info">
                    <i class="fas fa-bed me-1"></i> Active rooms
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Occupied Rooms</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">120</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-arrow-up me-1"></i> 80% occupancy
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Total Bookings</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">1,247</h2>
                  <p class="card-text text-primary">
                    <i class="fas fa-calendar me-1"></i> This month
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Monthly Revenue</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">$125K</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-arrow-up me-1"></i> +15% vs last month
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
                  <h5 class="mb-0">Revenue Trends</h5>
                </div>
                <div class="card-body">
                  <canvas id="revenueChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
            <div class="col-lg-4">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Room Status</h5>
                </div>
                <div class="card-body">
                  <canvas id="roomStatusChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Activity -->
          <div class="row g-4">
            <div class="col-lg-8">
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Recent Bookings</h5>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Guest Name</th>
                          <th>Room</th>
                          <th>Check-in</th>
                          <th>Check-out</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>John Smith</td>
                          <td>Deluxe 201</td>
                          <td>2025-05-25</td>
                          <td>2025-05-28</td>
                          <td><span class="badge bg-success">Confirmed</span></td>
                        </tr>
                        <tr>
                          <td>Maria Garcia</td>
                          <td>Suite 301</td>
                          <td>2025-05-26</td>
                          <td>2025-05-30</td>
                          <td><span class="badge bg-warning">Pending</span></td>
                        </tr>
                        <tr>
                          <td>David Johnson</td>
                          <td>Standard 105</td>
                          <td>2025-05-27</td>
                          <td>2025-05-29</td>
                          <td><span class="badge bg-success">Confirmed</span></td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-4">
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <a href="bookings.jsp" class="btn btn-outline-primary">
                      <i class="fas fa-plus me-2"></i>New Booking
                    </a>
                    <a href="roomstatus.jsp" class="btn btn-outline-info">
                      <i class="fas fa-bed me-2"></i>Room Status
                    </a>
                    <a href="users.jsp" class="btn btn-outline-success">
                      <i class="fas fa-users me-2"></i>Manage Users
                    </a>
                    <a href="purchasereport.jsp" class="btn btn-outline-warning">
                      <i class="fas fa-chart-bar me-2"></i>View Reports
                    </a>
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

      // Revenue Chart
      const revenueCtx = document
        .getElementById("revenueChart")
        .getContext("2d");
      const revenueChart = new Chart(revenueCtx, {
        type: "line",
        data: {
          labels: ["Jan", "Feb", "Mar", "Apr", "May"],
          datasets: [
            {
              label: "Revenue ($)",
              data: [85000, 92000, 78000, 105000, 125000],
              borderColor: "rgb(54, 162, 235)",
              backgroundColor: "rgba(54, 162, 235, 0.1)",
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
              ticks: {
                callback: function (value) {
                  return "$" + value.toLocaleString();
                },
              },
            },
          },
        },
      });

      // Room Status Chart
      const roomStatusCtx = document
        .getElementById("roomStatusChart")
        .getContext("2d");
      const roomStatusChart = new Chart(roomStatusCtx, {
        type: "doughnut",
        data: {
          labels: ["Occupied", "Available", "Maintenance", "Cleaning"],
          datasets: [
            {
              data: [120, 20, 5, 5],
              backgroundColor: [
                "rgba(40, 167, 69, 0.8)",
                "rgba(13, 110, 253, 0.8)",
                "rgba(220, 53, 69, 0.8)",
                "rgba(255, 193, 7, 0.8)",
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
    </script>
  </body>
</html>