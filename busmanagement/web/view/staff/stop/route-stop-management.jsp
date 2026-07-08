<%-- 
    Document   : route-stop-management
    Created on : Jul 1, 2026, 7:31:30 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Điểm dừng của Tuyến</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                min-height: 100vh;
                overflow-x: hidden;
            }
            .main-content {
                padding: 2rem;
            }
            .table-responsive {
                border-radius: 0.75rem;
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
                        <h2 class="fw-bold m-0" style="color: #5c67f2 !important;"><i class="fas fa-map-signs me-2"></i>Quản lý Điểm dừng - Tuyến #${routeId}</h2>
                    </div>

                    <!-- THÔNG BÁO -->
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

                    <!-- BẢNG DANH SÁCH TRẠM CỦA TUYẾN -->
                    <div class="card border-0 shadow-sm rounded-4 bg-white mb-4">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Order</th>
                                            <th>Tên điểm dừng</th>
                                            <th>Địa chỉ</th>
                                            <th>Khoảng cách (km)</th>
                                            <th>Tọa độ</th>
                                            <th class="text-center">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${routeStops}" var="rs">
                                            <tr>
                                                <td class="fw-bold fs-5">${rs.stopOrder}</td>
                                                <td>${rs.stopName}</td>
                                                <td>${rs.address}</td>
                                                <td><span class="badge bg-info text-dark">${rs.distanceFromStart} km</span></td>
                                                <td><small class="text-muted">${rs.latitude}, ${rs.longitude}</small></td>
                                                <td class="text-center">
                                                    <form action="${pageContext.request.contextPath}/staff/route-stop" method="POST" class="d-inline">
                                                        <input type="hidden" name="id" value="${rs.routeStopID}">
                                                        <input type="hidden" name="routeId" value="${routeId}">

                                                        <button type="submit" name="action" value="up" class="btn btn-sm btn-outline-secondary" title="Đẩy lên">
                                                            <i class="fas fa-arrow-up"></i>
                                                        </button>
                                                        <button type="submit" name="action" value="down" class="btn btn-sm btn-outline-secondary" title="Kéo xuống">
                                                            <i class="fas fa-arrow-down"></i>
                                                        </button>
                                                        <button type="submit" name="action" value="remove" class="btn btn-sm btn-outline-danger" 
                                                                onclick="return confirm('Xóa trạm ${rs.stopName} khỏi tuyến?');" title="Xóa">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty routeStops}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-3">Chưa có trạm nào trong tuyến này.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- FORM THÊM ĐIỂM DỪNG VÀO TUYẾN -->
                    <div class="card border-0 shadow-sm rounded-4 bg-white">
                        <div class="card-header bg-white fw-bold"><i class="fas fa-plus-circle me-1"></i>Thêm điểm dừng vào tuyến</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/staff/route-stop/add" method="POST" class="row g-3 align-items-end">
                                <input type="hidden" name="routeId" value="${routeId}">

                                <div class="col-md-5">
                                    <label class="form-label">Chọn điểm dừng</label>
                                    <select name="stopId" class="form-select" required>
                                        <option value="">-- Chọn điểm dừng --</option>
                                        <c:forEach items="${availableStops}" var="s">
                                            <option value="${s.stopID}">${s.stopName} - ${s.address}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Vị trí (Order)</label>
                                    <input type="number" name="position" class="form-control" placeholder="Ví dụ: 1, 2..." required min="1">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Khoảng cách (km)</label>
                                    <input type="number" step="0.01" name="distance" class="form-control" placeholder="Ví dụ: 2.5" min="0">
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-success w-100">
                                        <i class="fas fa-save me-1"></i> Thêm vào tuyến
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- NÚT QUAY LẠI -->
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/staff/route" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Về danh sách tuyến
                        </a>
                    </div>

                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>