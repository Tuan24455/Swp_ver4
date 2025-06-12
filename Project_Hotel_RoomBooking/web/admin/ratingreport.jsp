<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đánh Giá Xếp Hạng - Hotel Management System</title>
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
      .star {
        color: #ffd200;
      }
    </style>
</head>

<body>
<div class="d-flex" id="wrapper">

    <jsp:include page="/admin/includes/sidebar.jsp">
        <jsp:param name="activePage" value="ratingreport" />
    </jsp:include>

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
                        <h1 class="h2 mb-2">Đánh Giá Xếp Hạng</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Home</a></li>
                                <li class="breadcrumb-item active">Đánh Giá Xếp Hạng</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="row g-4 mb-4">
                <div class="col-xl-4 col-md-4">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Điểm Trung Bình</h6>
                            <h2 class="card-title display-6 fw-bold mb-1">
                                4.5/5
                            </h2>
                            <p class="card-text text-warning">
                                <i class="fas fa-star star me-1"></i> Trung bình từ khách hàng
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-md-4">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Tổng Đánh Giá</h6>
                            <h2 class="card-title display-6 fw-bold mb-1">
                                256
                            </h2>
                            <p class="card-text text-success">
                                <i class="fas fa-comment me-1"></i> Lượt đánh giá
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rating Distribution & Recent Reviews -->
            <div class="row g-4 mb-4">
                <div class="col-lg-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">Review về Phòng</h5>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled">
                                <li class="mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar">
                                            <img src="${pageContext.request.contextPath}/web/images/default-avatar.png" alt="Circle Image" class="img-fluid rounded-circle" style="width: 50px;" />
                                        </div>
                                        <div class="ms-3">
                                            <h6 class="mb-1">Nguyễn Văn A</h6>
                                            <span class="text-muted">
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                            </span>
                                            <p class="text-muted mb-0">Phòng rất sạch sẽ và thoải mái</p>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">Review về Chất Lượng Dịch Vụ</h5>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled">
                                <li>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar">
                                            <img src="${pageContext.request.contextPath}/web/images/default-avatar.png" alt="Circle Image" class="img-fluid rounded-circle" style="width: 50px;" />
                                        </div>
                                        <div class="ms-3">
                                            <h6 class="mb-1">Trần Thị B</h6>
                                            <span class="text-muted">
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                            </span>
                                            <p class="text-muted mb-0">Dịch vụ khá tốt, nhân viên thân thiện</p>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Reviews Table -->
            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Chi Tiết Đánh Giá</h4>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Khách Hàng</th>
                                            <th>Phòng</th>
                                            <th>Điểm</th>
                                            <th>Nhận Xét</th>
                                            <th>Ngày</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Nguyễn Văn A</td>
                                            <td>Deluxe Room</td>
                                            <td>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                            </td>
                                            <td>Phòng rất sạch sẽ và thoải mái</td>
                                            <td>15/06/2023</td>
                                        </tr>
                                        <tr>
                                            <td>Trần Thị B</td>
                                            <td>Standard Room</td>
                                            <td>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="fas fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                                <i class="far fa-star star"></i>
                                            </td>
                                            <td>Dịch vụ khá tốt, nhân viên thân thiện</td>
                                            <td>10/06/2023</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bundle JS (Popper + Bootstrap) -->
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
</script>
</body>
</html>
