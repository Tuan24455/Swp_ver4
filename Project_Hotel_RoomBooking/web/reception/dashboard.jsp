<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reception Dashboard - Hotel Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <style>
        /* Custom styles for a cleaner look */
        #calendar {
            max-width: 1100px;
            margin: 0 auto;
        }
        .fc .fc-toolbar-title {
            font-size: 1.5em;
        }
    </style>
</head>
<body>
    <div class="d-flex" id="wrapper">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <div id="page-content-wrapper" class="flex-fill">
            <!-- Top Navigation -->
            <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm">
                <div class="container-fluid">
                    <button class="btn btn-sm btn-outline-secondary" id="menu-toggle"><i class="fas fa-bars"></i></button>
                    <div class="d-flex align-items-center gap-3 ms-auto">
                        <span id="current-date" class="fw-semibold text-muted">Tuesday, June 24, 2025</span>
                        <span id="current-time" class="fw-semibold">16:56:28</span>
                    </div>
                </div>
            </nav>

            <div class="container-fluid py-4">
                <!-- Page Header -->
                <div class="page-header mb-4">
                    <h1 class="h2">Dashboard Overview</h1>
                </div>

                <!-- Calendar Card -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom">
                        <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Room Booking Calendar</h5>
                    </div>

                    <!-- Room Filter Section -->
                    <div class="card-body border-bottom">
                        <div class="row align-items-end g-3">
                            <div class="col-md-5">
                                <label for="roomFilter" class="form-label fw-semibold">Filter by Room:</label>
                                <select class="form-select" id="roomFilter">
                                    <option value="">All Rooms</option>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label for="statusFilter" class="form-label fw-semibold">Filter by Status:</label>
                                <select class="form-select" id="statusFilter">
                                    <option value="">All Status</option>
                                    <option value="Confirmed">Confirmed</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Check-in">Check-in</option>
                                    <option value="Check-out">Check-out</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="card-body">
                        <div id="calendar"></div>
                    </div>
                </div>

                <!-- Quick Actions Section -->
                <div class="row mt-4">
                    <div class="col-lg-6">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white border-bottom py-3">
                                <h5 class="mb-0"><i class="fas fa-bolt me-2 text-warning"></i>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="#" class="btn btn-outline-primary"><i class="fas fa-calendar-plus me-2"></i>New Booking</a>
                                    <a href="#" class="btn btn-outline-info"><i class="fas fa-door-open me-2"></i>Room Management</a>
                                    <a href="#" class="btn btn-outline-success"><i class="fas fa-users-cog me-2"></i>Staff Management</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Room Booking Detail Modal -->
    <div class="modal fade" id="roomDetailModal" tabindex="-1" aria-labelledby="roomDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="roomDetailModalLabel">Room Booking Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Room Number:</strong> <span id="modalRoomNumber"></span></p>
                            <p><strong>Floor Number:</strong> <span id="modalFloorNumber"></span></p>
                            <p><strong>Customer Name:</strong> <span id="modalCustomer"></span></p>
                            <p><strong>Check-in Date:</strong> <span id="modalCheckIn"></span></p>
                            <p><strong>Check-out Date:</strong> <span id="modalCheckOut"></span></p>
                            <p><strong>Status:</strong> <span id="modalStatus" class="badge"></span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Edit Booking</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById("menu-toggle")?.addEventListener("click", () => {
            document.getElementById("wrapper")?.classList.toggle("toggled");
        });

        const roomDetails = {
            '101': [
                { customer: 'Nguyễn Văn Nam (Người A)', checkIn: '2025-08-20', checkOut: '2025-08-30', status: 'Confirmed', statusClass: 'bg-success' },
                { customer: 'Trần Thị Bình (Người B)', checkIn: '2025-08-30', checkOut: '2025-08-31', status: 'Pending', statusClass: 'bg-warning' } // Đổi checkOut thành 31 để hiển thị đến hết 30
            ],
            '102': [{ customer: 'Trần Thị Hoa', checkIn: '2025-08-16', checkOut: '2025-08-19', status: 'Pending', statusClass: 'bg-warning' }],
            '103': [{ customer: 'Lê Minh Hải', checkIn: '2025-08-20', checkOut: '2025-08-22', status: 'Check-in', statusClass: 'bg-info' }],
            '104': [{ customer: 'Phạm Văn Bình', checkIn: '2025-08-25', checkOut: '2025-08-28', status: 'Confirmed', statusClass: 'bg-success' }],
            '105': [{ customer: 'Võ Thị Lan', checkIn: '2025-09-01', checkOut: '2025-09-05', status: 'Check-out', statusClass: 'bg-secondary' }],
            '201': [{ customer: 'Lê Minh Tuấn', checkIn: '2025-08-17', checkOut: '2025-08-22', status: 'Confirmed', statusClass: 'bg-success' }],
            '202': [{ customer: 'Phạm Thị Lan', checkIn: '2025-08-18', checkOut: '2025-08-21', status: 'Check-in', statusClass: 'bg-info' }],
            '203': [{ customer: 'Võ Văn Phúc', checkIn: '2025-08-19', checkOut: '2025-08-23', status: 'Confirmed', statusClass: 'bg-success' }],
            '204': [{ customer: 'Đặng Văn Khôi', checkIn: '2025-09-02', checkOut: '2025-09-04', status: 'Pending', statusClass: 'bg-warning' }],
            '205': [{ customer: 'Hoàng Thị Minh', checkIn: '2025-09-05', checkOut: '2025-09-08', status: 'Check-out', statusClass: 'bg-secondary' }],
            '301': [{ customer: 'Đặng Thị Mai', checkIn: '2025-08-20', checkOut: '2025-08-24', status: 'Check-out', statusClass: 'bg-secondary' }],
            '302': [{ customer: 'Hoàng Văn Dũng', checkIn: '2025-08-25', checkOut: '2025-08-28', status: 'Confirmed', statusClass: 'bg-success' }],
            '303': [{ customer: 'Bùi Văn Tùng', checkIn: '2025-09-10', checkOut: '2025-09-12', status: 'Check-in', statusClass: 'bg-info' }],
            '304': [{ customer: 'Phan Thị Ngọc', checkIn: '2025-09-15', checkOut: '2025-09-18', status: 'Pending', statusClass: 'bg-warning' }],
            '305': [{ customer: 'Lý Văn Quân', checkIn: '2025-09-20', checkOut: '2025-09-22', status: 'Confirmed', statusClass: 'bg-success' }],
            '401': [{ customer: 'Bùi Thị Hằng', checkIn: '2025-09-05', checkOut: '2025-09-10', status: 'Check-out', statusClass: 'bg-secondary' }],
            '402': [{ customer: 'Phan Văn An', checkIn: '2025-09-01', checkOut: '2025-09-05', status: 'Pending', statusClass: 'bg-warning' }],
            '403': [{ customer: 'Trương Thị Yến', checkIn: '2025-10-01', checkOut: '2025-10-03', status: 'Confirmed', statusClass: 'bg-success' }],
            '404': [{ customer: 'Ngô Văn Long', checkIn: '2025-10-05', checkOut: '2025-10-07', status: 'Check-in', statusClass: 'bg-info' }],
            '405': [{ customer: 'Vũ Thị Hà', checkIn: '2025-10-10', checkOut: '2025-10-12', status: 'Check-out', statusClass: 'bg-secondary' }],
            '501': [{ customer: 'Lý Thị Thu', checkIn: '2025-09-10', checkOut: '2025-09-14', status: 'Confirmed', statusClass: 'bg-success' }],
            '502': [{ customer: 'Đỗ Văn Kiên', checkIn: '2025-10-15', checkOut: '2025-10-18', status: 'Pending', statusClass: 'bg-warning' }],
            '503': [{ customer: 'Hồ Thị Dung', checkIn: '2025-10-20', checkOut: '2025-10-22', status: 'Check-in', statusClass: 'bg-info' }],
            '504': [{ customer: 'Mai Văn Hùng', checkIn: '2025-10-25', checkOut: '2025-10-28', status: 'Confirmed', statusClass: 'bg-success' }],
            '505': [{ customer: 'Dương Thị Linh', checkIn: '2025-11-01', checkOut: '2025-11-03', status: 'Check-out', statusClass: 'bg-secondary' }]
        };

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' });
        }

        function addDays(dateString, days) {
            const date = new Date(dateString);
            date.setDate(date.getDate() + days);
            return date.toISOString().split('T')[0]; // Trả về định dạng YYYY-MM-DD
        }

        function showRoomDetails(props) {
            // Tính số tầng từ room number (ví dụ: 201 → 2)
            const floor = Math.floor(parseInt(props.roomNumber) / 100);

            document.getElementById('modalRoomNumber').textContent = props.roomNumber;
            document.getElementById('modalFloorNumber').textContent = floor;
            document.getElementById('modalCustomer').textContent = props.customer;
            document.getElementById('modalCheckIn').textContent = formatDate(props.checkIn);
            document.getElementById('modalCheckOut').textContent = formatDate(props.checkOut);
            
            const statusBadge = document.getElementById('modalStatus');
            statusBadge.textContent = props.status;
            statusBadge.className = 'badge ' + props.statusClass;

            const modal = new bootstrap.Modal(document.getElementById('roomDetailModal'));
            modal.show();
        }

        let calendar;

        function renderCalendar(filteredRooms) {
            const calendarEl = document.getElementById('calendar');
            if (!calendarEl) return;

            const statusColorMap = {
                'Confirmed': '#28a745', 'Pending': '#ffc107',
                'Check-in': '#17a2b8', 'Check-out': '#6c757d'
            };

            const events = [];
            Object.entries(filteredRooms).forEach(([roomNumber, bookings]) => {
                bookings.forEach(booking => {
                    const eventEnd = addDays(booking.checkOut, 1); // Thêm 1 ngày vào checkOut để hiển thị đến hết ngày check-out
                    events.push({
                        title: 'Room ' + roomNumber + ' - ' + booking.customer,
                        start: booking.checkIn,
                        end: eventEnd, // Đảm bảo hiển thị đến hết ngày check-out
                        allDay: true,
                        extendedProps: {
                            roomNumber: roomNumber,
                            customer: booking.customer,
                            checkIn: booking.checkIn,
                            checkOut: booking.checkOut, // Giữ nguyên checkOut gốc cho modal
                            status: booking.status,
                            statusClass: booking.statusClass
                        },
                        backgroundColor: statusColorMap[booking.status] || '#007bff',
                        borderColor: statusColorMap[booking.status] || '#007bff'
                    });
                });
            });

            if (calendar) {
                calendar.removeAllEvents();
                calendar.addEventSource(events);
            } else {
                calendar = new FullCalendar.Calendar(calendarEl, {
                    height: 'auto',
                    initialView: 'dayGridMonth',
                    firstDay: 1, // Bắt đầu từ Monday (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: '' // Bỏ các nút month/week/day
                    },
                    events: events,
                    eventClick: info => {
                        info.jsEvent.preventDefault();
                        showRoomDetails(info.event.extendedProps); // Hiển thị chi tiết booking được click
                    }
                });
                calendar.render();
            }
        }

        function applyFilters() {
            const selectedRoom = document.getElementById('roomFilter').value;
            const status = document.getElementById('statusFilter').value;

            let filteredRooms = { ...roomDetails };

            // Lọc theo room
            if (selectedRoom !== '') {
                filteredRooms = { [selectedRoom]: roomDetails[selectedRoom] || [] };
            }

            // Lọc theo status (lọc từng booking trong mảng)
            if (status !== '') {
                Object.keys(filteredRooms).forEach(roomNumber => {
                    filteredRooms[roomNumber] = filteredRooms[roomNumber].filter(booking => booking.status === status);
                });
            }

            renderCalendar(filteredRooms);

            // Nếu chọn một phòng cụ thể và có bookings, nhảy đến ngày check-in của booking đầu tiên
            if (selectedRoom !== '' && filteredRooms[selectedRoom] && filteredRooms[selectedRoom].length > 0) {
                const firstBooking = filteredRooms[selectedRoom][0];
                console.log('Jumping to date for room ' + selectedRoom + ': ' + firstBooking.checkIn); // Debug
                calendar.gotoDate(firstBooking.checkIn); // Nhảy đến tháng chứa check-in
            }
        }

        function populateRoomFilter() {
            const roomFilterSelect = document.getElementById('roomFilter');
            if (!roomFilterSelect) return;
            Object.keys(roomDetails).sort((a, b) => a - b).forEach(roomNumber => {
                console.log('Adding room: ' + roomNumber); // Debug
                const option = document.createElement('option');
                option.value = roomNumber;
                option.textContent = 'Room ' + roomNumber;
                roomFilterSelect.appendChild(option);
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            populateRoomFilter();
            renderCalendar(roomDetails);
            document.getElementById('roomFilter')?.addEventListener('change', applyFilters);
            document.getElementById('statusFilter')?.addEventListener('change', applyFilters);
        });
    </script>
</body>
</html>