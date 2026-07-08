<%-- 
    Document   : payment-fail
    Created on : Jul 8, 2026, 10:56:44 AM
    Author     : Administrator
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thất Bại - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <style>
        :root {
            --primary: #0d47a1;
            --bg-light: #f4f6f9;
        }
        body {
            background-color: var(--bg-light);
            font-family: 'Outfit', sans-serif;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5 flex-grow-1 text-center" style="max-width: 600px; padding-top: 40px;">
        <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
            <div class="mb-4">
                <i class="fas fa-times-circle text-danger fa-4x"></i>
            </div>
            <h2 class="fw-bold text-dark mb-2">Thanh toán thất bại hoặc đã bị hủy!</h2>
            <p class="text-muted mb-4">Giao dịch của bạn không hoàn tất do lỗi xác thực hoặc đã bị hủy từ phía người dùng.</p>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-warning small py-2 mb-4 rounded-3">
                    Mã lỗi chi tiết: <strong>${param.error}</strong>
                </div>
            </c:if>

            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/route-list" class="btn btn-primary fw-bold px-4 py-2.5 rounded-3">
                    <i class="fas fa-search-location me-2"></i>Chọn tuyến & Thử lại
                </a>
                <a href="${pageContext.request.contextPath}/customer/ticket?tab=ticket" class="btn btn-light border fw-semibold px-4 py-2.5 rounded-3 text-secondary">
                    Về vé của tôi
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp" />
</body>
</html>