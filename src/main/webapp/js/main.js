// Smart Attendance & Shortage Prediction System - Interactive JS

document.addEventListener('DOMContentLoaded', function() {
    // Mobile sidebar toggle
    const mobileToggle = document.getElementById('mobileSidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    if (mobileToggle && sidebar) {
        mobileToggle.addEventListener('click', function() {
            sidebar.classList.toggle('open');
        });
    }

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-banner');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(function() {
                alert.remove();
            }, 500);
        }, 5000);
    });

    // Shortage live calculator
    const shortConducted = document.getElementById('liveConducted');
    const shortAttended = document.getElementById('liveAttended');
    const shortRequired = document.getElementById('liveRequired');
    if (shortConducted && shortAttended && shortRequired) {
        function updateShortageLive() {
            const C = parseInt(shortConducted.value) || 0;
            const A = parseInt(shortAttended.value) || 0;
            const R = parseFloat(shortRequired.value) || 75.0;

            if (C > 0 && A <= C) {
                const currentPct = ((A / C) * 100).toFixed(1);
                document.getElementById('liveCurrentPctDisplay').innerText = currentPct + '%';

                if (currentPct >= R) {
                    const canMiss = Math.floor((100 * A - R * C) / R);
                    document.getElementById('liveResultContainer').className = 'calc-result-box safe';
                    document.getElementById('liveResultStatus').innerHTML = '<span class="badge-status badge-safe">SAFE</span>';
                    document.getElementById('liveResultMessage').innerText = 'Your attendance is above ' + R + '%. You can miss up to ' + Math.max(0, canMiss) + ' class(es) while remaining above the threshold.';
                } else {
                    const needed = Math.ceil((R * C - 100 * A) / (100 - R));
                    const isCritical = currentPct < (R - 5);
                    const boxClass = isCritical ? 'calc-result-box critical' : 'calc-result-box warning';
                    const badgeClass = isCritical ? 'badge-status badge-critical' : 'badge-status badge-warning';
                    const statusText = isCritical ? 'CRITICAL SHORTAGE' : 'WARNING';

                    document.getElementById('liveResultContainer').className = boxClass;
                    document.getElementById('liveResultStatus').innerHTML = '<span class="' + badgeClass + '">' + statusText + '</span>';
                    document.getElementById('liveResultMessage').innerText = 'You must attend the next ' + Math.max(0, needed) + ' consecutive classes continuously to reach ' + R + '%.';
                }
            }
        }

        shortConducted.addEventListener('input', updateShortageLive);
        shortAttended.addEventListener('input', updateShortageLive);
        shortRequired.addEventListener('input', updateShortageLive);
    }
});

// Interactive Table Search & Filter helper
function setupTableFilter(searchInputId, filterSelectId, tableBodyId) {
    const searchInput = document.getElementById(searchInputId);
    const filterSelect = document.getElementById(filterSelectId);
    const tableBody = document.getElementById(tableBodyId);

    if (!tableBody) return;

    function applyFilter() {
        const query = (searchInput ? searchInput.value : '').toLowerCase().trim();
        const filterVal = (filterSelect ? filterSelect.value : 'ALL').toUpperCase();
        const rows = tableBody.querySelectorAll('tr');

        rows.forEach(function(row) {
            const text = row.innerText.toLowerCase();
            const statusBadge = row.querySelector('.badge-status');
            const rowStatus = statusBadge ? statusBadge.innerText.toUpperCase().trim() : '';

            const matchesSearch = query === '' || text.includes(query);
            let matchesFilter = true;

            if (filterVal !== 'ALL') {
                if (filterVal === 'BELOW_75') {
                    matchesFilter = rowStatus === 'WARNING' || rowStatus === 'CRITICAL';
                } else {
                    matchesFilter = rowStatus.includes(filterVal);
                }
            }

            row.style.display = (matchesSearch && matchesFilter) ? '' : 'none';
        });
    }

    if (searchInput) searchInput.addEventListener('keyup', applyFilter);
    if (filterSelect) filterSelect.addEventListener('change', applyFilter);
}
