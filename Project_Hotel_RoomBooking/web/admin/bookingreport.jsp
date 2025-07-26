<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Đặt Phòng - Hệ Thống Quản Lý Khách Sạn</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      .avatar-sm {
        width: 40px;
        height: 40px;
      }
      /* Custom CSS cho phần bộ lọc (từ tin nhắn trước) */
      .filter-card .input-group {
        border: 1px solid #ced4da; /* Border mặc định */
        border-radius: 0.375rem;
        transition: border-color 0.3s ease;
      }

      .filter-card .input-group:focus-within {
        border-color: #0d6efd; /* Màu primary khi focus */
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
      }

      .filter-card .form-control {
        border: none; /* Xóa border input để hợp nhất với group */
      }

      .filter-card .input-group-text {
        background-color: #f8f9fa; /* Nền nhẹ cho icon */
        border: none;
      }

      .filter-card .btn-primary {
        transition: background-color 0.3s ease, transform 0.2s ease;
      }

      .filter-card .btn-primary:hover {
        background-color: #0b5ed7; /* Darker primary on hover */
        transform: translateY(-2px); /* Effect nâng nhẹ */
      }

      .filter-card .form-label {
        font-weight: 500; /* Bold label */
        margin-bottom: 0.5rem;
      }

      /* Validation styles (thêm class 'is-invalid' bằng JS nếu cần) */
      .filter-card .is-invalid .input-group {
        border-color: #dc3545;
      }

      /* Responsive: Stack vertically on small screens */
      @media (max-width: 767px) {
        .filter-card .row > div {
          margin-bottom: 1rem;
        }
      }
    </style>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <!-- Sidebar -->
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="bookingreport" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <jsp:include page="includes/navbar.jsp" />

        <div class="container-fluid py-4">
          <!-- Bộ lọc tìm kiếm (đã bỏ filter loại phòng và CSS lại) -->
          <div class="card shadow-sm mb-4">
            <div class="card-body bg-light filter-card">
              <form method="get" action="bookingreport">
                <div class="row g-3 align-items-center">
                  <div class="col-md-4 col-12">
                    <label for="fromDate" class="form-label">Từ Ngày</label>
                    <div class="input-group">
                      <input
                        type="date"
                        class="form-control"
                        id="fromDate"
                        name="startDate"
                        value="${param.startDate}"
                      />
                      <span class="input-group-text"
                        ><i class="fas fa-calendar-alt"></i
                      ></span>
                    </div>
                  </div>
                  <div class="col-md-4 col-12">
                    <label for="toDate" class="form-label">Đến Ngày</label>
                    <div class="input-group">
                      <input
                        type="date"
                        class="form-control"
                        id="toDate"
                        name="endDate"
                        value="${param.endDate}"
                      />
                      <span class="input-group-text"
                        ><i class="fas fa-calendar-alt"></i
                      ></span>
                    </div>
                  </div>
                  <div class="col-md-4 col-12 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                      Lọc
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>

          <!-- Current Bookings Table (đã bỏ Summary Footer) -->
          <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <h5 class="mb-0">
                <i class="fas fa-users me-2"></i>Danh Sách Khách Hàng Đang Thuê
              </h5>
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
                      <th>
                        <i class="fas fa-calendar-check me-1"></i>Ngày Đặt
                      </th>
                      <th>
                        <i class="fas fa-calendar-times me-1"></i>Ngày Trả
                      </th>
                      <th>
                        <i class="fas fa-money-bill-wave me-1"></i>Tổng Tiền
                      </th>
                      <th><i class="fas fa-info-circle me-1"></i>Trạng Thái</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${currentBookings}" var="booking">
                      <tr>
                        <td>
                          <strong class="text-primary"
                            >${booking.roomNumber}</strong
                          >
                        </td>
                        <td>
                          <span class="badge bg-info"
                            >Tầng ${booking.floor}</span
                          >
                        </td>
                        <td>${booking.roomType}</td>
                        <td>
                          <span class="text-muted"
                            >${booking.capacity} người</span
                          >
                        </td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div
                              class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-2"
                            >
                              <i class="fas fa-user text-white"></i>
                            </div>
                            <div>
                              <strong>${booking.customerName}</strong>
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
                        <td>
                          <c:choose>
                            <c:when test="${booking.status == 'Confirmed'}">
                              <span class="badge bg-success">Đã Xác Nhận</span>
                            </c:when>
                            <c:when test="${booking.status == 'Pending'}">
                              <span class="badge bg-warning">Chờ Xử Lý</span>
                            </c:when>
                            <c:when test="${booking.status == 'Cancelled'}">
                              <span class="badge bg-danger">Đã Hủy</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-secondary"
                                >${booking.status}</span
                              >
                            </c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- Pagination Controls -->
              <c:if test="${totalPages > 1}">
                <div
                  class="d-flex justify-content-between align-items-center mt-3"
                >
                  <div class="text-muted">
                    Hiển thị
                    <strong>${(currentPage-1) * pageSize + 1}</strong> đến
                    <strong
                      >${currentPage * pageSize > totalRecords ? totalRecords :
                      currentPage * pageSize}</strong
                    >
                    của <strong>${totalRecords}</strong> kết quả
                  </div>
                  <nav aria-label="Pagination">
                    <ul class="pagination pagination-sm mb-0">
                      <!-- Previous Button -->
                      <li
                        class="page-item ${currentPage <= 1 ? 'disabled' : ''}"
                      >
                        <a
                          class="page-link"
                          href="?page=${currentPage - 1}&startDate=${param.startDate}&endDate=${param.endDate}&roomType=${param.roomType}"
                        >
                          <i class="fas fa-chevron-left"></i> Trước
                        </a>
                      </li>

                      <!-- Page Numbers -->
                      <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <c:if
                          test="${pageNum <= 5 || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2) || pageNum >= totalPages - 2}"
                        >
                          <li
                            class="page-item ${pageNum == currentPage ? 'active' : ''}"
                          >
                            <a
                              class="page-link"
                              href="?page=${pageNum}&startDate=${param.startDate}&endDate=${param.endDate}&roomType=${param.roomType}"
                            >
                              ${pageNum}
                            </a>
                          </li>
                        </c:if>
                        <c:if test="${pageNum == 6 && currentPage > 8}">
                          <li class="page-item disabled">
                            <span class="page-link">...</span>
                          </li>
                        </c:if>
                        <c:if
                          test="${pageNum == currentPage + 3 && pageNum < totalPages - 2}"
                        >
                          <li class="page-item disabled">
                            <span class="page-link">...</span>
                          </li>
                        </c:if>
                      </c:forEach>

                      <!-- Next Button -->
                      <li
                        class="page-item ${currentPage >= totalPages ? 'disabled' : ''}"
                      >
                        <a
                          class="page-link"
                          href="?page=${currentPage + 1}&startDate=${param.startDate}&endDate=${param.endDate}&roomType=${param.roomType}"
                        >
                          Sau <i class="fas fa-chevron-right"></i>
                        </a>
                      </li>
                    </ul>
                  </nav>
                </div>
              </c:if>

              <!-- Summary Footer đã bị bỏ hoàn toàn -->
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/bookingreport.js"></script>
  </body>
</html>
