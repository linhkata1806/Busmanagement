<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đang kết nối cổng thanh toán VNPAY - Bus Hà Nội</title>
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
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-light);
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
        .loading-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 45px rgba(0,0,0,0.06);
            background: white;
            padding: 50px;
            max-width: 600px;
            margin: 80px auto;
        }
        .spinner-custom {
            width: 4rem;
            height: 4rem;
            color: var(--primary);
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <!-- ===== HEADER NAVIGATION ===== -->
    <jsp:include page="/common/navbar.jsp" />

    <div class="container flex-grow-1 text-center">
        <div class="card loading-card shadow-sm">
            <div class="mb-4">
                <div class="spinner-border spinner-custom text-primary" role="status" style="border-width: 0.25em;">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
            
            <h3 class="fw-bold text-dark mb-3">Đang thanh toán qua VNPAY...</h3>
            <p class="text-muted fs-6 mb-4">
                Vui lòng hoàn tất quá trình thanh toán trong cửa sổ VNPAY vừa được mở ra.
            </p>
            
            <div class="alert alert-info border-0 rounded-3 small text-start mb-0">
                <i class="fas fa-info-circle me-2"></i>
                Sau khi thanh toán thành công tại cửa sổ VNPAY, trang web này sẽ tự động tải lại và cập nhật trạng thái vé của bạn. Vui lòng <strong>không đóng hoặc tải lại trang này</strong> cho đến khi nhận được kết quả.
            </div>
        </div>
    </div>

    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />

    <script>
        window.paymentCompleted = false;
        
        // Theo dõi trạng thái cửa sổ Pop-up
        let popup = window.open('', 'VNPayGateway');
        let checkInterval = setInterval(function() {
            if (window.paymentCompleted) {
                clearInterval(checkInterval);
                return;
            }
            if (popup && popup.closed) {
                clearInterval(checkInterval);
                window.location.href = "${pageContext.request.contextPath}/view/customer/payment-fail.jsp?error=payment_cancelled";
            }
        }, 1000);
    </script>
</body>
</html>
