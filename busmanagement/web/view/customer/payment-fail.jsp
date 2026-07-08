<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thất Bại - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
        .error-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            background: white;
            padding: 50px;
        }
        .error-card h3 {
            color: #2c3e50 !important;
            font-weight: 700;
        }
        .error-card p {
            color: #6c757d !important;
        }
        .error-icon-wrapper {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background-color: #fee2e2;
            border-radius: 50%;
            color: #dc3545;
            font-size: 2.2rem;
            margin-bottom: 24px;
        }
        .btn-primary {
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
        }
        .btn-primary:hover {
            background-color: var(--primary-dark) !important;
            border-color: var(--primary-dark) !important;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5 flex-grow-1 text-center" style="max-width: 600px; padding-top: 40px;">
        <div class="card error-card">
            <div class="mb-2">
                <div class="error-icon-wrapper">
                    <i class="fas fa-times"></i>
                </div>
            </div>
            <h3 class="fw-bold mb-3">Thanh toán thất bại hoặc đã bị hủy!</h3>
            <p class="fs-6 mb-4">
                <c:choose>
                    <c:when test="${param.error == 'payment_cancelled'}">
                        Giao dịch của bạn đã bị hủy do cửa sổ thanh toán VNPAY bị đóng hoặc trang web được tải lại trước khi nhận kết quả.
                    </c:when>
                    <c:otherwise>
                        Giao dịch của bạn không hoàn tất do lỗi xác thực hoặc đã bị hủy từ phía người dùng.
                    </c:otherwise>
                </c:choose>
            </p>

            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/route-list" class="btn btn-primary fw-bold px-4 py-2.5 rounded-3 text-white">
                    <i class="fas fa-redo me-2"></i>Chọn tuyến & Thử lại
                </a>
                <a href="${pageContext.request.contextPath}/customer/ticket?tab=ticket" class="btn btn-light border fw-semibold px-4 py-2.5 rounded-3 text-secondary">
                    Vé của tôi
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp" />
</body>
</html>