<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đặt dịch vụ - Reception</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #e53e3e;
            --primary-hover: #c53030;
            --secondary-color: #3182ce;
            --success-color: #38a169;
            --danger-color: #e53e3e;
            --warning-color: #d69e2e;
            --light-gray: #f7fafc;
            --medium-gray: #edf2f7;
            --dark-gray: #2d3748;
            --border-color: #e2e8f0;
            --text-primary: #1a202c;
            --text-secondary: #718096;
        }

        body {
            background-color: var(--light-gray);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: var(--text-primary);
        }

        #page-content-wrapper {
            margin-left: 230px;
            transition: all 0.3s ease;
        }

        #wrapper.toggled #page-content-wrapper {
            margin-left: 0;
        }

        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
            border-radius: 0 0 20px 20px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .header-section h3 {
            margin: 0;
            color: white;
            font-weight: 700;
            font-size: 2rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .datetime-info {
            color: rgba(255,255,255,0.9);
            font-size: 14px;
            margin-top: 0.5rem;
        }

        .content-section {
            padding: 30px;
        }

        .section-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .section-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 35px rgba(0,0,0,0.15);
        }

        .section-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
            padding: 1.5rem 2rem;
            color: white;
            font-weight: 700;
            font-size: 1.2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-content {
            padding: 2rem;
        }

        .service-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .service-table th {
            background: linear-gradient(135deg, #9aafc3, #f1f5f9);
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 700;
            color: var(--text-primary);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            border: none;
        }

        .service-table td {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .service-table tbody tr {
            transition: all 0.3s ease;
        }

        .service-table tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
            transform: scale(1.01);
        }

        .service-table tbody tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-failed {
            background-color: #f8d7da;
            color: #721c24;
        }

        .btn-action {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
            margin: 2px;
        }

        .btn-view {
            background-color: var(--secondary-color);
            color: white;
        }

        .btn-edit {
            background-color: var(--warning-color);
            color: white;
        }

        .add-service-btn {
            background-color: white;
            border: 1px solid var(--border-color);
            padding: 8px 16px;
            border-radius: 4px;
            color: var(--dark-gray);
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .add-service-btn:hover {
            background-color: #f8f9fa;
            color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .price-format {
            font-weight: 600;
            color: var(--success-color);
        }

        /* Pagination Styles */
        .pagination {
            margin: 0;
        }

        .pagination .page-link {
            border: 1px solid var(--border-color);
            color: var(--dark-gray);
            padding: 0.5rem 0.75rem;
            margin: 0 2px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .pagination .page-item.active .page-link {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: white;
        }

        .pagination .page-item.disabled .page-link {
            color: var(--border-color);
            background-color: var(--light-gray);
            border-color: var(--border-color);
        }

        .pagination .page-link:hover {
            background-color: var(--light-gray);
            border-color: var(--secondary-color);
            color: var(--secondary-color);
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="service-management" />
        </jsp:include>
        
        <!-- Page Content -->
        <div id="page-content-wrapper">
                <!-- Header Section -->
                <div class="header-section">
                    <h3>Service Management</h3>
                    <div class="datetime-info">
                        <div>Thứ Năm, 24 tháng 7, 2025</div>
                        <div>16:16:37</div>
                    </div>
                </div>

                <!-- Content Section -->
                <div class="content-section">
                    <!-- Success/Error Messages -->
                    <c:if test="${param.success == 'service_added'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Thành công!</strong> Dịch vụ đã được thêm thành công.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error == 'missing_fields'}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lỗi!</strong> Vui lòng điền đầy đủ các trường bắt buộc.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error == 'invalid_price'}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lỗi!</strong> Giá dịch vụ phải lớn hơn 0.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error == 'invalid_format'}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lỗi!</strong> Định dạng dữ liệu không hợp lệ.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error == 'server_error'}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lỗi!</strong> Có lỗi xảy ra khi thêm dịch vụ. Vui lòng thử lại.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <!-- All Service Section -->
                    <div class="section-card">
                        <div class="section-header d-flex justify-content-between align-items-center">
                            <span>All Service</span>
                            <!-- Removed Add new service button -->
                        </div>
                        <div class="section-content">
                            <table class="service-table">
                                <thead>
                                    <tr>
                                        <th>Dịch Vụ</th>
                                        <th>Đơn Giá</th>
                                        <th>Trạng Thái</th>
                                        <!-- <th>Thao Tác</th> removed -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="service" items="${allServices}">
                                        <tr>
                                            <td><c:out value="${service.name}" /></td>
                                            <td><span class="price-format"><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="" pattern="#,##0" /> VND</span></td>
                                            <td><span class="status-badge status-active">Đang hoạt động</span></td>
                                            <td>
                                                <!-- Removed edit button -->
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty allServices}">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted py-4">
                                                Không có dịch vụ nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Service Pagination -->
                        <c:if test="${totalServicePages > 1}">
                            <div class="d-flex justify-content-center mt-3">
                                <nav aria-label="Service pagination">
                                    <ul class="pagination pagination-sm">
                                        <!-- Previous Button -->
                                        <li class="page-item ${currentServicePage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?servicePage=${currentServicePage - 1}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        
                                        <!-- Page Numbers -->
                                        <c:forEach var="i" begin="1" end="${totalServicePages}">
                                            <li class="page-item ${i == currentServicePage ? 'active' : ''}">
                                                <a class="page-link" href="?servicePage=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <!-- Next Button -->
                                        <li class="page-item ${currentServicePage >= totalServicePages ? 'disabled' : ''}">
                                            <a class="page-link" href="?servicePage=${currentServicePage + 1}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                            
                            <!-- Service Count Info -->
                            <div class="text-center text-muted mt-2">
                                <small>
                                    Hiển thị ${(currentServicePage - 1) * 5 + 1} - ${(currentServicePage - 1) * 5 + allServices.size()} 
                                    trong tổng số ${totalServices} dịch vụ
                                </small>
                            </div>
                        </c:if>
                    </div>

                    <!-- Invoice Service Section -->
                    <div class="section-card">
                        <div class="section-header">
                            Invoice Service
                        </div>
                        <div class="section-content">
                            <table class="service-table">
                                <thead>
                                    <tr>
                                        <th>Số Hóa Đơn</th>
                                        <th>Tên Khách</th>
                                        <th>Dịch Vụ</th>
                                        <th>Ngày Đặt</th>
                                        <th>Số Lượng</th>
                                        <th>Đơn Giá</th>
                                        <th>Tổng Tiền</th>
                                        <th>Trạng Thái</th>
                                        <!-- <th>Thao Tác</th> removed -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${allServiceBookings}">
                                        <tr>
                                            <td><strong>SVC_${booking.id}</strong></td>
                                            <td><c:out value="${booking.customerName}" /></td>
                                            <td><c:out value="${booking.serviceName}" /></td>
                                            <td><fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd" /></td>
                                            <td><c:out value="${booking.quantity}" /></td>
                                            <td><span class="price-format"><fmt:formatNumber value="${booking.unitPrice}" type="currency" currencySymbol="" pattern="#,##0" /> đ</span></td>
                                            <td><span class="price-format"><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="" pattern="#,##0" /> đ</span></td>
                                            <td>
                                                <span class="status-badge ${booking.status == 'Completed' ? 'status-active' : 'status-failed'}">
                                                    <c:choose>
                                                        <c:when test="${booking.status == 'Pending'}">Chờ xác nhận</c:when>
                                                        <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                        <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                                                        <c:when test="${booking.status == 'Cancelled'}">Đã hủy</c:when>
                                                        <c:otherwise><c:out value="${booking.status}" /></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty allServiceBookings}">
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-4">
                                                Không có hóa đơn dịch vụ nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         </div>

    <!-- Add Service Modal -->
    <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addServiceModalLabel">
                        <i class="fas fa-plus-circle me-2"></i>Thêm dịch vụ mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addServiceForm" action="${pageContext.request.contextPath}/reception/addService" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="serviceName" class="form-label">Tên dịch vụ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="serviceName" name="serviceName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="servicePrice" class="form-label">Giá dịch vụ (VND) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="servicePrice" name="servicePrice" min="0" step="1000" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="serviceType" class="form-label">Loại dịch vụ <span class="text-danger">*</span></label>
                                    <select class="form-select" id="serviceType" name="serviceType" required>
                                        <option value="">Chọn loại dịch vụ</option>
                                        <option value="1">Ăn uống</option>
                                        <option value="2">Spa & Massage</option>
                                        <option value="3">Thể thao & Giải trí</option>
                                        <option value="4">Dịch vụ khác</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="serviceImage" class="form-label">Hình ảnh dịch vụ</label>
                                    <input type="file" class="form-control" id="serviceImage" name="serviceImage" accept="image/*">
                                    <div class="form-text">Chọn file hình ảnh (JPG, PNG, GIF)</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="serviceDescription" class="form-label">Mô tả dịch vụ</label>
                            <textarea class="form-control" id="serviceDescription" name="serviceDescription" rows="4" 
                                placeholder="Nhập mô tả chi tiết về dịch vụ..."></textarea>
                        </div>
                        
                        <!-- Preview Image -->
                        <div class="mb-3" id="imagePreview" style="display: none;">
                            <label class="form-label">Xem trước hình ảnh:</label>
                            <div>
                                <img id="previewImg" src="" alt="Preview" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid #ddd;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Thêm dịch vụ
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Service Modal -->
    <div class="modal fade" id="editServiceModal" tabindex="-1" aria-labelledby="editServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editServiceModalLabel">
                        <i class="fas fa-edit me-2"></i>Chỉnh sửa dịch vụ
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editServiceForm" action="${pageContext.request.contextPath}/admin/UpdateService" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="editServiceId" name="serviceId">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editServiceName" class="form-label">Tên dịch vụ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editServiceName" name="serviceName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editServicePrice" class="form-label">Giá dịch vụ (VND) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="editServicePrice" name="servicePrice" min="0" step="1000" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editServiceType" class="form-label">Loại dịch vụ <span class="text-danger">*</span></label>
                                    <select class="form-select" id="editServiceType" name="serviceType" required>
                                        <option value="">Chọn loại dịch vụ</option>
                                        <option value="1">Ăn uống</option>
                                        <option value="2">Spa & Massage</option>
                                        <option value="3">Thể thao & Giải trí</option>
                                        <option value="4">Dịch vụ khác</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editServiceImage" class="form-label">Hình ảnh dịch vụ</label>
                                    <input type="file" class="form-control" id="editServiceImage" name="serviceImage" accept="image/*">
                                    <div class="form-text">Chọn file hình ảnh mới (JPG, PNG, GIF) hoặc để trống để giữ ảnh cũ</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editServiceDescription" class="form-label">Mô tả dịch vụ</label>
                            <textarea class="form-control" id="editServiceDescription" name="serviceDescription" rows="4" 
                                placeholder="Nhập mô tả chi tiết về dịch vụ..."></textarea>
                        </div>
                        
                        <!-- Current Image -->
                        <div class="mb-3" id="currentImageDiv">
                            <label class="form-label">Hình ảnh hiện tại:</label>
                            <div>
                                <img id="currentServiceImg" src="" alt="Current Image" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid #ddd;">
                            </div>
                        </div>
                        
                        <!-- Preview New Image -->
                        <div class="mb-3" id="editImagePreview" style="display: none;">
                            <label class="form-label">Xem trước hình ảnh mới:</label>
                            <div>
                                <img id="editPreviewImg" src="" alt="Preview" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid #ddd;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Cập nhật dịch vụ
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update datetime
        function updateDateTime() {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            };
            const dateStr = now.toLocaleDateString('vi-VN', options);
            const timeStr = now.toLocaleTimeString('vi-VN');
            
            document.querySelector('.datetime-info').innerHTML = `
                <div>${dateStr}</div>
                <div>${timeStr}</div>
            `;
        }

        // Update every second
        setInterval(updateDateTime, 1000);
        updateDateTime();

        // Function to view service booking details
        function viewServiceBooking(bookingId) {
            // You can implement a modal or redirect to a details page
            alert('Viewing service booking SVC_' + bookingId);
            // Example: window.location.href = '${pageContext.request.contextPath}/reception/serviceBookingDetail?id=' + bookingId;
        }

        // Image preview functionality
        document.getElementById('serviceImage').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('imagePreview').style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                document.getElementById('imagePreview').style.display = 'none';
            }
        });

        // Form validation and submission
        document.getElementById('addServiceForm').addEventListener('submit', function(e) {
            const serviceName = document.getElementById('serviceName').value.trim();
            const servicePrice = document.getElementById('servicePrice').value;
            const serviceType = document.getElementById('serviceType').value;

            if (!serviceName || !servicePrice || !serviceType) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc!');
                return false;
            }

            if (servicePrice <= 0) {
                e.preventDefault();
                alert('Giá dịch vụ phải lớn hơn 0!');
                return false;
            }

            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thêm...';
            submitBtn.disabled = true;

            // Form will be submitted normally to the server
        });

        // Reset form when modal is closed
        document.getElementById('addServiceModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('addServiceForm').reset();
            document.getElementById('imagePreview').style.display = 'none';
            
            // Reset submit button
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-save me-2"></i>Thêm dịch vụ';
            submitBtn.disabled = false;
        });

        // Function to edit service
        function editService(id, name, price, description, typeId, imageUrl) {
            // Populate the edit form
            document.getElementById('editServiceId').value = id;
            document.getElementById('editServiceName').value = name;
            document.getElementById('editServicePrice').value = price;
            document.getElementById('editServiceDescription').value = description || '';
            document.getElementById('editServiceType').value = typeId || '';
            
            // Show current image
            if (imageUrl && imageUrl.trim() !== '') {
                document.getElementById('currentServiceImg').src = imageUrl;
                document.getElementById('currentImageDiv').style.display = 'block';
            } else {
                document.getElementById('currentImageDiv').style.display = 'none';
            }
            
            // Hide new image preview
            document.getElementById('editImagePreview').style.display = 'none';
            
            // Show the modal
            const editModal = new bootstrap.Modal(document.getElementById('editServiceModal'));
            editModal.show();
        }

        // Edit image preview functionality
        document.getElementById('editServiceImage').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('editPreviewImg').src = e.target.result;
                    document.getElementById('editImagePreview').style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                document.getElementById('editImagePreview').style.display = 'none';
            }
        });

        // Edit form validation and submission
        document.getElementById('editServiceForm').addEventListener('submit', function(e) {
            const serviceName = document.getElementById('editServiceName').value.trim();
            const servicePrice = document.getElementById('editServicePrice').value;
            const serviceType = document.getElementById('editServiceType').value;

            if (!serviceName || !servicePrice || !serviceType) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc!');
                return false;
            }

            if (servicePrice <= 0) {
                e.preventDefault();
                alert('Giá dịch vụ phải lớn hơn 0!');
                return false;
            }

            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang cập nhật...';
            submitBtn.disabled = true;

            // Form will be submitted normally to the server
        });

        // Reset edit form when modal is closed
        document.getElementById('editServiceModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('editServiceForm').reset();
            document.getElementById('editImagePreview').style.display = 'none';
            document.getElementById('currentImageDiv').style.display = 'none';
            
            // Reset submit button
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-save me-2"></i>Cập nhật dịch vụ';
            submitBtn.disabled = false;
        });
    </script>
</body>
</html>