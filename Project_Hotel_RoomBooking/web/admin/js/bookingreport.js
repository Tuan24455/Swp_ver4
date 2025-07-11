document.addEventListener("DOMContentLoaded", function () {
  // Khởi tạo các biến và phần tử
  const fromDateInput = document.getElementById("fromDate");
  const toDateInput = document.getElementById("toDate");
  const roomTypeSelect = document.getElementById("roomType");
  const filterButton = document.getElementById("filterButton");

  // Hàm để lấy tham số từ URL
  function getUrlParameter(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
    var results = regex.exec(location.search);
    return results === null
      ? ""
      : decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  // Lấy các tham số từ URL
  const urlStartDate = getUrlParameter("startDate");
  const urlEndDate = getUrlParameter("endDate");

  // Thiết lập ngày mặc định
  const today = new Date();
  const formattedToday = today.toISOString().split("T")[0];

  // Thiết lập ngày mặc định cho từ ngày (1 tháng trước)
  const oneMonthAgo = new Date();
  oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
  const formattedOneMonthAgo = oneMonthAgo.toISOString().split("T")[0];

  // Sử dụng giá trị từ URL nếu có, nếu không thì sử dụng giá trị mặc định
  fromDateInput.value = urlStartDate || formattedOneMonthAgo;
  toDateInput.value = urlEndDate || formattedToday;

  // Xử lý sự kiện cho nút lọc
  filterButton.addEventListener("click", function () {
    filterBookings();
  });

  // Hàm lọc dữ liệu đặt phòng
  function filterBookings() {
    const fromDate = fromDateInput.value;
    const toDate = toDateInput.value;
    const roomType = roomTypeSelect.value;

    // Tạo URL với các tham số lọc
    let url = "bookingreport?";
    url += "startDate=" + fromDate;
    url += "&endDate=" + toDate;

    if (roomType) {
      url += "&roomType=" + roomType;
    }

    // Chuyển hướng đến URL với các tham số lọc
    window.location.href = url;
  }

  // Cập nhật thống kê
  function updateStatistics() {
    // Tính tổng số khách đang lưu trú
    const tableRows = document.querySelectorAll(
      ".card:last-child table tbody tr"
    );

    // Tạo phần tử hiển thị tổng khách
    const guestCountElement = document.createElement("div");
    guestCountElement.className = "d-flex align-items-center";
    guestCountElement.innerHTML = `
             <i class="fas fa-users text-primary me-2"></i>
             <span class="text-muted">Tổng khách đang lưu trú: </span>
             <span style="color: #007bff; font-weight: bold; font-size: 18px;" class="ms-2">${tableRows.length} KHÁCH HÀNG</span>
         `;

    // Tính tổng doanh thu dự kiến
    let totalRevenue = 0;

    tableRows.forEach((row) => {
      const priceText = row.querySelector("td:last-child strong").textContent;
      // Loại bỏ ký tự đ và dấu phẩy, chuyển thành số
      const price = parseInt(priceText.replace(/[^0-9]/g, ""));
      if (!isNaN(price)) {
        totalRevenue += price;
      }
    });

    // Định dạng số tiền với dấu phẩy ngăn cách hàng nghìn
    const formattedRevenue = totalRevenue.toLocaleString("vi-VN");

    // Tạo phần tử hiển thị tổng doanh thu
    const revenueElement = document.createElement("div");
    revenueElement.className = "d-flex align-items-center justify-content-end";
    revenueElement.innerHTML = `
             <i class="fas fa-money-bill-wave text-success me-2"></i>
             <span class="text-muted">Tổng doanh thu dự kiến: </span>
             <span style="color: #28a745; font-weight: bold; font-size: 18px;" class="ms-2">${formattedRevenue} đ</span>
         `;

    // Xóa nội dung cũ
    const leftColumn = document.querySelector(".col-md-6");
    const rightColumn = document.querySelector(".col-md-6.text-end");

    if (leftColumn && rightColumn) {
      leftColumn.innerHTML = "";
      rightColumn.innerHTML = "";

      // Thêm nội dung mới
      leftColumn.appendChild(guestCountElement);
      rightColumn.appendChild(revenueElement);
    }
  }

  // Khởi tạo thống kê ban đầu
  updateStatistics();

  // Pagination for Current Bookings table (Phần đã sửa)
  var rowsPerPage = 8; // Số hàng mỗi trang, bạn có thể chỉnh
  var currentPage = 1; // Trang hiện tại mặc định

  // Selector cụ thể hơn để lấy tbody của bảng Current Bookings (dựa trên cấu trúc JSP)
  var tbody = document.querySelector(
    ".card:last-child .table-responsive .table-striped tbody"
  );
  var rows = tbody
    ? Array.prototype.slice.call(tbody.querySelectorAll("tr"))
    : [];
  var pageCount = Math.ceil(rows.length / rowsPerPage);
  var paginationContainer = document.getElementById("pagination");

  // Hàm hiển thị trang cụ thể
  function showPage(page) {
    if (page < 1 || page > pageCount) return; // Ngăn chặn trang invalid
    currentPage = page;

    // Tính start/end
    var start = (page - 1) * rowsPerPage;
    var end = start + rowsPerPage;

    // Hiển thị/ẩn rows
    rows.forEach(function (row, idx) {
      row.style.display = idx >= start && idx < end ? "" : "none";
    });

    // Cập nhật active class cho các trang số
    var pageItems = paginationContainer.querySelectorAll(
      ".page-item:not(.prev):not(.next)"
    );
    pageItems.forEach(function (li, idx) {
      li.classList.toggle("active", idx + 1 === page);
    });

    // Cập nhật disabled cho Prev/Next
    var prevBtn = paginationContainer.querySelector(".prev");
    var nextBtn = paginationContainer.querySelector(".next");
    if (prevBtn) prevBtn.classList.toggle("disabled", page === 1);
    if (nextBtn) nextBtn.classList.toggle("disabled", page === pageCount);
  }

  // Tạo pagination controls nếu có dữ liệu
  if (rows.length > 0 && pageCount > 0) {
    // Xóa nội dung cũ (nếu có)
    paginationContainer.innerHTML = "";

    // Tạo nút Previous
    var prevLi = document.createElement("li");
    prevLi.className = "page-item prev";
    var prevA = document.createElement("a");
    prevA.className = "page-link";
    prevA.href = "#";
    prevA.innerHTML = "&laquo;"; // Icon <<
    prevA.addEventListener("click", function (e) {
      e.preventDefault();
      if (currentPage > 1) showPage(currentPage - 1);
    });
    prevLi.appendChild(prevA);
    paginationContainer.appendChild(prevLi);

    // Tạo các trang số
    for (var i = 1; i <= pageCount; i++) {
      var li = document.createElement("li");
      li.className = "page-item";
      var a = document.createElement("a");
      a.className = "page-link";
      a.href = "#";
      a.innerText = i;
      (function (page) {
        a.addEventListener("click", function (e) {
          e.preventDefault();
          showPage(page);
        });
      })(i);
      li.appendChild(a);
      paginationContainer.appendChild(li);
    }

    // Tạo nút Next
    var nextLi = document.createElement("li");
    nextLi.className = "page-item next";
    var nextA = document.createElement("a");
    nextA.className = "page-link";
    nextA.href = "#";
    nextA.innerHTML = "&raquo;"; // Icon >>
    nextA.addEventListener("click", function (e) {
      e.preventDefault();
      if (currentPage < pageCount) showPage(currentPage + 1);
    });
    nextLi.appendChild(nextA);
    paginationContainer.appendChild(nextLi);

    // Khởi tạo trang đầu tiên
    showPage(1);
  } else {
    // Nếu không có dữ liệu, ẩn pagination hoặc hiển thị message
    paginationContainer.innerHTML = ""; // Xóa sạch
    // Optional: Thêm message (bỏ comment nếu cần)
    // var noDataMsg = document.createElement('p');
    // noDataMsg.className = 'text-center text-muted';
    // noDataMsg.innerText = 'Không có dữ liệu đặt phòng.';
    // paginationContainer.parentNode.appendChild(noDataMsg);
  }

  // Nếu bạn dùng AJAX để load dữ liệu mới (không redirect), gọi lại phần này sau khi update tbody
});
