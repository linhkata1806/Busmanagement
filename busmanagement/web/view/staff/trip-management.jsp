<%-- 
    Document   : trip-management
    Created on : Jun 29, 2026, 2:59:28 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý lịch trình chuyến xe - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --sidebar-bg: #1e293b; --bg-light: #f8f9fa; }
        body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }
        .sidebar { background-color: var(--sidebar-bg); min-height: 100vh; color: #cbd5e1; }
        .sidebar .nav-link { color: #94a3b8; border-radius: 0.375rem; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #fff; background-color: rgba(255,255,255,0.1); }
        .main-content { padding: 2rem; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
       <jsp:include page="sidebar.jsp">
                    <jsp:param name="activeMenu" value="dashboard" />
                </jsp:include>

        <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <h2 class="fw-bold text-dark m-0">Lịch chạy thực tế của Xe Buýt</h2>
                <a href="${pageContext.request.contextPath}/staff/trip/create" class="btn btn-primary fw-semibold shadow-sm">
                    <i class="fas fa-plus-circle me-2"></i>Thêm chuyến mới
                </a>
            </div>

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
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm p-4 mb-4 bg-white rounded-4">
                <form action="${pageContext.request.contextPath}/staff/trip" method="GET" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-secondary">Lọc theo ngày</label>
                        <input type="date" name="date" class="form-control" value="${filterDate}">
                    </div>
                    
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-secondary">Tuyến đường</label>
                        <select name="routeID" class="form-select">
                            <option value="ALL">-- Tất cả các tuyến --</option>
                            <c:forEach var="r" items="${routes}">
                                <option value="${r.routeID}" ${filterRoute == r.routeID ? 'selected' : ''}>
                                    Tuyến ${r.routeNumber}: ${r.routeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-secondary">Tìm biển số xe</label>
                        <input type="text" name="plate" class="form-control" placeholder="Ví dụ: 29B" value="${filterPlate}">
                    </div>
                    
                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-secondary">Trạng thái vận hành</label>
                        <select name="status" class="form-select">
                            <option value="ALL">Tất cả</option>
                            <option value="SCHEDULED" ${filterStatus eq 'SCHEDULED' ? 'selected' : ''}>SCHEDULED</option>
                            <option value="IN_PROGRESS" ${filterStatus eq 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                            <option value="COMPLETED" ${filterStatus eq 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            <option value="CANCELLED" ${filterStatus eq 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                    </div>
                    
                    <div class="col-md-2">
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
                                    <th class="ps-4 py-3">Mã Chuyến</th>
                                    <th>Thông tin Tuyến</th>
                                    <th>Phương tiện</th>
                                    <th>Nhân sự phụ trách</th>
                                    <th>Lịch trình</th>
                                    <th>Chiều chạy</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center pe-4">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty trips}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5 text-muted">
                                                <i class="fas fa-folder-open fa-3x mb-3 d-block text-black-50"></i>
                                                <h6 class="fw-bold">Không tìm thấy dữ liệu</h6>
                                                <p class="small m-0">Không có chuyến xe nào khớp với điều kiện tìm kiếm của bạn.</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="t" items="${trips}">
                                            <tr>
                                                <td class="ps-4 fw-bold text-primary">#${t.tripID}</td>
                                                <td>
                                                    <span class="badge bg-light text-dark border px-2 py-1 fw-bold mb-1 d-inline-block">Tuyến ${t.routeNumber}</span>
                                                    <div class="small text-muted text-truncate" style="max-width: 180px;" title="${t.routeName}">${t.routeName}</div>
                                                </td>
                                                <td class="fw-bold text-dark">
                                                    <i class="fas fa-bus text-secondary me-1"></i>${t.busPlate}
                                                </td>
                                                <td>
                                                    <div class="fw-semibold"><i class="fas fa-steering-wheel text-primary me-2"></i>${t.driverName}</div>
                                                    <div class="small text-secondary mt-1">
                                                        <i class="fas fa-user-friends me-1"></i>
                                                        <c:choose>
                                                            <c:when test="${empty t.assistantName}"><i>Không có phụ xe</i></c:when>
                                                            <c:otherwise>${t.assistantName}</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td class="small">
                                                    <div class="fw-bold text-dark mb-1"><i class="far fa-calendar-alt me-1"></i>${t.tripDate}</div>
                                                    <div class="text-muted fw-semibold"><i class="far fa-clock me-1"></i>${t.startTime} <i class="fas fa-long-arrow-alt-right mx-1"></i> ${t.endTime}</div>
                                                    <c:if test="${not empty t.actualStartTime}">
                                                        <div class="text-success fw-semibold mt-1" style="font-size: 0.8rem;"><i class="fas fa-play me-1"></i>Thực tế chạy: ${t.actualStartTime}</div>
                                                    </c:if>
                                                    <c:if test="${not empty t.actualEndTime}">
                                                        <div class="text-secondary fw-semibold mt-1" style="font-size: 0.8rem;"><i class="fas fa-flag-checkered me-1"></i>Kết thúc: ${t.actualEndTime}</div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.direction == 1}"><span class="badge text-success bg-success bg-opacity-10 px-2 py-1"><i class="fas fa-arrow-right me-1"></i>Lượt đi</span></c:when>
                                                        <c:otherwise><span class="badge text-warning bg-warning bg-opacity-10 px-2 py-1"><i class="fas fa-arrow-left me-1"></i>Lượt về</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.status eq 'SCHEDULED'}"><span class="badge bg-primary px-2 py-1">SCHEDULED</span></c:when>
                                                        <c:when test="${t.status eq 'IN_PROGRESS'}"><span class="badge bg-warning text-dark px-2 py-1">IN_PROGRESS</span></c:when>
                                                        <c:when test="${t.status eq 'COMPLETED'}"><span class="badge bg-secondary px-2 py-1">COMPLETED</span></c:when>
                                                        <c:otherwise><span class="badge bg-danger px-2 py-1">CANCELLED</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <div class="d-inline-flex gap-2">
                                                        <a href="${pageContext.request.contextPath}/staff/trip/update?id=${t.tripID}" class="btn btn-sm btn-outline-primary shadow-sm" title="Sửa lịch trình">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${t.status eq 'SCHEDULED'}">
                                                            <form action="${pageContext.request.contextPath}/staff/trip/delete" method="POST" class="m-0" onsubmit="return confirm('CẢNH BÁO: Xác nhận XÓA chuyến xe #${t.tripID} ra khỏi hệ thống?')">
                                                                <input type="hidden" name="id" value="${t.tripID}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm" title="Xóa chuyến">
                                                                    <i class="fas fa-trash-alt"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
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