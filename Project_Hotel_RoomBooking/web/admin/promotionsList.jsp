<%-- 
    Document   : promotions
    Created on : May 27, 2025, 10:40:46 PM
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
        <title>Promotions Management - Hotel Management System</title>
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
                <jsp:param name="activePage" value="promotion" />
            </jsp:include>


            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <jsp:include page="includes/navbar.jsp" />

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
                            <li class="breadcrumb-item active" aria-current="page">Promotions</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="h3 mb-0">Quản lí Khuyến Mãi</h1>
                        <button
                            class="btn btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#addPromotionModal"
                            >
                            <i class="fas fa-plus me-2"></i>Thêm Khuyến Mãi
                        </button>
                    </div>
                </div>

                <!-- Filter Section -->
                <form method="get" action="promotionsList"  class="mb-4">
                    <input type="hidden" name="page" value="1" />

                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status">
                                <option value="" ${paramStatus == null ? 'selected' : ''}>All Status</option>
                                <option value="active" ${paramStatus == 'active' ? 'selected' : ''}>Active</option>
                                <option value="expired" ${paramStatus == 'expired' ? 'selected' : ''}>Expired</option>
                                <option value="upcoming" ${paramStatus == 'upcoming' ? 'selected' : ''}>Upcoming</option>
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


                <!-- Promotions Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">All Promotions</h5>
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
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Percentage (%)</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Description</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${pro}">
                                        <tr>
                                            <td>#${p.id}</td>
                                            <td>${p.title}</td>
                                            <td>${p.percentage}</td>
                                            <td>${p.startAt}</td>
                                            <td>${p.endAt}</td>
                                            <td>${p.description}</td>
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
                                                        data-id="${p.id}"
                                                        data-title="${p.title}"
                                                        data-percentage="${p.percentage}"
                                                        data-start-at="${p.startAt}"
                                                        data-end-at="${p.endAt}"
                                                        data-description="${p.description}"
                                                        onclick="openEditModal(this)"
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





    <!-- Add Promotion Modal -->
    <div class="modal fade" id="addPromotionModal" tabindex="-1" aria-labelledby="addPromotionLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="promotionForm" action="${pageContext.request.contextPath}/addPromotion" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addPromotionLabel">Add New Promotion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="title" class="form-label">Title</label>
                                <input type="text" id="title" name="title" class="form-control" required />
                            </div>

                            <div class="col-md-6">
                                <label for="percentage" class="form-label">Percentage (%)</label>
                                <input type="number" id="percentage" name="percentage" class="form-control" min="0" max="100" required />
                            </div>

                            <div class="col-md-6">
                                <label for="start_at" class="form-label">Start Date</label>
                                <input type="date" id="start_at" name="start_at" class="form-control" required />
                            </div>

                            <div class="col-md-6">
                                <label for="end_at" class="form-label">End Date</label>
                                <input type="date" id="end_at" name="end_at" class="form-control" required />
                            </div>

                            <div class="col-12">
                                <label for="description" class="form-label">Description</label>
                                <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Promotion</button>
                    </div>
                </form>
            </div>
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
        function openEditModal(button) {
            const id = button.getAttribute('data-id');
            const title = button.getAttribute('data-title');
            const percentage = button.getAttribute('data-percentage');
            const startAt = button.getAttribute('data-start-at');
            const endAt = button.getAttribute('data-end-at');
            const description = button.getAttribute('data-description');

            document.getElementById('update_id').value = id;
            document.getElementById('update_title').value = title;
            document.getElementById('update_percentage').value = percentage;
            document.getElementById('update_start_at').value = startAt.substring(0, 10);
            document.getElementById('update_end_at').value = endAt.substring(0, 10);
            document.getElementById('update_description').value = description;

            var myModal = new bootstrap.Modal(document.getElementById('updatePromotionModal'));
            myModal.show();
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



