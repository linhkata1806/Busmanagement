<%-- 
    Document   : list-bus
    Created on : Jul 1, 2026, 1:18:44 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ Xe buýt ${bus.licensePlate} - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --bg-light: #f8f9fa; }
        body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }
        .main-content { padding: 2rem; }
        .form-card { border: none; border-radius: 1rem; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }
        .form-label { font-weight: 600; color: #495057; }
        /* Style riêng cho ô read-only nhìn cho xịn */
        input[readonly] { background-color: #e9ecef !important; color: #495057; cursor: not-allowed; font-weight: bold;}
    </style>
</head>
<body>

<!-- Xử lý State Retention cho Trạng thái (Status) - Đã cập nhật thành selectedStatus khớp với code của bạn -->
<c:choose>
    <c:when test="${not empty selectedStatus}">
        <c:set var="valStatus" value="${selectedStatus}" />
    </c:when>
    <c:otherwise>
        <c:set var="valStatus" value="${bus.status.name()}" /> <!-- Thêm .name() -->
    </c:otherwise>
</c:choose>

<!-- Gợi ý nạp nhanh cho ô nhập Loại xe -->
<datalist id="busTypeSuggestions">
    <option value="Bus Thường (Diesel)"></option>
    <option value="VinBus (Điện)"></option>
    <option value="BRT (Bus Nhanh)"></option>
    <option value="Minibus (Cỡ nhỏ)"></option>
</datalist>

<div class="container-fluid">
    <div class="row">
        <!-- SIDEBAR -->
        <jsp:include page="/view/staff/sidebar.jsp">
            <jsp:param name="activeMenu" value="bus" />
        </jsp:include>

        <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h2 class="fw-bold text-dark m-0">Hồ sơ phương tiện [${bus.licensePlate}]</h2>
                    <p class="text-muted small m-0">Xem chi tiết, cập nhật thông số hoặc thay đổi trạng thái bảo dưỡng.</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/bus" class="btn btn-light border fw-semibold shadow-sm">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </div>

            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-9">
                    
                    <!-- HIỂN THỊ THÔNG BÁO LỖI NẾU UPDATE SAI -->
                    <c:if test="${not empty msgError}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${msgError}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgError" scope="request"/>
                    </c:if>

                    <div class="card form-card bg-white p-4 p-md-5 mb-4">
                        <form action="${pageContext.request.contextPath}/staff/bus/update" method="POST">
                            <!-- Bắt buộc phải có input hidden chứa ID để gửi xuống Servlet -->
                            <input type="hidden" name="id" value="${bus.busID}">
                            
                            <div class="mb-4">
                                <label class="form-label">Biển số kiểm soát <i class="fas fa-lock text-muted ms-1" title="Không thể thay đổi"></i></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fas fa-id-card text-secondary"></i></span>
                                    <input type="text" name="licensePlate" class="form-control" 
                                           value="${bus.licensePlate}" readonly>
                                </div>
                                <div class="form-text small text-muted">Biển số là mã định danh duy nhất của phương tiện, không thể chỉnh sửa.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Loại phương tiện <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fas fa-bus-alt text-secondary"></i></span>
                                    <input type="text" name="busType" list="busTypeSuggestions" class="form-control" 
                                           value="${bus.busType}" required>
                                </div>
                            </div>

                            <div class="row mb-5">
                                <div class="col-md-6 mb-4 mb-md-0">
                                    <label class="form-label">Sức chứa (Hành khách) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-users text-secondary"></i></span>
                                        <input type="text" name="capacity" class="form-control" 
                                               value="${bus.capacity}" required>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái vận hành <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-traffic-light text-secondary"></i></span>
                                        <select name="status" class="form-select" required>
                                            <option value="ACTIVE" ${valStatus eq 'ACTIVE' ? 'selected' : ''}>Đang hoạt động (ACTIVE)</option>
                                            <option value="MAINTENANCE" ${valStatus eq 'MAINTENANCE' ? 'selected' : ''}>Bảo trì / Sửa chữa (MAINTENANCE)</option>
                                            <option value="RETIRED" ${valStatus eq 'RETIRED' ? 'selected' : ''}>Ngừng sử dụng (RETIRED)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <hr class="mb-4">

                            <div class="d-flex justify-content-between align-items-center">
                                <!-- Nút XÓA sử dụng form riêng bọc bên ngoài nút để submit độc lập -->
                                <button type="button" class="btn btn-outline-danger fw-bold" 
                                        onclick="if(confirm('CẢNH BÁO: Xác nhận xóa phương tiện ${bus.licensePlate} khỏi hệ thống? Hành động này không thể hoàn tác!')) document.getElementById('deleteForm').submit();">
                                    <i class="fas fa-trash-alt me-2"></i>Xóa phương tiện
                                </button>

                                <!-- Nút LƯU CẬP NHẬT -->
                                <button type="submit" class="btn btn-primary fw-bold px-4 shadow-sm">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Form ẩn dùng để gửi request Xóa -->
                    <form id="deleteForm" action="${pageContext.request.contextPath}/staff/bus/delete" method="POST" style="display: none;">
                        <input type="hidden" name="id" value="${bus.busID}">
                    </form>
                    
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>