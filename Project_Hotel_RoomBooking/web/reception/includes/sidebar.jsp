<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Replicated admin sidebar styles -->
<style>
    .sidebar-wrapper {
        position: fixed !important;
        top: 0;
        left: 0;
        height: 100vh;
        width: 230px; /* Sidebar width */
        background-color: #E3F2FD;
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
        color: #0D47A1;
        border-radius: 0;
        transition: all 0.3s ease;
        padding-left: 1rem;
        padding-right: 1rem;
    }
    .sidebar-menu .list-group-item:hover {
        background-color: #BBDEFB;
        color: #1565C0;
    }
    .sidebar-menu .list-group-item.active {
        background-color: #42A5F5;
        color: white;
    }
    .sidebar-menu .list-group-item i {
        width: 20px;
        text-align: center;
    }
    .menu-heading {
        color: #1976D2 !important;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    /* Adjust main content width */
    #page-content-wrapper {
        margin-left: 230px;
        width: calc(100% - 230px);
        transition: margin-left 0.3s ease, width 0.3s ease;
    }
    #wrapper.toggled #page-content-wrapper {
        margin-left: 0;
        width: 100%;
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

<div class="sidebar-wrapper" id="sidebar-wrapper">
    <div class="sidebar-menu">
        <div class="list-group list-group-flush">
            <a href="${pageContext.request.contextPath}/reception/dashboard.jsp" class="list-group-item list-group-item-action py-3 ${param.activePage == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-tachometer-alt me-2"></i> Bảng điều khiển
            </a>
            <a href="${pageContext.request.contextPath}/bookingList" class="list-group-item list-group-item-action py-3 ${param.activePage == 'bookings' ? 'active' : ''}">
                <i class="fas fa-calendar-check me-2"></i> Quản lý đặt phòng
            </a>
            <a href="${pageContext.request.contextPath}/reception/serviceManagement" class="list-group-item list-group-item-action py-3 ${param.activePage == 'service-management' ? 'active' : ''}">
                <i class="fas fa-concierge-bell me-2"></i> Quản lý đặt dịch vụ
            </a>
        </div>

        <div class="list-group list-group-flush">
            <a href="${pageContext.request.contextPath}/roomStatus"
               class="list-group-item list-group-item-action py-3 ${param.activePage == 'roomlist' ? 'active' : ''}">
                <i class="fas fa-list me-2"></i> Danh sách phòng
            </a>
        </div>

        <!-- Account & System Section -->
        <h6 class="menu-heading text-uppercase text-white-50 mt-4 px-3"></h6>
        <div class="list-group list-group-flush">
            <!-- Thêm link quay lại trang chủ tại đây -->
            <a href="${pageContext.request.contextPath}/home" class="list-group-item list-group-item-action py-3 ${param.activePage == 'home' ? 'active' : ''}">
                <i class="fa-solid fa-house me-2"></i> Quay lại trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/receptionInfor"
               class="list-group-item list-group-item-action py-3 ${param.activePage == 'account-settings' ? 'active' : ''}">
                <i class="fas fa-user-cog me-2"></i> Cài đặt tài khoản
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="list-group-item list-group-item-action py-3 text-danger"
               onclick="return confirm('Bạn có chắc muốn đăng xuất không?')">
                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
            </a>
        </div>
    </div>
</div>

<script>
    // Toggle sidebar functionality (copied from admin)
    document.addEventListener('DOMContentLoaded', function() {
        const menuToggle = document.getElementById('menu-toggle');
        const wrapper = document.getElementById('wrapper');
        const sidebar = document.getElementById('sidebar-wrapper');

        if (menuToggle) {
            menuToggle.addEventListener('click', function() {
                wrapper.classList.toggle('toggled');
                sidebar.classList.toggle('toggled');
            });
        }

        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function(event) {
            if (window.innerWidth <= 768) {
                const isClickInsideSidebar = sidebar.contains(event.target);
                const isClickOnToggle = menuToggle && menuToggle.contains(event.target);
                if (!isClickInsideSidebar && !isClickOnToggle && !sidebar.classList.contains('toggled')) {
                    wrapper.classList.add('toggled');
                    sidebar.classList.add('toggled');
                }
            }
        });
    });
</script>