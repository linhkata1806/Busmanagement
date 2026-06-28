<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hanoi Bus - Đăng Nhập</title>
        <!-- Bootstrap 5 CDN -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <!-- FontAwesome 6 CDN -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts (Inter) -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        
        <style>
            :root {
                --primary: #1a73e8;
                --primary-hover: #1557b0;
                --accent: #fbbc04;
                --bg-gradient: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            }
            
            body {
                font-family: 'Inter', sans-serif;
                background: var(--bg-gradient);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                color: #333;
            }
            
            .login-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.25);
                overflow: hidden;
                width: 100%;
                max-width: 450px;
                transition: transform 0.3s ease;
            }
            
            .login-card:hover {
                transform: translateY(-5px);
            }
            
            .card-header-custom {
                background: #fff;
                padding: 40px 40px 20px 40px;
                border-bottom: none;
                text-align: center;
            }
            
            .logo-icon {
                font-size: 3rem;
                color: var(--primary);
                margin-bottom: 15px;
                animation: float 3s ease-in-out infinite;
            }
            
            @keyframes float {
                0% { transform: translateY(0px); }
                50% { transform: translateY(-10px); }
                100% { transform: translateY(0px); }
            }
            
            .card-body-custom {
                padding: 0 40px 40px 40px;
            }
            
            .form-label {
                font-weight: 600;
                font-size: 0.85rem;
                color: #555;
                margin-bottom: 8px;
            }
            
            .input-group-text-custom {
                background-color: #f8f9fa;
                border-right: none;
                color: #6c757d;
            }
            
            .form-control-custom {
                border-left: none;
                padding: 11px 12px;
                font-size: 0.95rem;
            }
            
            .form-control-custom:focus {
                border-color: #dee2e6;
                box-shadow: none;
                background-color: #fff;
            }
            
            .input-group:focus-within .input-group-text-custom {
                border-color: var(--primary);
                color: var(--primary);
            }
            
            .input-group:focus-within .form-control-custom {
                border-color: var(--primary);
            }
            
            .btn-submit {
                background-color: var(--primary);
                border: none;
                color: white;
                font-weight: 600;
                padding: 12px;
                border-radius: 10px;
                font-size: 0.95rem;
                width: 100%;
                transition: all 0.2s;
                margin-top: 15px;
            }
            
            .btn-submit:hover {
                background-color: var(--primary-hover);
                box-shadow: 0 5px 15px rgba(26, 115, 232, 0.4);
            }
            
            .link-register {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.9rem;
                transition: color 0.2s;
            }
            
            .link-register:hover {
                color: var(--primary-hover);
                text-decoration: underline;
            }
            
            .password-toggle {
                cursor: pointer;
                border-left: none;
                background-color: #fff;
                color: #6c757d;
                border-color: #dee2e6;
            }
            
            .password-toggle:hover {
                color: var(--primary);
            }
            
            .spinner-border-custom {
                width: 1.2rem;
                height: 1.2rem;
                margin-right: 8px;
                display: none;
            }
        </style>
    </head>
    <body>

        <div class="login-card">
            <div class="card-header-custom">
                <div class="logo-icon">
                    <i class="fas fa-bus-alt"></i>
                </div>
                <h3 class="fw-bold text-dark mb-1">HANOI BUS</h3>
                <p class="text-muted small">Hệ thống quản lý xe buýt thông minh thủ đô</p>
            </div>
            
            <div class="card-body-custom">
                <!-- Alert container for error/success messages -->
                <div id="alert-container">
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>${requestScope.error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <div>${sessionScope.success}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="success" scope="session" />
                    </c:if>
                </div>

                <form id="loginForm" action="login" method="POST" class="needs-validation" novalidate>
                    <!-- Username Input -->
                    <div class="mb-3">
                        <label class="form-label">TÊN ĐĂNG NHẬP</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-user"></i></span>
                            <input type="text" name="username" class="form-control form-control-custom"
                                   minlength="4" maxlength="50" autocomplete="username"
                                   value="${requestScope.username}" required placeholder="Nhập username...">
                        </div>
                    </div>

                    <!-- Password Input -->
                    <div class="mb-4">
                        <label class="form-label">MẬT KHẨU</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-lock"></i></span>
                            <input type="password" id="password" name="password" class="form-control form-control-custom border-end-0" 
                                   minlength="6" autocomplete="current-password"
                                   required placeholder="Nhập mật khẩu...">
                            <span class="input-group-text password-toggle" id="togglePassword"><i class="fas fa-eye"></i></span>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn" class="btn-submit d-flex align-items-center justify-content-center">
                        <div class="spinner-border spinner-border-custom" role="status" id="loadingSpinner"></div>
                        <span>ĐĂNG NHẬP</span>
                    </button>
                </form>

                <div class="text-center mt-4">
                    <a href="register" class="link-register">Chưa có tài khoản? Đăng ký ngay</a>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Password Show/Hide Toggle
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#password');

            togglePassword.addEventListener('click', function () {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                
                const icon = this.querySelector('i');
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
            });

            // AJAX Form Submission
            const loginForm = document.getElementById('loginForm');
            const submitBtn = document.getElementById('submitBtn');
            const loadingSpinner = document.getElementById('loadingSpinner');
            const alertContainer = document.getElementById('alert-container');

            loginForm.addEventListener('submit', function (e) {
                e.preventDefault();

                // Validate form inputs
                if (!loginForm.checkValidity()) {
                    loginForm.classList.add('was-validated');
                    return;
                }

                // Show loading spinner, disable button
                loadingSpinner.style.display = 'inline-block';
                submitBtn.disabled = true;
                alertContainer.innerHTML = ''; // Clear old alerts

                const formData = new FormData(loginForm);
                const params = new URLSearchParams(formData);

                // Send request via AJAX (fetch API)
                fetch('login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                })
                .then(response => {
                    // Check if server redirected (indicates successful login)
                    if (response.redirected) {
                        window.location.href = response.url;
                        return null;
                    }
                    return response.text();
                })
                .then(html => {
                    if (html) {
                        // Reset spinner and button
                        loadingSpinner.style.display = 'none';
                        submitBtn.disabled = false;

                        // Parse the response html to retrieve error message
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');
                        
                        // Look for error message element or default error message
                        const errorMsgElement = doc.querySelector('.alert-danger div') || doc.querySelector('#alert-container .alert-danger div');
                        const errorMsg = errorMsgElement ? errorMsgElement.textContent.trim() : 'Tên đăng nhập hoặc mật khẩu không chính xác!';

                        // Display alert dynamically
                        alertContainer.innerHTML = `
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div>${errorMsg}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        `;
                    }
                })
                .catch(error => {
                    console.error('AJAX Error:', error);
                    loadingSpinner.style.display = 'none';
                    submitBtn.disabled = false;
                    alertContainer.innerHTML = `
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <div>Có lỗi kết nối xảy ra. Vui lòng thử lại!</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    `;
                });
            });
        </script>
    </body>
</html>
