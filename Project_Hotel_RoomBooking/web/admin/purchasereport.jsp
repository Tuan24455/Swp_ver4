<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Doanh Thu - Hệ Thống Quản Lý Khách Sạn</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link
      href="${pageContext.request.contextPath}/css/style.css"
      rel="stylesheet"
    />
    <link
      href="${pageContext.request.contextPath}/css/purchasereport.css"
      rel="stylesheet"
    />
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
                    <li class="breadcrumb-item">
                      <a href="dashboard.jsp"
                        ><i class="fas fa-home me-1"></i> Trang chủ</a
                      >
                    </li>
                    <li class="breadcrumb-item active">Báo Cáo Doanh Thu</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>

          <!-- Additional Services Analysis -->

          <!-- Additional Services Analysis -->
          <div class="row g-4 mb-4">
            <div class="col-lg-6">              <div class="card shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Dịch Vụ Bổ Sung Hàng Đầu</h5>
                    <div class="pagination-controls">
                      <button type="button" class="btn btn-outline-primary btn-sm me-2" 
                              onclick="changeServicePage(${currentServicePage != null ? currentServicePage - 1 : 0})" 
                              ${currentServicePage != null && currentServicePage <= 1 ? 'disabled' : ''}>
                        <i class="fas fa-chevron-left"></i>
                      </button>
                      <span class="fw-bold"> Trang ${currentServicePage != null ? currentServicePage : 1} / ${totalServicePages != null ? totalServicePages : 1}</span>
                      <button type="button" class="btn btn-outline-primary btn-sm ms-2" 
                              onclick="changeServicePage(${currentServicePage != null ? currentServicePage + 1 : 2})" 
                              ${currentServicePage != null && totalServicePages != null && currentServicePage >= totalServicePages ? 'disabled' : ''}>
                        <i class="fas fa-chevron-right"></i>
                      </button>
                    </div>
                  </div>
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
                        <c:if test="${empty topServicesData}">
                          <tr>
                            <td colspan="4" class="text-center">Không có dữ liệu để hiển thị.</td>
                          </tr>
                        </c:if>
                        <c:forEach var="service" items="${topServicesData}">
                          <tr>
                            <td><strong><c:out value="${service['Dịch Vụ']}" /></strong></td>
                            <td><c:out value="${service['Số Lần Sử Dụng']}" /></td>
                            <td><fmt:formatNumber value="${service['Doanh Thu']}" type="currency" currencyCode="VND" pattern="#,##0 ¤"/></td>
                            <td><fmt:formatNumber value="${service['Giá Trung Bình']}" type="currency" currencyCode="VND" pattern="#,##0 ¤"/></td>
                          </tr>
                        </c:forEach>
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
                        <c:if test="${empty reportData}">
                          <tr>
                            <td colspan="4" class="text-center">
                              Không có dữ liệu để hiển thị.
                            </td>
                          </tr>
                        </c:if>
                        <c:forEach var="row" items="${reportData}">
                          <tr>
                            <td>
                              <strong
                                ><c:out value="${row['Loai Phong']}"
                              /></strong>
                            </td>
                            <td><c:out value="${row['So Dem']}" /></td>
                            <td>
                              <fmt:formatNumber
                                value="${row['Doanh Thu']}"
                                type="currency"
                                currencyCode="VND"
                                pattern="#,##0 ¤"
                              />
                            </td>
                            <td>
                              <fmt:formatNumber
                                value="${row['Gia Trung Binh']}"
                                type="currency"
                                currencyCode="VND"
                                pattern="#,##0 ¤"
                              />
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Combined Invoice Report -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Báo Cáo Hóa Đơn Chi Tiết</h5>
                <div class="pagination-controls">
                  <button type="button" class="btn btn-outline-primary btn-sm me-2" 
                          onclick="changeCombinedPage(${currentCombinedPage != null ? currentCombinedPage - 1 : 0})" 
                          ${currentCombinedPage != null && currentCombinedPage <= 1 ? 'disabled' : ''}>
                    <i class="fas fa-chevron-left"></i>
                  </button>
                  <span class="fw-bold"> Trang ${currentCombinedPage != null ? currentCombinedPage : 1} / ${totalCombinedPages != null ? totalCombinedPages : 1}</span>
                  <button type="button" class="btn btn-outline-primary btn-sm ms-2" 
                          onclick="changeCombinedPage(${currentCombinedPage != null ? currentCombinedPage + 1 : 2})" 
                          ${currentCombinedPage != null && totalCombinedPages != null && currentCombinedPage >= totalCombinedPages ? 'disabled' : ''}>
                    <i class="fas fa-chevron-right"></i>
                  </button>
                </div>
              </div>
            </div>
            <div class="card-body">
              <!-- Combined Filter Section -->              
              <form method="post" action="${pageContext.request.contextPath}/admin/purchasereport">
                <input type="hidden" name="reportType" value="combined" />
                <input type="hidden" name="combinedPage" value="1" />
                <div class="row g-3 mb-4">
                  <div class="col-md-2">
                    <label class="form-label">Từ Ngày</label>
                    <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${param.dateFrom}" />
                  </div>
                  <div class="col-md-2">
                    <label class="form-label">Đến Ngày</label>
                    <input type="date" class="form-control" id="dateTo" name="dateTo" value="${param.dateTo}" />
                  </div>
                  <div class="col-md-2">
                    <label class="form-label">Loại Phòng</label>
                    <select class="form-select" id="roomTypeFilter" name="roomTypeFilter">
                      <option value="">Tất Cả Loại</option>
                      <c:forEach var="type" items="${roomTypes}">
                        <option value="${type}" ${param.roomTypeFilter == type ? 'selected' : ''}>${type}</option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-2">
                    <label class="form-label">Loại Dịch Vụ</label>
                    <select class="form-select" id="serviceTypeFilter" name="serviceTypeFilter">
                      <option value="">Tất Cả Loại</option>
                      <c:forEach var="type" items="${serviceTypes}">
                        <option value="${type}" ${param.serviceTypeFilter == type ? 'selected' : ''}>${type}</option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-2">
                    <label class="form-label">Trạng Thái Thanh Toán</label>
                    <select class="form-select" id="paymentStatusFilter" name="paymentStatusFilter">
                      <option value="">Tất Cả Trạng Thái</option>
                      <c:forEach var="status" items="${paymentStatuses}">
                        <option value="${status}" ${param.paymentStatusFilter == status ? 'selected' : ''}>${status}</option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
                    <div class="d-grid">
                      <button type="submit" class="btn btn-outline-primary">
                        <i class="fas fa-filter me-2"></i>Áp Dụng
                      </button>
                    </div>
                  </div>
                </div>
              </form>

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
                      <th>Dịch Vụ</th>
                      <th>Tổng Tiền</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:if test="${empty combinedInvoiceData}">
                      <tr>
                        <td colspan="10" class="text-center">
                          Không có dữ liệu để hiển thị.
                        </td>
                      </tr>
                    </c:if>
                    <c:forEach var="invoice" items="${combinedInvoiceData}">
                      <tr data-type="${invoice.type}">
                        <td>
                          <strong><c:out value="${invoice['Số Hóa Đơn']}" /></strong>
                        </td>
                        <td><c:out value="${invoice['Tên Khách']}" /></td>
                        <td><c:out value="${invoice['Phòng']}" /></td>
                        <td>
                          <fmt:formatDate value="${invoice['Nhận Phòng']}" pattern="yyyy-MM-dd" />
                        </td>
                        <td>
                          <fmt:formatDate value="${invoice['Trả Phòng']}" pattern="yyyy-MM-dd" />
                        </td>
                        <td>
                          <fmt:formatNumber value="${invoice['Phí Phòng']}" type="currency" currencyCode="VND" pattern="#,##0 ¤" />
                        </td>
                        <td><c:out value="${invoice['Dịch Vụ']}" /></td>
                        <td>
                          <strong><fmt:formatNumber value="${invoice['Tổng Tiền']}" type="currency" currencyCode="VND" pattern="#,##0 ¤" /></strong>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${invoice['Trạng Thái'] == 'Paid'}">
                              <span class="badge bg-success">Đã Thanh Toán</span>
                            </c:when>
                            <c:when test="${invoice['Trạng Thái'] == 'Pending'}">
                              <span class="badge bg-warning">Chờ Thanh Toán</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-danger"><c:out value="${invoice['Trạng Thái']}" /></span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <div class="btn-group btn-group-sm">
                            <button class="btn btn-outline-primary" title="Xem Hóa Đơn" onclick="viewCombinedInvoice('${invoice['Số Hóa Đơn']}', '${invoice.type}')">
                              <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-outline-info" title="In Hóa Đơn" onclick="printCombinedInvoice('${invoice['Số Hóa Đơn']}', '${invoice.type}')">
                              <i class="fas fa-print"></i>
                            </button>
                            <button class="btn btn-outline-secondary" title="Download PDF" onclick="downloadCombinedInvoice('${invoice['Số Hóa Đơn']}', '${invoice.type}')">
                              <i class="fas fa-download"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Remove the service invoice section -->

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
    </div>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin/js/purchasereport.js"></script>    <script>
        function changeServicePage(page) {
            if (page < 1 || page > ${totalServicePages != null ? totalServicePages : 1}) {
                return;
            }
            
            var currentUrl = new URL(window.location);
            currentUrl.searchParams.set('servicePage', page);
            window.location.href = currentUrl.toString();
        }
                    function changeRoomInvoicePage(page) {
             if (page < 1 || page > ${totalRoomInvoicePages != null ? totalRoomInvoicePages : 1}) {
                 return;
             }
             
             var currentUrl = new URL(window.location);
             currentUrl.searchParams.set('roomInvoicePage', page);
             window.location.href = currentUrl.toString();
         }

         function changeCombinedPage(page) {
            if (page < 1 || page > ${totalCombinedPages != null ? totalCombinedPages : 1}) {
                return;
            }
            
            var currentUrl = new URL(window.location);
            currentUrl.searchParams.set('combinedPage', page);
            window.location.href = currentUrl.toString();
        }

        function viewCombinedInvoice(invoiceId, type) {
            if (type === 'room') {
                viewInvoice(invoiceId);
            } else if (type === 'service') {
                viewServiceInvoice(invoiceId);
            }
        }

        function printCombinedInvoice(invoiceId, type) {
            // Implement print logic based on type
        }

        function downloadCombinedInvoice(invoiceId, type) {
            // Implement download logic based on type
        }

        function viewInvoice(invoiceId) {
            console.log('Fetching invoice details for ID:', invoiceId);
            
            // Fetch invoice details via AJAX
            var url = '${pageContext.request.contextPath}/admin/purchasereport?action=getInvoiceDetails&invoiceId=' + invoiceId;
            fetch(url)
                .then(function(response) {
                    console.log('Response status:', response.status);
                    return response.text();
                })
                .then(function(text) {
                    console.log('Raw response:', text);
                    try {
                        var data = JSON.parse(text);
                        console.log('Parsed data:', data);
                        
                        // Populate modal with invoice details
                        var invoiceDetails = document.getElementById('invoiceDetails');
                        
                        // Format currency for Vietnamese Dong
                        function formatCurrency(amount) {
                            if (amount == null || amount === '' || amount === undefined) return 'N/A';
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(amount);
                        }
                        
                        // Helper function to safely get value
                        function getValue(value) {
                            return (value !== null && value !== undefined && value !== '') ? value : 'N/A';
                        }
                        
                        var html = '<p><strong>Số Hóa Đơn:</strong> ' + getValue(data.invoiceId) + '</p>' +
                                  '<p><strong>Tên Khách:</strong> ' + getValue(data.customerName) + '</p>' +
                                  '<p><strong>Phòng:</strong> ' + getValue(data.room) + '</p>' +
                                  '<p><strong>Nhận Phòng:</strong> ' + getValue(data.checkIn) + '</p>' +
                                  '<p><strong>Trả Phòng:</strong> ' + getValue(data.checkOut) + '</p>' +
                                  '<p><strong>Phí Phòng:</strong> ' + formatCurrency(data.roomFee) + '</p>' +
                                  '<p><strong>Dịch Vụ Bổ Sung:</strong> ' + formatCurrency(data.additionalServices) + '</p>' +
                                  '<p><strong>Tổng Tiền:</strong> ' + formatCurrency(data.totalAmount) + '</p>' +
                                  '<p><strong>Trạng Thái:</strong> ' + getValue(data.status) + '</p>';
                        
                        invoiceDetails.innerHTML = html;

                        // Show the modal
                        var invoiceModal = new bootstrap.Modal(document.getElementById('invoiceModal'));
                        invoiceModal.show();
                    } catch (e) {
                        console.error('JSON parsing error:', e);
                        alert('Lỗi phân tích dữ liệu JSON: ' + e.message);
                    }
                })
                .catch(function(error) {
                    console.error('Error fetching invoice details:', error);
                    alert('Không thể tải chi tiết hóa đơn. Vui lòng thử lại sau.');
                });
        }

        function viewServiceInvoice(invoiceId) {
            console.log('Fetching service invoice details for ID:', invoiceId);
            
            // Fetch service invoice details via AJAX
            var url = '${pageContext.request.contextPath}/admin/purchasereport?action=getServiceInvoiceDetails&invoiceId=' + invoiceId;
            fetch(url)
                .then(function(response) {
                    console.log('Response status:', response.status);
                    return response.text();
                })
                .then(function(text) {
                    console.log('Raw response:', text);
                    try {
                        var data = JSON.parse(text);
                        console.log('Parsed data:', data);
                        
                        // Populate modal with service invoice details
                        var invoiceDetails = document.getElementById('invoiceDetails');
                        
                        // Format currency for Vietnamese Dong
                        function formatCurrency(amount) {
                            if (amount == null || amount === '' || amount === undefined) return 'N/A';
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(amount);
                        }
                        
                        // Helper function to safely get value
                        function getValue(value) {
                            return (value !== null && value !== undefined && value !== '') ? value : 'N/A';
                        }
                        
                        var html = '<p><strong>Số Hóa Đơn:</strong> ' + getValue(data.invoiceId) + '</p>' +
                                  '<p><strong>Tên Khách:</strong> ' + getValue(data.customerName) + '</p>' +
                                  '<p><strong>Dịch Vụ:</strong> ' + getValue(data.serviceName) + '</p>' +
                                  '<p><strong>Ngày Đặt:</strong> ' + getValue(data.bookingDate) + '</p>' +
                                  '<p><strong>Số Lượng:</strong> ' + getValue(data.quantity) + '</p>' +
                                  '<p><strong>Đơn Giá:</strong> ' + formatCurrency(data.unitPrice) + '</p>' +
                                  '<p><strong>Tổng Tiền:</strong> ' + formatCurrency(data.totalAmount) + '</p>' +
                                  '<p><strong>Trạng Thái:</strong> ' + getValue(data.status) + '</p>' +
                                  '<p><strong>Ghi Chú:</strong> ' + getValue(data.note) + '</p>';
                        
                        invoiceDetails.innerHTML = html;

                        // Show the modal
                        var invoiceModal = new bootstrap.Modal(document.getElementById('invoiceModal'));
                        invoiceModal.show();
                    } catch (e) {
                        console.error('JSON parsing error:', e);
                        alert('Lỗi phân tích dữ liệu JSON: ' + e.message);
                    }
                })
                .catch(function(error) {
                    console.error('Error fetching service invoice details:', error);
                    alert('Không thể tải chi tiết hóa đơn dịch vụ. Vui lòng thử lại sau.');
                });
        }

        function printServiceInvoice(invoiceId) {
            console.log('Printing service invoice:', invoiceId);
            // Implementation for printing service invoice
            alert('Chức năng in hóa đơn dịch vụ đang được phát triển.');
        }

        function downloadServiceInvoice(invoiceId) {
            console.log('Downloading service invoice:', invoiceId);
            // Implementation for downloading service invoice
            alert('Chức năng tải hóa đơn dịch vụ đang được phát triển.');
        }
    </script>
  </body>
</html>