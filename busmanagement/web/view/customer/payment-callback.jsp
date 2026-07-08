<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đang xử lý kết quả thanh toán...</title>
    <script>
        window.addEventListener('DOMContentLoaded', (event) => {
            const status = "${param.status}";
            const error = encodeURIComponent("${param.error}");
            const contextPath = "${pageContext.request.contextPath}";
            
            let targetUrl = "";
            if (status === "success") {
                targetUrl = contextPath + "/view/customer/payment-success.jsp";
            } else {
                targetUrl = contextPath + "/view/customer/payment-fail.jsp?error=" + error;
            }

            // Kiểm tra xem có cửa sổ cha (window.opener) đang mở không
            if (window.opener && !window.opener.closed) {
                try {
                    // Đánh dấu giao dịch hoàn tất trước khi chuyển hướng để tránh trigger tự hủy
                    window.opener.paymentCompleted = true;
                    // Chuyển hướng trang chính nằm ở background
                    window.opener.location.href = targetUrl;
                    // Đóng cửa sổ pop-up hiện tại lại
                    window.close();
                } catch (e) {
                    // Nếu gặp lỗi bảo mật cross-origin, tự điều hướng trực tiếp ở tab này
                    window.location.href = targetUrl;
                }
            } else {
                // Nếu cửa sổ cha đã bị đóng, điều hướng trực tiếp trên trang này
                window.location.href = targetUrl;
            }
        });
    </script>
</head>
<body>
    <div style="text-align: center; font-family: sans-serif; padding-top: 100px;">
        <h3>Đang xử lý kết quả giao dịch...</h3>
        <p style="color: #666;">Hệ thống đang đồng bộ thông tin vé của bạn. Vui lòng đợi trong giây lát.</p>
    </div>
</body>
</html>
