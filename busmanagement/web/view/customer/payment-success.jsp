<%-- 
    Document   : payment-success
    Created on : Jul 8, 2026, 10:57:11 AM
    Author     : Administrator
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thành Công - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
            --bg-light: #f8f9fa;
        }
        body {
            background-color: var(--bg-light);
            font-family: 'Outfit', sans-serif;
        }
        .navbar {
            background: var(--primary) !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
            color: white !important;
        }
        .navbar-brand span {
            color: var(--accent);
        }
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            font-weight: 500;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5 flex-grow-1 text-center" style="max-width: 600px; padding-top: 40px;">
        <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
            <div class="mb-4">
                <i class="fas fa-check-circle text-success fa-4x"></i>
            </div>
            <h2 class="fw-bold text-dark mb-2">Thanh toán hoặc đăng ký thành công!</h2>
            <p class="text-muted mb-4">Giao dịch của bạn đã được ghi nhận và cập nhật vào hệ thống điện tử.</p>

            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/customer/ticket?tab=ticket" class="btn btn-primary fw-bold px-4 py-2.5 rounded-3">
                    <i class="fas fa-ticket-alt me-2"></i>Xem vé của tôi
                </a>
                <a href="${pageContext.request.contextPath}/route-list" class="btn btn-light border fw-semibold px-4 py-2.5 rounded-3 text-secondary">
                    Quay về danh sách tuyến
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp" />
</body>
</html>