<%-- 
    Document   : account-management
    Created on : 06-07-2026, 19:32:21
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Tài khoản - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Tiêu đề bảng đồng nhất chiều cao, căn giữa */
        .table-dark th {
            padding-top: 15px !important;
            padding-bottom: 15px !important;
            vertical-align: middle !important;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
        }
        /* Dòng dữ liệu so le đậm nhạt, chiều cao bằng nhau */
        .table tbody td {
            padding-top: 12px !important;
            padding-bottom: 12px !important;
            vertical-align: middle !important;
        }
        .table-responsive {
            border-radius: 0.75rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activeMenu" value="accounts" />
        </jsp:include>
        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            
            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMsg" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMsg" scope="session" />
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold mb-0">Quản lý Tài khoản</h2>
                <a href="${pageContext.request.contextPath}/admin/account/create" class="btn btn-success shadow-sm">
                    <i class="fas fa-plus me-2"></i>Thêm tài khoản mới
                </a>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/accounts" method="GET" class="row g-3 mb-4 bg-white p-4 rounded-4 shadow-sm border-0">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-primary text-white"><i class="fas fa-search"></i></span>
                        <input type="text" name="search" class="form-control" placeholder="Tìm theo Username, Tên, Email..." value="${searchKeyword}">
                    </div>
                </div>
                <div class="col-md-4">
                    <select name="role" class="form-select">
                        <option value="ALL">Tất cả quyền (Roles)</option>
                        <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        <option value="STAFF" ${selectedRole == 'STAFF' ? 'selected' : ''}>STAFF</option>
                        <option value="DRIVER" ${selectedRole == 'DRIVER' ? 'selected' : ''}>DRIVER</option>
                        <option value="ASSISTANT" ${selectedRole == 'ASSISTANT' ? 'selected' : ''}>ASSISTANT</option>
                        <option value="CUSTOMER" ${selectedRole == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                </div>
            </form>

            <div class="card border-0 shadow-sm rounded-4 bg-white">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Quyền</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${accountList}" var="a">
                                    <tr>
                                        <td>${a.accountID}</td>
                                        <td class="fw-bold">${a.username}</td>
                                        <td>${a.fullName}</td>
                                        <td>${a.email}</td>
                                        <td><span class="badge bg-info text-dark">${a.roleName}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.active}">
                                                    <span class="badge bg-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/account/update?id=${a.accountID}" class="btn btn-sm btn-outline-primary" title="Sửa thông tin">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/accounts" method="POST" class="d-inline">
                                                <input type="hidden" name="id" value="${a.accountID}">
                                                <c:choose>
                                                    <c:when test="${a.active}">
                                                        <button name="action" value="lock" class="btn btn-sm btn-outline-danger" title="Khóa tài khoản" onclick="return confirm('Bạn có chắc chắn muốn KHÓA tài khoản ${a.username}?')">
                                                            <i class="fas fa-lock"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button name="action" value="unlock" class="btn btn-sm btn-outline-success" title="Mở khóa tài khoản">
                                                            <i class="fas fa-unlock"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
        
                                            <form action="${pageContext.request.contextPath}/admin/account/reset-password" method="POST" class="d-inline" onsubmit="return confirm('Reset mật khẩu của ${a.username} về mặc định (Bus@Year)?')">
                                                <input type="hidden" name="id" value="${a.accountID}">
                                                <button type="submit" class="btn btn-sm btn-outline-warning" title="Reset mật khẩu">
                                                    <i class="fas fa-key"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <c:if test="${empty accountList}">
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-search fa-3x mb-3 text-black-50"></i>
                                <p class="mb-0">Không tìm thấy tài khoản nào khớp với điều kiện lọc.</p>
                            </div>
                        </c:if>
                        
                        <%-- Component Phân trang --%>
                        <jsp:include page="/common/pagination.jsp" />
                    </div>
                </div>
            </div>
            
        </main>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>