<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Doanh Thu - Hệ Thống Quản Lý Khách Sạn</title>
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
      <jsp:include page="/admin/includes/sidebar.jsp">
        <jsp:param name="activePage" value="purchasereport" />
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
                <h1 class="h2 mb-2">Báo Cáo Doanh Thu</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active">Báo Cáo Doanh Thu</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>

          <!-- Summary Cards -->
          <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Tổng Phòng</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">150</h2>
                  <p class="card-text text-info">
                    <i class="fas fa-building me-1"></i> Tổng số phòng khách sạn
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Phòng Đang Dùng</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">117</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-user-check me-1"></i> 78% tỷ lệ lấp đầy
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Phòng Trống</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">28</h2>
                  <p class="card-text text-primary">
                    <i class="fas fa-door-open me-1"></i> Sẵn sàng cho khách
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Phòng Đang Sửa Chữa</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">5</h2>
                  <p class="card-text text-warning">
                    <i class="fas fa-tools me-1"></i> Đang bảo trì
                  </p>
                </div>
              </div>
            </div>
          </div>



          <!-- Additional Services Analysis -->
          <div class="row g-4 mb-4">

            <div class="col-lg-12">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Doanh Thu Phòng</h5>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Loại Phòng</th>
                          <th>Số Đêm</th>
                          <th>Doanh Thu</th>
                          <th>Giá Trung Bình</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td><strong>Phòng Deluxe</strong></td>
                          <td>245</td>
                          <td>$49,000</td>
                          <td>$200.00</td>
                        </tr>
                        <tr>
                          <td><strong>Phòng Standard</strong></td>
                          <td>312</td>
                          <td>$31,200</td>
                          <td>$100.00</td>
                        </tr>
                        <tr>
                          <td><strong>Phòng Suite</strong></td>
                          <td>89</td>
                          <td>$35,600</td>
                          <td>$400.00</td>
                        </tr>
                        <tr>
                          <td><strong>Phòng VIP</strong></td>
                          <td>67</td>
                          <td>$40,200</td>
                          <td>$600.00</td>
                        </tr>
                        <tr>
                          <td><strong>Phòng Family</strong></td>
                          <td>134</td>
                          <td>$40,200</td>
                          <td>$300.00</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Detailed Invoice Report -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">Báo Cáo Hóa Đơn Chi Tiết</h5>
            </div>
            <div class="card-body">
              <!-- Filter Section -->
              <div class="row g-3 mb-4">
                <div class="col-md-2">
                  <label class="form-label">Từ Ngày</label>
                  <input type="date" class="form-control" id="dateFrom" />
                </div>
                <div class="col-md-2">
                  <label class="form-label">Đến Ngày</label>
                  <input type="date" class="form-control" id="dateTo" />
                </div>
                <div class="col-md-2">
                  <label class="form-label">Loại Phòng</label>
                  <select class="form-select" id="roomTypeFilter">
                    <option value="">Tất Cả Loại</option>
                    <option value="standard">Tiêu Chuẩn</option>
                    <option value="deluxe">Cao Cấp</option>
                    <option value="suite">Phòng Suite</option>
                    <option value="presidential">Tổng Thống</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label">Trạng Thái Thanh Toán</label>
                  <select class="form-select" id="paymentStatusFilter">
                    <option value="">Tất Cả Trạng Thái</option>
                    <option value="paid">Đã Thanh Toán</option>
                    <option value="pending">Chờ Thanh Toán</option>
                    <option value="overdue">Quá Hạn</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label">Loại Khách</label>
                  <select class="form-select" id="guestTypeFilter">
                    <option value="">Tất Cả Khách</option>
                    <option value="regular">Thường</option>
                    <option value="vip">VIP</option>
                    <option value="corporate">Doanh Nghiệp</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label">&nbsp;</label>
                  <div class="d-grid">
                    <button
                      class="btn btn-outline-primary"
                      onclick="applyFilters()"
                    >
                      <i class="fas fa-filter me-2"></i>Áp Dụng
                    </button>
                  </div>
                </div>
              </div>

              <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                  <thead class="table-light">
                    <tr>
                      <th>Số Hóa Đơn</th>
                      <th>Tên Khách</th>
                      <th>Phòng</th>
                      <th>Nhận Phòng</th>
                      <th>Trả Phòng</th>
                      <th>Phí Phòng</th>

                      <th>Tổng Tiền</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>INV-2025-001</strong></td>
                      <td>John Smith</td>
                      <td>Deluxe 201</td>
                      <td>2025-05-20</td>
                      <td>2025-05-23</td>
                      <td>$450.00</td>

                      <td><strong>$575.50</strong></td>
                      <td><span class="badge bg-success">Đã Thanh Toán</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="Xem Hóa Đơn"
                            onclick="viewInvoice('INV-2025-001')"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-info"
                            title="In Hóa Đơn"
                            onclick="printInvoice('INV-2025-001')"
                          >
                            <i class="fas fa-print"></i>
                          </button>
                          <button
                            class="btn btn-outline-secondary"
                            title="Download PDF"
                            onclick="downloadInvoice('INV-2025-001')"
                          >
                            <i class="fas fa-download"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>INV-2025-002</strong></td>
                      <td>Maria Garcia</td>
                      <td>Suite 301</td>
                      <td>2025-05-21</td>
                      <td>2025-05-25</td>
                      <td>$800.00</td>

                      <td><strong>$1,045.75</strong></td>
                      <td><span class="badge bg-warning">Pending</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="Xem Hóa Đơn"
                            onclick="viewInvoice('INV-2025-002')"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-info"
                            title="In Hóa Đơn"
                            onclick="printInvoice('INV-2025-002')"
                          >
                            <i class="fas fa-print"></i>
                          </button>
                          <button
                            class="btn btn-outline-secondary"
                            title="Download PDF"
                            onclick="downloadInvoice('INV-2025-002')"
                          >
                            <i class="fas fa-download"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>INV-2025-003</strong></td>
                      <td>David Johnson</td>
                      <td>Standard 105</td>
                      <td>2025-05-22</td>
                      <td>2025-05-24</td>
                      <td>$200.00</td>

                      <td><strong>$245.25</strong></td>
                      <td><span class="badge bg-success">Đã Thanh Toán</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="Xem Hóa Đơn"
                            onclick="viewInvoice('INV-2025-003')"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-info"
                            title="In Hóa Đơn"
                            onclick="printInvoice('INV-2025-003')"
                          >
                            <i class="fas fa-print"></i>
                          </button>
                          <button
                            class="btn btn-outline-secondary"
                            title="Download PDF"
                            onclick="downloadInvoice('INV-2025-003')"
                          >
                            <i class="fas fa-download"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>INV-2025-004</strong></td>
                      <td>Sarah Wilson</td>
                      <td>Presidential 401</td>
                      <td>2025-05-23</td>
                      <td>2025-05-26</td>
                      <td>$1,200.00</td>

                      <td><strong>$1,580.90</strong></td>
                      <td><span class="badge bg-danger">Overdue</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="Xem Hóa Đơn"
                            onclick="viewInvoice('INV-2025-004')"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-info"
                            title="In Hóa Đơn"
                            onclick="printInvoice('INV-2025-004')"
                          >
                            <i class="fas fa-print"></i>
                          </button>
                          <button
                            class="btn btn-outline-secondary"
                            title="Download PDF"
                            onclick="downloadInvoice('INV-2025-004')"
                          >
                            <i class="fas fa-download"></i>
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
                  >Showing 1 to 4 of 1,247 invoices</small
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

    <!-- Invoice Detail Modal -->
    <div
      class="modal fade"
      id="invoiceModal"
      tabindex="-1"
      aria-labelledby="invoiceModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="invoiceModalLabel">Invoice Details</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div id="invoiceDetails">
              <!-- Invoice details will be loaded here -->
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
            <button
              type="button"
              class="btn btn-primary"
              onclick="printCurrentInvoice()"
            >
              <i class="fas fa-print me-2"></i>Print
            </button>
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

      // Revenue Chart
      const revenueCtx = document
        .getElementById("revenueChart")
        .getContext("2d");
      const revenueChart = new Chart(revenueCtx, {
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
              label: "Doanh Thu Phòng",
              data: [
                65000, 72000, 68000, 75000, 82000, 89000, 85000, 92000, 88000,
                95000, 91000, 89320,
              ],
              borderColor: "rgb(54, 162, 235)",
              backgroundColor: "rgba(54, 162, 235, 0.1)",
              tension: 0.4,
              fill: false,
            },
            {
              label: "Dịch Vụ Bổ Sung",
              data: [
                25000, 28000, 26000, 30000, 32000, 35000, 33000, 38000, 36000,
                40000, 38000, 36130,
              ],
              borderColor: "rgb(255, 159, 64)",
              backgroundColor: "rgba(255, 159, 64, 0.1)",
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
              ticks: {
                callback: function (value) {
                  return "$" + value.toLocaleString();
                },
              },
            },
          },
        },
      });

      // Revenue Distribution Chart
      const revenueDistributionCtx = document
        .getElementById("revenueDistributionChart")
        .getContext("2d");
      const revenueDistributionChart = new Chart(revenueDistributionCtx, {
        type: "doughnut",
        data: {
          labels: [
            "Phí Phòng",
            "Dịch Vụ Phòng",
            "Giặt Ủi",
            "Spa",
            "Mini Bar",
            "Khác",
          ],
          datasets: [
            {
              data: [71.2, 12.3, 6.3, 7.1, 2.5, 0.6],
              backgroundColor: [
                "rgba(54, 162, 235, 0.8)",
                "rgba(255, 99, 132, 0.8)",
                "rgba(255, 205, 86, 0.8)",
                "rgba(75, 192, 192, 0.8)",
                "rgba(153, 102, 255, 0.8)",
                "rgba(255, 159, 64, 0.8)",
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

      // Service Usage Chart
      const serviceUsageCtx = document
        .getElementById("serviceUsageChart")
        .getContext("2d");
      const serviceUsageChart = new Chart(serviceUsageCtx, {
        type: "bar",
        data: {
          labels: [
            "Dịch Vụ Phòng",
            "Giặt Ủi",
            "Spa",
            "Mini Bar",
            "WiFi Cao Cấp",
          ],
          datasets: [
            {
              label: "Số Lần Sử Dụng",
              data: [342, 198, 89, 156, 67],
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

      // Functions
      function exportReport(format) {
        alert(`Exporting purchase report in ${format.toUpperCase()} format...`);
        // Implementation for actual export functionality would go here
      }

      function generateInvoiceReport() {
        alert("Generating comprehensive invoice report...");
        // Implementation for actual report generation would go here
      }

      function applyFilters() {
        const dateFrom = document.getElementById("dateFrom").value;
        const dateTo = document.getElementById("dateTo").value;
        const roomType = document.getElementById("roomTypeFilter").value;
        const paymentStatus = document.getElementById(
          "paymentStatusFilter"
        ).value;
        const guestType = document.getElementById("guestTypeFilter").value;

        alert(
          `Applying filters: Date Range=${dateFrom} to ${dateTo}, Room Type=${roomType}, Payment Status=${paymentStatus}, Guest Type=${guestType}`
        );
        // Implementation for actual filtering would go here
      }

      function viewInvoice(invoiceId) {
        // Sample invoice data - in real implementation, this would come from server
        const invoiceData = {
          "INV-2025-001": {
            id: "INV-2025-001",
            guest: "John Smith",
            room: "Deluxe 201",
            checkIn: "2025-05-20",
            checkOut: "2025-05-23",
            roomCharges: 450.0,
            services: [
              { name: "Room Service", amount: 85.5 },
              { name: "Laundry", amount: 40.0 },
            ],
            total: 575.5,
            status: "Paid",
          },
        };

        const invoice = invoiceData[invoiceId];
        if (invoice) {
          let servicesHtml = "";
          invoice.services.forEach((service) => {
            servicesHtml += `
              <tr>
                <td>${service.name}</td>
                <td>$${service.amount.toFixed(2)}</td>
              </tr>
            `;
          });

          document.getElementById("invoiceDetails").innerHTML = `
            <div class="row">
              <div class="col-md-6">
                <h6>Invoice Information</h6>
                <p><strong>Invoice #:</strong> ${invoice.id}</p>
                <p><strong>Guest:</strong> ${invoice.guest}</p>
                <p><strong>Room:</strong> ${invoice.room}</p>
                <p><strong>Status:</strong> <span class="badge bg-success">${
                  invoice.status
                }</span></p>
              </div>
              <div class="col-md-6">
                <h6>Stay Information</h6>
                <p><strong>Check-in:</strong> ${invoice.checkIn}</p>
                <p><strong>Check-out:</strong> ${invoice.checkOut}</p>
                <p><strong>Duration:</strong> 3 nights</p>
              </div>
            </div>
            <hr>
            <h6>Charges Breakdown</h6>
            <table class="table table-sm">
              <thead>
                <tr>
                  <th>Description</th>
                  <th>Amount</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Room Charges (3 nights)</td>
                  <td>$${invoice.roomCharges.toFixed(2)}</td>
                </tr>
                ${servicesHtml}
                <tr class="table-active">
                  <td><strong>Total Amount</strong></td>
                  <td><strong>$${invoice.total.toFixed(2)}</strong></td>
                </tr>
              </tbody>
            </table>
          `;

          const modal = new bootstrap.Modal(
            document.getElementById("invoiceModal")
          );
          modal.show();
        }
      }

      function printInvoice(invoiceId) {
        alert(`Printing invoice ${invoiceId}...`);
        // Implementation for actual printing would go here
      }

      function downloadInvoice(invoiceId) {
        alert(`Downloading invoice ${invoiceId} as PDF...`);
        // Implementation for actual PDF download would go here
      }

      function printCurrentInvoice() {
        alert("Printing current invoice...");
        // Implementation for printing the currently viewed invoice
      }
    </script>
  </body>
</html>