<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<style>
  .sidebar-wrapper {
    position: fixed !important;
    top: 0;
    left: 0;
    height: 100vh;
    width: 230px; /* Sidebar rộng 230px */
    background-color: #e3f2fd;
    z-index: 1000;
    overflow-y: auto;
    overflow-x: hidden;
    transition: transform 0.3s ease;
  }

  .sidebar-wrapper.toggled {
    transform: translateX(-100%);
  }

  .sidebar-menu .list-group-item {
    background-color: transparent;
    border: none;
    color: #0d47a1;
    border-radius: 0;
    transition: all 0.3s ease;
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .sidebar-menu .list-group-item:hover {
    background-color: #bbdefb;
    color: #1565c0;
  }

  .sidebar-menu .list-group-item.active {
    background-color: #42a5f5;
    color: white;
  }

  .sidebar-menu .list-group-item i {
    width: 20px;
    text-align: center;
  }

  .menu-heading {
    color: #1976d2 !important;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  /* Điều chỉnh phần nội dung chính theo chiều rộng mới */
  #page-content-wrapper {
    margin-left: 230px;
    width: calc(100% - 230px);
    transition: margin-left 0.3s ease, width 0.3s ease;
  }

  #wrapper.toggled #page-content-wrapper {
    margin-left: 0;
    width: 100%;
  }
  /* Khi sidebar ẩn, triệt tiêu padding ngang của container chính */
  #wrapper.toggled #page-content-wrapper .container-fluid {
    padding-left: 0 !important;
    padding-right: 0 !important;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .sidebar-wrapper {
      transform: translateX(-100%);
    }

    .sidebar-wrapper.toggled {
      transform: translateX(0);
    }

    #page-content-wrapper {
      margin-left: 0;
      width: 100%;
    }
  }
</style>

<c:set
  var="isReportActive"
  value="${param.activePage == 'purchasereport' || param.activePage == 'stockreport' || param.activePage == 'bookingreport' || param.activePage == 'ratingreport'}"
/>

<div class="sidebar-wrapper" id="sidebar-wrapper">
  <!-- Toggle button -->

  <div class="sidebar-menu">
    <div class="list-group list-group-flush">
      <a
        href="${pageContext.request.contextPath}/admin/dashboard"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'dashboard' ? 'active' : ''}"
      >
        <i class="fas fa-tachometer-alt me-2"></i> Bảng điều khiển
      </a>
      <a
        href="${pageContext.request.contextPath}/userList"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'users' ? 'active' : ''}"
      >
        <i class="fas fa-hotel me-2"></i> Người dùng
      </a>
      <a
        href="${pageContext.request.contextPath}/promotionList"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'promotion' ? 'active' : ''}"
      >
        <i class="fas fa-hotel me-2"></i> Quản lý khuyến mãi
      </a>
      <a
        href="${pageContext.request.contextPath}/admin/bookings.jsp"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'bookings' ? 'active' : ''}"
      >
        <i class="fas fa-calendar-check me-2"></i> Quản lí dịch vụ
      </a>
      <a
        href="#"
        class="list-group-item list-group-item-action py-3 ${isReportActive ? 'active' : ''}"
        data-bs-toggle="collapse"
        data-bs-target="#roomBookSubmenu"
        aria-expanded="${isReportActive ? 'true' : 'false'}"
      >
        <i class="fas fa-book me-2"></i> Báo cáo & Phân tích
        <i class="fas fa-chevron-down ms-auto"></i>
      </a>
      <div
        class="collapse ${isReportActive ? 'show' : ''}"
        id="roomBookSubmenu"
      >
        <div class="list-group list-group-flush ps-4">
          <a
            href="${pageContext.request.contextPath}/admin/purchasereport"
            class="list-group-item list-group-item-action py-2 ${param.activePage == 'purchasereport' ? 'active' : ''}"
          >
            <i class="fas fa-shopping-cart me-2"></i> Báo cáo doanh thu
          </a>
          <a
            href="${pageContext.request.contextPath}/admin/bookingreport"
            class="list-group-item list-group-item-action py-2 ${param.activePage == 'bookingreport' ? 'active' : ''}"
          >
            <i class="fas fa-chart-line me-2"></i> Báo cáo đặt phòng
          </a>
          <a
            href="${pageContext.request.contextPath}/admin/ratingreport"
            class="list-group-item list-group-item-action py-2 ${param.activePage == 'ratingreport' ? 'active' : ''}"
          >
            <i class="fas fa-star me-2"></i> Đánh Giá Xếp Hạng
          </a>
        </div>
      </div>
    </div>

    <div class="list-group list-group-flush">
      <a
        href="${pageContext.request.contextPath}/roomList"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'roomlist' ? 'active' : ''}"
      >
        <i class="fas fa-list me-2"></i> Danh sách phòng
      </a>
    </div>

    <!-- Account & System Section -->
    <h6 class="menu-heading text-uppercase text-white-50 mt-4 px-3"></h6>
    <div class="list-group list-group-flush">
      <a
        href="${pageContext.request.contextPath}/admin/account-settings.jsp"
        class="list-group-item list-group-item-action py-3 ${param.activePage == 'account-settings' ? 'active' : ''}"
      >
        <i class="fas fa-user-cog me-2"></i> Cài đặt tài khoản
      </a>
      <a
        href="${pageContext.request.contextPath}/admin/logout"
        class="list-group-item list-group-item-action py-3 text-danger"
        onclick="return confirm('Bạn có chắc muốn đăng xuất không?')"
      >
        <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
      </a>
    </div>
  </div>
</div>

<script>
  function confirmLogout() {
    if (confirm("Bạn có chắc muốn đăng xuất không?")) {
      // Invalidate session and redirect
      fetch("${pageContext.request.contextPath}/admin/logout", {
        method: "POST",
      }).then(() => {
        window.location.href =
          "${pageContext.request.contextPath}/login.jsp?logout=true";
      });
    }
    return false;
  }

  // Toggle sidebar functionality
  document.addEventListener("DOMContentLoaded", function () {
    const menuToggle = document.getElementById("menu-toggle");
    const wrapper = document.getElementById("wrapper");

    const sidebar = document.getElementById("sidebar-wrapper");

    if (menuToggle) {
      menuToggle.addEventListener("click", function () {
        wrapper.classList.toggle("toggled");
        sidebar.classList.toggle("toggled");
      });
    }

    // Close sidebar when clicking outside on mobile
    document.addEventListener("click", function (event) {
      if (window.innerWidth <= 768) {
        const isClickInsideSidebar = sidebar.contains(event.target);
        const isClickOnToggle = menuToggle && menuToggle.contains(event.target);

        if (
          !isClickInsideSidebar &&
          !isClickOnToggle &&
          !sidebar.classList.contains("toggled")
        ) {
          wrapper.classList.add("toggled");
          sidebar.classList.add("toggled");
        }
      }
    });
  });
</script>
