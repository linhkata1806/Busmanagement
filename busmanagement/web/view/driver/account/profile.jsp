<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ Sơ Cá Nhân - Tài Xế</title>
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
            .profile-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                background: white;
            }
            .avatar-container {
                position: relative;
                display: inline-block;
            }
            .avatar-img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #fff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }
            .avatar-placeholder {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 48px;
                background-color: #3b82f6;
                color: #fff;
                border: 4px solid #fff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
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
                        <h1 class="h2 text-dark fw-bold">Thông Tin Cá Nhân</h1>
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

                    <div class="row g-4">
                        <!-- Left Panel: Avatar & Static Info -->
                        <div class="col-12 col-md-4">
                            <div class="card profile-card p-4 text-center">
                                <div class="mb-3">
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
                                <h4 class="fw-bold text-dark mt-2 mb-1">${account.fullName}</h4>
                                <span class="badge bg-secondary px-2.5 py-1.5 rounded mb-3">${account.roleName}</span>

                                <hr class="my-4">

                                <div class="d-flex flex-column gap-3 text-start mb-4">
                                    <div class="row">
                                        <div class="col-5 text-secondary fw-semibold">Tên tài khoản:</div>
                                        <div class="col-7 text-dark fw-bold">${account.username}</div>
                                    </div>
                                    <div class="row">
                                        <div class="col-5 text-secondary fw-semibold">Trạng thái:</div>
                                        <div class="col-7">
                                            <c:choose>
                                                <c:when test="${account.active}">
                                                    <span class="badge bg-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Bị khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/driver/change-password" class="btn btn-outline-primary">
                                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Right Panel: Edit Profile Form -->
                        <div class="col-12 col-md-8">
                            <div class="card profile-card p-4">
                                <h5 class="fw-bold text-dark mb-4">Cập Nhật Thông Tin</h5>
                                <form action="${pageContext.request.contextPath}/driver/profile" method="POST" enctype="multipart/form-data">
                                    <div class="row g-3">
                                        <!-- Full Name -->
                                        <div class="col-12">
                                            <label for="fullName" class="form-label fw-semibold text-secondary">Họ và tên</label>
                                            <input type="text" class="form-control py-2.5" id="fullName" name="fullName" value="${account.fullName}" required>
                                        </div>

                                        <!-- Email -->
                                        <div class="col-12 col-sm-6">
                                            <label for="email" class="form-label fw-semibold text-secondary">Email liên hệ</label>
                                            <input type="email" class="form-control py-2.5" id="email" name="email" value="${account.email}" required>
                                        </div>

                                        <!-- Phone -->
                                        <div class="col-12 col-sm-6">
                                            <label for="phone" class="form-label fw-semibold text-secondary">Số điện thoại</label>
                                            <input type="text" class="form-control py-2.5" id="phone" name="phone" value="${account.phone}">
                                        </div>

                                        <!-- Avatar Upload -->
                                        <div class="col-12">
                                            <label for="avatar" class="form-label fw-semibold text-secondary">Thay đổi ảnh đại diện</label>
                                            <input type="file" class="form-control py-2" id="avatar" name="avatar" accept="image/*">
                                            <div class="form-text">Hỗ trợ các định dạng: JPG, PNG, GIF. Kích thước tối đa 2MB.</div>
                                        </div>

                                        <div class="col-12 mt-4 text-end">
                                            <button type="submit" class="btn btn-primary px-4 py-2.5">
                                                <i class="fas fa-save me-2"></i>Lưu thay đổi
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
