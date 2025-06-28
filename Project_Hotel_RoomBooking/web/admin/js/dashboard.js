// Chart Data
const chartData = {
    weekly: {
        labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
        revenue: [445000000, 52000000, 48000000, 61000000, 55000000, 67000000, 59000000],
        bookings: [25, 30, 28, 35, 32, 38, 34]
    },
    monthly: {
        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
        revenue: [1200000000, 1350000000, 1180000000, 1420000000, 1380000000, 1250000000, 1480000000, 1520000000, 1380000000, 1450000000, 1380000000, 1250000000],
        bookings: [650, 720, 680, 780, 750, 690, 820, 850, 780, 810, 780, 690]
    },
    yearly: {
        labels: ['2020', '2021', '2022', '2023', '2024'],
        revenue: [12500000000, 11800000000, 14200000000, 15800000000, 16500000000],
        bookings: [8500, 7800, 9200, 9800, 10200]
    }
};

let revenueChart, roomStatusChart, monthlyPerformanceChart, servicesChart;
let currentPeriod = 'weekly';

// Initialize Charts
document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
});

function initializeCharts() {
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: chartData[currentPeriod].labels,
            datasets: [{
                label: 'Doanh Thu (VND)',
                data: chartData[currentPeriod].revenue,
                borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                yAxisID: 'y'
            }, {
                label: 'Số Đặt Phòng',
                data: chartData[currentPeriod].bookings,
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

    // Monthly Performance Chart
    const monthlyCtx = document.getElementById('monthlyPerformanceChart').getContext('2d');
    monthlyPerformanceChart = new Chart(monthlyCtx, {
        type: 'bar',
        data: {
            labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
            datasets: [{
                label: 'Doanh Thu',
                data: [85, 92, 78, 95, 88, 90],
                backgroundColor: '#4f46e5',
                borderRadius: 4
            }, {
                label: 'Lấp Đầy',
                data: [78, 85, 72, 88, 82, 86],
                backgroundColor: '#06b6d4',
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top'
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        callback: function(value) {
                            return value + '%';
                        }
                    }
                }
            }
        }
    });

    // Services Chart
    const servicesCtx = document.getElementById('servicesChart').getContext('2d');
    servicesChart = new Chart(servicesCtx, {
        type: 'horizontalBar',
        data: {
            labels: ['Spa', 'Nhà Hàng', 'Gym', 'Hồ Bơi', 'Karaoke'],
            datasets: [{
                label: 'Lượt Sử Dụng',
                data: [450, 380, 290, 520, 180],
                backgroundColor: ['#ef4444', '#f59e0b', '#10b981', '#06b6d4', '#8b5cf6'],
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            plugins: {
                legend: {
                    display: false
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

// Update Chart Function
function updateChart(period) {
    currentPeriod = period;
    
    // Update active button
    document.querySelectorAll('.btn-period').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    
    // Update chart data
    revenueChart.data.labels = chartData[period].labels;
    revenueChart.data.datasets[0].data = chartData[period].revenue;
    revenueChart.data.datasets[1].data = chartData[period].bookings;
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