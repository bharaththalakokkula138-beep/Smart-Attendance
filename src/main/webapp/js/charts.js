// Smart Attendance & Shortage Prediction System - Chart.js Visualizations

function renderStudentAttendanceTrendChart(canvasId, trendLabels, trendValues, requiredThreshold) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    const thresholdData = new Array(trendLabels.length).fill(requiredThreshold || 75.0);

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: trendLabels,
            datasets: [
                {
                    label: 'Actual Attendance %',
                    data: trendValues,
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.35,
                    pointBackgroundColor: '#4f46e5',
                    pointRadius: 5,
                    pointHoverRadius: 7
                },
                {
                    label: 'Required Threshold (' + requiredThreshold + '%)',
                    data: thresholdData,
                    borderColor: '#ef4444',
                    borderWidth: 2,
                    borderDash: [6, 6],
                    fill: false,
                    pointRadius: 0
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    min: 40,
                    max: 100,
                    ticks: {
                        callback: function(val) { return val + '%'; }
                    },
                    grid: { color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(item) {
                            return item.dataset.label + ': ' + item.parsed.y + '%';
                        }
                    }
                },
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        boxWidth: 8
                    }
                }
            }
        }
    });
}

function renderDistributionDoughnut(canvasId, safe, warning, critical) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Safe (>= 75%)', 'Warning (70-75%)', 'Critical (< 70%)'],
            datasets: [{
                data: [safe, warning, critical],
                backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                borderWidth: 2,
                borderColor: '#ffffff',
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        boxWidth: 12,
                        usePointStyle: true
                    }
                }
            }
        }
    });
}

function renderSubjectBarChart(canvasId, subjects, percentages, requiredPct) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    const backgroundColors = percentages.map(function(val) {
        if (val >= requiredPct) return '#10b981';
        if (val >= (requiredPct - 5)) return '#f59e0b';
        return '#ef4444';
    });

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: subjects,
            datasets: [{
                label: 'Attendance %',
                data: percentages,
                backgroundColor: backgroundColors,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    min: 0,
                    max: 100,
                    ticks: {
                        callback: function(val) { return val + '%'; }
                    }
                }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(item) {
                            return 'Attendance: ' + item.parsed.y + '%';
                        }
                    }
                }
            }
        }
    });
}

function renderDepartmentBarChart(canvasId, departments, averages) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: departments,
            datasets: [{
                label: 'Department Average %',
                data: averages,
                backgroundColor: '#6366f1',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    min: 50,
                    max: 100,
                    ticks: { callback: function(val) { return val + '%'; } }
                }
            },
            plugins: {
                legend: { display: false }
            }
        }
    });
}
