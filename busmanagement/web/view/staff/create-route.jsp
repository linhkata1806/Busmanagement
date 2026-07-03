<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm mới Tuyến xe - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --bg-light: #f8f9fa; }
        body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }
        .main-content { padding: 2rem; }
        .form-card { border: none; border-radius: 1rem; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }
    </style>
</head>
<body>

<c:set var="valNumber" value="${not empty route.routeNumber ? route.routeNumber : ''}" />
<c:set var="valName" value="${not empty route.routeName ? route.routeName : ''}" />
<c:set var="valStart" value="${not empty route.startPoint ? route.startPoint : ''}" />
<c:set var="valEnd" value="${not empty route.endPoint ? route.endPoint : ''}" />
<c:set var="valHours" value="${not empty route.operatingHours ? route.operatingHours : ''}" />
<c:set var="valFreq" value="${not empty route.frequence ? route.frequence : ''}" />
<c:set var="valPrice" value="${not empty route.ticketPrice ? route.ticketPrice : ''}" />
<c:set var="valDist" value="${not empty route.totalDistance ? route.totalDistance : ''}" />
<c:set var="valDuration" value="${not empty route.estimatedDuration ? route.estimatedDuration : ''}" />
<c:set var="valStatus" value="${route.isActive ? 'ACTIVE' : 'INACTIVE'}" />

<datalist id="stopSuggestions">
    <c:forEach var="s" items="${stops}">
        <option value="${s.stopName}"></option>
    </c:forEach>
</datalist>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activeMenu" value="route" />
        </jsp:include>

        <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h2 class="fw-bold text-dark m-0">Thêm mới Tuyến xe</h2>
                    <p class="text-muted small m-0">Tạo hành trình khai thác mới cho hệ thống xe buýt.</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/route" class="btn btn-light border fw-semibold">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </div>

            <div class="row justify-content-center">
                <div class="col-xl-8 col-lg-10">
                    
                    <c:if test="${not empty msgError}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i><strong>Lỗi xử lý:</strong> ${msgError}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="card form-card bg-white p-4 p-sm-5">
                        <form id="createForm" action="${pageContext.request.contextPath}/staff/route/create" method="POST" class="row g-4">
                            
                            <div class="col-md-12">
                                <label class="form-label small fw-bold text-secondary">Trạng thái vận hành</label>
                                <select name="status" class="form-select py-2 fw-bold" required>
                                    <option value="ACTIVE" class="text-success" ${valStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Đang khai thác)</option>
                                    <option value="INACTIVE" class="text-secondary" ${valStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE (Chưa hoạt động)</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Mã số tuyến</label>
                                <input type="text" name="routeNumber" class="form-control py-2 fw-bold" value="${valNumber}" placeholder="Ví dụ: 01, 107..." required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Điểm đầu</label>
                                <input type="text" name="startPoint" list="stopSuggestions" class="form-control py-2" value="${valStart}" placeholder="Gõ tìm bến..." autocomplete="off" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Điểm cuối</label>
                                <input type="text" name="endPoint" list="stopSuggestions" class="form-control py-2" value="${valEnd}" placeholder="Gõ tìm bến..." autocomplete="off" required>
                            </div>

                            <div class="col-md-12">
                                <label class="form-label small fw-bold text-secondary">Tên tuyến đường</label>
                                <input type="text" name="routeName" class="form-control py-2" value="${valName}" placeholder="Ví dụ: Kim Mã - Nhổn" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Thời gian hoạt động</label>
                                <input type="text" name="operatingHours" class="form-control py-2" value="${valHours}" placeholder="Ví dụ: 05:00 - 22:00" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Tần suất giãn cách</label>
                                <input type="text" name="frequency" class="form-control py-2" value="${valFreq}" placeholder="Ví dụ: 10-15 phút/lượt">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Giá vé lượt (VNĐ)</label>
                                <input type="number" name="ticketPrice" class="form-control py-2" value="${valPrice}" placeholder="Ví dụ: 7000" required min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Tổng chiều dài (km)</label>
                                <input type="number" step="0.1" name="distance" class="form-control py-2" value="${valDist}" placeholder="Ví dụ: 15.5" required min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-secondary">Thời gian dự kiến (phút)</label>
                                <input type="number" name="estimatedDuration" class="form-control py-2" value="${valDuration}" placeholder="Ví dụ: 45" min="1" required>
                            </div>
                        </form>

                        <div class="d-flex gap-2 justify-content-end border-top pt-4 mt-4">
                            <a href="${pageContext.request.contextPath}/staff/route" class="btn btn-light px-4 py-2 border fw-semibold">Quay lại</a>
                            <button type="button" onclick="document.getElementById('createForm').submit()" class="btn btn-success px-4 py-2 fw-semibold shadow-sm">
                                <i class="fas fa-save me-2"></i>Tạo tuyến đường
                            </button>
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
