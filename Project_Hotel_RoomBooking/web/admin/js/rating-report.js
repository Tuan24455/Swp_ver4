// Sidebar toggle functionality
document.addEventListener('DOMContentLoaded', function() {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
        });
    }
});

// Additional functionality for rating report
function initializeRatingReport() {
    // Add any specific rating report functionality here
    console.log('Rating Report initialized');
}

// Auto-submit form when filter changes
function setupFilterAutoSubmit() {
    const filterType = document.getElementById('filterType');
    const quality = document.getElementById('quality');
    
    if (filterType) {
        filterType.addEventListener('change', function() {
            // Optional: Auto-submit form on filter change
            // this.form.submit();
        });
    }
    
    if (quality) {
        quality.addEventListener('change', function() {
            // Optional: Auto-submit form on quality change
            // this.form.submit();
        });
    }
}

// Initialize all functions when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeRatingReport();
    setupFilterAutoSubmit();
});