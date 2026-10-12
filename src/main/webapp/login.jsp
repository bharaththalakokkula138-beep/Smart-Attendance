<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Attendance & Shortage Prediction System</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #312e81 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .login-card-container {
            width: 100%;
            max-width: 480px;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px 36px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .login-brand-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #4f46e5, #06b6d4);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 26px;
            margin: 0 auto 16px;
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.4);
        }
        .role-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-bottom: 24px;
            background: #f1f5f9;
            padding: 6px;
            border-radius: 12px;
        }
        .role-btn {
            padding: 10px 6px;
            border: none;
            background: transparent;
            font-size: 13px;
            font-weight: 600;
            color: #64748b;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }
        .role-btn.active {
            background: white;
            color: #4f46e5;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .quick-credentials-box {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            padding: 16px;
            margin-top: 24px;
        }
        .quick-pill {
            display: inline-block;
            font-size: 11px;
            padding: 4px 10px;
            background: #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            margin: 3px;
            transition: all 0.2s;
        }
        .quick-pill:hover {
            background: #4f46e5;
            color: white;
        }
    </style>
</head>
<body>

<div class="login-card-container">
    <div class="login-card">
        <div class="text-center">
            <div class="login-brand-icon">
                <i class="fa-solid fa-graduation-cap"></i>
            </div>
            <h2 class="fw-bold mb-1" style="color: #0f172a; font-size: 22px;">Smart Attendance</h2>
            <p class="text-muted small mb-4">Shortage Prediction &amp; Analytics System</p>
        </div>

        <% if (request.getParameter("msg") != null) { %>
            <div class="alert alert-success d-flex align-items-center py-2 px-3 small rounded-3 mb-3">
                <i class="fa-solid fa-circle-check me-2"></i>
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <% if (request.getAttribute("errorMessage") != null || request.getParameter("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center py-2 px-3 small rounded-3 mb-3">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : request.getParameter("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
            <!-- Role Selector -->
            <div class="role-selector">
                <button type="button" class="role-btn active" onclick="setRole('STUDENT', this)">
                    <i class="fa-solid fa-user-graduate d-block mb-1"></i> Student
                </button>
                <button type="button" class="role-btn" onclick="setRole('FACULTY', this)">
                    <i class="fa-solid fa-chalkboard-user d-block mb-1"></i> Faculty
                </button>
                <button type="button" class="role-btn" onclick="setRole('ADMIN', this)">
                    <i class="fa-solid fa-shield-halved d-block mb-1"></i> Admin
                </button>
            </div>
            <input type="hidden" name="role" id="selectedRole" value="STUDENT">

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary" id="identifierLabel">Roll Number or Email</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted">
                        <i class="fa-regular fa-envelope" id="identifierIcon"></i>
                    </span>
                    <input type="text" name="identifier" id="identifierInput" class="form-control border-start-0 ps-0" placeholder="e.g. 21A01 or bharath@college.edu" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted">
                        <i class="fa-solid fa-lock"></i>
                    </span>
                    <input type="password" name="password" id="passwordInput" class="form-control border-start-0 ps-0" placeholder="Enter your password" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-modern w-100 justify-content-center py-2 fw-semibold">
                <i class="fa-solid fa-right-to-bracket me-2"></i> Sign In to Dashboard
            </button>
        </form>

        <!-- Quick 1-Click Demo Logins -->
        <div class="quick-credentials-box">
            <div class="d-flex align-items-center justify-content-between mb-2">
                <span class="small fw-bold text-secondary"><i class="fa-solid fa-bolt text-warning me-1"></i> Quick Demo Access:</span>
            </div>
            <div class="d-flex flex-wrap gap-1">
                <span class="quick-pill" onclick="quickFill('STUDENT', '21A01', 'student123')">
                    <strong>Student:</strong> Bharath (21A01)
                </span>
                <span class="quick-pill" onclick="quickFill('FACULTY', 'ramesh@college.edu', 'faculty123')">
                    <strong>Faculty:</strong> Dr. Ramesh
                </span>
                <span class="quick-pill" onclick="quickFill('ADMIN', 'admin', 'admin123')">
                    <strong>Admin:</strong> Administrator
                </span>
            </div>
        </div>
    </div>
</div>

<script>
function setRole(role, btn) {
    document.getElementById('selectedRole').value = role;
    document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const label = document.getElementById('identifierLabel');
    const input = document.getElementById('identifierInput');
    if (role === 'STUDENT') {
        label.innerText = 'Roll Number or College Email';
        input.placeholder = 'e.g. 21A01 or bharath@college.edu';
    } else if (role === 'FACULTY') {
        label.innerText = 'Faculty Email or Code';
        input.placeholder = 'e.g. ramesh@college.edu or FAC001';
    } else {
        label.innerText = 'Admin Username or Email';
        input.placeholder = 'e.g. admin or admin@college.edu';
    }
}

function quickFill(role, identifier, password) {
    const btns = document.querySelectorAll('.role-btn');
    if (role === 'STUDENT') setRole(role, btns[0]);
    else if (role === 'FACULTY') setRole(role, btns[1]);
    else if (role === 'ADMIN') setRole(role, btns[2]);

    document.getElementById('identifierInput').value = identifier;
    document.getElementById('passwordInput').value = password;
}
</script>

</body>
</html>
