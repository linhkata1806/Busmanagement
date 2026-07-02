<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tuyến xe - Hệ thống xe buýt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            overflow-x: hidden;
        }
        .main-content {
            width: 100%;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Layout Flexbox chia 2 cột: Sidebar & Content -->
    <div class="d-flex">
        
        <!-- NHÚNG SIDEBAR: Đánh dấu menu Route đang active -->
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activeMenu" value="route" />
        </jsp:include>

        <!-- NỘI DUNG CHÍNH -->
        <div class="main-content">
            <div class="container-fluid py-4">
                
                <h2 class="mb-4 text-primary"><i class="fas fa-route me-2"></i>Quản lý Tuyến xe</h2>

                <!-- HIỂN THỊ THÔNG BÁO FLASH MESSAGE -->
                <c:if test="${not empty sessionScope.msgSuccess}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.msgSuccess}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="msgSuccess" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.msgError}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.msgError}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="msgError" scope="session"/>
                </c:if>

                <!-- KHU VỰC TÌM KIẾM VÀ THÊM MỚI -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/staff/route" method="GET" class="row g-3 align-items-center">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên tuyến hoặc mã tuyến..." value="${keyword}">
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
                                <a href="${pageContext.request.contextPath}/staff/route/create" class="btn btn-success w-100">
                                    <i class="fas fa-plus me-1"></i> Thêm mới
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- BẢNG DANH SÁCH TUYẾN XE -->
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped mb-0 align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Mã tuyến</th>
                                        <th>Tên tuyến (Lộ trình)</th>
                                        <th>Thời gian HĐ</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${routes}" var="route">
                                        <tr>
                                            <td class="fw-bold">${route.routeID}</td>
                                            <td><span class="badge bg-secondary">${route.routeNumber}</span></td>
                                            <td class="fw-bold text-primary">${route.routeName}</td>
                                            
                                            <!-- ĐÃ SỬA THÀNH operatingHours CHO KHỚP VỚI MODEL ROUTE -->
                                            <td><small class="text-muted"><i class="far fa-clock me-1"></i>${route.operatingHours}</small></td>
                                            
                                            <td>
                                                <c:choose>
                                                    <c:when test="${route.isActive}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Ngừng HĐ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                
                                                <!-- NÚT QUẢN LÝ TRẠM (CHUYỂN SANG ROUTE STOP) -->
                                                <a href="${pageContext.request.contextPath}/staff/route-stop?routeId=${route.routeID}" 
                                                   class="btn btn-sm btn-info text-white me-1" title="Quản lý trạm dừng">
                                                    <i class="fas fa-map-signs"></i> Quản lý trạm
                                                </a>
                                                
                                                <!-- Nút Sửa -->
                                                <a href="${pageContext.request.contextPath}/staff/route/update?id=${route.routeID}" 
                                                   class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa tuyến">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                
                                                <!-- Nút Xóa (Dùng form ẩn Method POST) -->
                                                <form action="${pageContext.request.contextPath}/staff/route/delete" method="POST" class="d-inline" 
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa tuyến xe này không?');">
                                                    <input type="hidden" name="id" value="${route.routeID}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa tuyến">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </form>
                                                
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty routes}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">Không tìm thấy tuyến xe nào phù hợp.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>