<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán QR - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --bg-light: #f8f9fa;
            --dark-blue: #1a1a2e;
            --success-color: #2ec4b6;
        }
        body { 
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-light); 
        }
        .payment-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            background: white;
            overflow: hidden;
        }
        .payment-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 25px;
            text-align: center;
        }
        .qr-wrapper {
            background: #fff;
            padding: 15px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: inline-block;
            margin: 20px 0;
            border: 2px solid #eaeeff;
        }
        .qr-image {
            width: 220px;
            height: 220px;
            object-fit: contain;
        }
        .info-row {
            padding: 12px 15px;
            border-bottom: 1px dashed #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #6c757d;
            font-weight: 500;
            font-size: 0.95rem;
        }
        .info-value {
            color: #212529;
            font-weight: 600;
            font-size: 1rem;
        }
        .btn-confirm {
            background-color: #2ec4b6;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 700;
            transition: all 0.3s ease;
        }
        .btn-confirm:hover {
            background-color: #27a89c;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(46, 196, 182, 0.4);
        }
        .btn-cancel {
            background-color: #f1f3f9;
            color: #495057;
            border: none;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-cancel:hover {
            background-color: #e2e6f0;
            color: #212529;
        }
        .copy-badge {
            cursor: pointer;
            background: #eef2ff;
            color: var(--primary);
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            margin-left: 8px;
            transition: all 0.2s;
        }
        .copy-badge:hover {
            background: var(--primary);
            color: white;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <!-- ===== HEADER NAVIGATION ===== -->
    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5 flex-grow-1">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">

                <!-- Hiển thị thông báo thành công từ Session -->
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 rounded-3 border-0 shadow-sm" role="alert" style="background-color: #d1f7ec; color: #0f5132;">
                        <i class="fas fa-check-circle me-2 fs-5"></i>
                        <div>${sessionScope.successMsg}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMsg" scope="session" />
                </c:if>

                <div class="card payment-card">
                    <div class="payment-header">
                        <h4 class="fw-bold mb-1"><i class="fas fa-qrcode me-2"></i>QUÉT MÃ THANH TOÁN</h4>
                        <p class="mb-0 opacity-75 small">Sử dụng ứng dụng ngân hàng hoặc ví điện tử bất kỳ để quét</p>
                    </div>
                    <div class="card-body p-4 text-center">

                        <div class="qr-wrapper">
                            <!-- Gọi API tạo mã QR động thực tế của QRServer với tham số được URL-encode -->
                            <c:url var="qrCodeUrl" value="https://api.qrserver.com/v1/create-qr-code/">
                                <c:param name="size" value="250x250" />
                                <c:param name="data" value="Chuyen khoan Bus Ha Noi: Loai ve ${requestScope.qrType}, So tien ${requestScope.qrAmount}đ, Tuyen ${requestScope.qrRoute}" />
                            </c:url>
                            <img class="qr-image" 
                                 src="${qrCodeUrl}" 
                                 alt="Mã QR chuyển khoản ngân hàng" />
                        </div>

                        <div class="text-start bg-light p-3 rounded-3 mb-4">
                            <div class="info-row">
                                <span class="info-label">Ngân hàng thụ hưởng</span>
                                <span class="info-value text-primary">MB Bank (Quân Đội)</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Loại dịch vụ</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${requestScope.qrType eq 'luot'}">Vé lượt trực tuyến</c:when>
                                        <c:when test="${requestScope.qrType eq 'thang'}">Vé tháng (Cố định)</c:when>
                                        <c:otherwise>Vé tháng (Liên tuyến)</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số tài khoản</span>
                                <span class="info-value">
                                    <span id="accountNo">190012345678</span>
                                    <span class="copy-badge" onclick="copyText('accountNo')"><i class="far fa-copy"></i> Sao chép</span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Tên chủ tài khoản</span>
                                <span class="info-value text-uppercase">CONG TY CO PHAN XE BUS HA NOI</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số tiền thanh toán</span>
                                <span class="info-value text-danger fs-5 fw-bold">
                                    <fmt:formatNumber value="${requestScope.qrAmount}" pattern="#,###"/> đ
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Nội dung chuyển khoản</span>
                                <span class="info-value">
                                    <c:set var="transferDesc" value="THANH TOAN VE XE BUS ${requestScope.qrRoute}"/>
                                    <span id="transferCode">${transferDesc}</span>
                                    <span class="copy-badge" onclick="copyText('transferCode')"><i class="far fa-copy"></i> Sao chép</span>
                                </span>
                            </div>
                        </div>

                        <div class="d-flex justify-content-center align-items-center gap-3">
                            <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-cancel">
                                <i class="fas fa-times me-1"></i>Hủy bỏ giao dịch
                            </a>
                            <form action="${pageContext.request.contextPath}/customer/buy-ticket" method="POST" class="m-0">
                                <input type="hidden" name="action" value="confirm">
                                <input type="hidden" name="routeId" value="${requestScope.qrRouteId}">
                                <input type="hidden" name="ticketType" value="${requestScope.qrType}">
                                <input type="hidden" name="passTypeId" value="${requestScope.qrPassTypeId}">
                                <input type="hidden" name="imageProof" value="${requestScope.qrImageProof}">

                                <button type="submit" class="btn btn-confirm">
                                    <i class="fas fa-check-circle me-1"></i>Đã hoàn tất thanh toán
                                </button>
                            </form>
                        </div>

                        <div class="mt-4 text-muted small">
                            <i class="fas fa-info-circle me-1"></i>Hệ thống sẽ kiểm tra và phê duyệt vé ngay sau khi nhận được tiền.
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />
    <script>
        function copyText(elementId) {
            const text = document.getElementById(elementId).innerText;
            navigator.clipboard.writeText(text).then(() => {
                alert("Đã sao chép nội dung: " + text);
            }).catch(err => {
                console.error("Không thể sao chép: ", err);
            });
        }
    </script>
</body>
</html>
