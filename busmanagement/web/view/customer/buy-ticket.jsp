<%-- 
    Document   : buy-ticket
    Created on : Jun 27, 2026, 8:18:43 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đăng ký dịch vụ vé - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
            --bg-light: #f8f9fa;
        }
        body { 
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
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }
        
        /* Thiết kế hóa đơn dạng Vé xe Bus chuyên nghiệp */
        .ticket-container {
            max-width: 500px;
            margin: 0 auto;
        }
        .ticket-card {
            background: white;
            border-radius: 16px;
            border: 2px dashed #ced4da;
            position: relative;
            overflow: hidden;
        }
        .ticket-header {
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            color: white;
            padding: 24px;
            text-align: center;
        }
        .ticket-body { 
            padding: 28px; 
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px dashed #e9ecef;
        }
        .info-row:last-of-type { 
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
        
        /* Tạo vết răng cưa hai bên hông vé cho giống vé thật */
        .ticket-card::before, .ticket-card::after {
            content: '';
            position: absolute;
            top: 75px;
            width: 20px;
            height: 20px;
            background-color: var(--bg-light);
            border-radius: 50%;
            z-index: 3;
        }
        .ticket-card::before { left: -10px; }
        .ticket-card::after { right: -10px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                🚌 Bus <span>Hà Nội</span>
            </a>
            <div class="collapse navbar-collapse" id="navMenu">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/guide">Hướng dẫn</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item text-white fw-semibold">
                        <i class="fas fa-user-circle me-1"></i> Chào, ${sessionScope.USER.fullName}
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="ticket-container">
            
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card ticket-card shadow-sm">
                <div class="ticket-header">
                    <h5 class="fw-bold m-0 text-uppercase tracking-wide">
                        <c:choose>
                            <c:when test="${ticketType == 'thang'}">
                                <i class="fas fa-id-card me-2"></i> Đăng ký vé tháng
                            </c:when>
                            <c:when test="${ticketType == 'lien_chuyen'}">
                                <i class="fas fa-route me-2"></i> Đăng ký vé liên chuyến
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-ticket-alt me-2"></i> Mua vé lượt trực tuyến
                            </c:otherwise>
                        </c:choose>
                    </h5>
                </div>

                <div class="ticket-body">
                    
                    <c:if test="${ticketType != 'lien_chuyen'}">
                        <div class="info-row">
                            <span class="info-label">Mã số tuyến:</span>
                            <span class="info-value text-primary">Tuyến ${route.routeNumber}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Tên lộ trình:</span>
                            <span class="info-value text-end text-truncate" style="max-width: 65%;" title="${route.routeName}">
                                ${route.routeName}
                            </span>
                        </div>
                    </c:if>
                    
                    <c:if test="${ticketType == 'lien_chuyen'}">
                        <div class="info-row">
                            <span class="info-label">Phạm vi áp dụng:</span>
                            <span class="info-value text-success">Toàn mạng lưới xe buýt</span>
                        </div>
                    </c:if>

                    <div class="info-row">
                        <span class="info-label">Loại dịch vụ:</span>
                        <span class="info-value text-dark">
                            <c:choose>
                                <c:when test="${ticketType == 'thang'}">Vé tháng (1 Tuyến)</c:when>
                                <c:when test="${ticketType == 'lien_chuyen'}">Vé tháng liên tuyến</c:when>
                                <c:otherwise>Vé lượt tiêu chuẩn</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Ngày giao dịch:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${currentDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>

                    <c:set var="basePrice" value="${ticketType == 'luot' ? route.ticketPrice : (ticketType == 'thang' ? 100000 : 200000)}" />
                    <div class="info-row align-items-center mt-4 pt-3 border-top border-2">
                        <span class="info-label fw-bold text-dark fs-6">Tổng chi phí:</span>

                        <span class="info-value text-success fs-3 fw-bold">
                            <fmt:formatNumber value="${displayPrice}" pattern="#,###"/> đ
                        <span class="info-value text-success fs-3 fw-bold" id="priceDisplay">
                            <fmt:formatNumber value="${basePrice}" pattern="#,###"/> đ
                        </span>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer/buy-ticket" method="POST" class="mt-4 needs-validation" novalidate>
                        <input type="hidden" name="routeId" value="${route.routeID != null ? route.routeID : 0}">
                        <input type="hidden" name="ticketType" value="${ticketType}">
                        
                        <c:if test="${ticketType == 'thang' || ticketType == 'lien_chuyen'}">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary small">ĐỐI TƯỢNG ĐĂNG KÝ VÉ THÁNG</label>
                                <select name="passTypeId" class="form-select rounded-3" id="passTypeSelect" onchange="updatePrice()">
                                    <c:choose>
                                        <c:when test="${ticketType == 'thang'}">
                                            <option value="1" data-discount="50">Học sinh / Sinh viên (1 Tuyến) - Giảm 50%</option>
                                            <option value="3" data-discount="100">Người cao tuổi - Miễn phí 100%</option>
                                            <option value="4" data-discount="0">Đối tượng khác (Phổ thông) - Nguyên giá</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="2" data-discount="50">Học sinh / Sinh viên (Liên Tuyến) - Giảm 50%</option>
                                            <option value="3" data-discount="100">Người cao tuổi - Miễn phí 100%</option>
                                            <option value="4" data-discount="0">Đối tượng khác (Phổ thông) - Nguyên giá</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary small">MÃ HSSV / SỐ CCCD</label>
                                <input type="text" name="cardNumber" class="form-control rounded-3" placeholder="Nhập mã thẻ hoặc số định danh..." required>
                            </div>
                            
                            <div class="mb-3" id="proofUploadSection">
                                <label class="form-label fw-bold text-secondary small">ẢNH THẺ HSSV / CCCD (MINH CHỨNG ƯU TIÊN)</label>
                                <input type="text" name="imageProof" class="form-control rounded-3" placeholder="Dán link ảnh thẻ/minh chứng ưu tiên..." required value="https://hanoibus.vn/images/proof_default.jpg">
                                <div class="form-text small text-muted">Nhập link ảnh thẻ để nhân viên quầy kiểm tra duyệt trước khi cấp vé.</div>
                            </div>
                        </c:if>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success fw-bold py-2.5 shadow-sm rounded-3 fs-6">
                                <i class="fas fa-check-circle me-1"></i> XÁC NHẬN THANH TOÁN
                            </button>
                            <a href="${pageContext.request.contextPath}/route-list" class="btn btn-light border py-2 fw-semibold text-muted rounded-3">
                                Hủy bỏ giao dịch
                            </a>
                        </div>
                    </form>

                    <script>
                        function updatePrice() {
                            const select = document.getElementById('passTypeSelect');
                            if (!select) return;
                            const discount = parseFloat(select.options[select.selectedIndex].getAttribute('data-discount'));
                            const basePrice = ${basePrice};
                            const finalPrice = basePrice * (100 - discount) / 100;
                            
                            document.getElementById('priceDisplay').textContent = new Intl.NumberFormat('vi-VN').format(finalPrice) + ' đ';
                        }
                        
                        window.addEventListener('DOMContentLoaded', () => {
                            updatePrice();
                        });
                    </script>
                    
                </div>
            </div>
            
            <p class="text-center text-muted small mt-3">
                <i class="fas fa-shield-alt me-1 text-secondary"></i> Giao dịch bảo mật kỹ thuật số. Vé điện tử sẽ được cấp ngay sau khi xác nhận thành công.
            </p>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>