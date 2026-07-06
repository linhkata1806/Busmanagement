<%-- 
    Document   : create-bus
    Created on : Jul 1, 2026, 1:00:11 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Phương tiện mới - Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --bg-light: #f8f9fa;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', sans-serif;
            }
            .main-content {
                padding: 2rem;
            }
            .form-card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }
            .form-label {
                font-weight: 600;
                color: #495057;
            }
        </style>
    </head>
    <body>

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
                    <jsp:param name="activeMenu" value="dashboard" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <div>
                            <h2 class="fw-bold text-dark m-0">Thêm phương tiện mới</h2>
                            <p class="text-muted small m-0">Đăng ký hồ sơ xe buýt mới vào hệ thống vận hành.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/bus" class="btn btn-light border fw-semibold shadow-sm">
                            <i class="fas fa-times me-2"></i>Hủy bỏ
                        </a>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-xl-6 col-lg-8">

                            <!-- HIỂN THỊ THÔNG BÁO LỖI -->
                            <c:if test="${not empty msgError}">
                                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>${msgError}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="msgError" scope="request"/>
                            </c:if>

                            <div class="card form-card bg-white p-4 p-md-5">
                                <form action="${pageContext.request.contextPath}/staff/bus/create" method="POST">

                                    <div class="mb-4">
                                        <label class="form-label">Biển số kiểm soát <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="fas fa-id-card text-secondary"></i></span>
                                            <!-- VALUE Ở ĐÂY SẼ HỨNG LẠI DỮ LIỆU ĐÃ NHẬP KHI CÓ LỖI -->
                                            <input type="text" name="licensePlate" class="form-control" 
                                                   value="${b_licensePlate}" 
                                                   placeholder="VD: 29B-123.45" required>
                                        </div>
                                        <div class="form-text small">Định dạng chuẩn: Mã tỉnh + Chữ cái - Dãy số (VD: 29B-123.45).</div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label">Loại phương tiện <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="fas fa-bus-alt text-secondary"></i></span>
                                            <input type="text" name="busType" list="busTypeSuggestions" class="form-control" 
                                                   value="${b_busType}" 
                                                   placeholder="Nhập hoặc chọn loại phương tiện từ danh sách" required>
                                        </div>
                                    </div>

                                    <div class="mb-5">
                                        <label class="form-label">Sức chứa (Hành khách) <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="fas fa-users text-secondary"></i></span>
                                            <input type="text" name="capacity" class="form-control" 
                                                   value="${b_capacity}" 
                                                   placeholder="Nhập tổng số chỗ ngồi và đứng..." required>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-lg fw-bold shadow-sm">
                                            <i class="fas fa-save me-2"></i>Lưu hồ sơ phương tiện
                                        </button>
                                    </div>

                                </form>
                            </div>

                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>