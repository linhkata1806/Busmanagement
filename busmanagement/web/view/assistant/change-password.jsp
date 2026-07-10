<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Phụ xe</title>
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
        .form-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            background: white;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp">
                <jsp:param name="activeMenu" value="profile" />
            </jsp:include>
            
            <!-- Main Content Area -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 text-dark fw-bold">Đổi mật khẩu</h1>
                    <a href="${pageContext.request.contextPath}/assistant/profile" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại hồ sơ
                    </a>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                        <div>${errorMsg}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Change Password Form -->
                <div class="row">
                    <div class="col-12 col-md-8 col-lg-6">
                        <div class="card form-card p-4">
                            <form action="change-password" method="POST">
                                <div class="mb-3">
                                    <label for="oldPassword" class="form-label text-secondary fw-semibold">Mật khẩu hiện tại</label>
                                    <input type="password" class="form-control" id="oldPassword" name="oldPassword" required minlength="6">
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label text-secondary fw-semibold">Mật khẩu mới</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                                    <div class="form-text mt-1 text-secondary">
                                        Độ dài mật khẩu tối thiểu là 6 ký tự.
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label text-secondary fw-semibold">Nhập lại mật khẩu mới</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="6">
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2.5 shadow-sm fw-bold">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
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
