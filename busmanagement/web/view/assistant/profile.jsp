<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - Phụ Xe</title>
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

                <!-- Profile Info Card -->
                <div class="row justify-content-center">
                    <div class="col-12 col-md-8 col-lg-6">
                        <div class="card profile-card p-4">
                            <div class="text-center mb-4">
                                <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 32px;">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <h4 class="fw-bold text-dark mt-3 mb-1">${account.fullName}</h4>
                                <span class="badge bg-secondary px-2.5 py-1.5 rounded">${account.roleName}</span>
                            </div>
                            
                            <hr class="my-4">

                            <div class="d-flex flex-column gap-3 mb-4">
                                <div class="row">
                                    <div class="col-4 text-secondary fw-semibold">Tên tài khoản:</div>
                                    <div class="col-8 text-dark fw-bold">${account.username}</div>
                                </div>
                                <div class="row">
                                    <div class="col-4 text-secondary fw-semibold">Email liên hệ:</div>
                                    <div class="col-8 text-dark">${account.email}</div>
                                </div>
                                <div class="row">
                                    <div class="col-4 text-secondary fw-semibold">Số điện thoại:</div>
                                    <div class="col-8 text-dark">${account.phone}</div>
                                </div>
                                <div class="row">
                                    <div class="col-4 text-secondary fw-semibold">Trạng thái:</div>
                                    <div class="col-8">
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
                            
                            <div class="d-grid mt-2">
                                <a href="${pageContext.request.contextPath}/assistant/change-password" class="btn btn-outline-primary py-2">
                                    <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
