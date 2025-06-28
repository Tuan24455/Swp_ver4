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

    // Room Status Chart
    const roomStatusCtx = document.getElementById('roomStatusChart').getContext('2d');
    roomStatusChart = new Chart(roomStatusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Đã Đặt', 'Trống', 'Bảo Trì'],
            datasets: [{
                data: [120, 25, 8],
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
function showNotification(message) {
    document.getElementById('toastMessage').textContent = message;
    const toast = new bootstrap.Toast(document.getElementById('notificationToast'));
    toast.show();
}

function exportReport() {
    showNotification('Đang xuất báo cáo...');
    // Add export logic here
}

function refreshData() {
    showNotification('Đang làm mới dữ liệu...');
    // Add refresh logic here
    setTimeout(() => {
        showNotification('Dữ liệu đã được cập nhật!');
    }, 2000);
}

// Sidebar Toggle
function toggleSidebar() {
    document.getElementById('wrapper').classList.toggle('toggled');
}