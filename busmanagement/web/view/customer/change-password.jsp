<%-- 
    Document   : change-password
    Created on : Jun 27, 2026, 5:44:39 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d47a1;
            --primary-light: #1565c0;
            --accent: #fbbc04;
            --bg-light: #f4f6f9;
        }
        body { 
            background-color: var(--bg-light); 
        }

        /* ===== NAVBAR ===== */
        .navbar { 
            background: var(--primary) !important; 
            border-bottom: 1px solid rgba(255,255,255,0.1); 
        }
        .navbar-brand { 
            font-weight: 700; font-size: 1.3rem; color: white !important; 
        }
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }

        /* ===== HERO BANNER ===== */
        .hero { 
            background: var(--primary); padding: 40px 0 100px; color: white; text-align: center; 
        }

        /* ===== FORM CONTAINER ===== */
        .form-layout { 
            margin-top: -60px; position: relative; z-index: 10; 
        }
        .custom-card {
            background: white; border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06); border: none; padding: 30px;
        }
        .form-label { 
            font-weight: 600; color: #5f6368; font-size: 0.9rem; 
        }
        .form-control { 
            padding: 12px 15px; border-radius: 8px; border: 1px solid #ced4da; 
        }
        .form-control:focus { 
            border-color: var(--primary-light); box-shadow: 0 0 0 0.25rem rgba(21, 101, 192, 0.25); 
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                🚌 Bus <span>Hà Nội</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
            </button>
            <div class="collapse navbar-collapse" id="navMenu">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i> Chào, <strong>${sessionScope.USER.fullName}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile"><i class="fas fa-user me-2 text-primary"></i>Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2 text-danger"></i>Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero">
        <div class="container">
            <h2 class="fw-bold mb-1">Đổi mật khẩu</h2>
            <p class="text-white-50">Bảo vệ tài khoản của bạn bằng mật khẩu an toàn</p>
        </div>
    </div>

    <div class="container form-layout mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card custom-card shadow-sm">
                    
                    <h5 class="fw-bold mb-4 text-dark border-bottom pb-3">
                        <i class="fas fa-lock me-2 text-primary"></i>Thiết lập mật khẩu mới
                    </h5>

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i> ${errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/customer/changePassword" method="POST">
                        
                        <div class="mb-3">
                            <label for="oldPassword" class="form-label">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="Nhập mật khẩu cũ..." required>
                        </div>

                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Ít nhất 6 ký tự..." minlength="6" required>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới..." minlength="6" required>
                        </div>

                        <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light border px-4 fw-semibold">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary px-4 fw-semibold" style="background-color: var(--primary-light); border-color: var(--primary-light);">
                                <i class="fas fa-key me-2"></i>Cập nhật mật khẩu
                            </button>
                        </div>
                        
                    </form>

                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
