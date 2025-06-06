<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>'
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>User Management - Hotel Management System</title>
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
            .table-actions .btn {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
            }
            .status-badge {
                font-size: 0.75rem;
                padding: 0.35rem 0.65rem;
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
        </style>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Include Sidebar -->
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="users" />
            </jsp:include>
            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Include Top Navigation -->
                <jsp:include page="includes/header.jsp" />
                <div class="container-fluid py-4">
                    <!-- Page Header -->
                    <div class="page-header" style="
                         background-image: url('https://images.squarespace-cdn.com/content/v1/5aadf482aa49a1d810879b88/1626698419120-J7CH9BPMB2YI728SLFPN/1.jpg');
                         background-size: cover;
                         background-position: center;
                         background-repeat: no-repeat;
                         padding: 20px;
                         color: white;
                         ">                       
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="h2 mb-2">Customer Management</h1>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Home</a></li>
                                        <li class="breadcrumb-item active">Customer Management</li>
                                    </ol>
                                </nav>
                            </div>

                        </div>
                    </div>

                    <!-- User Management Table -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white border-bottom py-3">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">Customer List</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control"
                                            placeholder="Search users..."
                                            id="searchInput"
                                            />
                                        <button class="btn btn-outline-secondary" type="button">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <!-- Filter Section -->
                            <div class="p-3 border-bottom bg-light">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <select class="form-select" id="roleFilter">
                                            <option value="">All Roles</option>
                                            <option value="admin">Admin</option>
                                            <option value="manager">Manager</option>
                                            <option value="staff">Staff</option>
                                            <option value="customer">Customer</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="statusFilter">
                                            <option value="">All Status</option>
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                            <option value="suspended">Suspended</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <input
                                            type="date"
                                            class="form-control"
                                            id="dateFilter"
                                            placeholder="Registration Date"
                                            />
                                    </div>
                                    <div class="col-md-3">
                                        <button
                                            class="btn btn-outline-primary w-100"
                                            onclick="applyFilters()"
                                            >
                                            <i class="fas fa-filter me-2"></i>Apply Filters
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>User ID</th>
                                            <th>Name</th>
                                            <td>Gender</td>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Address</th>
                                            <th>BookingDate</th>
                                            <th>Ckeck_in_date</th>
                                            <th>Check_out_date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${user}">
                                            <tr>
                                                <td><strong>#${u.id}</strong></td>
<!--                                                <td>
                                                    <img
                                                        src="https://via.placeholder.com/40x40"
                                                        class="rounded-circle"
                                                        alt="User Avatar"
                                                        width="40"
                                                        height="40"
                                                        />
                                                </td>-->
                                                <td>
                                                    <div>
                                                        <strong>${u.fullName}</strong>
                                                        <br />
                                                        <small class="text-muted">@${u.userName}</small>
                                                    </div>
                                                </td>
                                                <td>${u.gender}</td>
                                                <td>${u.email}</td>
                                                
<!--                                                <td>
                                                    <c:choose>
                                                        <c:when test="${!u.deleted}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>-->
                                                <td>${u.phone} </td>
                                                <td>${u.address}</td>

                                                <!--                                                <td>
                                                <fmt:formatDate value="${u.birth}" pattern="yyyy-MM-dd" />
                                            </td>-->

                                                <td><fmt:formatDate value="${u.bookingDate}" pattern="yyyy-MM-dd" /></td>
                                                <td>${u.checkInDate}</td>
                                                <td>${u.checkOutDate}</td>

                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <div class="p-3 border-top">
                                <div
                                    class="d-flex justify-content-between align-items-center flex-wrap"
                                    >
                                    <small class="text-muted mb-2 mb-md-0"
                                           >Showing 1 to 4 of 1,247 users</small
                                    >
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>