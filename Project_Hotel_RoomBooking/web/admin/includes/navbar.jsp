<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm">
    <div class="container-fluid">
        <div class="d-flex align-items-center gap-3">
            <span id="current-date" class="fw-semibold text-muted"></span>
            <span id="current-time" class="fw-semibold"></span>
        </div>
    </div>
</nav>

<script>
    // --- Clock --- 
    function updateClock() {
        const now = new Date();
        const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        const dateElem = document.getElementById('current-date');
        const timeElem = document.getElementById('current-time');
        if(dateElem) dateElem.textContent = now.toLocaleDateString('vi-VN', dateOptions);
        if(timeElem) timeElem.textContent = now.toLocaleTimeString('vi-VN');
    }
    setInterval(updateClock, 1000);
    updateClock();

</script>
