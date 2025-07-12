// dashboard.js

let revenueChart, roomStatusChart;
let currentPeriod = 'weekly';

// Initialize Charts
document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
    updateChart('weekly');  // Load default weekly data dynamically
});

function initializeCharts() {
    // Revenue Chart (init with empty data, will be updated by fetch)
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Doanh Thu (VND)',
                data: [],
                borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                yAxisID: 'y'
            }, {
                label: 'Số Đặt Phòng',
                data: [],
                borderColor: '#06b6d4',
                backgroundColor: 'rgba(6, 182, 212, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    callbacks: {
                        label: function(context) {
                            if (context.datasetIndex === 0) {
                                return context.dataset.label + ': ' + new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.y);
                            } else {
                                return context.dataset.label + ': ' + context.parsed.y + ' đặt phòng';
                            }
                        }
                    }
                }
            },
            scales: {
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND',
                                notation: 'compact'
                            }).format(value);
                        }
                    }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    grid: {
                        drawOnChartArea: false,
                    },
                    ticks: {
                        callback: function(value) {
                            return value + ' đặt';
                        }
                    }
                }
            }
        }
    });

    // Room Status Chart - Note: This will be populated with server data
    const roomStatusCtx = document.getElementById('roomStatusChart').getContext('2d');
    roomStatusChart = new Chart(roomStatusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Đã Đặt', 'Trống', 'Bảo Trì'],
            datasets: [{
                data: [0, 0, 0], // Will be populated by JSP
                backgroundColor: ['#10b981', '#4f46e5', '#f59e0b'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

// Function to update room status chart with server data
function updateRoomStatusChart(occupiedRooms, vacantRooms, maintenanceRooms) {
    if (roomStatusChart) {
        roomStatusChart.data.datasets[0].data = [occupiedRooms, vacantRooms, maintenanceRooms];
        roomStatusChart.update();
    }
}

// Update Chart Function (sửa: fetch data động từ server thay vì hard-coded)
function updateChart(period) {
    currentPeriod = period;
    
    // Update active button
    document.querySelectorAll('.btn-period').forEach(btn => btn.classList.remove('active'));
    const activeBtn = document.querySelector(`.btn-period[onclick="updateChart('${period}')"]`);
    if (activeBtn) {
        activeBtn.classList.add('active');
    }
    
    // Fetch data từ servlet
    fetch(`/Project_Hotel_RoomBooking/admin/revenue-chart?period=${period}`)  // Đã thay /your-context-path/ bằng /Project_Hotel_RoomBooking/ dựa trên URL test của bạn
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Update chart data
            revenueChart.data.labels = data.labels || [];
            revenueChart.data.datasets[0].data = data.revenue || [];
            revenueChart.data.datasets[1].data = data.bookings || [];
            revenueChart.update();
            
            // Show notification
            let periodText;
            if (period === 'weekly') {
                periodText = 'tuần';
            } else if (period === 'monthly') {
                periodText = 'tháng';
            } else {
                periodText = 'năm';
            }
            showNotification('Đã cập nhật biểu đồ theo ' + periodText);
        })
        .catch(error => {
            console.error('Error fetching chart data:', error);
            showNotification('Lỗi khi tải dữ liệu biểu đồ', 'danger');
        });
}

// Utility Functions
function showNotification(message, type = 'info') {
    // Tạo notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'info' ? 'primary' : type === 'success' ? 'success' : 'danger'} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    notification.innerHTML = `
        <i class="fas fa-${type === 'info' ? 'info-circle' : type === 'success' ? 'check-circle' : 'exclamation-triangle'}"></i> ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 3000);
}

function exportReport() {
    // Implement report export logic
    showNotification('Đang xuất báo cáo...', 'info');
    
    // Get data from page elements or global variables
    const occupancyRate = document.querySelector('.kpi-card h3').textContent || '0';
    const totalRooms = document.querySelector('[data-total-rooms]')?.textContent || '0';
    const occupiedRooms = document.querySelector('[data-occupied-rooms]')?.textContent || '0';
    const vacantRooms = document.querySelector('[data-vacant-rooms]')?.textContent || '0';
    const maintenanceRooms = document.querySelector('[data-maintenance-rooms]')?.textContent || '0';
    const totalRevenue = document.querySelector('[data-total-revenue]')?.textContent || '0';
    const averageRating = document.querySelector('[data-average-rating]')?.textContent || '0';
    
    // Tạo dữ liệu báo cáo từ dashboard
    const reportData = {
        occupancyRate: occupancyRate,
        totalRooms: totalRooms,
        occupiedRooms: occupiedRooms,
        vacantRooms: vacantRooms,
        maintenanceRooms: maintenanceRooms,
        totalRevenue: totalRevenue,
        averageRating: averageRating,
        exportDate: new Date().toLocaleDateString('vi-VN')
    };
    
    // Tạo và download file CSV
    const csvContent = "data:text/csv;charset=utf-8," 
        + "Báo cáo Dashboard Hotel\n"
        + "Ngày xuất," + reportData.exportDate + "\n"
        + "Tỷ lệ lấp đầy," + reportData.occupancyRate + "\n"
        + "Tổng số phòng," + reportData.totalRooms + "\n"
        + "Phòng đã đặt," + reportData.occupiedRooms + "\n"
        + "Phòng trống," + reportData.vacantRooms + "\n"
        + "Phòng bảo trì," + reportData.maintenanceRooms + "\n"
        + "Tổng doanh thu," + reportData.totalRevenue + "\n"
        + "Đánh giá trung bình," + reportData.averageRating;
    
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "dashboard_report_" + new Date().toISOString().split('T')[0] + ".csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('Báo cáo đã được xuất thành công!', 'success');
}

function refreshData() {
    // Hiển thị loading
    showNotification('Đang làm mới dữ liệu...', 'info');
    
    // Reload trang để lấy dữ liệu mới từ servlet
    window.location.reload();
}

// Sidebar Toggle
function toggleSidebar() {
    document.getElementById('wrapper').classList.toggle('toggled');
}

// Global function to initialize room status chart with server data
window.initRoomStatusWithServerData = function(occupiedRooms, vacantRooms, maintenanceRooms) {
    // Wait for chart to be initialized
    if (roomStatusChart) {
        updateRoomStatusChart(occupiedRooms, vacantRooms, maintenanceRooms);
    } else {
        // Retry after a short delay if chart not ready
        setTimeout(() => {
            updateRoomStatusChart(occupiedRooms, vacantRooms, maintenanceRooms);
        }, 100);
    }
};