<%-- 
    Document   : serviceList
    Created on : Jun 24, 2025, 3:54:48 PM
    Author     : Phạm Quốc Tuấn
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isErrorPage="true" %>


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

                <!--                 Filter Section -->
                <form method="get" action=""  class="mb-4">
                    <input type="hidden" name="page" value="1" />

                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Loại Dịch Vụ</label>
                            <select class="form-select" name="type">
                                <option value="" ${paramStatus == null ? 'selected' : ''}>Tất Cả</option>
                                <option value="Restaurant"${paramStatus == 'active' ? 'selected' : ''}>Nhà Hàng</option>
                                <option value="Spa" ${paramStatus == 'expired' ? 'selected' : ''}>Spa</option>
                                <option value="Gym" ${paramStatus == 'upcoming' ? 'selected' : ''}>Gym</option>
                                <option value="Shuttle" ${paramStatus == 'upcoming' ? 'selected' : ''}>Di Chuyển</option>
                            </select>
                        </div>
                        <!-- Giá tối thiểu -->
                        <div class="col-md-3">
                            <label class="form-label">Giá Tối Thiểu</label>
                            <input type="number" class="form-control" name="minPrice" placeholder="VD: 100000" value="${param.minPrice}" />
                        </div>

                        <!-- Giá tối đa -->
                        <div class="col-md-3">
                            <label class="form-label">Giá Tối Đa</label>
                            <input type="number" class="form-control" name="maxPrice" placeholder="VD: 500000" value="${param.maxPrice}" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label d-block">&nbsp;</label>    
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search me-2"></i>Filter
                            </button>
                        </div>
                    </div>

                </form>


                <!--                 Service Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">All Service</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
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
                                    placeholder="Tìm dịch vụ..."
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
                                    <c:forEach var="s" items="${services}">
                                        <tr>
                                            <td>#${s.typeName}</td>
                                            <td>${s.name}</td>
                                            <td>
                                                <img src="${s.imageUrl}" 
                                                     alt="Ảnh dịch vụ" width="80" style="object-fit: cover; border-radius: 6px;" />
                                            </td>
                                            <td>${s.price}</td>
                                            <td>${s.description}</td>
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
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editServiceModal${s.id}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>



                                                    <form action="deleteService" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa không?');">
                                                        <input type="hidden" name="id" value="${s.id}" />
                                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                     </c:forEach>
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


                                            
                                        
                                        <!-- Modal chỉnh sửa dịch vụ theo ID -->
                                <c:forEach var="s" items="${services}">
                                    <div class="modal fade" id="editServiceModal${s.id}" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <form action="updateService" method="post" enctype="multipart/form-data">
                                                
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Chỉnh sửa Dịch Vụ</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <input type="hidden" name="id" value="${s.id}" />

                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label>Loại dịch vụ</label>
                                                            <select class="form-select" name="service_type_id">
                                                                <option value="1" ${s.typeId == 1 ? 'selected' : ''}>Restaurant</option>
                                                                <option value="2" ${s.typeId == 2 ? 'selected' : ''}>Spa</option>
                                                                <option value="3" ${s.typeId == 3 ? 'selected' : ''}>Gym</option>
                                                                <option value="4" ${s.typeId == 4 ? 'selected' : ''}>Shuttle</option>
                                                            </select>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label>Tên dịch vụ</label>
                                                            <input type="text" name="service_name" class="form-control" value="${s.name}" required />
                                                        </div>

                                                        <div class="mb-3">
                                                            <label>Giá</label>
                                                            <input type="number" name="service_price" class="form-control" value="${s.price}" required />
                                                        </div>

                                                        <div class="mb-3">
                                                            <label>Ảnh hiện tại</label><br />
                                                            <img src="${pageContext.request.contextPath}/${s.imageUrl}" width="100" />
                                                            <input type="file" name="image" class="form-control mt-2" accept="image/*" />
                                                            <input type="hidden" name="oldImageUrl" value="${s.imageUrl}" />
                                                        </div>

                                                        <div class="mb-3">
                                                            <label>Mô tả</label>
                                                            <textarea class="form-control" name="description" id="editDescription${s.id}" rows="4">${s.description}</textarea>              
                                                        </div>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
    <!-- Modal Thêm Dịch Vụ -->
    <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <form action="addService" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create" />
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addServiceModalLabel">Thêm Dịch Vụ Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">

                        <div class="mb-3">
                            <label for="service_type_id" class="form-label">Loại dịch vụ</label>
                            <select class="form-select" id="service_type_id" name="service_type_id" required>
                                <option value="" disabled selected>-- Chọn loại dịch vụ --</option>
                                <option value="1">Restaurant</option>
                                <option value="2">Spa</option>
                                <option value="3">Gym</option>
                                <option value="4">Shuttle</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="service_name" class="form-label">Tên dịch vụ</label>
                            <input type="text" class="form-control" id="service_name" name="service_name" required>
                        </div>


                        <div class="mb-3">
                            <label for="service_price" class="form-label">Giá (VNĐ)</label>
                            <input type="number" class="form-control" id="service_price" name="service_price" step="1000"  required>
                        </div>

                        <div class="mb-3">
                            <label for="image" class="form-label" >Ảnh đại diện</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/*" required="">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
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


    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
    <script>
                                                        // Khởi tạo CKEditor
                                                        let editor;
                                                        ClassicEditor
                                                                .create(document.querySelector('#description'), {
                                                                    toolbar: [
                                                                        'heading', '|',
                                                                        'bold', 'italic', 'link', 'bulletedList', 'numberedList', '|',
                                                                        'undo', 'redo'
                                                                    ]
                                                                })
                                                                .then(e => editor = e)
                                                                .catch(error => console.error(error));

                                                        // Gắn sự kiện khi form submit
                                                        document.querySelector("#addServiceModal form").addEventListener("submit", async function (e) {
                                                            e.preventDefault(); // ❌ Chặn reload

                                                            const form = this;
                                                            const formData = new FormData(form);
                                                            formData.set("description", editor.getData());

                                                            try {
                                                                const response = await fetch("addService", {
                                                                    method: "POST",
                                                                    body: formData
                                                                });

                                                                const result = await response.text();

                                                                if (result === "success") {
                                                                    alert("Thêm dịch vụ thành công!");
                                                                    location.reload();
                                                                } else if (result === "duplicate") {
                                                                    alert("Tên dịch vụ đã tồn tại!");
                                                                } else if (result === "invalidPrice") {
                                                                    alert("Giá phải là số dương lớn hơn 0!");
                                                                } else {
                                                                    alert("Có lỗi xảy ra khi thêm dịch vụ.");
                                                                }
                                                            } catch (err) {
                                                                alert("Lỗi kết nối máy chủ.");
                                                                console.error(err);
                                                            }
                                                        });
    </script>
<script>
    const ckeditors = {};

    // Khởi tạo CKEditor khi modal mở
    document.querySelectorAll('[id^="editServiceModal"]').forEach(modal => {
        modal.addEventListener('shown.bs.modal', function () {
            const id = this.id.replace("editServiceModal", "");
            const textarea = document.getElementById("editDescription" + id);
            if (!ckeditors[id]) {
                ClassicEditor.create(textarea, {
                    toolbar: ['heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', '|', 'undo', 'redo']
                })
                .then(editor => ckeditors[id] = editor)
                .catch(error => console.error(error));
            }
        });
    });

    // Xử lý submit form chỉnh sửa dịch vụ
    document.querySelectorAll('form[action="updateService"]').forEach(form => {
        form.addEventListener('submit', async function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            const serviceIdInput = form.querySelector('input[name="id"]');
            if (!serviceIdInput) {
                alert("Không tìm thấy ID dịch vụ.");
                return;
            }

            const serviceId = serviceIdInput.value;
            const editor = ckeditors[serviceId];

            // Validate: loại dịch vụ
            const typeSelect = form.querySelector('select[name="service_type_id"]');
            if (!typeSelect || !typeSelect.value) {
                alert("Vui lòng chọn loại dịch vụ.");
                return;
            }

            // Validate: tên dịch vụ
            const nameInput = form.querySelector('input[name="service_name"]');
            if (!nameInput || nameInput.value.trim().length === 0) {
                alert("Tên dịch vụ không được để trống.");
                return;
            }

            // Validate: giá
            const priceInput = form.querySelector('input[name="service_price"]');
            if (!priceInput) {
                alert("Không tìm thấy input giá.");
                return;
            }

            const price = parseFloat(priceInput.value);
            if (isNaN(price) || price <= 0) {
                alert("Giá phải là số dương lớn hơn 0.");
                return;
            }

            // Validate: mô tả
            if (!editor) {
                alert("Mô tả chưa được khởi tạo trình soạn thảo.");
                return;
            }

            const description = editor.getData().trim();
            if (description.length === 0) {
                alert("Mô tả không được để trống.");
                return;
            }

            // Gán lại mô tả vào formData
            formData.set("description", description);

            try {
                const res = await fetch("updateService", {
                    method: "POST",
                    body: formData
                });

                const result = await res.text();
                if (result === "success") {
                    alert("Cập nhật dịch vụ thành công!");
                    location.reload();
                } else if (result === "duplicate") {
                    alert("Tên dịch vụ đã tồn tại!");
                } else if (result === "invalidPrice") {
                    alert("Giá không hợp lệ!");
                } else if (result === "invalidDescription") {
                    alert("Mô tả không hợp lệ!");
                } else {
                    alert("Đã xảy ra lỗi khi cập nhật.");
                }

            } catch (err) {
                console.error(err);
                alert("Lỗi kết nối máy chủ.");
            }
        });
    });
</script>






    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
