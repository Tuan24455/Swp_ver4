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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="service" />
            </jsp:include>


            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->


                <style>
                    .header-bg {
                        background-image: url('https://media.istockphoto.com/id/1372396372/vi/anh/xe-cho-thu%C3%AA-xe-bu%C3%BDt-s%C3%A2n-bay-%C4%91%C6%B0a-%C4%91%C3%B3n-%E1%BB%9F-las-vegas.jpg?s=2048x2048&w=is&k=20&c=flaqoSKcuO-om3VdmoL_Yl1KJIZIc3RBnT8E5nHs4Pg=');
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
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb custom-breadcrumb mb-0">
                            <li></li>
                            <li class="breadcrumb-item active" aria-current="page"></li>
                        </ol>
                    </nav>

                    <!-- Dòng tiêu đề + nút -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <!-- Nút Home -->
                            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary me-3">
                                <i class="fas fa-home"></i>
                            </a>
                            <!-- Tiêu đề -->
                            <h1 class="h3 mb-0">Quản lí Dịch Vụ</h1>
                        </div>

                        <!-- Nút Thêm Dịch Vụ -->
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
                <form action="serviceList" method="post" class="mb-4">
                    <input type="hidden" name="page" value="1" />
                    <div class="card shadow-sm border-0 rounded-4" style="background: #f5f9ff;">
                        <div class="card-body rounded-4">
                            <h5 class="mb-4 fw-semibold text-primary">
                            </h5>
                            <div class="row g-4 align-items-end">
                                <!-- Loại Dịch Vụ -->
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-concierge-bell me-1"></i> Loại Dịch Vụ
                                    </label>
                                    <select class="form-select rounded-pill shadow-sm" name="type">
                                        <option value="" ${param.type == null ? 'selected' : ''}>Tất Cả</option>
                                        <option value="Restaurant" ${param.type == 'Restaurant' ? 'selected' : ''}>Nhà Hàng</option>
                                        <option value="Spa" ${param.type == 'Spa' ? 'selected' : ''}>Spa</option>
                                        <option value="Gym" ${param.type == 'Gym' ? 'selected' : ''}>Gym</option>
                                        <option value="Shuttle" ${param.type == 'Shuttle' ? 'selected' : ''}>Di Chuyển</option>
                                    </select>
                                </div>

                                <!-- Giá Tối Thiểu -->
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-dollar-sign me-1"></i> Giá Tối Thiểu
                                    </label>
                                    <input type="number" class="form-control rounded-pill shadow-sm" name="minPrice"
                                           placeholder="VD: 100000" value="${param.minPrice}" />
                                </div>

                                <!-- Giá Tối Đa -->
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-dollar-sign me-1"></i> Giá Tối Đa
                                    </label>
                                    <input type="number" class="form-control rounded-pill shadow-sm" name="maxPrice"
                                           placeholder="VD: 500000" value="${param.maxPrice}" />
                                </div>

                                <!-- Nút Lọc -->
                                <div class="col-md-3 d-flex justify-content-start mt-2 mt-md-0">
                                    <button class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" type="submit">
                                        <i class="fas fa-filter me-2"></i> Lọc
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>





                <!--                 Service Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">Thông tin dịch vụ </h5>
                    </div>
                    <div class="card-body">
                        <!-- Hiển thị thông báo nếu không tìm thấy kết quả -->
                        <c:if test="${not empty requestScope.noResultsMessage}">
                            <div class="alert alert-danger" role="alert">
                                ${requestScope.noResultsMessage}
                            </div>
                        </c:if>

                        <!-- Phần tìm kiếm dịch vụ -->
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
                            <div class="input-group search-table-input" style="width: 250px">
                                <form action="serviceList" method="post" class="d-flex">
                                    <input type="text" class="form-control" name="searchQuery" placeholder="Tìm dịch vụ..." value="${param.searchQuery}" />
                                    <button class="btn btn-outline-primary" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </form>
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
                                                <div class="d-flex align-items-center gap-2">                                    
                                                    <button class="btn btn-sm btn-outline-warning"
                                                            title="Chỉnh sửa"
                                                            type="button"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#editServiceModal${s.id}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>

                                                    <form action="deleteService"
                                                          method="post"
                                                          onsubmit="return confirm('Bạn có chắc muốn xóa không?');"
                                                          class="m-0 p-0">
                                                        <input type="hidden" name="id" value="${s.id}" />
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-danger"
                                                                title="Xóa">
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

                        <!-- Phân trang -->
                        <c:set var="startEntry" value="${(currentPage - 1) * pageSize + 1}" />
                        <c:set var="endEntry" value="${startEntry + services.size() - 1}" />
                        <div class="d-flex justify-content-end align-items-center mt-3 flex-wrap">

                            <nav aria-label="Service pagination">
                                <ul class="pagination pagination-sm mb-0">
                                    <!-- Previous Page -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="serviceList?searchQuery=${param.searchQuery}&type=${param.type}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&page=${currentPage - 1}">
                                            Previous
                                        </a>
                                    </li>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="serviceList?searchQuery=${param.searchQuery}&type=${param.type}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&page=${p}">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="serviceList?searchQuery=${param.searchQuery}&type=${param.type}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&page=${currentPage + 1}">
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
                            <input type="number" class="form-control" id="service_price" name="service_price" min="100000" step="50000" required>
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
                                                                              'bold', 'italic', 'bulletedList', 'numberedList', '|',
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
                                                                          alert("Giá phải bắt đầu từ 100000");
                                                                      } else if (result === "blankDescription") {
                                                                          alert("Mô tả Không được để trống !");
                                                                      } else if (result === "invalidNameFormat") {
                                                                          alert("Tên dịch vụ không hợp lệ !");
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
                        toolbar: ['heading', '|', 'bold', 'italic', 'bulletedList', 'numberedList', '|', 'undo', 'redo']
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
                    } else if (result === "invalidName") {
                        alert("Tên dịch vụ không hợp lệ !");
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
