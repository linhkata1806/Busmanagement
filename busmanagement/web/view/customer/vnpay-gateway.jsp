<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String paymentUrl = request.getParameter("paymentUrl");
    java.util.Map<String, String> params = new java.util.HashMap<>();
    if (paymentUrl != null && paymentUrl.contains("?")) {
        String queryString = paymentUrl.substring(paymentUrl.indexOf("?") + 1);
        String[] pairs = queryString.split("&");
        for (String pair : pairs) {
            String[] kv = pair.split("=");
            if (kv.length == 2) {
                params.put(kv[0], java.net.URLDecoder.decode(kv[1], "UTF-8"));
            }
        }
    }
    
    // Đẩy params vào request scope để dễ xử lý qua JSTL
    request.setAttribute("vnpParams", params);
    
    // Tính toán số tiền thực tế để hiển thị
    long amountCent = 0;
    if (params.containsKey("vnp_Amount")) {
        try {
            amountCent = Long.parseLong(params.get("vnp_Amount"));
        } catch (NumberFormatException ignored) {}
    }
    request.setAttribute("displayAmount", amountCent / 100);

    // Chuẩn bị tính toán mã băm cho trường hợp Thành Công (vnp_ResponseCode = 00)
    java.util.Map<String, String> successFields = new java.util.TreeMap<>();
    successFields.put("vnp_Amount", params.get("vnp_Amount"));
    successFields.put("vnp_BankCode", "NCB");
    successFields.put("vnp_BankTranNo", "VNP" + System.currentTimeMillis());
    successFields.put("vnp_CardType", "ATM");
    successFields.put("vnp_OrderInfo", params.get("vnp_OrderInfo"));
    successFields.put("vnp_PayDate", new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
    successFields.put("vnp_ResponseCode", "00");
    successFields.put("vnp_TmnCode", params.get("vnp_TmnCode"));
    successFields.put("vnp_TransactionNo", "TXN" + System.currentTimeMillis());
    successFields.put("vnp_TransactionStatus", "00");
    successFields.put("vnp_TxnRef", params.get("vnp_TxnRef"));

    StringBuilder successHashData = new StringBuilder();
    java.util.Iterator<String> successItr = successFields.keySet().iterator();
    while (successItr.hasNext()) {
        String fieldName = successItr.next();
        String fieldValue = successFields.get(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            successHashData.append(fieldName).append('=').append(java.net.URLEncoder.encode(fieldValue, "US-ASCII"));
            if (successItr.hasNext()) {
                successHashData.append('&');
            }
        }
    }
    String successHash = util.VNPayUtil.hmacSHA512(util.VNPayConfig.vnp_HashSecret, successHashData.toString());
    request.setAttribute("successFields", successFields);
    request.setAttribute("successHash", successHash);

    // Chuẩn bị tính toán mã băm cho trường hợp Hủy Giao Dịch (vnp_ResponseCode = 24)
    java.util.Map<String, String> cancelFields = new java.util.TreeMap<>(successFields);
    cancelFields.put("vnp_ResponseCode", "24");
    cancelFields.put("vnp_TransactionStatus", "02");
    
    StringBuilder cancelHashData = new StringBuilder();
    java.util.Iterator<String> cancelItr = cancelFields.keySet().iterator();
    while (cancelItr.hasNext()) {
        String fieldName = cancelItr.next();
        String fieldValue = cancelFields.get(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            cancelHashData.append(fieldName).append('=').append(java.net.URLEncoder.encode(fieldValue, "US-ASCII"));
            if (cancelItr.hasNext()) {
                cancelHashData.append('&');
            }
        }
    }
    String cancelHash = util.VNPayUtil.hmacSHA512(util.VNPayConfig.vnp_HashSecret, cancelHashData.toString());
    request.setAttribute("cancelFields", cancelFields);
    request.setAttribute("cancelHash", cancelHash);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng thanh toán điện tử VNPAY (Simulator) - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --bg-light: #f4f6f9;
            --dark-blue: #1a1a2e;
        }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-light);
        }
        .gateway-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 45px rgba(0,0,0,0.08);
            background: white;
            overflow: hidden;
            border: 1px solid #e8eefc;
        }
        .gateway-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 25px;
        }
        .vnpay-logo {
            height: 35px;
            object-fit: contain;
        }
        .qr-wrapper {
            background: #fff;
            padding: 15px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: inline-block;
            border: 2px solid #eaeeff;
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
        }
        .info-value {
            color: #212529;
            font-weight: 600;
        }
        .btn-success-sim {
            background-color: #2ec4b6;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-weight: 700;
            font-size: 1.05rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        .btn-success-sim:hover {
            background-color: #249d92;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(46, 196, 182, 0.3);
            color: white;
        }
        .btn-cancel-sim {
            background-color: #f1f3f9;
            color: #495057;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            text-align: center;
            display: inline-block;
            text-decoration: none;
        }
        .btn-cancel-sim:hover {
            background-color: #e2e6f0;
            color: #212529;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <!-- ===== HEADER NAVIGATION ===== -->
    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5 flex-grow-1">
        <div class="row justify-content-center">
            <div class="col-xl-9 col-lg-10">
                <div class="gateway-card">
                    <div class="gateway-header d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold mb-1"><i class="fas fa-shield-alt me-2"></i>CỔNG THANH TOÁN ĐIỆN TỬ VNPAY</h4>
                            <p class="mb-0 opacity-75 small">Môi trường giả lập thanh toán an toàn dành cho dự án Bus Hà Nội</p>
                        </div>
                        <img class="vnpay-logo bg-white p-2 rounded-3" src="https://vnpay.vn/wp-content/uploads/2020/07/Logo-VNPAY.svg" alt="VNPAY Logo" onerror="this.src='https://sandbox.vnpayment.vn/paymentv2/images/licenses/logo-vnpay.png'" />
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        <div class="row g-4">
                            <!-- Cột trái: Thông tin đơn hàng -->
                            <div class="col-md-6 border-end pe-md-4">
                                <h5 class="fw-bold text-primary mb-4"><i class="fas fa-file-invoice-dollar me-2"></i>Thông tin đơn hàng</h5>
                                
                                <div class="bg-light p-3 rounded-4 mb-4">
                                    <div class="info-row">
                                        <span class="info-label">Mã đơn hàng (TxnRef)</span>
                                        <span class="info-value text-dark">${vnpParams.vnp_TxnRef}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Số tiền thanh toán</span>
                                        <span class="info-value text-danger fs-5 fw-bold">
                                            <fmt:formatNumber value="${displayAmount}" pattern="#,###"/> đ
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Nội dung thanh toán</span>
                                        <span class="info-value text-muted text-end small" style="max-width: 60%;">${vnpParams.vnp_OrderInfo}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Terminal Code</span>
                                        <span class="info-value">${vnpParams.vnp_TmnCode}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Nhà cung cấp</span>
                                        <span class="info-value text-primary">VNPAY GATEWAY (TEST)</span>
                                    </div>
                                </div>
                                
                                <div class="alert alert-info border-0 rounded-3 shadow-sm small d-flex align-items-start gap-2">
                                    <i class="fas fa-info-circle mt-1"></i>
                                    <div>
                                        Đây là cổng thanh toán mô phỏng được tích hợp trực tiếp để demo dự án. Toàn bộ giao dịch đều là giả lập và không phát sinh chi phí thực tế.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Cột phải: Quét mã QR & Chọn kết quả -->
                            <div class="col-md-6 ps-md-4 text-center">
                                <h5 class="fw-bold text-primary mb-4 text-start"><i class="fas fa-qrcode me-2"></i>Quét mã QR để thanh toán</h5>
                                
                                <div class="qr-wrapper mb-4">
                                    <c:url var="qrUrl" value="https://api.qrserver.com/v1/create-qr-code/">
                                        <c:param name="size" value="200x200" />
                                        <c:param name="data" value="VNPAY SIMULATOR - TXN ${vnpParams.vnp_TxnRef} - AMOUNT ${displayAmount}đ" />
                                    </c:url>
                                    <img src="${qrUrl}" alt="Mã QR mô phỏng thanh toán" style="width: 180px; height: 180px; object-fit: contain;" />
                                </div>
                                
                                <p class="text-muted small mb-4">
                                    Mô phỏng quét mã QR thành công bằng cách chọn một trong hai phương thức hành động bên dưới:
                                </p>
                                
                                <div class="d-flex flex-column gap-3">
                                    <!-- Form submit thành công -->
                                    <form action="${pageContext.request.contextPath}/vnpay-return" method="GET">
                                        <c:forEach var="entry" items="${successFields}">
                                            <input type="hidden" name="${entry.key}" value="${entry.value}">
                                        </c:forEach>
                                        <input type="hidden" name="vnp_SecureHash" value="${successHash}">
                                        <button type="submit" class="btn btn-success-sim">
                                            <i class="fas fa-check-circle me-2"></i>XÁC NHẬN THANH TOÁN THÀNH CÔNG
                                        </button>
                                    </form>
                                    
                                    <!-- Form submit hủy giao dịch -->
                                    <form action="${pageContext.request.contextPath}/vnpay-return" method="GET">
                                        <c:forEach var="entry" items="${cancelFields}">
                                            <input type="hidden" name="${entry.key}" value="${entry.value}">
                                        </c:forEach>
                                        <input type="hidden" name="vnp_SecureHash" value="${cancelHash}">
                                        <button type="submit" class="btn btn-cancel-sim">
                                            <i class="fas fa-times-circle me-2"></i>HỦY BỎ GIAO DỊCH
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
