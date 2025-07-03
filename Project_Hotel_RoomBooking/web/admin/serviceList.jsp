<%-- 
    Document   : serviceList
    Created on : Jun 24, 2025, 3:54:48 PM
    Author     : Phạm Quốc Tuấn
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Service Management - Hotel Management System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
            />
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" />
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="service" />
            </jsp:include>


            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-secondary" id="menu-toggle">
                            <i class="fas fa-bars"></i>
                        </button>
                    </div>
                </nav>

                <style>
                    .header-bg {
                        background-image: url('https://images.squarespace-cdn.com/content/v1/5aadf482aa49a1d810879b88/1626698419120-J7CH9BPMB2YI728SLFPN/1.jpg');
                        background-size: cover;
                        background-position: center;
                        background-repeat: no-repeat;
                        padding: 20px 30px;
                        border-radius: 8px;
                        color: white;
                        box-shadow: inset 0 0 0 1000px rgba(0,0,0,0.4); /* Overlay giúp chữ nổi */
                    }
                    .header-bg .breadcrumb a {
                        color: #ddd;
                    }
                    .header-bg .breadcrumb .active {
                        color: #fff;
                    }
                </style>

                <div class="header-bg mb-4">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb custom-breadcrumb">
                            <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Dịch Vụ</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="h3 mb-0">Quản lí Dịch Vụ</h1>
                        <button
                            class="btn btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#addServiceModal"
                            >
                            <i class="fas fa-plus me-2"></i>Thêm Dịch Vụ
                        </button>
                    </div>
                </div>

                <!-- Filter Section -->
                <form method="get" action="promotionsList"  class="mb-4">
                    <input type="hidden" name="page" value="1" />

                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Loại Dịch Vụ</label>
                            <select class="form-select" name="status">
                                <option value="" ${paramStatus == null ? 'selected' : ''}>Tất Cả</option>
                                <option value="Restaurant"${paramStatus == 'active' ? 'selected' : ''}>Nhà Hàng</option>
                                <option value="Spa" ${paramStatus == 'expired' ? 'selected' : ''}>Spa</option>
                                <option value="Gym" ${paramStatus == 'upcoming' ? 'selected' : ''}>Gym</option>
                                <option value="Shuttle" ${paramStatus == 'upcoming' ? 'selected' : ''}>Di Chuyển</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Start Date</label>
                            <input type="date" class="form-control" name="startDate" value="${paramStartDate}" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">End Date</label>
                            <input type="date" class="form-control" name="endDate" value="${paramEndDate}" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label d-block">&nbsp;</label>    
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search me-2"></i>Filter
                            </button>
                        </div>
                    </div>

                </form>


                <!-- Service Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">All Service</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
                            <div class="d-flex align-items-center mb-2 mb-md-0">
                                <span class="me-2 text-muted">Show</span>
                                <select
                                    class="form-select form-select-sm"
                                    style="width: auto"
                                    >
                                    <option value="10">10</option>
                                    <option value="25">25</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                </select>
                                <span class="ms-2 text-muted">entries</span>
                            </div>
                            <div
                                class="input-group search-table-input"
                                style="width: 250px"
                                >
                                <span class="input-group-text"
                                      ><i class="fas fa-search"></i
                                    ></span>
                                <input
                                    type="text"
                                    class="form-control"
                                    placeholder="Search promotions..."
                                    />
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Loại Dịch Vụ</th>
                                        <th>Tên Dịch Vụ</th>
                                        <th>Ảnh (%)</th>
                                        <th>Giá</th>
                                        <th>Description</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${d}">
                                        <tr>
                                            <td>#${d.serviceTypeName}</td>
                                            <td>${d.serviceName}</td>
                                            <td>${d.imageUrl}</td>
                                            <td>${d.servicePrice}</td>
                                            <td>${d.description}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button
                                                        class="btn btn-sm btn-outline-primary"
                                                        title="View"
                                                        >
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button
                                                        class="btn btn-sm btn-outline-warning"
                                                        title="Edit"
                                                        type="button"
                                                        onclick="openEditModal(${d.id}, '${p.title}', ${p.percentage}, '${p.startAt}', '${p.endAt}', '${p.description}')"
                                                        >
                                                        <i class="fas fa-edit"></i>
                                                    </button>


                                                    <form action="${pageContext.request.contextPath}/deletePromotion" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa không?');">
                                                        <input type="hidden" name="id" value="${p.id}" />
                                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <!-- More rows here -->
                                </tbody>
                            </table>
                        </div>

                        <c:set var="startEntry" value="${(currentPage - 1) * pageSize + 1}" />
                        <c:set var="endEntry" value="${startEntry + pro.size() - 1}" />

                        <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                            <small class="text-muted mb-2 mb-md-0">
                                Showing ${startEntry} to ${endEntry} of ${totalPromotions} entries
                            </small>

                            <nav aria-label="Promotion pagination">
                                <ul class="pagination pagination-sm mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="promotionsList?status=${paramStatus}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${currentPage - 1}">
                                            Previous
                                        </a>
                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="promotionsList?status=${paramStatus}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${p}">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="promotionsList?status=${paramStatus}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${currentPage + 1}">
                                            Next
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>





