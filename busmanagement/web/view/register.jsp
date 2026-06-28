<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hanoi Bus - Đăng Ký Tài Khoản</title>
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
            
            .register-card {
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
            
            .register-card:hover {
                transform: translateY(-5px);
            }
            
            .card-header-custom {
                background: #fff;
                padding: 40px 40px 0 40px;
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
                padding: 25px 40px 40px 40px;
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
            
            .link-login {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.9rem;
                transition: color 0.2s;
            }
            
            .link-login:hover {
                color: var(--primary-hover);
                text-decoration: underline;
            }

            .link-home {
                color: #6c757d;
                text-decoration: none;
                font-weight: 500;
                font-size: 0.9rem;
                transition: all 0.2s;
            }
            
            .link-home:hover {
                color: var(--primary);
                text-decoration: underline;
            }

            .card-header-tabs-custom {
                display: flex;
                border-bottom: 2px solid #e0e0e0;
                margin-top: 20px;
                padding: 0;
                list-style: none;
            }
            
            .nav-link-custom {
                display: block;
                padding: 10px;
                text-align: center;
                color: #6c757d;
                font-weight: 600;
                font-size: 0.95rem;
                text-decoration: none;
                border-bottom: 3px solid transparent;
                transition: all 0.2s;
            }
            
            .nav-link-custom:hover {
                color: var(--primary);
            }
            
            .nav-link-custom.active {
                color: var(--primary);
                border-bottom-color: var(--primary);
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

        <div class="register-card">
            <div class="card-header-custom">
                <div class="logo-icon">
                    <i class="fas fa-bus-alt"></i>
                </div>
                <h3 class="fw-bold text-dark mb-1">HANOI BUS</h3>
                <p class="text-muted small mb-0">Hệ thống quản lý xe buýt thông minh thủ đô</p>
                
                <!-- Nav tabs to switch between Login & Register -->
                <ul class="nav nav-tabs card-header-tabs-custom justify-content-center">
                    <li class="nav-item w-50">
                        <a class="nav-link-custom" href="login">ĐĂNG NHẬP</a>
                    </li>
                    <li class="nav-item w-50">
                        <a class="nav-link-custom active" href="register">ĐĂNG KÝ</a>
                    </li>
                </ul>
            </div>
            
            <div class="card-body-custom">
                <!-- Alert container for error messages -->
                <div id="alert-container">
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>${requestScope.error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                </div>

                <form id="registerForm" action="register" method="POST" class="needs-validation" novalidate>
                    <!-- Full Name -->
                    <div class="mb-3">
                        <label class="form-label">HỌ VÀ TÊN</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-id-card"></i></span>
                            <input type="text" name="fullName" class="form-control form-control-custom"
                                   value="${requestScope.fullName}" required placeholder="Vd: Nguyễn Văn A">
                        </div>
                    </div>

                    <!-- Username -->
                    <div class="mb-3">
                        <label class="form-label">TÊN ĐĂNG NHẬP</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-user"></i></span>
                            <input type="text" name="username" class="form-control form-control-custom"
                                   minlength="4" maxlength="50"
                                   value="${requestScope.username}" required placeholder="Nhập username...">
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="mb-3">
                        <label class="form-label">MẬT KHẨU</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-lock"></i></span>
                            <input type="password" id="password" name="password" class="form-control form-control-custom border-end-0" 
                                   minlength="6" autocomplete="new-password" required placeholder="Tối thiểu 6 ký tự...">
                            <span class="input-group-text password-toggle" id="togglePassword"><i class="fas fa-eye"></i></span>
                        </div>
                    </div>

                    <!-- Re-password -->
                    <div class="mb-3">
                        <label class="form-label">NHẬP LẠI MẬT KHẨU</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-key"></i></span>
                            <input type="password" id="repassword" name="repassword" class="form-control form-control-custom border-end-0" 
                                   minlength="6" required placeholder="Nhập lại mật khẩu trên...">
                            <span class="input-group-text password-toggle" id="toggleRePassword"><i class="fas fa-eye"></i></span>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="mb-3">
                        <label class="form-label">EMAIL</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control form-control-custom"
                                   value="${requestScope.email}" required placeholder="Vd: email@domain.com">
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="mb-4">
                        <label class="form-label">SỐ ĐIỆN THOẠI</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="fas fa-phone"></i></span>
                            <input type="text" name="phone" class="form-control form-control-custom"
                                   pattern="0[0-9]{9}" value="${requestScope.phone}" required placeholder="Vd: 0987654321">
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn" class="btn-submit d-flex align-items-center justify-content-center">
                        <div class="spinner-border spinner-border-custom" role="status" id="loadingSpinner"></div>
                        <span>ĐĂNG KÝ NGAY</span>
                    </button>
                </form>

                <div class="text-center mt-4">
                    <a href="home" class="link-home"><i class="fas fa-arrow-left me-1"></i> Trở về menu chính</a>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Password Show/Hide Toggles
            function setupPasswordToggle(toggleId, inputId) {
                const toggleElement = document.getElementById(toggleId);
                const inputElement = document.getElementById(inputId);

                toggleElement.addEventListener('click', function () {
                    const type = inputElement.getAttribute('type') === 'password' ? 'text' : 'password';
                    inputElement.setAttribute('type', type);
                    
                    const icon = this.querySelector('i');
                    icon.classList.toggle('fa-eye');
                    icon.classList.toggle('fa-eye-slash');
                });
            }

            setupPasswordToggle('togglePassword', 'password');
            setupPasswordToggle('toggleRePassword', 'repassword');

            // AJAX Form Submission
            const registerForm = document.getElementById('registerForm');
            const submitBtn = document.getElementById('submitBtn');
            const loadingSpinner = document.getElementById('loadingSpinner');
            const alertContainer = document.getElementById('alert-container');

            registerForm.addEventListener('submit', function (e) {
                e.preventDefault();

                const passwordVal = document.getElementById('password').value;
                const repasswordVal = document.getElementById('repassword').value;

                // Client-side passwords match validation
                if (passwordVal !== repasswordVal) {
                    alertContainer.innerHTML = `
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>Mật khẩu nhập lại không khớp!</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    `;
                    return;
                }

                // Validate form inputs
                if (!registerForm.checkValidity()) {
                    registerForm.classList.add('was-validated');
                    return;
                }

                // Show loading spinner, disable button
                loadingSpinner.style.display = 'inline-block';
                submitBtn.disabled = true;
                alertContainer.innerHTML = ''; // Clear old alerts

                const formData = new FormData(registerForm);
                const params = new URLSearchParams(formData);

                // Send request via AJAX
                fetch('register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                })
                .then(response => {
                    // Check if server redirected (indicates successful registration and redirect to login)
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
                        
                        // Look for error message element
                        const errorMsgElement = doc.querySelector('.alert-danger div') || doc.querySelector('#alert-container .alert-danger div') || doc.querySelector('.error-msg');
                        const errorMsg = errorMsgElement ? errorMsgElement.textContent.trim() : 'Đăng ký tài khoản không thành công. Vui lòng kiểm tra lại thông tin!';

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
