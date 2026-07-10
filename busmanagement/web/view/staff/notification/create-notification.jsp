<%-- 
    Document   : create-notification
    Created on : Jun 28, 2026, 10:29:04 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo thông báo mới - Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --sidebar-bg: #1e293b;
                --bg-light: #f8f9fa;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', sans-serif;
            }
            .sidebar {
                background-color: var(--sidebar-bg);
                min-height: 100vh;
                color: #cbd5e1;
            }
            .sidebar .nav-link {
                color: #94a3b8;
                border-radius: 0.375rem;
            }
            .main-content {
                padding: 2rem;
            }
        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/view/staff/sidebar.jsp">
                    <jsp:param name="activeMenu" value="notification" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="mb-4 pb-2 border-bottom">
                        <h2 class="fw-bold text-dark m-0">Tạo thông báo mới</h2>
                    </div>

                    <c:if test="${not empty msgError}">
                        <div class="alert alert-danger shadow-sm mb-4" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${msgError}
                        </div>
                    </c:if>

                    <div class="card border-0 shadow-sm rounded-4 bg-white max-w-xl p-4">
                        <form action="${pageContext.request.contextPath}/staff/notification/create" method="POST" class="d-flex flex-column gap-3">

                            <div>
                                <label class="form-label small fw-bold">Người nhận (Nhập ID Tài khoản Khách hàng)</label>
                                <input type="number" name="accountID" class="form-control" placeholder="Ví dụ: 10, 11 (Bắt buộc > 0)" required min="1">
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Loại thông báo</label>
                                <select name="notificationType" class="form-select">
                                    <option value="SYSTEM_ALERT">SYSTEM (Hệ thống)</option>
                                    <option value="SYSTEM_MAINTENANCE">MAINTENANCE (Bảo trì)</option>
                                    <option value="ROUTE_DELAY">ROUTE_DELAY (Trễ tuyến)</option>
                                    <option value="ROUTE_CHANGE">ROUTE_CHANGE (Thay đổi lộ trình)</option>
                                </select>
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Tiêu đề thông báo</label>
                                <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề tin..." required autocomplete="off">
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Nội dung thông báo</label>
                                <textarea name="content" class="form-control" rows="5" placeholder="Nhập nội dung thông báo chi tiết..." required></textarea>
                            </div>

                            <div class="d-flex gap-2 justify-content-end pt-2 border-top">
                                <a href="${pageContext.request.contextPath}/staff/notification" class="btn btn-light px-4 fw-semibold">Hủy</a>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold">Tạo mới</button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
