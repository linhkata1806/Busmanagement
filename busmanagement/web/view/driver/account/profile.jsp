<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - Tài xế</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bg-light: #f8fafc;
        }
        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-content {
            padding: 2rem;
        }
        .profile-header {
            background: linear-gradient(135deg, #0d47a1 0%, #1e3a8a 100%);
            color: white;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
            padding: 2.5rem 1rem;
            text-align: center;
        }
        .profile-avatar {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }
        .avatar-img {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }
        .avatar-placeholder {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.95rem;
        }
        .info-value {
            font-weight: 500;
            color: #212529;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../sidebar.jsp">
                <jsp:param name="activeMenu" value="profile" />
            </jsp:include>
            
            <!-- Main Content Area -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 text-dark fw-bold">Thông tin cá nhân</h1>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2 fs-5"></i>
                        <div>${successMsg}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% session.removeAttribute("successMsg"); %>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                        <div>${errorMsg}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Profile Card -->
                <div class="card shadow-sm border-0 rounded-4 bg-white mb-4">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <c:choose>
                                <c:when test="${not empty account.avatar}">
                                    <img src="${pageContext.request.contextPath}/${account.avatar}" class="avatar-img" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder">
                                        <i class="fas fa-user-tie"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="fw-bold mb-1">${account.fullName}</h3>
                        <p class="mb-0 text-light opacity-75">@${account.username}</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/driver/profile" method="POST" enctype="multipart/form-data">
                            <div class="row g-4">
                                <!-- Left Column -->
                                <div class="col-md-6 border-end pe-md-4">
                                    <div class="py-3 border-bottom d-flex justify-content-between align-items-center">
                                        <span class="info-label"><i class="fas fa-user-circle text-primary me-2"></i>Tên tài khoản</span>
                                        <span class="info-value text-dark fw-bold">@${account.username}</span>
                                    </div>
                                    <div class="py-3 border-bottom">
                                        <label for="fullName" class="info-label mb-2"><i class="fas fa-user text-success me-2"></i>Họ và tên</label>
                                        <input type="text" class="form-control py-2.5" id="fullName" name="fullName" value="${account.fullName}" required>
                                    </div>
                                    <div class="py-3">
                                        <label for="email" class="info-label mb-2"><i class="fas fa-envelope text-info me-2"></i>Email liên hệ</label>
                                        <input type="email" class="form-control py-2.5" id="email" name="email" value="${account.email}" required>
                                    </div>
                                </div>

                                <!-- Right Column -->
                                <div class="col-md-6 ps-md-4">
                                    <div class="py-3 border-bottom d-flex justify-content-between align-items-center">
                                        <span class="info-label"><i class="fas fa-user-tag text-warning me-2"></i>Vai trò hệ thống</span>
                                        <span class="badge bg-danger px-3 py-2 fs-6 shadow-sm"><i class="fas fa-id-badge me-1"></i>${account.roleName}</span>
                                    </div>
                                    <div class="py-3 border-bottom d-flex justify-content-between align-items-center">
                                        <span class="info-label"><i class="fas fa-toggle-on text-success me-2"></i>Trạng thái</span>
                                        <c:choose>
                                            <c:when test="${account.active}">
                                                <span class="badge bg-success px-3 py-2 fs-6 shadow-sm">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger px-3 py-2 fs-6 shadow-sm">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="py-3 border-bottom">
                                        <label for="phone" class="info-label mb-2"><i class="fas fa-phone-alt text-primary me-2"></i>Số điện thoại</label>
                                        <input type="text" class="form-control py-2.5" id="phone" name="phone" value="${account.phone}">
                                    </div>
                                    <div class="py-3">
                                        <label for="avatar" class="info-label mb-2"><i class="fas fa-image text-secondary me-2"></i>Thay đổi ảnh đại diện</label>
                                        <input type="file" class="form-control py-2" id="avatar" name="avatar" accept="image/*">
                                    </div>
                                </div>
                            </div>

                            <!-- Footer Actions -->
                            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/driver/change-password" class="btn btn-outline-primary px-4 py-2.5">
                                    <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                </a>
                                <button type="submit" class="btn btn-primary px-5 py-2.5 fw-bold shadow-sm">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
