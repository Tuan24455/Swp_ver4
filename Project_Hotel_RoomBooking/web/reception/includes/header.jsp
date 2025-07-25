<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!-- Date and time display -->
<div class="d-flex align-items-center gap-3 ms-auto">
  <span id="current-date" class="fw-semibold text-muted"
    >Thứ Ba, 24 tháng 6, 2025</span
  >
  <span id="current-time" class="fw-semibold">16:46:00</span>
</div>

<script>
  // Update date and time
  function updateDateTime() {
    const now = new Date();

    // Format date
    const days = [
      "Chủ Nhật",
      "Thứ Hai",
      "Thứ Ba",
      "Thứ Tư",
      "Thứ Năm",
      "Thứ Sáu",
      "Thứ Bảy",
    ];
    const months = [
      "tháng 1",
      "tháng 2",
      "tháng 3",
      "tháng 4",
      "tháng 5",
      "tháng 6",
      "tháng 7",
      "tháng 8",
      "tháng 9",
      "tháng 10",
      "tháng 11",
      "tháng 12",
    ];

    const dayName = days[now.getDay()];
    const day = now.getDate();
    const month = months[now.getMonth()];
    const year = now.getFullYear();

    const dateString = `${dayName}, ${day} ${month}, ${year}`;

    // Format time
    const hours = String(now.getHours()).padStart(2, "0");
    const minutes = String(now.getMinutes()).padStart(2, "0");
    const seconds = String(now.getSeconds()).padStart(2, "0");

    const timeString = `${hours}:${minutes}:${seconds}`;

    // Update elements
    const dateElement = document.getElementById("current-date");
    const timeElement = document.getElementById("current-time");

    if (dateElement) dateElement.textContent = dateString;
    if (timeElement) timeElement.textContent = timeString;
  }

  // Initialize immediately
  updateDateTime();
  // Update time every second
  setInterval(updateDateTime, 1000);
</script>
