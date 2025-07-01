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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/css/purchasereport.css" rel="stylesheet" />
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
                  <h2 class="card-title display-6 fw-bold mb-1">${totalRooms}</h2>
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
                  <h2 class="card-title display-6 fw-bold mb-1">${occupiedRooms}</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-user-check me-1"></i> 
                    <c:if test="${totalRooms > 0}">
                      <fmt:formatNumber value="${(occupiedRooms / totalRooms) * 100}" maxFractionDigits="0"/>% tỷ lệ lấp đầy
                    </c:if>
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Phòng Trống</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">${availableRooms}</h2>
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
                  <h2 class="card-title display-6 fw-bold mb-1">${maintenanceRooms}</h2>
                  <p class="card-text text-warning">
                    <i class="fas fa-tools me-1"></i> Đang bảo trì
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Additional Services Analysis -->

          <!-- Additional Services Analysis -->
          <div class="row g-4 mb-4">
            <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Dịch Vụ Bổ Sung Hàng Đầu</h5>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Dịch Vụ</th>
                          <th>Số Lần Sử Dụng</th>
                          <th>Doanh Thu</th>
                          <th>Giá Trung Bình</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td><strong>Dịch Vụ Phòng</strong></td>
                          <td>342</td>
                          <td>$15,480</td>
                          <td>$45.26</td>
                        </tr>
                        <tr>
                          <td><strong>Dịch Vụ Giặt Ủi</strong></td>
                          <td>198</td>
                          <td>$7,920</td>
                          <td>$40.00</td>
                        </tr>
                        <tr>
                          <td><strong>Dịch Vụ Spa</strong></td>
                          <td>89</td>
                          <td>$8,900</td>
                          <td>$100.00</td>
                        </tr>
                        <tr>
                          <td><strong>Mini Bar</strong></td>
                          <td>156</td>
                          <td>$3,120</td>
                          <td>$20.00</td>
                        </tr>
                        <tr>
                          <td><strong>WiFi Cao Cấp</strong></td>
                          <td>67</td>
                          <td>$670</td>
                          <td>$10.00</td>
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
                    <button class="btn btn-outline-primary" onclick="applyFilters()">
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
                      <th>Dịch Vụ Bổ Sung</th>
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
                      <td>$125.50</td>
                      <td><strong>$575.50</strong></td>
                      <td><span class="badge bg-success">Đã Thanh Toán</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button class="btn btn-outline-primary" title="Xem Hóa Đơn" onclick="viewInvoice('INV-2025-001')">
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-info" title="In Hóa Đơn" onclick="printInvoice('INV-2025-001')">
                            <i class="fas fa-print"></i>
                          </button>
                          <button class="btn btn-outline-secondary" title="Download PDF" onclick="downloadInvoice('INV-2025-001')">
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
                      <td>$245.75</td>
                      <td><strong>$1,045.75</strong></td>
                      <td><span class="badge bg-warning">Pending</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button class="btn btn-outline-primary" title="Xem Hóa Đơn" onclick="viewInvoice('INV-2025-002')">
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-info" title="In Hóa Đơn" onclick="printInvoice('INV-2025-002')">
                            <i class="fas fa-print"></i>
                          </button>
                          <button class="btn btn-outline-secondary" title="Download PDF" onclick="downloadInvoice('INV-2025-002')">
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
                      <td>$45.25</td>
                      <td><strong>$245.25</strong></td>
                      <td><span class="badge bg-success">Đã Thanh Toán</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button class="btn btn-outline-primary" title="Xem Hóa Đơn" onclick="viewInvoice('INV-2025-003')">
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-info" title="In Hóa Đơn" onclick="printInvoice('INV-2025-003')">
                            <i class="fas fa-print"></i>
                          </button>
                          <button class="btn btn-outline-secondary" title="Download PDF" onclick="downloadInvoice('INV-2025-003')">
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
                      <td>$380.90</td>
                      <td><strong>$1,580.90</strong></td>
                      <td><span class="badge bg-danger">Overdue</span></td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button class="btn btn-outline-primary" title="Xem Hóa Đơn" onclick="viewInvoice('INV-2025-004')">
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="btn btn-outline-info" title="In Hóa Đơn" onclick="printInvoice('INV-2025-004')">
                            <i class="fas fa-print"></i>
                          </button>
                          <button class="btn btn-outline-secondary" title="Download PDF" onclick="downloadInvoice('INV-2025-004')">
                            <i class="fas fa-download"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                <small class="text-muted mb-2 mb-md-0">Showing 1 to 4 of 1,247 invoices</small>
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
    <div class="modal fade" id="invoiceModal" tabindex="-1" aria-labelledby="invoiceModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="invoiceModalLabel">Invoice Details</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div id="invoiceDetails">
              <!-- Invoice details will be loaded here -->
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" onclick="printCurrentInvoice()">
              <i class="fas fa-print me-2"></i>Print
            </button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin/js/purchasereport.js"></script>
  </body>
</html>