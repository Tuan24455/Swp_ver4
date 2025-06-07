<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Stock Reports - Hotel Management System</title>
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
        <jsp:param name="activePage" value="stockreport" />
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
          <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h1 class="h2 mb-2">Inventory & Stock Reports</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Home</a></li>
                    <li class="breadcrumb-item active">Stock Reports</li>
                  </ol>
                </nav>
              </div>
              <div class="btn-group">
                <button
                  class="btn btn-light"
                  onclick="exportReport('pdf')"
                >
                  <i class="fas fa-file-pdf me-2"></i>Export PDF
                </button>
                <button
                  class="btn btn-light"
                  onclick="exportReport('excel')"
                >
                  <i class="fas fa-file-excel me-2"></i>Export Excel
                </button>
                <button
                  class="btn btn-light"
                  onclick="generateStockAlert()"
                >
                  <i class="fas fa-exclamation-triangle me-2"></i>Stock Alerts
                </button>
              </div>
            </div>
          </div>

          <!-- Summary Cards -->
          <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Total Items</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">1,247</h2>
                  <p class="card-text text-info">
                    <i class="fas fa-boxes me-1"></i> Across all categories
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Low Stock Items</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">23</h2>
                  <p class="card-text text-danger">
                    <i class="fas fa-exclamation-triangle me-1"></i> Needs
                    reorder
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Stock Value</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">$89,450</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-dollar-sign me-1"></i> Total inventory
                    value
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Monthly Usage</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">$12,340</h2>
                  <p class="card-text text-warning">
                    <i class="fas fa-chart-line me-1"></i> This month
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
                  <h5 class="mb-0">Stock Movement Trends</h5>
                </div>
                <div class="card-body">
                  <canvas
                    id="stockMovementChart"
                    style="height: 300px"
                  ></canvas>
                </div>
              </div>
            </div>
            <div class="col-lg-4">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Category Distribution</h5>
                </div>
                <div class="card-body">
                  <canvas
                    id="categoryDistributionChart"
                    style="height: 300px"
                  ></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Stock Alerts -->
          <div class="row g-4 mb-4">
            <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div
                  class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Low Stock Alerts</h5>
                  <span class="badge bg-danger">23 Items</span>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Item</th>
                          <th>Current Stock</th>
                          <th>Min. Required</th>
                          <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td><strong>Towels (Bath)</strong></td>
                          <td><span class="text-danger">15</span></td>
                          <td>50</td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="fas fa-shopping-cart"></i> Reorder
                            </button>
                          </td>
                        </tr>
                        <tr>
                          <td><strong>Bed Sheets</strong></td>
                          <td><span class="text-danger">8</span></td>
                          <td>30</td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="fas fa-shopping-cart"></i> Reorder
                            </button>
                          </td>
                        </tr>
                        <tr>
                          <td><strong>Toilet Paper</strong></td>
                          <td><span class="text-warning">25</span></td>
                          <td>100</td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="fas fa-shopping-cart"></i> Reorder
                            </button>
                          </td>
                        </tr>
                        <tr>
                          <td><strong>Shampoo</strong></td>
                          <td><span class="text-danger">12</span></td>
                          <td>40</td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="fas fa-shopping-cart"></i> Reorder
                            </button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Top Consumed Items</h5>
                </div>
                <div class="card-body">
                  <canvas id="topConsumedChart" style="height: 300px"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Detailed Stock Report -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">Detailed Stock Report</h5>
            </div>
            <div class="card-body">
              <!-- Filter Section -->
              <div class="row g-3 mb-4">
                <div class="col-md-3">
                  <label class="form-label">Category</label>
                  <select class="form-select" id="categoryFilter">
                    <option value="">All Categories</option>
                    <option value="housekeeping">Housekeeping</option>
                    <option value="fnb">F&B</option>
                    <option value="maintenance">Maintenance</option>
                    <option value="textiles">Textiles</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <label class="form-label">Stock Status</label>
                  <select class="form-select" id="statusFilter">
                    <option value="">All Status</option>
                    <option value="in-stock">In Stock</option>
                    <option value="low-stock">Low Stock</option>
                    <option value="out-of-stock">Out of Stock</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <label class="form-label">Supplier</label>
                  <select class="form-select" id="supplierFilter">
                    <option value="">All Suppliers</option>
                    <option value="hotel-supplies">Hotel Supplies Co.</option>
                    <option value="linen-express">Linen Express</option>
                    <option value="maintenance-pro">Maintenance Pro</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <label class="form-label">&nbsp;</label>
                  <div class="d-grid">
                    <button
                      class="btn btn-outline-primary"
                      onclick="applyFilters()"
                    >
                      <i class="fas fa-filter me-2"></i>Apply Filters
                    </button>
                  </div>
                </div>
              </div>

              <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                  <thead class="table-light">
                    <tr>
                      <th>Item Code</th>
                      <th>Item Name</th>
                      <th>Category</th>
                      <th>Current Stock</th>
                      <th>Min. Stock</th>
                      <th>Unit Price</th>
                      <th>Total Value</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>HK001</strong></td>
                      <td>Bath Towels</td>
                      <td>Housekeeping</td>
                      <td>15</td>
                      <td>50</td>
                      <td>$12.50</td>
                      <td>$187.50</td>
                      <td><span class="badge bg-danger">Low Stock</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-warning" title="Edit">
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-success"
                            title="Reorder"
                          >
                            <i class="fas fa-shopping-cart"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>HK002</strong></td>
                      <td>Bed Sheets</td>
                      <td>Housekeeping</td>
                      <td>8</td>
                      <td>30</td>
                      <td>$25.00</td>
                      <td>$200.00</td>
                      <td><span class="badge bg-danger">Low Stock</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-warning" title="Edit">
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-success"
                            title="Reorder"
                          >
                            <i class="fas fa-shopping-cart"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>FB001</strong></td>
                      <td>Coffee Beans</td>
                      <td>F&B</td>
                      <td>45</td>
                      <td>20</td>
                      <td>$18.00</td>
                      <td>$810.00</td>
                      <td><span class="badge bg-success">In Stock</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-warning" title="Edit">
                            <i class="fas fa-edit"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>MT001</strong></td>
                      <td>Light Bulbs</td>
                      <td>Maintenance</td>
                      <td>120</td>
                      <td>50</td>
                      <td>$3.50</td>
                      <td>$420.00</td>
                      <td><span class="badge bg-success">In Stock</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-warning" title="Edit">
                            <i class="fas fa-edit"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div
                class="d-flex justify-content-between align-items-center mt-3 flex-wrap"
              >
                <small class="text-muted mb-2 mb-md-0"
                  >Showing 1 to 4 of 1,247 entries</small
                >
                <nav aria-label="Page navigation">
                  <ul class="pagination pagination-sm mb-0">
                    <li class="page-item disabled">
                      <a class="page-link" href="#">Previous</a>
                    </li>
                    <li class="page-item active">
                      <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">2</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">3</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">Next</a>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Sidebar toggle functionality
      document
        .getElementById("menu-toggle")
        .addEventListener("click", function () {
          document
            .getElementById("sidebar-wrapper")
            .classList.toggle("toggled");
        });

      // Stock Movement Chart
      const stockMovementCtx = document
        .getElementById("stockMovementChart")
        .getContext("2d");
      const stockMovementChart = new Chart(stockMovementCtx, {
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
              label: "Stock In",
              data: [
                120, 150, 180, 140, 160, 190, 170, 200, 180, 160, 140, 130,
              ],
              borderColor: "rgb(75, 192, 192)",
              backgroundColor: "rgba(75, 192, 192, 0.1)",
              tension: 0.4,
              fill: false,
            },
            {
              label: "Stock Out",
              data: [
                100, 130, 160, 120, 140, 170, 150, 180, 160, 140, 120, 110,
              ],
              borderColor: "rgb(255, 99, 132)",
              backgroundColor: "rgba(255, 99, 132, 0.1)",
              tension: 0.4,
              fill: false,
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

      // Category Distribution Chart
      const categoryDistributionCtx = document
        .getElementById("categoryDistributionChart")
        .getContext("2d");
      const categoryDistributionChart = new Chart(categoryDistributionCtx, {
        type: "doughnut",
        data: {
          labels: [
            "Housekeeping",
            "F&B",
            "Maintenance",
            "Textiles",
            "Technology",
          ],
          datasets: [
            {
              data: [40, 25, 20, 10, 5],
              backgroundColor: [
                "rgba(54, 162, 235, 0.8)",
                "rgba(255, 99, 132, 0.8)",
                "rgba(255, 205, 86, 0.8)",
                "rgba(75, 192, 192, 0.8)",
                "rgba(153, 102, 255, 0.8)",
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

      // Top Consumed Chart
      const topConsumedCtx = document
        .getElementById("topConsumedChart")
        .getContext("2d");
      const topConsumedChart = new Chart(topConsumedCtx, {
        type: "bar",
        data: {
          labels: ["Towels", "Bed Sheets", "Toilet Paper", "Shampoo", "Coffee"],
          datasets: [
            {
              label: "Units Consumed",
              data: [450, 320, 280, 180, 150],
              backgroundColor: "rgba(255, 159, 64, 0.8)",
              borderColor: "rgba(255, 159, 64, 1)",
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

      // Functions
      function exportReport(format) {
        alert(`Exporting stock report in ${format.toUpperCase()} format...`);
        // Implementation for actual export functionality would go here
      }

      function generateStockAlert() {
        alert("Generating stock alerts for low inventory items...");
        // Implementation for actual stock alert generation would go here
      }

      function applyFilters() {
        const category = document.getElementById("categoryFilter").value;
        const status = document.getElementById("statusFilter").value;
        const supplier = document.getElementById("supplierFilter").value;

        alert(
          `Applying filters: Category=${category}, Status=${status}, Supplier=${supplier}`
        );
        // Implementation for actual filtering would go here
      }
    </script>
  </body>
</html>
