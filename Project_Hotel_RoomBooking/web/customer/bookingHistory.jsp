<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Lịch sử đặt phòng</title>

    <!-- Font Awesome (nếu muốn dùng icon) -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />

    <link rel="stylesheet" href="customer/customer.css" />
    <link rel="stylesheet" href="customer/includes/component.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- CSS gộp vào JSP -->
    <style>
      :root {
        --primary-color: #007bff;
        --primary-hover: #0056b3;
        --secondary-color: #6c757d;
        --success-color: #28a745;
        --danger-color: #dc3545;
        --warning-color: #ffc107;
        --light-color: #f8f9fa;
        --dark-color: #343a40;
        --border-color: #dee2e6;
        --shadow-sm: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        --shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        --transition: all 0.3s ease;
      } /* Giữ nguyên phần navbar */
      .navbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #ffffff;
        padding: 0 24px;
        height: 60px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        position: sticky;
        top: 0;
        z-index: 100;
      }

      .navbar .logo {
        font-size: 24px;
        font-weight: bold;
        color: var(--primary-color);
        text-decoration: none;
      }

      /* Booking History specific styles */
      .booking-history-container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
      }

      .booking-history-header {
        margin-bottom: 25px;
      }

      .booking-history-header h2 {
        color: #343a40;
        font-size: 1.8rem;
        margin-bottom: 10px;
      }

      .booking-history-header p {
        color: #6c757d;
        font-size: 1rem;
      }

      .booking-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
      }

      .booking-table th {
        background-color: #f8f9fa;
        padding: 12px 15px;
        text-align: left;
        font-weight: 600;
        color: #343a40;
        border-bottom: 2px solid #dee2e6;
      }

      .booking-table td {
        padding: 12px 15px;
        border-bottom: 1px solid #dee2e6;
        color: #343a40;
      }

      .booking-table tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
      }
      .status-badge {
        display: inline-block;
        padding: 8px 12px;
        border-radius: 4px;
        font-size: 0.85rem;
        font-weight: 600;
        text-align: center;
      }

      .status-confirmed {
        background-color: rgba(40, 167, 69, 0.15);
        color: #28a745;
      }

      .status-pending {
        background-color: rgba(255, 193, 7, 0.15);
        color: #ffc107;
      }

      .status-cancelled {
        background-color: rgba(220, 53, 69, 0.15);
        color: #dc3545;
      }

      .status-completed {
        background-color: rgba(52, 58, 64, 0.15);
        color: #343a40;
      }

      .status-payment-failed {
        background-color: rgba(220, 53, 69, 0.15);
        color: #dc3545;
      }

      .view-details-btn {
        display: inline-block;
        padding: 6px 12px;
        background-color: var(--primary-color);
        color: white;
        border-radius: 4px;
        text-decoration: none;
        font-size: 0.9rem;
        transition: var(--transition);
      }

      .view-details-btn:hover {
        background-color: var(--primary-hover);
        color: white;
      }
      .empty-bookings {
        text-align: center;
        padding: 40px 20px;
        color: #6c757d;
        background-color: #f8f9fa;
        border-radius: 8px;
        margin: 20px 0;
      }

      .empty-bookings i {
        font-size: 3rem;
        margin-bottom: 15px;
        color: #dee2e6;
      }

      .price-column {
        text-align: right;
        font-weight: 600;
        white-space: nowrap;
      }

      /* Hover effect for table rows */
      .table tbody tr {
        transition: all 0.2s ease;
        cursor: pointer;
      }

      .table tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
        transform: translateY(-1px);
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
      }
    </style>
  </head>
  <body>
    <!-- NAVBAR GIỐNG booking.jsp -->
    <jsp:include page="includes/header.jsp" />

    <!-- NỘI DUNG CHÍNH: LỊCH SỬ ĐẶT LỊCH -->
    <div class="booking-history-container">
  <div class="booking-history-header text-center">
    <h2>Lịch sử đặt phòng</h2>
    <p class="text-muted mb-4">Xem lại các lần đặt phòng của bạn, tìm kiếm nhanh theo số phòng, tầng, ngày nhận/trả.</p>
  </div>

  <!-- FORM FILTER -->
  <form class="row g-3 mb-4 align-items-end bg-light p-3 rounded shadow-sm" method="get" style="box-shadow: var(--shadow-sm);">
    <div class="col-md-2">
      <label for="roomNumber" class="form-label">Số phòng</label>
      <input type="text" class="form-control" id="roomNumber" name="roomNumber" placeholder="Nhập số phòng" value="${roomNumber}">
    </div>
    <div class="col-md-2">
      <label for="floor" class="form-label">Tầng</label>
      <input type="number" class="form-control" id="floor" name="floor" placeholder="Tầng" value="${floor}">
    </div>
    <div class="col-md-2">
      <label for="checkInFrom" class="form-label">Nhận từ</label>
      <input type="date" class="form-control" id="checkInFrom" name="checkInFrom" value="${checkInFrom}">
    </div>
    <div class="col-md-2">
      <label for="checkInTo" class="form-label">Nhận đến</label>
      <input type="date" class="form-control" id="checkInTo" name="checkInTo" value="${checkInTo}">
    </div>
    <div class="col-md-2">
      <label for="checkOutFrom" class="form-label">Trả từ</label>
      <input type="date" class="form-control" id="checkOutFrom" name="checkOutFrom" value="${checkOutFrom}">
    </div>
    <div class="col-md-2">
      <label for="checkOutTo" class="form-label">Trả đến</label>
      <input type="date" class="form-control" id="checkOutTo" name="checkOutTo" value="${checkOutTo}">
    </div>
    <div class="col-md-12 d-flex align-items-center gap-2 mt-2">
      <button type="submit" class="btn btn-primary px-4"><i class="fa fa-search me-1"></i> Lọc</button>
      <a href="bookingHistory" class="btn btn-outline-secondary px-3"><i class="fa fa-rotate-left"></i> Reset</a>
    </div>
  </form>

  <!-- THÔNG BÁO NẾU CÓ -->
          <c:if test="${not empty message && messageType != 'danger'}">
            <c:if test="${!(message eq 'Thanh toán đặt phòng thành công!')}">
              <div
                class="alert alert-${messageType} alert-dismissible fade show"
                role="alert"
              >
                ${message}
                <button
                  type="button"
                  class="btn-close"
                  data-bs-dismiss="alert"
                  aria-label="Close"
                ></button>
              </div>
            </c:if>
          </c:if>
          <!-- BẢNG HIỂN THỊ LỊCH SỬ ĐẶT PHÒNG -->
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-4">
              <thead class="table-light">
                <tr>
                  <th scope="col">Mã đặt phòng</th>
                  <th scope="col">Ngày nhận phòng</th>
                  <th scope="col">Ngày trả phòng</th>
                  <th scope="col">Phòng</th>
                  <th scope="col">Tầng</th>
                  <th scope="col">Tổng tiền</th>
                  <th scope="col">Trạng thái</th>
                  <th scope="col">Ngày đặt</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="booking" items="${bookings}">
                  <tr>
                    <td data-label="Mã đặt phòng">
                      #<c:out value="${booking.bookingId}" />
                    </td>
                    <td data-label="Ngày nhận phòng">
                      <fmt:formatDate
                        value="${booking.checkInDate}"
                        pattern="dd/MM/yyyy"
                      />
                    </td>
                    <td data-label="Ngày trả phòng">
                      <fmt:formatDate
                        value="${booking.checkOutDate}"
                        pattern="dd/MM/yyyy"
                      />
                    </td>
                    <td data-label="Phòng">
                      <c:out value="${booking.rooms}" />
                    </td>
                    <td data-label="Tầng">
                      <c:out value="${booking.floors}" />
                    </td>
                    <td data-label="Tổng tiền" class="price-column">
                      <fmt:formatNumber
                        value="${booking.totalPrice}"
                        type="currency"
                        currencySymbol="đ"
                        maxFractionDigits="0"
                      />
                    </td>
                    <td data-label="Trạng thái">
                      <c:choose>
                        <c:when test="${booking.status == 'COMPLETED'}">
                          <span class="status-badge status-completed"
                            >Hoàn thành</span
                          >
                        </c:when>
                        <c:when test="${booking.status == 'CONFIRMED'}">
                          <span class="status-badge status-confirmed"
                            >Đã xác nhận</span
                          >
                        </c:when>
                        <c:when test="${booking.status == 'PENDING'}">
                          <span class="status-badge status-pending"
                            >Chờ thanh toán</span
                          >
                        </c:when>
                        <c:when test="${booking.status == 'CANCELLED'}">
                          <span class="status-badge status-cancelled"
                            >Đã hủy</span
                          >
                        </c:when>
                        <c:when test="${booking.status == 'PAYMENT_FAILED'}">
                          <span class="status-badge status-payment-failed"
                            >Thanh toán thất bại</span
                          >
                        </c:when>
                        <c:otherwise>
                          <span class="status-badge">${booking.status}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td data-label="Ngày đặt">
                      <fmt:formatDate
                        value="${booking.createdAt}"
                        pattern="dd/MM/yyyy HH:mm"
                      />
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty bookings}">
                  <tr>
                    <td colspan="8" class="text-center text-muted py-4">
                      <i class="fas fa-calendar-times fs-4 mb-3 d-block"></i>
                      Bạn chưa có lịch sử đặt phòng nào
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
          <!-- PHÂN TRANG -->
          <c:if test="${totalPages > 1}">
            <nav
              aria-label="Điều hướng trang"
              class="d-flex justify-content-center"
            >
              <ul class="pagination mb-0">
                <!-- Nút Previous -->
                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                  <a class="page-link" href="?page=${currentPage - 1}">
                    <i class="fas fa-chevron-left"></i>
                  </a>
                </li>

                <!-- Hiển thị các số trang -->
                <c:forEach var="i" begin="1" end="${totalPages}">
                  <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}">${i}</a>
                  </li>
                </c:forEach>

                <!-- Nút Next -->
                <li
                  class="page-item ${currentPage >= totalPages ? 'disabled' : ''}"
                >
                  <a class="page-link" href="?page=${currentPage + 1}">
                    <i class="fas fa-chevron-right"></i>
                  </a>
                </li>
              </ul>
            </nav>
          </c:if>
        </div>
      </div>
    </div>
    <!-- Add Bootstrap JS and Popper.js for certain components -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom script for additional functionality -->
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Auto-dismiss alerts after 5 seconds
        const alerts = document.querySelectorAll(".alert");
        alerts.forEach(function (alert) {
          setTimeout(function () {
            const closeButton = alert.querySelector(".btn-close");
            if (closeButton) {
              closeButton.click();
            }
          }, 5000);
        });

        // Add click event for row highlighting
        const tableRows = document.querySelectorAll(".booking-table tbody tr");
        tableRows.forEach(function (row) {
          row.addEventListener("click", function () {
            // Could add functionality to view booking details in the future
            console.log(
              "Row clicked:",
              this.querySelector("td:first-child").textContent
            );
          });
        });
      });
    </script>
  </body>
</html>
