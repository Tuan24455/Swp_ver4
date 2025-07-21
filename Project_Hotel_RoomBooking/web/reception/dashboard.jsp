<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bảng Điều Khiển Lễ Tân - Hệ Thống Quản Lý Khách Sạn</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="${pageContext.request.contextPath}/css/dashboard.css"
      rel="stylesheet"
    />
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

      <!-- Nội Dung Chính -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Thanh Điều Hướng Trên -->
        <nav
          class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
        >
          <div class="container-fluid">
            <button class="btn btn-sm btn-outline-secondary" id="menu-toggle">
              <i class="fas fa-bars"></i>
            </button>
            <div class="d-flex align-items-center gap-3 ms-auto">
              <span id="current-date" class="fw-semibold text-muted"
                >Thứ Ba, 24 Tháng 6, 2025</span
              >
              <span id="current-time" class="fw-semibold">16:56:28</span>
            </div>
          </div>
        </nav>

        <div class="container-fluid py-4">
          <!-- Tiêu Đề Trang -->
          <div class="page-header mb-4">
            <h1 class="h2">Tổng Quan Bảng Điều Khiển</h1>
          </div>

          <!-- Thẻ Lịch -->
          <div class="card shadow-sm">
            <div class="card-header bg-white border-bottom">
              <h5 class="mb-0">
                <i class="fas fa-calendar-alt me-2"></i>Lịch Đặt Phòng
              </h5>
            </div>

            <!-- Phần Lọc Phòng -->
            <div class="card-body border-bottom">
              <div class="row align-items-end g-3">
                <div class="col-md-4">
                  <label for="roomFilter" class="form-label fw-semibold"
                    >Lọc theo Phòng:</label
                  >
                  <select class="form-select" id="roomFilter">
                    <option value="">Tất Cả Phòng</option>
                    <!-- Options will be populated dynamically after data loads -->
                  </select>
                </div>
                <div class="col-md-4">
                  <label for="statusFilter" class="form-label fw-semibold"
                    >Lọc theo Trạng Thái:</label
                  >
                  <select class="form-select" id="statusFilter">
                    <option value="">Tất Cả Trạng Thái</option>
                    <option value="Đã Xác Nhận">Đã Xác Nhận</option>
                    <option value="Đang Chờ">Đang Chờ</option>
                    <option value="Nhận Phòng">Nhận Phòng</option>
                    <option value="Trả Phòng">Trả Phòng</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label for="dateFilter" class="form-label fw-semibold"
                    >Lọc theo Ngày:</label
                  >
                  <select class="form-select" id="dateFilter" disabled>
                    <option value="">Chọn Ngày</option>
                    <!-- Options will be populated based on selected room -->
                  </select>
                </div>
              </div>
            </div>

            <div class="card-body">
              <div id="calendar"></div>
            </div>
          </div>

          <!-- Phần Hành Động Nhanh -->
          <div class="row mt-4">
            <div class="col-lg-6">
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-bolt me-2 text-warning"></i>Hành Động Nhanh
                  </h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <a href="#" class="btn btn-outline-primary"
                      ><i class="fas fa-calendar-plus me-2"></i>Đặt Phòng Mới</a
                    >
                    <a href="#" class="btn btn-outline-info"
                      ><i class="fas fa-door-open me-2"></i>Quản Lý Phòng</a
                    >
                    <a href="#" class="btn btn-outline-success"
                      ><i class="fas fa-users-cog me-2"></i>Quản Lý Nhân Viên</a
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Chi Tiết Đặt Phòng -->
    <div
      class="modal fade"
      id="roomDetailModal"
      tabindex="-1"
      aria-labelledby="roomDetailModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="roomDetailModalLabel">
              Chi Tiết Đặt Phòng
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-12">
                <p>
                  <strong>Số Phòng:</strong> <span id="modalRoomNumber"></span>
                </p>
                <p>
                  <strong>Số Tầng:</strong> <span id="modalFloorNumber"></span>
                </p>
                <p>
                  <strong>Tên Khách Hàng:</strong>
                  <span id="modalCustomer"></span>
                </p>
                <p>
                  <strong>Ngày Nhận Phòng:</strong>
                  <span id="modalCheckIn"></span>
                </p>
                <p>
                  <strong>Ngày Trả Phòng:</strong>
                  <span id="modalCheckOut"></span>
                </p>
                <p>
                  <strong>Trạng Thái:</strong>
                  <span id="modalStatus" class="badge"></span>
                </p>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Đóng
            </button>
            <button type="button" class="btn btn-primary">
              Chỉnh Sửa Đặt Phòng
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Debugging: Display roomBookings data -->
    <div class="container-fluid py-4">
      <div class="card shadow-sm">
        <div class="card-header bg-white border-bottom">
          <h5 class="mb-0">Debugging Room Bookings Data</h5>
        </div>
        <div class="card-body">
          <pre>
            <c:forEach var="entry" items="${roomBookings}">
              Room: ${entry.key}
              <c:forEach var="booking" items="${entry.value}">
                Customer: ${booking.customer}, Check-in: ${booking.checkInDate}, Check-out: ${booking.checkOutDate}, Status: ${booking.status}
              </c:forEach>
            </c:forEach>
          </pre>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Menu toggle functionality
      document.getElementById("menu-toggle")?.addEventListener("click", () => {
        document.getElementById("wrapper")?.classList.toggle("toggled");
      });

      // Global variables
      let roomDetails = {};
      let calendar;

      // Utility functions
      function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString("vi-VN", {
          day: "2-digit",
          month: "2-digit",
          year: "numeric",
        });
      }
      function addDays(dateString, days) {
        try {
          const date = new Date(dateString);

          // Check if date is valid
          if (isNaN(date.getTime())) {
            console.warn("Invalid date in addDays:", dateString);
            return dateString; // Return original string if invalid
          }

          date.setDate(date.getDate() + days);
          return date.toISOString().split("T")[0];
        } catch (err) {
          console.error("Error in addDays function:", err);
          return dateString; // Return original string on error
        }
      }

      function showRoomDetails(props) {
        const floor = Math.floor(parseInt(props.roomNumber) / 100);

        document.getElementById("modalRoomNumber").textContent =
          props.roomNumber;
        document.getElementById("modalFloorNumber").textContent = floor;
        document.getElementById("modalCustomer").textContent = props.customer;
        document.getElementById("modalCheckIn").textContent = formatDate(
          props.checkIn
        );
        document.getElementById("modalCheckOut").textContent = formatDate(
          props.checkOut
        );

        const statusBadge = document.getElementById("modalStatus");
        statusBadge.textContent = props.status;
        statusBadge.className = "badge " + props.statusClass;

        const modal = new bootstrap.Modal(
          document.getElementById("roomDetailModal")
        );
        modal.show();
      }

      // Load booking data via AJAX to avoid JSP JSON escaping issues
      async function loadBookingData() {
        try {
          console.log("Loading booking data via AJAX...");

          const response = await fetch(
            "${pageContext.request.contextPath}/json-test"
          );

          if (!response.ok) {
            throw new Error(
              "HTTP " + response.status + ": " + response.statusText
            );
          }

          const jsonText = await response.text();
          console.log("AJAX response length:", jsonText.length);
          roomDetails = JSON.parse(jsonText);
          console.log("Successfully loaded roomDetails via AJAX:", roomDetails);
          console.log("Number of rooms:", Object.keys(roomDetails).length);

          // Debug: Log sample booking date format if available
          const roomKeys = Object.keys(roomDetails);
          if (roomKeys.length > 0) {
            const firstRoom = roomKeys[0];
            if (roomDetails[firstRoom] && roomDetails[firstRoom].length > 0) {
              const sampleBooking = roomDetails[firstRoom][0];
              console.log("Sample booking date format:", {
                checkIn: sampleBooking.checkIn,
                checkOut: sampleBooking.checkOut,
                checkInType: typeof sampleBooking.checkIn,
                checkOutType: typeof sampleBooking.checkOut,
              });
            }
          }

          // Populate room filter dropdown after data loads
          populateRoomFilter(roomDetails);

          // Initialize calendar after data is loaded
          renderCalendar(roomDetails);

          return true;
        } catch (error) {
          console.error("Failed to load booking data via AJAX:", error);

          // Fallback to JSP attribute method
          console.log("Falling back to JSP attribute method...");
          return loadBookingDataFromJSP();
        }
      }

      // Fallback method using JSP attributes
      function loadBookingDataFromJSP() {
        console.log("=== Using JSP attribute fallback ===");
        const roomBookingsJson = "${roomBookingsJson}";

        try {
          if (
            roomBookingsJson &&
            roomBookingsJson.trim() !== "" &&
            roomBookingsJson.trim() !== "null"
          ) {
            console.log("JSP roomBookingsJson:", roomBookingsJson);
            roomDetails = JSON.parse(roomBookingsJson);
            console.log("Successfully parsed JSP roomDetails:", roomDetails);

            // Populate room filter dropdown after data loads
            populateRoomFilter(roomDetails);

            renderCalendar(roomDetails);
            return true;
          } else {
            console.log("JSP Room Bookings JSON is empty or invalid.");
            return false;
          }
        } catch (e) {
          console.error("Failed to parse JSP roomBookingsJson:", e);
          return false;
        }
      }

      // Populate room filter dropdown with available rooms
      function populateRoomFilter(roomData) {
        const roomFilter = document.getElementById("roomFilter");
        if (!roomFilter) {
          console.error("Room filter element not found!");
          return;
        }

        // Clear existing options except the first one (All Rooms)
        while (roomFilter.options.length > 1) {
          roomFilter.remove(1);
        }

        // Get all room numbers and sort them numerically
        const roomNumbers = Object.keys(roomData).sort(
          (a, b) => parseInt(a) - parseInt(b)
        );
        console.log("Available room numbers:", roomNumbers);

        // Add room options to the dropdown
        roomNumbers.forEach((roomNumber) => {
          const option = document.createElement("option");
          option.value = roomNumber;
          option.textContent = "Phòng " + roomNumber;
          roomFilter.appendChild(option);
        });

        console.log("Room filter populated with", roomNumbers.length, "rooms");
      }

      // New function: Populate date filter based on selected room
      function populateDateFilter(selectedRoom) {
        const dateFilter = document.getElementById("dateFilter");
        if (!dateFilter) {
          console.error("Date filter element not found!");
          return;
        }

        // Reset and disable if no room selected
        dateFilter.disabled = true;
        dateFilter.innerHTML = '<option value="">Chọn Ngày</option>';

        if (selectedRoom === "") {
          console.log("No room selected, disabling date filter");
          return;
        }

        const bookings = roomDetails[selectedRoom] || [];
        if (bookings.length === 0) {
          console.log(`No bookings for room ${selectedRoom}`);
          return;
        }

        // Collect unique check-in dates
        const uniqueDates = new Set();
        bookings.forEach((booking) => {
          if (booking.checkIn) {
            uniqueDates.add(booking.checkIn); // Assuming checkIn is in YYYY-MM-DD format
          }
        });

        // Convert to array and sort by date
        const sortedDates = Array.from(uniqueDates).sort(
          (a, b) => new Date(a) - new Date(b)
        );

        // Populate options
        sortedDates.forEach((date) => {
          const option = document.createElement("option");
          option.value = date;
          option.textContent = formatDate(date); // Display in DD-MM-YYYY
          dateFilter.appendChild(option);
        });

        dateFilter.disabled = false;
        console.log(
          `Date filter populated with ${sortedDates.length} dates for room ${selectedRoom}`
        );
      }

      function renderCalendar(filteredRooms) {
        console.log("Rendering calendar with data:", filteredRooms);

        const calendarEl = document.getElementById("calendar");
        if (!calendarEl) {
          console.error("Calendar element not found!");
          return;
        }

        // Status translation and color mapping
        // Maps database status values to UI display values and colors
        const statusDisplayMap = {
          Confirmed: "Đã Xác Nhận",
          Pending: "Đang Chờ",
          "Check-in": "Nhận Phòng",
          "Check-out": "Trả Phòng",
        };

        const statusColorMap = {
          Confirmed: "#28a745",
          Pending: "#ffc107",
          "Check-in": "#17a2b8",
          "Check-out": "#6c757d",
        };

        const statusClassMap = {
          Confirmed: "bg-success",
          Pending: "bg-warning text-dark",
          "Check-in": "bg-info text-dark",
          "Check-out": "bg-secondary",
        };

        const events = [];

        // Create calendar events from room bookings
        Object.entries(filteredRooms).forEach(([roomNumber, bookings]) => {
          if (!bookings || !Array.isArray(bookings)) {
            console.warn(`No valid bookings for room ${roomNumber}`);
            return;
          }
          bookings.forEach((booking) => {
            if (!booking.checkIn || !booking.checkOut) {
              console.warn("Skipping booking with invalid dates:", booking);
              return;
            }

            // Ensure dates are valid
            let startDate, endDate;
            try {
              startDate = new Date(booking.checkIn);
              endDate = new Date(booking.checkOut);

              // Verify the dates are valid
              if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
                console.warn("Invalid date format for booking:", booking);
                return;
              }

              // Get translated status for display
              const displayStatus =
                statusDisplayMap[booking.status] || booking.status;

              const eventEnd = addDays(booking.checkOut, 1);
              events.push({
                title: "Phòng " + roomNumber + " - " + booking.customer,
                start: booking.checkIn,
                end: eventEnd,
                allDay: true,
                extendedProps: {
                  roomNumber: roomNumber,
                  customer: booking.customer,
                  checkIn: booking.checkIn,
                  checkOut: booking.checkOut,
                  status: displayStatus, // Use translated status for display
                  statusClass: statusClassMap[booking.status] || "bg-primary",
                },
                backgroundColor: statusColorMap[booking.status] || "#007bff",
                borderColor: statusColorMap[booking.status] || "#007bff",
              });
            } catch (err) {
              console.error("Error processing booking dates:", err, booking);
            }
          });
        });

        console.log(`Created ${events.length} calendar events`);

        if (calendar) {
          calendar.removeAllEvents();
          calendar.addEventSource(events);
        } else {
          calendar = new FullCalendar.Calendar(calendarEl, {
            height: "auto",
            initialView: "dayGridMonth",
            firstDay: 1,
            locale: "vi",
            headerToolbar: {
              left: "prev,next today",
              center: "title",
              right: "",
            },
            events: events,
            eventClick: (info) => {
              info.jsEvent.preventDefault();
              showRoomDetails(info.event.extendedProps);
            },
          });

          calendar.render();
          console.log("Calendar rendered successfully");
        }
      }

      function applyFilters() {
        const selectedRoom = document.getElementById("roomFilter").value;
        const selectedStatus = document.getElementById("statusFilter").value;
        const selectedDate = document.getElementById("dateFilter").value;

        console.log(
          `Applying filters - Room: ${selectedRoom}, Status: ${selectedStatus}, Date: ${selectedDate}`
        );

        // Map UI status values back to database status values
        const statusDbMap = {
          "Đã Xác Nhận": "Confirmed",
          "Đang Chờ": "Pending",
          "Nhận Phòng": "Check-in",
          "Trả Phòng": "Check-out",
        };

        const dbStatus = statusDbMap[selectedStatus] || selectedStatus;

        // Make a deep copy of roomDetails
        let filteredRooms = JSON.parse(JSON.stringify(roomDetails));

        // Filter by room
        if (selectedRoom !== "") {
          console.log(`Filtering for room: ${selectedRoom}`);
          if (roomDetails[selectedRoom]) {
            filteredRooms = { [selectedRoom]: roomDetails[selectedRoom] || [] };
          } else {
            console.warn(`Room ${selectedRoom} not found in data`);
            filteredRooms = {};
          }
        }

        // Filter by status
        if (selectedStatus !== "") {
          console.log(
            `Filtering for status: ${selectedStatus} (DB: ${dbStatus})`
          );
          Object.keys(filteredRooms).forEach((roomNumber) => {
            // Filter bookings by status
            const originalLength = filteredRooms[roomNumber]?.length || 0;
            filteredRooms[roomNumber] = filteredRooms[roomNumber].filter(
              (booking) => {
                return booking.status === dbStatus;
              }
            );
            console.log(
              `Room ${roomNumber}: filtered from ${originalLength} to ${filteredRooms[roomNumber].length} bookings`
            );
          });
        }

        // Render the filtered calendar
        renderCalendar(filteredRooms);

        // If a date is selected, navigate to that date
        if (selectedDate !== "" && calendar) {
          try {
            console.log(`Navigating to date: ${selectedDate}`);
            calendar.gotoDate(new Date(selectedDate));
          } catch (err) {
            console.error("Failed to navigate to date:", err);
          }
        } else if (
          selectedRoom !== "" &&
          filteredRooms[selectedRoom] &&
          filteredRooms[selectedRoom].length > 0 &&
          filteredRooms[selectedRoom][0].checkIn
        ) {
          // Fallback: Navigate to first booking date if no specific date selected
          const firstBooking = filteredRooms[selectedRoom][0];
          try {
            console.log(
              `Navigating to first booking date: ${firstBooking.checkIn}`
            );
            calendar.gotoDate(new Date(firstBooking.checkIn));
          } catch (err) {
            console.error("Failed to navigate to date:", err);
          }
        }
      }

      // Initialize on DOM load
      document.addEventListener("DOMContentLoaded", async () => {
        console.log("=== Dashboard initialization ===");

        // Load data (AJAX first, JSP fallback)
        const dataLoaded = await loadBookingData();

        if (dataLoaded) {
          console.log("Data loaded successfully");
        } else {
          console.error("Failed to load booking data");
          // Show error message to user
          const calendarEl = document.getElementById("calendar");
          if (calendarEl) {
            calendarEl.innerHTML =
              '<div class="alert alert-danger">Không thể tải dữ liệu đặt phòng. Vui lòng làm mới trang.</div>';
          }
        }

        // Setup event listeners
        const roomFilter = document.getElementById("roomFilter");
        const statusFilter = document.getElementById("statusFilter");
        const dateFilter = document.getElementById("dateFilter");

        roomFilter?.addEventListener("change", () => {
          populateDateFilter(roomFilter.value); // Populate date filter when room changes
          applyFilters();
        });
        statusFilter?.addEventListener("change", applyFilters);
        dateFilter?.addEventListener("change", applyFilters); // Apply filters and gotoDate when date changes

        // Update clock
        updateClock();
        setInterval(updateClock, 1000);

        console.log("Dashboard initialization complete");
      });

      // Update the clock display
      function updateClock() {
        const now = new Date();
        const timeEl = document.getElementById("current-time");
        const dateEl = document.getElementById("current-date");

        if (timeEl) {
          timeEl.textContent = now.toLocaleTimeString("vi-VN");
        }

        if (dateEl) {
          const options = {
            weekday: "long",
            day: "numeric",
            month: "long",
            year: "numeric",
          };
          dateEl.textContent = now.toLocaleDateString("vi-VN", options);
        }
      }
    </script>
  </body>
</html>