<!-- Modal Thêm Dịch Vụ -->
<div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form action="ServiceController" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="create" />
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="addServiceModalLabel">Thêm Dịch Vụ Mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">

          <div class="mb-3">
            <label for="service_name" class="form-label">Tên dịch vụ</label>
            <input type="text" class="form-control" id="service_name" name="service_name" required>
          </div>

          <div class="mb-3">
            <label for="service_type_id" class="form-label">Loại dịch vụ</label>
            <select class="form-select" id="service_type_id" name="service_type_id" required>
              <option value="" disabled selected>-- Chọn loại dịch vụ --</option>
              <option value="1">Restaurant</option>
              <option value="2">Spa</option>
              <option value="3">Gym</option>
              <option value="4">Shuttle</option>
              <c:forEach var="type" items="${serviceTypeList}">
                <option value="${type.id}">${type.service_type}</option>
              </c:forEach>
            </select>
          </div>

          <div class="mb-3">
            <label for="service_price" class="form-label">Giá (VNĐ)</label>
            <input type="number" class="form-control" id="service_price" name="service_price" step="1000" required>
          </div>

          <div class="mb-3">
            <label for="description" class="form-label">Mô tả</label>
            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
          </div>

          <div class="mb-3">
            <label for="image" class="form-label">Ảnh đại diện</label>
            <input type="file" class="form-control" id="image" name="image" accept="image/*">
          </div>

        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Thêm dịch vụ</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        </div>
      </div>
    </form>
  </div>
</div>



    <!-- Update Promotion Modal -->
    <div class="modal fade" id="updatePromotionModal" tabindex="-1" aria-labelledby="updatePromotionLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="updatePromotionForm" action="${pageContext.request.contextPath}/updatePromotion" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updatePromotionLabel">Update Promotion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <input type="hidden" id="update_id" name="id" value="${promotion.id}" />

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="update_title" class="form-label">Title</label>
                                <input type="text" id="update_title" name="title" class="form-control" required
                                       value="${promotion.title}" />
                            </div>

                            <div class="col-md-6">
                                <label for="update_percentage" class="form-label">Percentage (%)</label>
                                <input type="number" id="update_percentage" name="percentage" class="form-control" min="0" max="100" required
                                       value="${promotion.percentage}" />
                            </div>

                            <div class="col-md-6">
                                <label for="update_start_at" class="form-label">Start Date</label>
                                <input type="date" id="update_start_at" name="start_at" class="form-control" required
                                       value="<fmt:formatDate value='${promotion.startAt}' pattern='yyyy-MM-dd'/>" />
                            </div>

                            <div class="col-md-6">
                                <label for="update_end_at" class="form-label">End Date</label>
                                <input type="date" id="update_end_at" name="end_at" class="form-control" required
                                       value="<fmt:formatDate value='${promotion.endAt}' pattern='yyyy-MM-dd'/>" />
                            </div>

                            <div class="col-12">
                                <label for="update_description" class="form-label">Description</label>
                                <textarea id="update_description" name="description" class="form-control" rows="3">${promotion.description}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Promotion</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        function openEditModal(id, title, percentage, startAt, endAt, description) {
            // Gán dữ liệu vào các input của form update
            document.getElementById('update_id').value = id;
            document.getElementById('update_title').value = title;
            document.getElementById('update_percentage').value = percentage;

            // Chuyển đổi định dạng ngày nếu cần
            document.getElementById('update_start_at').value = startAt ? startAt.substring(0, 10) : '';
            document.getElementById('update_end_at').value = endAt ? endAt.substring(0, 10) : '';

            document.getElementById('update_description').value = description;

            // Mở modal bằng Bootstrap 5 JS API
            const updateModal = new bootstrap.Modal(document.getElementById('updatePromotionModal'));
            updateModal.show();
        }
    </script>

    <script>
        function validatePromotionForm(formId, startDateId, endDateId) {
            const form = document.getElementById(formId);
            form.addEventListener('submit', function (event) {
                const startDate = new Date(document.getElementById(startDateId).value);
                const endDate = new Date(document.getElementById(endDateId).value);

                if (endDate <= startDate) {
                    event.preventDefault();  // Ngăn submit
                    alert('End Date phải lớn hơn Start Date!');
                    document.getElementById(endDateId).focus();
                }
            });
        }

        // Gọi cho cả 2 form add và update
        validatePromotionForm('promotionForm', 'start_at', 'end_at');
        validatePromotionForm('updatePromotionForm', 'update_start_at', 'update_end_at');
    </script>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
