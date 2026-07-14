<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Truy cập bị từ chối - Hanoi Bus</title>
    <jsp:include page="/common/head_imports.jsp" />

</head>
<body>
    <!-- Header/Navbar chung của project -->
    <jsp:include page="/common/navbar.jsp" />

    <!-- Nội dung chính -->
    <div class="main-content container my-5">
        <div class="card shadow-sm p-5 border-0 text-center" style="max-width: 500px; width: 100%; border-radius: 12px; background: #ffffff;">
            <div class="mb-4">
                <i class="fas fa-exclamation-triangle text-warning" style="font-size: 4rem;"></i>
            </div>
            <h2 class="fw-bold text-dark mb-3">Truy Cập Bị Từ Chối!</h2>
            <p class="text-muted mb-4">
                Rất tiếc, tài khoản của bạn không có quyền truy cập vào đường dẫn hoặc chức năng này. 
                Vui lòng liên hệ với Quản trị viên nếu bạn cho rằng đây là một sự nhầm lẫn.
            </p>
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-warning px-4 py-2 fw-semibold text-white shadow-sm" style="background: #fbbc04; border: none; border-radius: 20px;">
                    <i class="fas fa-home me-2"></i>Quay lại Trang chủ
                </a>
            </div>
            <div class="mt-4">
                <small class="text-muted">Hệ thống sẽ tự động quay lại sau <span id="timer" class="fw-bold text-danger">5</span> giây...</small>
            </div>
        </div>
    </div>

    <!-- Footer chung của project -->
    <jsp:include page="/common/footer.jsp" />

    <script>
        let seconds = 5;
        const timerSpan = document.getElementById('timer');
        const homeUrl = '${pageContext.request.contextPath}/home';

        const countdown = setInterval(() => {
            seconds--;
            timerSpan.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(countdown);
                window.location.href = homeUrl;
            }
        }, 1000);
    </script>
</body>
</html>
