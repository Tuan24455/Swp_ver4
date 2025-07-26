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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

                <div class="header-bg mb-4 p-3 rounded shadow-sm bg-light">
              

                    <!-- Dòng tiêu đề + nút -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <!-- Nút Home (icon) -->
                            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary me-3">
                                <i class="fas fa-home"></i>
                            </a>
                            <!-- Tiêu đề -->
                            <h1 class="h3 mb-0">Quản lí Khuyến Mãi</h1>
                        </div>

                        <!-- Nút Thêm Khuyến Mãi -->
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
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <form method="post" action="promotionList">
                            <input type="hidden" name="page" value="1" />
                            <div class="row g-3 align-items-end">
                                <div class="col-md-4 col-sm-6">
                                    <label for="startDate" class="form-label fw-semibold">
                                        <i class="fas fa-calendar-alt me-1 text-primary"></i>Start Date
                                    </label>
                                    <input type="date" id="startDate" class="form-control rounded-3 shadow-sm" name="startDate" value="${paramStartDate}" />
                                </div>

                                <div class="col-md-4 col-sm-6">
                                    <label for="endDate" class="form-label fw-semibold">
                                        <i class="fas fa-calendar-check me-1 text-success"></i>End Date
                                    </label>
                                    <input type="date" id="endDate" class="form-control rounded-3 shadow-sm" name="endDate" value="${paramEndDate}" />
                                </div>

                                <div class="col-md-4 col-sm-12 d-flex justify-content-start justify-content-md-start mt-2 mt-md-0">
                                    <button type="submit" class="btn btn-primary px-4 py-2 rounded-pill shadow-sm  w-md-auto">
                                        <i class="fas fa-filter me-2"></i>Lọc
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>



                <!-- Promotions Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">Thông tin khuyến mãi</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty requestScope.noResultsMessage}">
                            <div class="alert alert-danger" role="alert">
                                ${requestScope.noResultsMessage}
                            </div>
                        </c:if>
                        <form action="promotionList" method="post" class="d-flex mb-3" style="width: 300px;">
                            <input type="text" class="form-control me-2" name="searchQuery"
                                   placeholder="Tìm khuyến mãi..."
                                   value="${sessionScope.promotionSearchQuery}" />
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>



                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tên khuyến mãi</th>
                                        <th>Ưu đãi (%)</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Mô tả</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${pro}">
                                        <tr>
                                            <td>${p.title}</td>
                                            <td>${p.percentage}</td>
                                            <td>${p.startAt}</td>
                                            <td>${p.endAt}</td>
                                            <td>${p.description}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-warning"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#updatePromotionModal${p.id}"
                                                            style="margin-right: 10px;">
                                                        <i class="fas fa-edit"></i>
                                                    </button>



                                                    <form action="${pageContext.request.contextPath}/deletePromotion" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa không?');">
                                                        <input type="hidden" name="id" value="${p.id}" />
                                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                                <div class="modal fade" id="updatePromotionModal${p.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title">Cập Nhật Khuyến Mãi</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <form class="updatePromotionForm" action="updatePromotion" method="post" enctype="multipart/form-data">
                                                                    <input type="hidden" name="id" value="${p.id}">

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Tiêu Đề</label>
                                                                        <input type="text" class="form-control" name="title" value="${p.title}" required>
                                                                    </div>

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Tỷ Lệ Giảm Giá (%)</label>
                                                                        <input type="number" class="form-control" name="percentage" min="0" max="100" value="${p.percentage}" required>
                                                                    </div>

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Ngày Bắt Đầu</label>
                                                                        <input type="date" class="form-control" name="start_at"
                                                                               value="<fmt:formatDate value='${p.startAt}' pattern='yyyy-MM-dd' />" required>
                                                                    </div>

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Ngày Kết Thúc</label>
                                                                        <input type="date" class="form-control" name="end_at"
                                                                               value="<fmt:formatDate value='${p.endAt}' pattern='yyyy-MM-dd' />" required>
                                                                    </div>

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Mô Tả</label>
                                                                        <textarea class="form-control" name="description" rows="3" required>${p.description}</textarea>
                                                                    </div>

                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                        <button type="submit" class="btn btn-primary">Lưu Cập Nhật</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
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
                        <div class="d-flex justify-content-end align-items-center mt-3 flex-wrap">

                            <nav aria-label="Promotion pagination">
                                <ul class="pagination pagination-sm mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="promotionList?searchQuery=${param.searchQuery}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${currentPage - 1}">
                                            Previous
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="promotionList?searchQuery=${param.searchQuery}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${p}">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="promotionList?searchQuery=${param.searchQuery}&startDate=${paramStartDate}&endDate=${paramEndDate}&page=${currentPage + 1}">
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





    <!-- Modal Thêm Khuyến Mãi -->
    <div class="modal fade" id="addPromotionModal" tabindex="-1" aria-labelledby="addPromotionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPromotionModalLabel">Thêm Khuyến Mãi</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addPromotionForm" action="addPromotion" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="title" class="form-label">Tiêu Đề</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label for="percentage" class="form-label">Tỷ Lệ Giảm Giá (%)</label>
                            <input type="number" class="form-control" id="percentage" name="percentage" min="0" max="100" required>
                        </div>
                        <div class="mb-3">
                            <label for="start_at" class="form-label">Ngày Bắt Đầu</label>
                            <input type="date" class="form-control" id="start_at" name="start_at" required>
                        </div>
                        <div class="mb-3">
                            <label for="end_at" class="form-label">Ngày Kết Thúc</label>
                            <input type="date" class="form-control" id="end_at" name="end_at" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô Tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu Khuyến Mãi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>





    <script>
        function openUpdateModal(button) {
            $('#update_id').val($(button).data('id'));
            $('#update_title').val($(button).data('title'));
            $('#update_percentage').val($(button).data('percentage'));
            $('#update_start_at').val($(button).data('start'));
            $('#update_end_at').val($(button).data('end'));
            $('#update_description').val($(button).data('description'));

            $('#updatePromotionModal').modal('show');
        }

    </script>

    <script>
        $(document).ready(function () {
            let today = new Date().toISOString().split('T')[0];
            $('#start_at').attr('min', today);
            $('#end_at').attr('min', today);
        });
    </script>

    <script>
        $(document).ready(function () {
            const today = new Date().toISOString().split('T')[0];
            $('input[name="start_at"]').attr('min', today);
            $('input[name="end_at"]').attr('min', today);
        });

    </script>

    <script>
        $('#addPromotionForm').on('submit', function (e) {
            e.preventDefault();
            var formData = new FormData(this);

            $.ajax({
                url: 'addPromotion',
                method: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function (response) {
                    if (response === "duplicate") {
                        alert("Tên khuyến mãi đã tồn tại.");
                    } else if (response === "invalidTitleFormat") {
                        alert("Tên không được chứa kí tự đặc biệt !");
                    } else if (response === "blankDescription") {
                        alert("Mô tả phải từ 10-100 ký tự.");
                    } else if (response === "overlap") {
                        alert("Thời gian khuyến mãi trùng với khuyến mãi hiện có ");
                    } else if (response === "invalidPercentage") {
                        alert("Phần trăm khuyến mãi không hợp lệ.");
                    } else if (response === "startMustAfterLastEnd") {
                        alert("Ngày bắt đầu khuyến mãi đang tồn tại khuyến mãi khác ! ");
                    } else if (response === "invalidDateRange") {
                        alert("Ngày bắt đầu phải lớn hơn ngày kết thúc !");
                    } else if (response === "success") {
                        alert("Thêm khuyến mãi thành công ❤");
                        $('#addPromotionModal').modal('hide');
                        location.reload();
                    } else {
                        alert("Đã xảy ra lỗi bất ngờ!");
                    }
                },
                error: function () {
                    alert("Lỗi kết nối máy chủ.");
                }
            });
        });

    </script>
    <script>
        $(document).on('submit', '.updatePromotionForm', function (e) {
            e.preventDefault(); // Quan trọng! Không để form reload

            var formData = new FormData(this);

            $.ajax({
                url: 'updatePromotion',
                method: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function (response) {
                    if (response.trim() === "startMustAfterLastEnd") {
                        alert("Ngày bắt đầu phải sau ngày kết thúc khuyến mãi trước.");
                    } else if (response === "duplicate") {
                        alert("Tên khuyến mãi đã tồn tại.");
                    } else if (response.trim() === "success") {
                        alert("Cập nhật thành công ❤️");
                        $('.modal').modal('hide');
                        location.reload();
                    } else if (response === "invalidDateRange") {
                        alert("Ngày bắt đầu phải lớn hơn ngày kết thúc !");
                    } else if (response === "overlap") {
                        alert("Khuyến mãi đã trùng với khuyến mãi hiện có !");
                    } else if (response === "invalidTitleFormat") {
                        alert("Tên khuyến mãi không được chứa các kí tự đăcj biệt !");
                    } else if (response === "blankDescription") {
                        alert("Mô tả phải từ 10-100 ký tự !");
                    } else {
                        alert(response);
                    }
                },
                error: function () {
                    alert("Lỗi kết nối máy chủ.");
                }
            });
        });

    </script>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>



