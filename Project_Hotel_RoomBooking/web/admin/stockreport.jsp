<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
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
      <jsp:include page="/admin/includes/sidebar.jsp">
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
                <h1 class="h2 mb-2">Báo Cáo Tồn Kho</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active">Báo Cáo Tồn Kho</li>
                  </ol>
                </nav>
              </div>
              <div class="btn-group">
                <button
                  class="btn btn-primary"
                  data-bs-toggle="modal"
                  data-bs-target="#addItemModal"
                >
                  <i class="fas fa-plus me-2"></i>Thêm Mặt Hàng
                </button>
                <button
                  class="btn btn-success"
                  data-bs-toggle="modal"
                  data-bs-target="#addCategoryModal"
                >
                  <i class="fas fa-folder-plus me-2"></i>Thêm Danh Mục
                </button>
              </div>
            </div>
          </div>

          <%--
          <div class="row g-4 mb-4">
            <div class="col-xl-6 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Total Value</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">
                    <fmt:formatNumber value="${kpiMetrics.totalStockValue}" type="currency" currencySymbol="đ"/>
                  </h2>
                  <p class="card-text text-success">
                    <i class="fas fa-dollar-sign me-1"></i> Tổng Doanh Thu
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-6 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Monthly Usage</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">
                    <fmt:formatNumber value="${kpiMetrics.monthlyUsage}" type="currency" currencySymbol="đ"/>
                  </h2>
                  <p class="card-text text-warning">
                    <i class="fas fa-chart-line me-1"></i> Doanh Thu Tháng Này
                  </p>
                </div>
              </div>
            </div>
          </div>
          --%>

          <!-- Stock Alerts -->
          <div class="row g-4 mb-4">
            <%-- <div class="col-lg-6">
              <div class="card shadow-sm h-100">
                <div
                  class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Low Stock Alerts</h5>
                  <span class="badge ${lowStockCount > 0 ? 'bg-danger' : 'bg-success'}">${lowStockCount} Items</span>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${empty lowStockItems}">
                      <div class="text-center py-4">
                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                        <h5 class="text-success">Tất cả hàng hóa đều đủ số lượng</h5>
                        <p class="text-muted">Không có mặt hàng nào cần bổ sung.</p>
                      </div>
                    </c:when>
                    <c:otherwise>
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
                            <c:forEach var="item" items="${lowStockItems}" varStatus="status">
                              <c:if test="${status.index < 10}"> <!-- Limit to 10 items -->
                                <tr>
                                  <td>
                                    <strong>${item.itemName}</strong>
                                    <br><small class="text-muted">${item.category}</small>
                                  </td>
                                  <td>
                                    <c:choose>
                                      <c:when test="${item.remainingStock <= 0}">
                                        <span class="text-danger fw-bold">${item.remainingStock}</span>
                                        <i class="fas fa-times-circle text-danger ms-1" title="Out of stock"></i>
                                      </c:when>
                                      <c:when test="${item.remainingStock <= item.minRequired * 0.5}">
                                        <span class="text-danger fw-bold">${item.remainingStock}</span>
                                        <i class="fas fa-exclamation-triangle text-danger ms-1" title="Critical low"></i>
                                      </c:when>
                                      <c:otherwise>
                                        <span class="text-warning fw-bold">${item.remainingStock}</span>
                                        <i class="fas fa-exclamation-triangle text-warning ms-1" title="Low stock"></i>
                                      </c:otherwise>
                                    </c:choose>
                                  </td>
                                  <td>${item.minRequired}</td>
                                  <td>
                                    <button class="btn btn-sm btn-outline-primary" data-item-id="${item.id}" data-item-name="${item.itemName}" onclick="reorderItem(this)">
                                      <i class="fas fa-shopping-cart"></i> Reorder
                                    </button>
                                  </td>
                                </tr>
                              </c:if>
                            </c:forEach>
                          </tbody>
                        </table>
                        <c:if test="${lowStockCount > 10}">
                          <div class="text-center mt-3">
                            <small class="text-muted">Showing 10 of ${lowStockCount} low stock items</small>
                          </div>
                        </c:if>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div> --%>
            <div class="col-lg-12">
              <!-- Detailed Stock Report -->
              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">Bảng Thống Kê</h5>
                </div>
                <div class="card-body">
                  <!-- Filter Section -->
                  <div class="row g-3 mb-4">
                    <div class="col-md-3">
                      <label class="form-label">Danh mục</label>
                      <select class="form-select" id="categoryFilter">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                          <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                      </select>
                    </div>
                    <div class="col-md-3">
                      <label class="form-label">Trạng thái tồn kho</label>
                      <select class="form-select" id="statusFilter">
                        <option value="">Tất cả</option>
                        <option value="in-stock">Còn hàng</option>
                        <option value="low-stock">Gần hết</option>
                        <option value="out-of-stock">Hết hàng</option>
                      </select>
                    </div>
                    <div class="col-md-3">
                      <label class="form-label">&nbsp;</label>
                      <div class="d-grid">
                        <button class="btn btn-outline-primary" onclick="applyFilters()"><i class="fas fa-filter me-2"></i>Lọc
                        </button>
                      </div>
                    </div>
                  </div>

                  <!-- Error Message -->
                  <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                      <i class="fas fa-exclamation-triangle me-2"></i>
                      ${error}
                    </div>
                  </c:if>

                  <!-- Food Items Table -->
                  <h6 class="mb-3">Thống kê Thực Phẩm</h6>
                  <div class="table-responsive mb-4">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Mã SP</th>
                          <th>Tên mặt hàng</th>
                          <th>Danh mục</th>
                          <th>Số lượng còn</th>
                          <th>Đơn giá</th>
                          <th>Thành tiền</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="row" items="${stockList}">
                          <c:if test="${row.category eq 'Thực phẩm'}">
                            <tr>
                              <td><strong>${row.id}</strong></td>
                              <td>${row.itemName}</td>
                              <td><span class="badge bg-secondary">${row.category}</span></td>
                              <td>
                                <c:choose>
                                  <c:when test="${row.remainingStock <= 10}">
                                    <span class="text-danger fw-bold">${row.remainingStock}</span>
                                    <i class="fas fa-exclamation-triangle text-danger ms-1"></i>
                                  </c:when>
                                  <c:when test="${row.remainingStock <= 50}">
                                    <span class="text-warning fw-bold">${row.remainingStock}</span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="text-success fw-bold">${row.remainingStock}</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td><fmt:formatNumber value="${row.unitPrice}" type="currency" currencySymbol="đ"/></td>
                              <td><fmt:formatNumber value="${row.totalValue}" type="currency" currencySymbol="đ"/></td>
                            </tr>
                          </c:if>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>

                  <!-- Utility Items Table -->
                  <h6 class="mb-3">Thống kê Tiện Ích</h6>
                  <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                      <thead class="table-light">
                        <tr>
                          <th>Mã SP</th>
                          <th>Tên mặt hàng</th>
                          <th>Danh mục</th>
                          <th>Số lượng còn</th>
                          <th>Đơn giá</th>
                          <th>Thành tiền</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="row" items="${stockList}">
                          <c:if test="${row.category eq 'Tiện ích phòng'}">
                            <tr>
                              <td><strong>${row.id}</strong></td>
                              <td>${row.itemName}</td>
                              <td><span class="badge bg-secondary">${row.category}</span></td>
                              <td>
                                <c:choose>
                                  <c:when test="${row.remainingStock <= 10}">
                                    <span class="text-danger fw-bold">${row.remainingStock}</span>
                                    <i class="fas fa-exclamation-triangle text-danger ms-1"></i>
                                  </c:when>
                                  <c:when test="${row.remainingStock <= 50}">
                                    <span class="text-warning fw-bold">${row.remainingStock}</span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="text-success fw-bold">${row.remainingStock}</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td><fmt:formatNumber value="${row.unitPrice}" type="currency" currencySymbol="đ"/></td>
                              <td><fmt:formatNumber value="${row.totalValue}" type="currency" currencySymbol="đ"/></td>
                            </tr>
                          </c:if>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>

                  <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                    <small class="text-muted mb-2 mb-md-0">Showing ${stockList.size()} entries</small>
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
      </div>
    </div>

    <!-- Modals -->
    <!-- Add Item Modal -->
    <div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addItemModalLabel">Thêm Mặt Hàng</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" id="addItemModalBody">
            <div class="text-center py-5">
              <div class="spinner-border text-primary"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-md modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addCategoryModalLabel">Thêm Danh Mục</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" id="addCategoryModalBody">
            <div class="text-center py-5">
              <div class="spinner-border text-success"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Load dynamic content when modals are shown
      const addItemModal = document.getElementById('addItemModal');
      addItemModal.addEventListener('show.bs.modal', () => {
        fetch('${pageContext.request.contextPath}/additem')
          .then(res => res.text())
          .then(html => {
            document.getElementById('addItemModalBody').innerHTML = html;
          })
          .catch(() => {
            document.getElementById('addItemModalBody').innerHTML = '<p class="text-danger">Không tải được dữ liệu.</p>';
          });
      });

      const addCategoryModal = document.getElementById('addCategoryModal');
      addCategoryModal.addEventListener('show.bs.modal', () => {
        fetch('${pageContext.request.contextPath}/addcategory')
          .then(res => res.text())
          .then(html => {
            document.getElementById('addCategoryModalBody').innerHTML = html;
          })
          .catch(() => {
            document.getElementById('addCategoryModalBody').innerHTML = '<p class="text-danger">Không tải được dữ liệu.</p>';
          });
      });
    </script>

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
        
        console.log("Applying filters - Category:", category, "Status:", status, "Supplier:", supplier);
        
        const params = new URLSearchParams();
        if (category) params.append("category", category);
        if (status) params.append("status", status);
        if (supplier) params.append("supplier", supplier);
        
        const url = '${pageContext.request.contextPath}/stockreport?' + params.toString();
        console.log("Redirecting to:", url);
        window.location.href = url;
      }

      function reorderItem(button) {
        const itemId = button.getAttribute('data-item-id');
        const itemName = button.getAttribute('data-item-name');
        
        // Show prompt to enter quantity
        const quantity = prompt('Nhập số lượng cần thêm cho "' + itemName + '":', '10');
        
        if (quantity === null) {
          return; // User cancelled
        }
        
        const quantityNum = parseInt(quantity);
        if (isNaN(quantityNum) || quantityNum <= 0) {
          alert('Vui lòng nhập số lượng hợp lệ (lớn hơn 0)');
          return;
        }
        
        // Disable button during request
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        
        // Send AJAX request to add stock
        fetch('${pageContext.request.contextPath}/addstock', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: 'itemId=' + encodeURIComponent(itemId) + '&quantity=' + encodeURIComponent(quantityNum)
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            alert(data.message);
            // Reload page to show updated data
            window.location.reload();
          } else {
            alert('Lỗi: ' + data.message);
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Có lỗi xảy ra khi thêm hàng vào kho');
        })
        .finally(() => {
          // Re-enable button
          button.disabled = false;
          button.innerHTML = '<i class="fas fa-shopping-cart"></i> Reorder';
        });
      }
    </script>
  </body>
</html>
