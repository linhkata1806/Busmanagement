<%-- 
    Document   : edit-stop
    Created on : Jul 1, 2026, 6:19:04 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật Điểm Dừng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Cập nhật Điểm Dừng</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- HIỂN THỊ LỖI -->
                        <c:if test="${not empty requestScope.msgError}">
                            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${requestScope.msgError}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/staff/stop/update" method="POST">
                            <!-- Chú ý: input ẩn này phải tên là stopID để khớp với Controller -->
                            <input type="hidden" name="stopID" value="${stop.stopID}">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên điểm dừng <span class="text-danger">*</span></label>
                                <input type="text" name="stopName" class="form-control" required value="${stop.stopName}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ</label>
                                <input type="text" name="address" class="form-control" value="${stop.address}">
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Vĩ độ (Latitude) <span class="text-danger">*</span></label>
                                    <input type="number" step="any" name="latitude" class="form-control" required value="${stop.latitude}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Kinh độ (Longitude) <span class="text-danger">*</span></label>
                                    <input type="number" step="any" name="longitude" class="form-control" required value="${stop.longitude}">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Trạng thái hoạt động <span class="text-danger">*</span></label>
                                <select name="isActive" class="form-select">
                                    <option value="true" ${stop.isActive ? 'selected' : ''}>Hoạt động (ACTIVE)</option>
                                    <option value="false" ${!stop.isActive ? 'selected' : ''}>Ngừng hoạt động (INACTIVE)</option>
                                </select>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/staff/stop" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i> Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>