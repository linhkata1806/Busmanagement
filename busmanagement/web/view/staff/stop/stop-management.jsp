<%-- 
    Document   : stop-management
    Created on : Jul 1, 2026, 6:18:14 PM
    Author     : Administrator
--%>

<%-- 
    Document   : stop-management
    Created on : Jul 1, 2026, 6:18:14 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Điểm dừng - Hệ thống xe buýt</title>
        <!-- Nhúng Bootstrap 5 & FontAwesome của bạn vào đây -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* CSS hỗ trợ để Sidebar và Main content hiển thị full màn hình */
            body {
                min-height: 100vh;
                overflow-x: hidden;
            }
            .main-content {
                padding: 2rem;
            }
            .table-dark th {
                padding-top: 15px !important;
                padding-bottom: 15px !important;
                vertical-align: middle !important;
                font-size: 0.9rem !important;
                font-weight: 600 !important;
            }
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

                <!-- NHÚNG SIDEBAR -->
                <jsp:include page="/view/staff/sidebar.jsp">
                    <jsp:param name="activeMenu" value="stop" />
                </jsp:include>

                <!-- NỘI DUNG CHÍNH -->
                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">

                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h2 class="fw-bold text-dark m-0">Quản lý điểm dừng</h2>
                    </div>

                    <!-- HIỂN THỊ THÔNG BÁO FLASH MESSAGE -->
                    <c:if test="${not empty sessionScope.msgSuccess}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.msgSuccess}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgSuccess" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.msgInfo}">
                        <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-info-circle me-2"></i>${sessionScope.msgInfo}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgInfo" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.msgError}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.msgError}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgError" scope="session"/>
                    </c:if>

                    <div class="card border-0 shadow-sm rounded-4 bg-white mb-4">
                        <div class="card-body">
                            <!-- FORM TÌM KIẾM & LỌC -->
                            <form action="${pageContext.request.contextPath}/staff/stop" method="GET" class="row g-3 align-items-center">
                                <div class="col-md-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" name="search" class="form-control" placeholder="Tìm theo tên điểm dừng hoặc địa chỉ..." value="${search}">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select name="status" class="form-select">
                                        <option value="ALL" ${status == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                                        <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                                </div>
                                <div class="col-md-2 text-end">
                                    <a href="${pageContext.request.contextPath}/staff/stop/create" class="btn btn-success w-100">
                                        <i class="fas fa-plus me-1"></i> Thêm mới
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- BẢNG DỮ LIỆU -->
                    <div class="card border-0 shadow-sm rounded-4 bg-white">
                        <div class="card-body p-0">
                            <div class="table-responsive d-flex flex-column h-100" style="min-height: 500px;">
                                <div class="flex-grow-1">
                                    <table class="table table-hover table-striped mb-0 align-middle" style="min-width: 900px;">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên điểm dừng</th>
                                                <th>Địa chỉ</th>
                                                <th>Tọa độ (Lat, Lng)</th>
                                                <th>Trạng thái</th>
                                                <th class="text-center">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${listStops}" var="stop">
                                                <tr>
                                                    <td class="fw-bold">${stop.stopID}</td>
                                                    <td>${stop.stopName}</td>
                                                    <td>${stop.address}</td>
                                                    <td><small class="text-muted"><i class="fas fa-location-crosshairs me-1"></i>${stop.latitude}, ${stop.longitude}</small></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${stop.isActive}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Ngừng hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <!-- Nút Sửa -->
                                                        <a href="${pageContext.request.contextPath}/staff/stop/update?id=${stop.stopID}" class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
    
                                                        <!-- Nút Xóa (Dùng form ẩn Method POST) -->
                                                        <form action="${pageContext.request.contextPath}/staff/stop/delete" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa điểm dừng này không?');">
                                                            <input type="hidden" name="id" value="${stop.stopID}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa">
                                                                <i class="fas fa-trash-alt"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty listStops}">
                                                <tr>
                                                    <td colspan="6" class="text-center text-muted py-4">Không tìm thấy điểm dừng nào phù hợp.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <%@ include file="../../../common/pagination.jsp" %>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>