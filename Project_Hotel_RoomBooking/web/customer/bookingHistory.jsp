<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <title>Lịch sử đặt lịch</title>

        <!-- Font Awesome (nếu muốn dùng icon) -->
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
              crossorigin="anonymous" referrerpolicy="no-referrer"/>

        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="customer/includes/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
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
                --shadow-sm: 0 .125rem .25rem rgba(0,0,0,.075);
                --shadow: 0 .5rem 1rem rgba(0,0,0,.15);
                --transition: all 0.3s ease;
            }

            /* Giữ nguyên phần navbar */
            .navbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: #ffffff;
                padding: 0 24px;
                height: 60px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .navbar .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: #333;
                text-decoration: none;
            }

            .navbar-center .nav-links {
                display: flex;
                gap: 24px;
                position: relative;
            }

            .navbar-center .nav-links li a {
                text-decoration: none;
                color: #333;
                font-weight: 500;
                padding: 6px 8px;
                border-radius: 4px;
                transition: background-color 0.2s;
            }

            .navbar-center .nav-links li a:hover,
            .navbar-center .nav-links li a.active {
                background-color: #f2f2f2;
                color: #007bff;
            }

            /* Custom Styles */
            body {
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
            }

            .card {
                background: #fff;
                border-radius: 10px;
                border: none;
                transition: var(--transition);
            }

            .card:hover {
                transform: translateY(-2px);
            }

            .card-title {
                color: var(--dark-color);
                font-size: 1.75rem;
                font-weight: 600;
            }

            .input-group {
                box-shadow: var(--shadow-sm);
                border-radius: 8px;
                overflow: hidden;
            }

            .form-control {
                border: 1px solid var(--border-color);
                padding: 0.75rem 1rem;
                font-size: 1rem;
                transition: var(--transition);
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                transition: var(--transition);
            }

            .btn-primary:hover {
                background-color: var(--primary-hover);
                border-color: var(--primary-hover);
                transform: translateY(-1px);
            }

            .table {
                margin-bottom: 0;
            }

            .table thead th {
                background-color: var(--light-color);
                border-bottom: 2px solid var(--border-color);
                color: var(--dark-color);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
            }

            .table td {
                vertical-align: middle;
                padding: 1rem;
                border-bottom: 1px solid var(--border-color);
            }

            .table tbody tr {
                transition: var(--transition);
            }

            .table tbody tr:hover {
                background-color: rgba(0,123,255,.05);
            }

            .badge {
                padding: 0.5em 1em;
                font-weight: 500;
                letter-spacing: 0.5px;
            }

            .pagination {
                margin-top: 2rem;
            }

            .page-link {
                border: none;
                padding: 0.75rem 1rem;
                margin: 0 0.25rem;
                color: var(--dark-color);
                border-radius: 6px;
                transition: var(--transition);
            }

            .page-item.active .page-link {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .page-item.disabled .page-link {
                background-color: var(--light-color);
                color: var(--secondary-color);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    padding: 1rem;
                }

                .card-body {
                    padding: 1.25rem;
                }

                .table thead {
                    display: none;
                }

                .table tbody tr {
                    display: block;
                    margin-bottom: 1rem;
                    border: 1px solid var(--border-color);
                    border-radius: 8px;
                }

                .table td {
                    display: block;
                    text-align: right;
                    padding: 0.75rem;
                    border: none;
                }

                .table td::before {
                    content: attr(data-label);
                    float: left;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 0.85rem;
                }

                .pagination .page-link {
                    padding: 0.5rem 0.75rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- NAVBAR GIỐNG booking.jsp -->
        <jsp:include page="includes/header.jsp"/>


        <!-- NỘI DUNG CHÍNH: LỊCH SỬ ĐẶT LỊCH -->
        <div class="container py-5">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">Lịch sử đặt lịch</h2>

                    <!-- FORM TÌM KIẾM -->
                    <form action="bookingHistory" method="get" class="mb-4">
                        <div class="input-group">
                            <input type="text" name="search" 
                                   class="form-control form-control-lg shadow-none"
                                   placeholder="Tìm theo dịch vụ hoặc trạng thái..."
                                   value="${fn:escapeXml(param.search)}"/>
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search me-2"></i>Tìm
                            </button>
                        </div>
                    </form>

                    <!-- BẢNG HIỂN THỊ LỊCH SỬ -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-4">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">Ngày</th>
                                    <th scope="col">Giờ</th>
                                    <th scope="col">Dịch vụ</th>
                                    <th scope="col">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${historyList}">
                                    <tr>
                                        <td><c:out value="${b.ngay}" /></td>
                                        <td><c:out value="${b.gio}" /></td>
                                        <td><c:out value="${b.dichVu}" /></td>
                                        <td>
                                            <span class="badge rounded-pill bg-${b.trangThai == 'Đã hoàn thành' ? 'success' : b.trangThai == 'Đã hủy' ? 'danger' : 'warning'} text-white">
                                                <c:out value="${b.trangThai}" />
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty historyList}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-4">
                                            <i class="fas fa-calendar-times fs-4 mb-3 d-block"></i>
                                            Không tìm thấy lịch sử đặt nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- PHÂN TRANG -->
                    <nav aria-label="Điều hướng trang" class="d-flex justify-content-center">
                        <ul class="pagination mb-0">
                            <!-- Nút Previous -->
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?search=${fn:escapeXml(param.search)}&amp;page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>

                            <!-- Hiển thị các số trang -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?search=${fn:escapeXml(param.search)}&amp;page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Nút Next -->
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?search=${fn:escapeXml(param.search)}&amp;page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </body>
</html>