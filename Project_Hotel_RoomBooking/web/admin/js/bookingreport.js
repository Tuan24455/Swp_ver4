document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo các biến và phần tử
    const fromDateInput = document.getElementById('fromDate');
    const toDateInput = document.getElementById('toDate');
    const roomTypeSelect = document.getElementById('roomType');
    const filterButton = document.getElementById('filterButton');
    
    // Hàm để lấy tham số từ URL
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }
    
    // Lấy các tham số từ URL
    const urlStartDate = getUrlParameter('startDate');
    const urlEndDate = getUrlParameter('endDate');
    
    // Thiết lập ngày mặc định
    const today = new Date();
    const formattedToday = today.toISOString().split('T')[0];
    
    // Thiết lập ngày mặc định cho từ ngày (1 tháng trước)
    const oneMonthAgo = new Date();
    oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
    const formattedOneMonthAgo = oneMonthAgo.toISOString().split('T')[0];
    
    // Sử dụng giá trị từ URL nếu có, nếu không thì sử dụng giá trị mặc định
    fromDateInput.value = urlStartDate || formattedOneMonthAgo;
    toDateInput.value = urlEndDate || formattedToday;
    
    
    // Xử lý sự kiện cho nút lọc
    filterButton.addEventListener('click', function() {
        filterBookings();
    });
    
    // Hàm lọc dữ liệu đặt phòng
    function filterBookings() {
        const fromDate = fromDateInput.value;
        const toDate = toDateInput.value;
        const roomType = roomTypeSelect.value;
        
        // Tạo URL với các tham số lọc
        let url = 'bookingreport?';
        url += 'startDate=' + fromDate;
        url += '&endDate=' + toDate;
        
        if (roomType) {
            url += '&roomType=' + roomType;
        }
        
        // Chuyển hướng đến URL với các tham số lọc
        window.location.href = url;
    }
    
    // Cập nhật thống kê
    function updateStatistics() {
        // Tính tổng số khách đang lưu trú
        const tableRows = document.querySelectorAll('.card:last-child table tbody tr');
        
        // Tạo phần tử hiển thị tổng khách
         const guestCountElement = document.createElement('div');
         guestCountElement.className = 'd-flex align-items-center';
         guestCountElement.innerHTML = `
             <i class="fas fa-users text-primary me-2"></i>
             <span class="text-muted">Tổng khách đang lưu trú: </span>
             <span style="color: #007bff; font-weight: bold; font-size: 18px;" class="ms-2">${tableRows.length} KHÁCH HÀNG</span>
         `;
        
        // Tính tổng doanh thu dự kiến
        let totalRevenue = 0;
        
        tableRows.forEach(row => {
            const priceText = row.querySelector('td:last-child strong').textContent;
            // Loại bỏ ký tự đ và dấu phẩy, chuyển thành số
            const price = parseInt(priceText.replace(/[^0-9]/g, ''));
            if (!isNaN(price)) {
                totalRevenue += price;
            }
        });
        
        // Định dạng số tiền với dấu phẩy ngăn cách hàng nghìn
        const formattedRevenue = totalRevenue.toLocaleString('vi-VN');
        
        // Tạo phần tử hiển thị tổng doanh thu
         const revenueElement = document.createElement('div');
         revenueElement.className = 'd-flex align-items-center justify-content-end';
         revenueElement.innerHTML = `
             <i class="fas fa-money-bill-wave text-success me-2"></i>
             <span class="text-muted">Tổng doanh thu dự kiến: </span>
             <span style="color: #28a745; font-weight: bold; font-size: 18px;" class="ms-2">${formattedRevenue} đ</span>
         `;
        
        // Xóa nội dung cũ
        const leftColumn = document.querySelector('.col-md-6');
        const rightColumn = document.querySelector('.col-md-6.text-end');
        
        if (leftColumn && rightColumn) {
            leftColumn.innerHTML = '';
            rightColumn.innerHTML = '';
            
            // Thêm nội dung mới
            leftColumn.appendChild(guestCountElement);
            rightColumn.appendChild(revenueElement);
        }
    }
    
    // Khởi tạo thống kê ban đầu
    updateStatistics();
});