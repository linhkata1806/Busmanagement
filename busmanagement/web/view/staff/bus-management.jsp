<%-- 
    Document   : bus-management
    Created on : Jun 30, 2026, 9:08:16 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Xe buýt - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --bg-light: #f8f9fa; }
        body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }
        .main-content { padding: 2rem; }
        .hover-primary:hover { color: #1a73e8 !important; text-decoration: underline !important; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activeMenu" value="bus" />
        </jsp:include>

        <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <h2 class="fw-bold text-dark m-0">Danh mục Phương tiện Xe buýt</h2>
                <a href="${pageContext.request.contextPath}/staff/bus/create" class="btn btn-primary fw-semibold shadow-sm">
                    <i class="fas fa-plus-circle me-2"></i>Thêm xe mới
                </a>
            </div>

            <!-- HIỂN THỊ THÔNG BÁO THÀNH CÔNG (Màu xanh lá) -->
            <c:if test="${not empty sessionScope.msgSuccess}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.msgSuccess}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="msgSuccess" scope="session"/>
            </c:if>

            <!-- HIỂN THỊ THÔNG BÁO NGHIỆP VỤ SOFT DELETE (Màu xanh dương) -->
            <c:if test="${not empty sessionScope.msgInfo}">
                <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-info-circle me-2"></i>${sessionScope.msgInfo}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="msgInfo" scope="session"/>
            </c:if>

            <!-- HIỂN THỊ THÔNG BÁO LỖI (Màu đỏ) -->
            <c:if test="${not empty sessionScope.msgError}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.msgError}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="msgError" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.msgError}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.msgError}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="msgError" scope="session"/>
            </c:if>

            <div class="card border-0 shadow-sm p-4 mb-4 bg-white rounded-4">
                <form action="${pageContext.request.contextPath}/staff/bus" method="GET" class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-secondary">Từ khóa tìm kiếm (Biển số xe, Loại xe)</label>
                        <input type="text" name="keyword" class="form-control" placeholder="Nhập biển số hoặc loại xe..." value="${keyword}">
                    </div>
                    
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-secondary">Trạng thái hoạt động</label>
                        <select name="status" class="form-select">
                            <option value="ALL" ${status eq 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                            <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Đang hoạt động (ACTIVE)</option>
                            <option value="MAINTENANCE" ${status eq 'MAINTENANCE' ? 'selected' : ''}>Bảo trì (MAINTENANCE)</option>
                            <option value="RETIRED" ${status eq 'RETIRED' ? 'selected' : ''}>RETIRED (Thanh lý)</option>
                        </select>
                    </div>
                    
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-secondary w-100 fw-bold"><i class="fas fa-search me-2"></i>Lọc tìm</button>
                    </div>
                </form>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-uppercase small text-secondary">
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th>Biển số xe</th>
                                    <th>Loại phương tiện</th>
                                    <th>Sức chứa</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center pe-4">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty buses}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="fas fa-bus fa-3x mb-3 d-block text-black-50"></i>
                                                <h6 class="fw-bold">Không tìm thấy phương tiện</h6>
                                                <p class="small m-0">Không có xe buýt nào khớp với điều kiện tìm kiếm.</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="b" items="${buses}">
                                            <tr>
                                                <td class="ps-4 text-secondary fw-semibold">#${b.busID}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/staff/bus/update?id=${b.busID}" class="text-decoration-none">
                                                        <span class="badge bg-primary fs-6 px-3 py-2 shadow-sm" style="cursor: pointer;">${b.licensePlate}</span>
                                                    </a>
                                                </td>
                                                <td class="fw-bold text-dark">
                                                    <a href="${pageContext.request.contextPath}/staff/bus/update?id=${b.busID}" class="text-decoration-none text-dark hover-primary">
                                                        ${b.busType}
                                                    </a>
                                                </td>
                                                <td><i class="fas fa-users text-secondary me-2"></i>${b.capacity} chỗ</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'ACTIVE'}">
                                                            <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1"><i class="fas fa-check-circle me-1"></i>ACTIVE</span>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'MAINTENANCE'}">
                                                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning px-2 py-1"><i class="fas fa-tools me-1"></i>MAINTENANCE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-2 py-1"><i class="fas fa-ban me-1"></i>RETIRED</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <div class="d-inline-flex gap-2">
                                                        <a href="${pageContext.request.contextPath}/staff/bus/update?id=${b.busID}" class="btn btn-sm btn-outline-primary shadow-sm" title="Hồ sơ chi tiết">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/staff/bus/delete" method="POST" class="m-0" onsubmit="return confirm('CẢNH BÁO: Xác nhận xóa/ngừng sử dụng xe ${b.licensePlate}?')">
                                                            <input type="hidden" name="id" value="${b.busID}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm" title="Xóa xe">
                                                                <i class="fas fa-trash-alt"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>