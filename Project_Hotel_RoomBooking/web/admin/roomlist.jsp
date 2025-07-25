E<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Room List - Hotel Management System</title>
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

        <!-- jQuery (bắt buộc) -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Bootstrap (CSS + JS) -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>

        <!-- Summernote CSS + JS -->
        <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>


    </head>
    <body>
        <div class="d-flex" id="wrapper" >
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="roomlist" />
            </jsp:include>

            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <jsp:include page="includes/navbar.jsp" />

                <div class="container-fluid py-4" >
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb custom-breadcrumb">
                            <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Room List
                            </li>
                        </ol>
                    </nav>

                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h3 mb-0">Quản lí phòng</h1>
                        <button
                            class="btn btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#addRoomModal"
                            >
                            <i class="fas fa-plus me-2"></i>Thêm phòng mới
                        </button>
                    </div>

                    <!-- Room Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Tổng số phòng</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${countAll}</h2>
                                    <p class="card-text text-info">
                                        <i class="fas fa-bed me-1"></i> Tất cả các kiẻu phòng
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Đang trống</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Available'] != null ? statusCounts['Available'] : 0}</h2>
                                    <p class="card-text text-success">
                                        <i class="fas fa-check-circle me-1"></i> Sẵn sàng để sử dụng
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Đang sử dụng</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Occupied'] != null ? statusCounts['Occupied'] : 0}</h2>
                                    <p class="card-text text-warning">
                                        <i class="fas fa-user me-1"></i> Có khách khàng sử dụng
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Bảo trì</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Maintenance'] != null ? statusCounts['Maintenance'] : 0}</h2>
                                    <p class="card-text text-danger">
                                        <i class="fas fa-tools me-1"></i> Đang sửa chữa
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <form method="post" action="roomList" class="row g-3 mb-4">
                        <input type="hidden" name="page" value="1" />
                        <div class="col-md-3">
                            <label class="form-label">Loại phòng</label>
                            <select name="roomType" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="rt" items="${roomTypes}">
                                    <option value="${rt.roomType}" ${param.roomType == rt.roomType ? 'selected' : ''}>
                                        ${rt.roomType}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Tình trạng</label>
                            <select name="roomStatus" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="Available" ${param.roomStatus == 'Available' ? 'selected' : ''}>Đang trống</option>
                                <option value="Occupied" ${param.roomStatus == 'Occupied' ? 'selected' : ''}>Đang sử dụng</option>
                                <option value="Maintenance" ${param.roomStatus == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">Tầng</label>
                            <select name="floor" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach begin="1" end="5" var="i">
                                    <option value="${i}" ${param.floor == i ? 'selected' : ''}>Tầng ${i}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2 align-self-end">
                            <button type="submit" class="btn btn-primary w-100">Lọc</button>
                        </div>
                    </form>
                    <!-- Rooms Table -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">Danh sách phòng</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="roomList" class="mb-3" style="max-width: 400px;">
                                <div class="input-group">
                                    <input type="text" name="roomNumberSearch" class="form-control" placeholder="Nhập số phòng..." value="${param.roomNumberSearch}" />
                                    <input type="hidden" name="page" value="1" />
                                    <button class="btn btn-outline-primary" type="submit">🔍 Tìm kiếm</button>
                                </div>
                            </form>





                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Ảnh</th>
                                            <th>Số phòng</th>
                                            <th>Kiểu phòng</th>
                                            <th>Tầng</th>
                                            <th>Sức chứa</th>
                                            <th>Giá phòng / đêm</th>
                                            <th>Trạng thái</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${rooms}">                                                                      
                                            <tr>
                                                <td>
                                                    <img src="${r.imageUrl}" alt="Room Image" width="80" height="60" style="object-fit:cover; border-radius: 6px;" />
                                                </td>
                                                <td><strong>${r.roomNumber}</strong></td>
                                                <td>${r.roomTypeName}</td>
                                                <td>${r.floor}</td>
                                                <td>${r.capacity}</td>
                                                <td>${r.roomPrice}đ</td>
                                                <td>
                                                    <span class="badge
                                                          ${r.roomStatus == 'Available' ? 'bg-light text-dark' : 
                                                            (r.roomStatus == 'Occupied' ? 'bg-warning text-dark' : 
                                                            (r.roomStatus == 'Maintenance' ? 'bg-danger' :
                                                            (r.roomStatus == 'Cleaning' ? 'bg-info text-dark' : 'bg-secondary')))}">
                                                          <c:choose>
                                                              <c:when test="${r.roomStatus == 'Available'}">Đang trống</c:when>
                                                              <c:when test="${r.roomStatus == 'Occupied'}">Đang sử dụng</c:when>
                                                              <c:when test="${r.roomStatus == 'Maintenance'}"> Đang bảo trì</c:when>

                                                              <c:otherwise>Không xác định</c:otherwise>
                                                          </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <!-- Nút chỉnh sửa -->
                                                        <button
                                                            type="button"
                                                            class="btn btn-sm btn-outline-warning"
                                                            title="Chỉnh sửa"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#editRoomModal${r.id}">
                                                            <i class="fas fa-edit"></i>
                                                        </button>

                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-danger delete-room-btn"
                                                                title="Xóa"
                                                                data-room-id="${r.id}"
                                                                data-room-number="${r.roomNumber}">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>


                                            </tr>          
                                        </tbody>

                                        <div class="modal fade" id="editRoomModal${r.id}" tabindex="-1" aria-labelledby="updateRoomLabel${r.id}" aria-hidden="true">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <form action="updateRoom" method="post" enctype="multipart/form-data" class="updateRoomForm">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="updateRoomLabel${r.id}">Cập nhật phòng</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>

                                                        <div class="modal-body">
                                                            <input type="hidden" name="roomId" value="${r.id}" />
                                                            <input type="hidden" name="oldImageUrl" value="${r.imageUrl}" />

                                                            <div class="row g-3">
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Số phòng</label>
                                                                    <input type="text" class="form-control" name="roomNumber" value="${r.roomNumber}" required />
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <label class="form-label">Loại phòng</label>
                                                                    <select name="roomType" class="form-select" required>
                                                                        <option value="1" ${r.roomTypeName == 'Standard Room' ? 'selected' : ''}>Standard Room</option>
                                                                        <option value="2" ${r.roomTypeName == 'Deluxe Room' ? 'selected' : ''}>Deluxe Room</option>
                                                                        <option value="3" ${r.roomTypeName == 'Suite' ? 'selected' : ''}>Suite</option>
                                                                        <option value="4" ${r.roomTypeName == 'Presidential Suite' ? 'selected' : ''}>Presidential Suite</option>
                                                                    </select>
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <label class="form-label">Tầng</label>
                                                                    <input type="text" class="form-control" name="floor_display" value="Tầng ${r.floor}" readonly>
                                                                    <input type="hidden" name="floor" value="${r.floor}">
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <label class="form-label">Sức chứa</label>
                                                                    <select class="form-select" name="capacity" required>
                                                                        <option value="1" ${r.capacity == 1 ? 'selected' : ''}>1 người</option>
                                                                        <option value="2" ${r.capacity == 2 ? 'selected' : ''}>2 người</option>
                                                                        <option value="3" ${r.capacity == 3 ? 'selected' : ''}>3 người</option>
                                                                        <option value="4" ${r.capacity == 4 ? 'selected' : ''}>4 người</option>
                                                                        <option value="6" ${r.capacity == 6 ? 'selected' : ''}>6 người</option>
                                                                    </select>
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <label class="form-label">Giá phòng / đêm</label>
                                                                    <input type="number" class="form-control" step="0.01" name="price" value="${r.roomPrice}" required />
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <label class="form-label">Tình trạng</label>
                                                                    <c:choose>
                                                                        <c:when test="${r.roomStatus == 'Occupied'}">
                                                                            <input type="text" class="form-control" value="Đang được sử dụng" readonly />
                                                                            <input type="hidden" name="status" value="Occupied" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <select name="status" class="form-select" required>
                                                                                <option value="Available" ${r.roomStatus == 'Available' ? 'selected' : ''}>Đang trống</option>
                                                                                <option value="Maintenance" ${r.roomStatus == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                                                            </select>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                                </div>

                                                                <div class="col-md-12">
                                                                    <label class="form-label">Image</label>
                                                                    <div class="mb-2">
                                                                        <img src="${pageContext.request.contextPath}/${r.imageUrl}" width="100" class="rounded" />
                                                                    </div>
                                                                    <input type="file" class="form-control" name="roomImage" accept="image/*" />
                                                                </div>

                                                                <div class="col-12">
                                                                    <label class="form-label">Description</label>
                                                                    <textarea class="form-control editDescription" name="description" rows="5">${r.description}</textarea>

                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary">Update Room</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>                                                                  
                                    </c:forEach>

                                </table>
                            </div>
                            <c:set var="startEntry" value="${(currentPage - 1) * pageSize + 1}" />
                            <c:set var="endEntry" value="${startEntry + rooms.size() - 1}" />

                            <div class="d-flex justify-content-end align-items-center mt-3 flex-wrap">

                                <nav aria-label="Room pagination">
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${currentPage - 1}">
                                                Previous
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                   href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${p}">
                                                    ${p}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${currentPage + 1}">
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

        <script>
            $(document).ready(function () {
                $(document).on('click', '.delete-room-btn', async function () {
                    const roomId = $(this).data('room-id');
                    const roomNumber = $(this).data('room-number');

                    if (!confirm("Bạn có chắc chắn muốn xóa phòng số " + roomNumber + " không?")) {
                        return;
                    }

                    const formData = new FormData();
                    formData.append("roomId", roomId);

                    try {
                        const response = await fetch("deleteRoom", {
                            method: "POST",
                            body: formData
                        });

                        const result = await response.text();
                        switch (result.trim()) {
                            case "success":
                                alert("Xóa phòng thành công!");
                                location.reload();
                                break;
                            case "invalidStatus":
                                alert("Chỉ được xóa phòng đang trống hoặc đang bảo trì.");
                                break;
                            case "hasFutureBookings":
                                alert("Không thể xóa phòng vì đã có lịch đặt trong tương lai.");
                                break;
                            case "missingRoomId":
                                alert("Thiếu thông tin mã phòng cần xóa.");
                                break;
                            default:
                                alert("Có lỗi xảy ra khi xóa phòng. Phản hồi: " + result);
                        }
                    } catch (err) {
                        alert("Lỗi kết nối tới máy chủ.");
                        console.error(err);
                    }
                });
            });
        </script>




        <!-- Add Room Modal -->
        <div class="modal fade" id="addRoomModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm phòng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="addRoomForm" enctype="multipart/form-data">
                        <div class="modal-body">
                            <div id="addRoomError" class="text-danger mb-2"></div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Số phòng</label>
                                    <input type="text" class="form-control" name="roomNumber" required />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Loại phòng</label>
                                    <select class="form-select" name="roomType" required>
                                        <option value="">Chọn loại phòng</option>
                                        <option value="1">Standard Room</option>
                                        <option value="2">Deluxe Room</option>
                                        <option value="3">Suite</option>
                                        <option value="4">Presidential Suite</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Tầng</label>
                                    <select class="form-select" name="floor" required>
                                        <option value="">Chọn tầng</option>
                                        <option value="1">Tầng 1</option>
                                        <option value="2">Tầng 2</option>
                                        <option value="3">Tầng 3</option>
                                        <option value="4">Tầng 4</option>
                                        <option value="5">Tầng 5</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Sức chứa</label>
                                    <select class="form-select" name="capacity" required>
                                        <option value="">Chọn sức chứa</option>
                                        <option value="1">1 người</option>
                                        <option value="2">2 người</option>
                                        <option value="3">3 người</option>
                                        <option value="4">4 người</option>
                                        <option value="6">6 người</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá phòng / đêm</label>
                                    <input type="number" class="form-control" name="price" step="0.01" required />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Tình trạng</label>
                                    <select class="form-select" name="status" required>
                                        <option value="Available">Phòng trống</option>
                                        <option value="Maintenance">Bảo trì</option>
                                    </select>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Ảnh phòng</label>
                                    <input type="file" class="form-control" name="roomImage" accept="image/*" required />
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Mô tả phòng</label>
                                    <textarea class="form-control" name="description" id="addDescription" rows="5" placeholder="Nhập các tiện ích, đặc điểm phòng..."  ></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm phòng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>




        <script>
            $(document).ready(function () {
                // Khi modal được mở thì khởi tạo Summernote nếu chưa có
                $(document).on('shown.bs.modal', '.modal', function () {
                    const textarea = $(this).find('.editDescription');
                    if (!textarea.hasClass('summernote-enabled')) {
                        textarea.addClass('summernote-enabled');
                        textarea.summernote({
                            placeholder: 'Nhập mô tả phòng...',
                            tabsize: 2,
                            height: 300,
                            toolbar: [
                                ['style', ['bold', 'italic', 'underline', 'clear']],
                                ['font', ['fontsize', 'color']],
                                ['para', ['ul', 'ol', 'paragraph']],
                                ['insert', ['picture', 'link']],
                                ['view', ['fullscreen', 'codeview']]
                            ]
                        });
                    }
                });

                // Gửi form cập nhật bằng AJAX
                $(document).on("submit", ".updateRoomForm", async function (e) {
                    e.preventDefault();
                    const form = this;

                    const roomId = $(form).find('input[name="roomId"]').val();
                    const descriptionTextarea = $(form).find('textarea[name="description"]');
                    const descriptionValue = $(descriptionTextarea).summernote('code');

                    // Kiểm tra nội dung rỗng
                    const tempDiv = document.createElement("div");
                    tempDiv.innerHTML = descriptionValue;
                    const plainText = tempDiv.textContent || tempDiv.innerText || "";
                    const containsImage = tempDiv.querySelector('img') !== null;

                    if (plainText.trim().length === 0 && !containsImage) {
                        alert("Mô tả không được để trống!");
                        return;
                    }

                    descriptionTextarea.val(descriptionValue); // gán lại vào textarea để submit

                    const formData = new FormData(form);

                    try {
                        const response = await fetch("updateRoom", {
                            method: "POST",
                            body: formData
                        });

                        const result = await response.text();
                        console.log("Server response:", result);

                        switch (result) {
                            case 'success':
                                alert("Cập nhật phòng thành công!");
                                $('#editRoomModal' + roomId).modal('hide');
                                location.reload();
                                break;
                            case 'roomBookedFuture':
                                alert("Phòng đã có lịch đặt trong tương lai. Không thể sửa trạng thái.");
                                break;
                            case 'invalidRoomNumber':
                                alert("Số phòng phải từ 100 đến 999.");
                                break;
                            case 'invalidRoomFloor':
                                alert("Số phòng không khớp với tầng đã chọn.");
                                break;
                            case 'cannotChangeToMaintenanceWithBooking':
                                alert("Phòng đang có lịch đặt trong thời gian tới - Không thể bảo trì !");
                                break;
                            case 'invalidPrice':
                                alert("Giá phòng phải là số dương lớn hơn 500000");
                                break;
                            case 'tooLongDescription':
                                alert("Mô tả không được quá 1000 ký tự!");
                                break;
                            case 'invalidImage':
                                alert("Ảnh phòng phải là JPG, PNG hoặc JPEG.");
                                break;
                            default:
                                alert("Lỗi không xác định: " + result);
                        }
                    } catch (err) {
                        alert("Lỗi kết nối máy chủ.");
                        console.error(err);
                    }
                });
            });
        </script>

        <script>
            $(document).ready(function () {
                $('#addDescription').summernote({
                    placeholder: 'Nhập mô tả phòng ở đây...',
                    tabsize: 2,
                    height: 300,
                    toolbar: [
                        ['style', ['bold', 'italic', 'underline', 'clear']],
                        ['font', ['fontsize', 'color']],
                        ['para', ['ul', 'ol', 'paragraph']],
                        ['insert', ['picture', 'link']],
                        ['view', ['fullscreen', 'codeview']]
                    ]
                });
            });
            document.querySelector("#addRoomForm").addEventListener("submit", async function (e) {
                e.preventDefault();
                const form = this;
                // Lấy mô tả từ Summernote
                const descriptionValue = $('#addDescription').summernote('code');
                // Kiểm tra mô tả (có chữ hoặc ảnh)
                const tempDiv = document.createElement("div");
                tempDiv.innerHTML = descriptionValue;
                const plainText = tempDiv.textContent || tempDiv.innerText || "";
                const containsImage = tempDiv.querySelector('img') !== null;
                if (plainText.trim().length === 0 && !containsImage) {
                    alert("Mô tả không được để trống!");
                    return;
                }

                // Đồng bộ Summernote vào textarea thật
                document.querySelector('textarea[name="description"]').value = descriptionValue;
                const formData = new FormData(form);
                try {
                    const response = await fetch("addRoom", {
                        method: "POST",
                        body: formData
                    });
                    const result = await response.text();
                    console.log(result);
                    switch (result) {
                        case 'success':
                            alert("Thêm phòng thành công!");
                            $('#addRoomModal').modal('hide');
                            location.reload();
                            break;
                        case 'roomNumberExists':
                            alert("Số phòng đã tồn tại!");
                            break;
                        case 'invalidPrice':
                            alert("Giá phòng phải là số dương lớn hơn 500000");
                            break;
                        case 'emptyDescription':
                            alert("Mô tả không được để trống!");
                            break;
                        case 'tooLongDescription':
                            alert("Mô tả không được quá 1000 ký tự!");
                            break;
                        case 'invalidRoomNumber':
                            alert("Số phòng phải từ 100 đến 999.");
                            break;
                        case 'invalidRoomFloor':
                            alert("Số phòng không khớp với tầng đã chọn.");
                            break;
                        case 'invalidImage':
                            alert("Ảnh phòng phải là JPG, PNG, JPEG.");
                            break;
                        default:
                            alert("Có lỗi xảy ra khi thêm phòng.");
                    }
                } catch (err) {
                    alert("Lỗi kết nối máy chủ.");
                    console.error(err);
                }
            });
        </script>




        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
