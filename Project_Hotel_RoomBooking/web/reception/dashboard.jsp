<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Hotel Management System</title>
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
    <link
      href="${pageContext.request.contextPath}/css/dashboard.css"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <nav
          class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
        >
          <div class="container-fluid">
            <div class="d-flex align-items-center gap-3">
              <span id="current-date" class="fw-semibold text-muted">Thứ Ba, 24 tháng 6, 2025</span>
              <span id="current-time" class="fw-semibold">16:56:28</span>
            </div>
          </div>
        </nav>

        <div class="container-fluid py-4">
          <!-- Page Header -->
          <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h1 class="h2 mb-2">Dashboard Overview</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                      <a href="#"><i class="fas fa-home me-1"></i>Home</a>
                    </li>
                    <li class="breadcrumb-item active">Dashboard</li>
                  </ol>
                </nav>
              </div>
              <div class="btn-group">
                <button class="btn btn-light" onclick="exportReport()">
                  <i class="fas fa-download me-2"></i>Export Report
                </button>
                <button class="btn btn-light" onclick="refreshData()">
                  <i class="fas fa-sync-alt me-2"></i>Refresh
                </button>
              </div>
            </div>
          </div>

          <!-- Gantt Chart -->
          <div class="card shadow-sm">
            <div class="card-header bg-white border-bottom">
              <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                  <i class="fas fa-chart-gantt me-2"></i>Room Booking Timeline
                </h5>
                <div class="btn-group">
                  <button class="btn btn-sm btn-outline-primary active">
                    <i class="fas fa-calendar me-1"></i>Week View
                  </button>
                  <button class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-calendar-day me-1"></i>Day View
                  </button>
                </div>
              </div>
            </div>
            <div class="card-body p-0">
              <div class="gantt-wrapper">
                <div class="gantt-container">
                <div class="gantt-layout">
                  <!-- Left Sidebar -->
                  <div class="gantt-sidebar">
                    <div class="gantt-header-row">
                      <div class="room-col">Room</div>
                      <div class="customer-col">Customer</div>
                      <div class="status-col">Status</div>
                    </div>
                    
                    <!-- Room 101 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('101')">
                      <div class="room-col">
                        <span class="room-number">101</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Nguyễn Văn Nam</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 102 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('102')">
                      <div class="room-col">
                        <span class="room-number">102</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Trần Thị Hoa</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-warning">Pending</span>
                      </div>
                    </div>
                    
                    <!-- Room 201 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('201')">
                      <div class="room-col">
                        <span class="room-number">201</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Lê Minh Tuấn</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 202 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('202')">
                      <div class="room-col">
                        <span class="room-number">202</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Phạm Thị Lan</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-info">Check-in</span>
                      </div>
                    </div>
                    
                    <!-- Room 203 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('203')">
                      <div class="room-col">
                        <span class="room-number">203</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Võ Văn Phúc</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 301 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('301')">
                      <div class="room-col">
                        <span class="room-number">301</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Đặng Thị Mai</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-secondary">Check-out</span>
                      </div>
                    </div>
                    
                    <!-- Room 302 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('302')">
                      <div class="room-col">
                        <span class="room-number">302</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Hoàng Văn Dũng</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 303 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('303')">
                      <div class="room-col">
                        <span class="room-number">303</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Bùi Thị Hằng</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-warning">Pending</span>
                      </div>
                    </div>
                    
                    <!-- Room 401 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('401')">
                      <div class="room-col">
                        <span class="room-number">401</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Nguyễn Thị Thu</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-info">Check-in</span>
                      </div>
                    </div>
                    
                    <!-- Room 402 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('402')">
                      <div class="room-col">
                        <span class="room-number">402</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Trương Văn Hải</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 403 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('403')">
                      <div class="room-col">
                        <span class="room-number">403</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Phan Thị Linh</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-success">Confirmed</span>
                      </div>
                    </div>
                    
                    <!-- Room 501 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('501')">
                      <div class="room-col">
                        <span class="room-number">501</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Lý Văn Toàn</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-warning">Pending</span>
                      </div>
                    </div>
                    
                    <!-- Room 502 -->
                    <div class="gantt-room-row" onclick="showRoomDetails('502')">
                      <div class="room-col">
                        <span class="room-number">502</span>
                      </div>
                      <div class="customer-col">
                        <span class="customer-name">Đinh Thị Hương</span>
                      </div>
                      <div class="status-col">
                        <span class="badge bg-secondary">Check-out</span>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Right Timeline -->
                  <div class="gantt-timeline">
                    <!-- Timeline Header -->
                    <div class="timeline-header">
                      <div class="timeline-date">15</div>
                      <div class="timeline-date">16</div>
                      <div class="timeline-date">17</div>
                      <div class="timeline-date">18</div>
                      <div class="timeline-date">19</div>
                      <div class="timeline-date today">20</div>
                      <div class="timeline-date">21</div>
                      <div class="timeline-date">22</div>
                      <div class="timeline-date">23</div>
                      <div class="timeline-date">24</div>
                      <div class="timeline-date">25</div>
                      <div class="timeline-date">26</div>
                    </div>
                    
                    <!-- Timeline Rows -->
                    <div class="timeline-content">
                      <!-- Grid Lines -->
                      <div class="timeline-grid">
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                        <div class="grid-line"></div>
                      </div>
                      
                      <!-- Room 101 Bar (Day 15-18) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 0%; width: 25%;" onclick="showRoomDetails('101')">
                          <span class="bar-text">3 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 102 Bar (Day 16-19) -->
                      <div class="timeline-row">
                        <div class="gantt-bar pending" style="left: 8.33%; width: 25%;" onclick="showRoomDetails('102')">
                          <span class="bar-text">3 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 201 Bar (Day 17-22) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 16.66%; width: 41.66%;" onclick="showRoomDetails('201')">
                          <span class="bar-text">5 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 202 Bar (Day 18-21) -->
                      <div class="timeline-row">
                        <div class="gantt-bar checkin" style="left: 25%; width: 25%;" onclick="showRoomDetails('202')">
                          <span class="bar-text">3 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 203 Bar (Day 19-23) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 33.33%; width: 33.33%;" onclick="showRoomDetails('203')">
                          <span class="bar-text">4 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 301 Bar (Day 20-24) -->
                      <div class="timeline-row">
                        <div class="gantt-bar checkout" style="left: 41.66%; width: 33.33%;" onclick="showRoomDetails('301')">
                          <span class="bar-text">4 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 302 Bar (Day 21-25) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 50%; width: 33.33%;" onclick="showRoomDetails('302')">
                          <span class="bar-text">4 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 303 Bar (Day 22-26) -->
                      <div class="timeline-row">
                        <div class="gantt-bar pending" style="left: 58.33%; width: 33.33%;" onclick="showRoomDetails('303')">
                          <span class="bar-text">4 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 401 Bar (Day 15-20) -->
                      <div class="timeline-row">
                        <div class="gantt-bar checkin" style="left: 0%; width: 41.66%;" onclick="showRoomDetails('401')">
                          <span class="bar-text">5 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 402 Bar (Day 17-21) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 16.66%; width: 33.33%;" onclick="showRoomDetails('402')">
                          <span class="bar-text">4 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 403 Bar (Day 19-22) -->
                      <div class="timeline-row">
                        <div class="gantt-bar confirmed" style="left: 33.33%; width: 25%;" onclick="showRoomDetails('403')">
                          <span class="bar-text">3 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 501 Bar (Day 20-26) -->
                      <div class="timeline-row">
                        <div class="gantt-bar pending" style="left: 41.66%; width: 50%;" onclick="showRoomDetails('501')">
                          <span class="bar-text">6 nights</span>
                        </div>
                      </div>
                      
                      <!-- Room 502 Bar (Day 16-19) -->
                      <div class="timeline-row">
                        <div class="gantt-bar checkout" style="left: 8.33%; width: 25%;" onclick="showRoomDetails('502')">
                          <span class="bar-text">3 nights</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Detail Sidebar -->
                <div class="detail-sidebar" id="detailSidebar">
                  <div class="detail-header">
                    <h6 class="mb-0">
                      <i class="fas fa-info-circle me-2"></i>Room Details
                    </h6>
                    <button class="btn btn-sm btn-outline-secondary" onclick="closeDetailSidebar()">
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                  <div class="detail-content" id="detailContent">
                    <div class="text-center text-muted py-4">
                      <i class="fas fa-mouse-pointer fa-2x mb-2"></i>
                      <p>Click on a room or booking bar to view details</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

          <!-- Quick Actions Section -->
          <div class="row">
            <div class="col-lg-4">
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-bolt me-2 text-warning"></i>Quick Actions
                  </h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-3">
                    <a
                      href="${pageContext.request.contextPath}/admin/bookings.jsp"
                      class="btn btn-outline-primary quick-action-btn"
                    >
                      <i class="fas fa-calendar-plus me-2"></i>New Booking
                    </a>
                    <a
                      href="roomstatus.jsp"
                      class="btn btn-outline-info quick-action-btn"
                    >
                      <i class="fas fa-door-open me-2"></i>Room Management
                    </a>
                    <a
                      href="users.jsp"
                      class="btn btn-outline-success quick-action-btn"
                    >
                      <i class="fas fa-users-cog me-2"></i>Staff Management
                    </a>
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
            <h5 class="modal-title" id="roomDetailModalLabel">
              <i class="fas fa-bed me-2"></i>Room Booking Details
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="booking-detail-item">
              <div class="booking-detail-label">Room Number</div>
              <div class="booking-detail-value" id="modalRoomNumber">101</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Guest Name</div>
              <div class="booking-detail-value" id="modalGuestName">Nguyễn Văn Nam</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Check-in Date</div>
              <div class="booking-detail-value" id="modalCheckIn">November 15, 2024</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Check-out Date</div>
              <div class="booking-detail-value" id="modalCheckOut">November 18, 2024</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Number of Nights</div>
              <div class="booking-detail-value" id="modalNights">3 nights</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Room Type</div>
              <div class="booking-detail-value" id="modalRoomType">Deluxe Room</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Total Price</div>
              <div class="booking-detail-value">
                <span class="text-success fw-bold" id="modalPrice">$450.00</span>
              </div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Booking Status</div>
              <div class="booking-detail-value">
                <span class="room-status-badge bg-success text-white" id="modalStatus">Confirmed</span>
              </div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Contact Number</div>
              <div class="booking-detail-value" id="modalContact">+84 123 456 789</div>
            </div>
            
            <div class="booking-detail-item">
              <div class="booking-detail-label">Special Requests</div>
              <div class="booking-detail-value" id="modalRequests">Extra pillows, Late check-out</div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">
              <i class="fas fa-edit me-2"></i>Edit Booking
            </button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Sidebar toggle functionality
      document
        .getElementById("menu-toggle")
        .addEventListener("click", function () {
          document
            .getElementById("sidebar-wrapper")
            .classList.toggle("toggled");
        });

      function exportReport() {
        alert('Export functionality would be implemented here');
      }

      function refreshData() {
        alert('Refresh functionality would be implemented here');
      }

      // Room details data
      const roomDetails = {
        '101': {
          room: '101',
          type: 'Deluxe Single',
          customer: 'Nguyễn Văn Nam',
          phone: '0909 123 456',
          email: 'nam.nguyen@email.com',
          checkIn: '2024-01-15',
          checkOut: '2024-01-18',
          nights: 3,
          price: '1,500,000 VND',
          totalPrice: '4,500,000 VND',
          status: 'Confirmed',
          statusClass: 'bg-success',
          amenities: ['WiFi', 'TV', 'Air Conditioning', 'Mini Bar'],
          notes: 'Guest requested early check-in at 12:00 PM',
          image: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=300&h=120&fit=crop'
        },
        '102': {
          room: '102',
          type: 'Deluxe Double',
          customer: 'Trần Thị Hoa',
          phone: '0909 234 567',
          email: 'hoa.tran@email.com',
          checkIn: '2024-01-16',
          checkOut: '2024-01-19',
          nights: 3,
          price: '1,800,000 VND',
          totalPrice: '5,400,000 VND',
          status: 'Pending',
          statusClass: 'bg-warning',
          amenities: ['WiFi', 'TV', 'Air Conditioning', 'Balcony'],
          notes: 'Waiting for payment confirmation',
          image: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=300&h=120&fit=crop'
        },
        '201': {
          room: '201',
          type: 'Suite',
          customer: 'Lê Minh Tuấn',
          phone: '0909 345 678',
          email: 'tuan.le@email.com',
          checkIn: '2024-01-17',
          checkOut: '2024-01-22',
          nights: 5,
          price: '2,500,000 VND',
          totalPrice: '12,500,000 VND',
          status: 'Confirmed',
          statusClass: 'bg-success',
          amenities: ['WiFi', 'TV', 'Air Conditioning', 'Jacuzzi', 'Kitchen'],
          notes: 'VIP guest - special welcome amenities',
          image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300&h=120&fit=crop'
        },
        '202': {
          room: '202',
          type: 'Family Room',
          customer: 'Phạm Thị Lan',
          phone: '0909 456 789',
          email: 'lan.pham@email.com',
          checkIn: '2024-01-18',
          checkOut: '2024-01-21',
          nights: 3,
          price: '2,000,000 VND',
          totalPrice: '6,000,000 VND',
          status: 'Check-in',
          statusClass: 'bg-info',
          amenities: ['WiFi', 'TV', 'Air Conditioning', 'Extra Bed'],
          notes: 'Guest checked in at 2:00 PM',
          image: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?w=300&h=120&fit=crop'
        },
        '203': {
          room: '203',
          type: 'Standard Double',
          customer: 'Võ Văn Phúc',
          phone: '0909 567 890',
          email: 'phuc.vo@email.com',
          checkIn: '2024-01-19',
          checkOut: '2024-01-23',
          nights: 4,
          price: '1,200,000 VND',
          totalPrice: '4,800,000 VND',
          status: 'Confirmed',
          statusClass: 'bg-success',
          amenities: ['WiFi', 'TV', 'Air Conditioning'],
          notes: 'No special requests',
          image: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=120&fit=crop'
        },
        '301': {
          room: '301',
          type: 'Deluxe Suite',
          customer: 'Đặng Thị Mai',
          phone: '0909 678 901',
          email: 'mai.dang@email.com',
          checkIn: '2024-01-20',
          checkOut: '2024-01-24',
          nights: 4,
          price: '3,000,000 VND',
          totalPrice: '12,000,000 VND',
          status: 'Check-out',
          statusClass: 'bg-secondary',
          amenities: ['WiFi', 'TV', 'Air Conditioning', 'Ocean View', 'Premium Service'],
          notes: 'Guest will check out at 11:00 AM',
          image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=120&fit=crop'
        }
      };

             function showRoomDetails(roomNumber) {
         // Get room data
         const room = roomDetails[roomNumber];
         
         if (!room) {
           // If no data exists for this room, create default data
           const defaultRoom = {
             room: roomNumber,
             type: 'Standard Room',
             customer: 'Guest Name',
             checkIn: '2024-01-20',
             checkOut: '2024-01-23',
             nights: 3,
             price: '1,500,000 VND',
             status: 'Confirmed',
             phone: '+84 123 456 789',
             notes: 'No special requests'
           };
           
           // Update modal with default data
           document.getElementById('modalRoomNumber').textContent = 'Room ' + roomNumber;
           document.getElementById('modalGuestName').textContent = defaultRoom.customer;
           document.getElementById('modalCheckIn').textContent = formatDate(defaultRoom.checkIn);
           document.getElementById('modalCheckOut').textContent = formatDate(defaultRoom.checkOut);
           document.getElementById('modalNights').textContent = defaultRoom.nights + ' nights';
           document.getElementById('modalRoomType').textContent = defaultRoom.type;
           document.getElementById('modalPrice').textContent = defaultRoom.price;
           document.getElementById('modalStatus').textContent = defaultRoom.status;
           document.getElementById('modalStatus').className = 'room-status-badge bg-success text-white';
           document.getElementById('modalContact').textContent = defaultRoom.phone;
           document.getElementById('modalRequests').textContent = defaultRoom.notes;
         } else {
           // Update modal with room data
           document.getElementById('modalRoomNumber').textContent = 'Room ' + room.room;
           document.getElementById('modalGuestName').textContent = room.customer;
           document.getElementById('modalCheckIn').textContent = formatDate(room.checkIn);
           document.getElementById('modalCheckOut').textContent = formatDate(room.checkOut);
           document.getElementById('modalNights').textContent = room.nights + ' nights';
           document.getElementById('modalRoomType').textContent = room.type;
           document.getElementById('modalPrice').textContent = room.totalPrice;
           document.getElementById('modalStatus').textContent = room.status;
           document.getElementById('modalStatus').className = 'room-status-badge ' + room.statusClass.replace('bg-', 'bg-') + ' text-white';
           document.getElementById('modalContact').textContent = room.phone;
           document.getElementById('modalRequests').textContent = room.notes;
         }
         
         // Show modal
         const modal = new bootstrap.Modal(document.getElementById('roomDetailModal'));
         modal.show();
       }
       
       function formatDate(dateString) {
         const date = new Date(dateString);
         const options = { year: 'numeric', month: 'long', day: 'numeric' };
         return date.toLocaleDateString('en-US', options);
       }

      function closeDetailSidebar() {
        const sidebar = document.getElementById('detailSidebar');
        sidebar.classList.remove('show');
      }
    </script>
  </body>
</html>
