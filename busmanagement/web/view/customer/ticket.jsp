<%-- 
    Document   : ticket
    Created on : Jun 28, 2026, 10:22:50 AM
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
        <title>Quản lý vé của tôi - Bus Hà Nội</title>
        <jsp:include page="/common/head_imports.jsp" />
        <style>
            :root {
                --primary: #1a73e8;
                --primary-dark: #1557b0;
                --accent: #fbbc04;
                --bg-light: #f4f6f9;
            }
            body {
                background-color: var(--bg-light);
            }

            /* ===== NAVBAR ===== */
            .navbar {
                background: var(--primary) !important;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            .navbar-brand {
                font-weight: 700;
                font-size: 1.3rem;
                color: white !important;
            }
            .navbar-brand span {
                color: var(--accent);
            }
            .navbar-nav .nav-link {
                color: rgba(255,255,255,0.9) !important;
                font-weight: 500;
            }
            .navbar .dropdown-menu {
                border: none;
            }

            /* Style cho Tab Pills */
            .nav-pills-custom {
                background: #ffffff;
                border-radius: 12px;
                padding: 6px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            }
            .nav-pills-custom .nav-item .nav-link {
                color: #5f6368 !important;
                font-weight: 600;
                padding: 10px 24px;
                border-radius: 8px;
                transition: all 0.3s ease;
                background: transparent !important;
            }
            .nav-pills-custom .nav-item .nav-link.active {
                background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%) !important;
                color: #ffffff !important;
                box-shadow: 0 4px 10px rgba(26, 115, 232, 0.3);
            }
            .nav-pills-custom .nav-item .nav-link:hover:not(.active) {
                background-color: #f1f3f4 !important;
                color: #1a73e8 !important;
            }

            /* Custom ticket voucher card */
            .ticket-card-custom {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #e8eaed;
                overflow: hidden;
                position: relative;
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .ticket-card-custom:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                border-color: #1a73e8;
            }
            .ticket-card-header {
                background: #f8f9fa;
                padding: 16px 20px;
                border-bottom: 1px dashed #dee2e6;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .ticket-card-body {
                padding: 20px;
            }
            /* Răng cưa hai bên hông vé */
            .ticket-card-custom::before, .ticket-card-custom::after {
                content: '';
                position: absolute;
                top: 48px;
                width: 12px;
                height: 12px;
                background-color: var(--bg-light);
                border-radius: 50%;
                z-index: 2;
            }
            .ticket-card-custom::before {
                left: -6px;
            }
            .ticket-card-custom::after {
                right: -6px;
            }
            /* ===== FOOTER ===== */
            footer {
                background: #1a1a2e;
                color: rgba(255,255,255,0.7);
                padding: 30px 0;
                margin-top: 60px;
            }
            footer a {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
            }
            footer a:hover {
                color: white;
            }

            /* PAGE HEADER */
            .page-header {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
                padding: 20px 0;
                color: white;
                margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }
            .page-header h3 {
                font-size: 1.45rem;
                letter-spacing: -0.3px;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">

        <!-- ===== HEADER NAVIGATION ===== -->
        <c:set var="activePage" value="ticket" />
        <jsp:include page="/common/navbar.jsp" />

        <div class="page-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                        <h3 class="fw-bold m-0"><i class="fas fa-wallet me-2"></i>Lịch sử mua & Đăng ký dịch vụ vé</h3>
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container my-5 flex-grow-1" style="min-height: 700px;">
            <ul class="nav nav-pills nav-pills-custom mb-4">
                <li class="nav-item">
                    <a class="nav-link fw-bold py-2.5 px-4 ${activeTab eq 'ticket' ? 'active' : ''}" 
                       href="?tab=ticket">
                        <i class="fas fa-ticket-alt me-2"></i>Vé lượt
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-bold py-2.5 px-4 ${activeTab eq 'pass' ? 'active' : ''}" 
                       href="?tab=pass">
                        <i class="fas fa-id-card me-2"></i>Vé tháng
                    </a>
                </li>
            </ul>

            <div>

                <c:if test="${activeTab eq 'ticket'}">
                    <div class="row g-3">
                        <c:choose>
                            <c:when test="${empty ticketList}">
                                <div class="col-12 text-center py-5 text-muted shadow-sm bg-white rounded-3">
                                    <i class="fas fa-box-open fa-3x mb-3 text-black-50"></i>
                                    <p class="mb-3">Bạn chưa thực hiện giao dịch mua vé lượt nào.</p>
                                    <a href="${pageContext.request.contextPath}/route-list" class="btn btn-primary fw-bold px-4 py-2 rounded-3" style="background-color: var(--primary);">
                                        <i class="fas fa-search-location me-2"></i>Tìm tuyến & Mua vé ngay
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${ticketList}">
                                    <div class="col-md-4">
                                        <div class="ticket-card-custom h-100" onclick="showTicketDetails('${t.ticketCode}', '${t.routeNumber}', '${t.routeName}', '${t.purchasedAt}', '${t.status}', '${t.price}')" style="cursor: pointer;">
                                            <div class="ticket-card-header">
                                                <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 fs-7 fw-bold">${t.ticketCode}</span>
                                                <c:choose>
                                                    <c:when test="${t.status == 'UNUSED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success border-opacity-25"><i class="fas fa-check-circle me-1"></i>Chưa dùng</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'COMPLETED'}">
                                                        <span class="badge bg-secondary-subtle text-secondary"><i class="fas fa-history me-1"></i>Đã sử dụng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger"><i class="fas fa-exclamation-circle me-1"></i>${t.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="ticket-card-body">
                                                <h5 class="fw-bold text-dark mb-1">Tuyến ${t.routeNumber}</h5>
                                                <p class="text-muted small mb-3 text-truncate" title="${t.routeName}">${t.routeName}</p>
                                                <hr class="text-muted opacity-25 my-2">
                                                <div class="d-flex justify-content-between align-items-center text-secondary small mt-3">
                                                    <span>Giá vé: <strong class="text-success"><fmt:formatNumber value="${t.price}" pattern="#,###"/> đ</strong></span>
                                                    <button class="btn btn-sm btn-outline-primary py-1.5 px-3 rounded-pill fw-semibold" 
                                                            onclick="event.stopPropagation(); showTicketQR('${t.ticketCode}', '${t.routeNumber}', '${t.status}')">
                                                        <i class="fas fa-qrcode me-1"></i>Xem QR
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${activeTab eq 'pass'}">

                    <h5 class="fw-bold text-secondary mb-3 mt-2"><i class="fas fa-route me-2"></i>Vé tháng đơn tuyến</h5>
                    <div class="row g-3 mb-5">
                        <c:choose>
                            <c:when test="${empty routePassList}">
                                <div class="col-12 text-center py-5 text-muted shadow-sm bg-white rounded-3">
                                    <i class="fas fa-id-card fa-3x mb-3 text-black-50"></i>
                                    <p class="mb-3">Không tìm thấy dữ liệu đăng ký vé tháng đơn tuyến.</p>
                                    <a href="${pageContext.request.contextPath}/route-list" class="btn btn-outline-primary fw-bold px-4 py-2 rounded-3">
                                        <i class="fas fa-search me-2"></i>Chọn tuyến để đăng ký
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mp" items="${routePassList}">
                                    <div class="col-md-4">
                                        <div class="ticket-card-custom h-100" onclick="showPassDetails('${mp.passCode}', '${mp.routeName != null ? mp.routeName : 'Tuyến đơn tuyến'}', '${mp.createdAt}', '${mp.typeName}', 'Hà Nội', 'Vé tháng', '${mp.routeName != null ? 'Vé tháng đơn tuyến' : 'Vé tháng toàn mạng'}', '1 chu kỳ (30 ngày)', 'Xe buýt', '${mp.routeNumber != null ? 'Đơn tuyến' : 'Toàn mạng'}', '${mp.startDate} đến ${mp.endDate}', '${pageContext.request.contextPath}/${mp.imageProof}', 'Cổng thanh toán điện tử VNPAY', 'Miễn phí', '${mp.price}')" style="cursor: pointer;">
                                            <div class="ticket-card-header">
                                                <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 fs-7 fw-bold">${mp.passCode}</span>
                                                <c:choose>
                                                    <c:when test="${mp.status == 'APPROVED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success border-opacity-25"><i class="fas fa-check-circle me-1"></i>Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${mp.status == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning border-opacity-25"><i class="fas fa-clock me-1"></i>Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger"><i class="fas fa-times-circle me-1"></i>Từ chối</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="ticket-card-body">
                                                <h5 class="fw-bold text-dark mb-1">Tuyến ${mp.routeNumber}</h5>
                                                <p class="text-muted small mb-3 text-truncate" title="${mp.routeName}">${mp.routeName}</p>
                                                
                                                <div class="bg-light p-2.5 rounded-3 small text-secondary mb-3">
                                                    <div class="mb-1 d-flex justify-content-between">
                                                        <span>Đối tượng:</span>
                                                        <strong class="text-dark">${mp.typeName}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between">
                                                        <span>Hiệu lực:</span>
                                                        <strong class="text-dark">${mp.startDate} đến ${mp.endDate}</strong>
                                                    </div>
                                                </div>

                                                <c:if test="${not empty mp.imageProof}">
                                                    <button class="btn btn-sm btn-outline-info w-100 mb-3 fw-semibold py-1.5" 
                                                            onclick="event.stopPropagation(); showProofImage('${pageContext.request.contextPath}/${mp.imageProof}')">
                                                        <i class="fas fa-image me-1"></i>Ảnh giấy tờ đã nộp
                                                    </button>
                                                </c:if>
                                                
                                                <hr class="text-muted opacity-25 my-2">
                                                
                                                <div class="d-flex justify-content-between align-items-center text-secondary small mt-3">
                                                    <span>Giá vé: <strong class="text-success"><fmt:formatNumber value="${mp.price}" pattern="#,###"/> đ</strong></span>
                                                    <c:if test="${(mp.status == 'APPROVED' or mp.status == 'EXPIRED') and not empty mp.qrCodeToken}">
                                                         <button class="btn btn-sm btn-outline-success py-1.5 px-3 rounded-pill fw-semibold" 
                                                                 onclick="event.stopPropagation(); showQRCode('${mp.qrCodeToken}', '${mp.status}', 'Tuyến ${mp.routeNumber}')">
                                                             <i class="fas fa-qrcode me-1"></i>Xem QR
                                                         </button>
                                                     </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h5 class="fw-bold text-secondary mb-3"><i class="fas fa-globe me-2"></i>Vé tháng toàn mạng</h5>
                    <div class="row g-3">
                        <c:choose>
                            <c:when test="${empty allRoutePassList}">
                                <div class="col-12 text-center py-5 text-muted shadow-sm bg-white rounded-3">
                                    <i class="fas fa-globe fa-3x mb-3 text-black-50"></i>
                                    <p class="mb-3">Không tìm thấy dữ liệu đăng ký vé tháng toàn mạng lưới.</p>
                                    <a href="${pageContext.request.contextPath}/customer/buy-ticket?routeId=0&ticketType=lien_chuyen" class="btn btn-success fw-bold px-4 py-2 rounded-3">
                                        <i class="fas fa-check-circle me-2"></i>Đăng ký vé tháng ngay
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="amp" items="${allRoutePassList}">
                                    <div class="col-md-4">
                                        <div class="ticket-card-custom h-100" onclick="showPassDetails('${amp.passCode}', 'Toàn mạng lưới xe buýt', '${amp.createdAt}', '${amp.typeName}', 'Hà Nội', 'Vé tháng', 'Vé tháng toàn mạng', '1 chu kỳ (30 ngày)', 'Xe buýt', 'Toàn mạng', '${amp.startDate} đến ${amp.endDate}', '${pageContext.request.contextPath}/${amp.imageProof}', 'Cổng thanh toán điện tử VNPAY', 'Miễn phí', '${amp.price}')" style="cursor: pointer;">
                                            <div class="ticket-card-header">
                                                <span class="badge bg-success-subtle text-success border border-success border-opacity-25 fs-7 fw-bold">${amp.passCode}</span>
                                                <c:choose>
                                                    <c:when test="${amp.status == 'APPROVED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success border-opacity-25"><i class="fas fa-check-circle me-1"></i>Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${amp.status == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning border-opacity-25"><i class="fas fa-clock me-1"></i>Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger"><i class="fas fa-times-circle me-1"></i>Từ chối</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="ticket-card-body">
                                                <h5 class="text-success fw-bold mb-1"><i class="fas fa-bus me-1"></i>Vé liên tuyến</h5>
                                                <p class="text-muted small mb-3 text-truncate" title="Toàn bộ mạng lưới xe bus nội đô Hà Nội">Toàn bộ mạng lưới xe bus Hà Nội</p>
                                                
                                                <div class="bg-light p-2.5 rounded-3 small text-secondary mb-3">
                                                    <div class="mb-1 d-flex justify-content-between">
                                                        <span>Đối tượng:</span>
                                                        <strong class="text-dark">${amp.typeName}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between">
                                                        <span>Hiệu lực:</span>
                                                        <strong class="text-dark">${amp.startDate} đến ${amp.endDate}</strong>
                                                    </div>
                                                </div>

                                                <c:if test="${not empty amp.imageProof}">
                                                    <button class="btn btn-sm btn-outline-info w-100 mb-3 fw-semibold py-1.5" 
                                                            onclick="event.stopPropagation(); showProofImage('${pageContext.request.contextPath}/${amp.imageProof}')">
                                                        <i class="fas fa-image me-1"></i>Ảnh giấy tờ đã nộp
                                                    </button>
                                                </c:if>
                                                
                                                <hr class="text-muted opacity-25 my-2">
                                                
                                                <div class="d-flex justify-content-between align-items-center text-secondary small mt-3">
                                                    <span>Giá vé: <strong class="text-success"><fmt:formatNumber value="${amp.price}" pattern="#,###"/> đ</strong></span>
                                                    <c:if test="${(amp.status == 'APPROVED' or amp.status == 'EXPIRED') and not empty amp.qrCodeToken}">
                                                        <button class="btn btn-sm btn-outline-success py-1.5 px-3 rounded-pill fw-semibold" 
                                                                onclick="event.stopPropagation(); showQRCode('${amp.qrCodeToken}', '${amp.status}', 'Toàn mạng')">
                                                            <i class="fas fa-qrcode me-1"></i>Xem QR
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

            </div>
        </div>

        <!-- Bootstrap Modal for ticket QR -->
        <div class="modal fade" id="ticketQRModal" tabindex="-1" aria-labelledby="ticketQRModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 380px;">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-secondary" id="ticketQRModalLabel">MÃ VÉ CHI TIẾT</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center pt-2">
                        <div class="bg-light p-3 rounded-4 mb-3 d-inline-block">
                            <img id="modalQRImage" src="" alt="Mã QR soát vé" style="width: 220px; height: 220px; object-fit: contain;" />
                        </div>
                        <h4 class="fw-bold text-primary mb-1" id="modalTicketCode"></h4>
                        <p class="text-secondary small mb-3">Tuyến: <span id="modalRouteNumber" class="fw-bold"></span></p>
                        <div class="badge px-3 py-2 fs-6 mb-2" id="modalTicketStatus"></div>
                        <p class="text-muted small mt-3 mb-1"><i class="fas fa-info-circle me-1"></i>Đưa mã này cho phụ xe quét khi lên xe bus.</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showTicketQR(ticketCode, routeNumber, status) {
                document.getElementById('modalTicketCode').innerText = ticketCode;
                document.getElementById('modalRouteNumber').innerText = "Tuyến " + routeNumber;

                const statusBadge = document.getElementById('modalTicketStatus');
                let statusText = status;
                if (status === 'UNUSED') {
                    statusText = 'Chưa dùng';
                } else if (status === 'CHECKED_IN') {
                    statusText = 'Đã lên xe';
                } else if (status === 'COMPLETED') {
                    statusText = 'Đã sử dụng';
                }
                statusBadge.innerText = statusText;
                
                statusBadge.className = "badge px-3 py-2 fs-6 mb-2";
                if (status === 'UNUSED') {
                    statusBadge.classList.add('bg-success');
                } else if (status === 'CHECKED_IN') {
                    statusBadge.classList.add('bg-primary');
                } else if (status === 'COMPLETED') {
                    statusBadge.classList.add('bg-secondary');
                } else {
                    statusBadge.classList.add('bg-danger');
                }

                const qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=" + encodeURIComponent(ticketCode);
                document.getElementById('modalQRImage').src = qrUrl;

                const myModal = new bootstrap.Modal(document.getElementById('ticketQRModal'));
                myModal.show();
            }
        </script>
        <div class="modal fade" id="customerProofModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4 overflow-hidden">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-secondary">Giấy tờ chứng minh đã nộp</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center p-3 bg-light">
                        <img id="customerModalImg" src="" class="img-fluid rounded shadow-sm w-100 mb-3" style="max-height: 55vh; object-fit: contain;" onerror="handleImageError(this)">
                        
                        <div id="imageErrorMsg" class="alert alert-warning d-none text-start small mb-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Tệp ảnh minh chứng của vé này không tồn tại trên máy chủ (có thể đã bị xóa khi Clean & Build).
                        </div>
                        
                        <c:set var="avatarUrl" value="${sessionScope.USER.avatar}" />
                        <c:if test="${not empty avatarUrl}">
                            <c:if test="${not avatarUrl.startsWith('http')}">
                                <c:set var="avatarUrl" value="${pageContext.request.contextPath}/${avatarUrl}" />
                            </c:if>
                            <div class="border-top pt-3 text-start">
                                <span class="d-block small text-muted mb-1"><i class="fas fa-info-circle me-1"></i>Sử dụng giấy tờ đã tải lên ở mục hồ sơ cá nhân trước đó:</span>
                                <a id="profileAvatarLink" href="${avatarUrl}" target="_blank" class="btn btn-sm btn-outline-primary fw-semibold rounded-pill px-3 mt-1">
                                    <i class="fas fa-external-link-alt me-1"></i>Xem ảnh từ Hồ sơ cá nhân
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function showProofImage(imgUrl) {
                let cleanUrl = imgUrl;
                // Nếu là chuỗi Base64 gửi kèm context path dư thừa, cắt bỏ để chạy chính xác
                if (imgUrl.includes('data:image/')) {
                    cleanUrl = imgUrl.substring(imgUrl.indexOf('data:image/'));
                }
                
                // Ẩn thông báo lỗi trước đó
                document.getElementById('imageErrorMsg').classList.add('d-none');
                
                document.getElementById('customerModalImg').src = cleanUrl;
                var proofModal = new bootstrap.Modal(document.getElementById('customerProofModal'));
                proofModal.show();
            }

            function handleImageError(imgElement) {
                // Hiển thị hộp thông báo lỗi chi tiết
                document.getElementById('imageErrorMsg').classList.remove('d-none');
                // Gán ảnh placeholder để UI gọn gàng, tránh vỡ khung hình
                imgElement.src = "https://placehold.co/600x400/e9ecef/495057?text=Anh+Minh+Chung+Khong+Ton+Tai";
            }
        </script>
        <!-- Modal hiển thị QR Code cho vé tháng -->
        <div class="modal fade" id="qrCodeModal" tabindex="-1" aria-labelledby="qrCodeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 380px;">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-secondary" id="qrCodeModalLabel">MÃ VÉ CHI TIẾT</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center pt-2">
                        <div class="bg-light p-3 rounded-4 mb-3 d-inline-block">
                            <img id="qrImage" src="" alt="Mã QR soát vé" style="width: 220px; height: 220px; object-fit: contain;" />
                        </div>
                        <h4 class="fw-bold text-primary mb-1" id="qrText"></h4>
                        <p class="text-secondary small mb-3">Tuyến: <span id="qrRouteNumber" class="fw-bold"></span></p>
                        <div class="badge px-3 py-2 fs-6 mb-2" id="qrStatusBadge"></div>
                        <p class="text-danger small mt-2" id="qrWarning" style="display: none;">Vé đã hết hạn, không thể sử dụng!</p>
                        <p class="text-muted small mt-3 mb-1"><i class="fas fa-info-circle me-1"></i>Đưa mã này cho phụ xe quét khi lên xe bus.</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showQRCode(codeData, status, routeInfo) {
                // Sử dụng api.qrserver.com thay cho Google Charts đã bị khai tử
                var qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=" + encodeURIComponent(codeData);

                document.getElementById('qrImage').src = qrUrl;
                document.getElementById('qrText').innerText = codeData;
                document.getElementById('qrRouteNumber').innerText = routeInfo || 'Toàn mạng';

                const statusBadge = document.getElementById('qrStatusBadge');
                statusBadge.innerText = (status === 'APPROVED' ? 'Hoạt động' : (status === 'EXPIRED' ? 'Hết hạn' : status));
                statusBadge.className = "badge px-3 py-2 fs-6 mb-2";
                if (status === 'APPROVED') {
                    statusBadge.classList.add('bg-success');
                } else if (status === 'EXPIRED') {
                    statusBadge.classList.add('bg-danger');
                } else {
                    statusBadge.classList.add('bg-secondary');
                }

                // Hiện cảnh báo nếu vé hết hạn (EXPIRED)
                if (status === 'EXPIRED') {
                    document.getElementById('qrWarning').style.display = 'block';
                } else {
                    document.getElementById('qrWarning').style.display = 'none';
                }

                var qrModal = new bootstrap.Modal(document.getElementById('qrCodeModal'));
                qrModal.show();
            }
        </script>

        <!-- Modal chi tiết đăng ký vé tháng -->
        <div class="modal fade" id="passDetailsModal" tabindex="-1" aria-labelledby="passDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow rounded-4 overflow-hidden">
                    <div class="modal-header bg-primary text-white border-0 py-3">
                        <h5 class="modal-title fw-bold" id="passDetailsModalLabel">
                            <i class="fas fa-info-circle me-2"></i>Chi tiết đăng ký vé tháng
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4 bg-light">
                        <div class="row g-4">
                            <!-- Cột trái: Thông tin chi tiết -->
                            <div class="col-md-7">
                                <div class="card border-0 shadow-sm rounded-3 p-3 bg-white h-100">
                                    <h6 class="fw-bold text-primary border-bottom pb-2 mb-3">
                                        <i class="fas fa-id-card me-2"></i>Thông tin đăng ký thẻ
                                    </h6>
                                    <div class="d-flex flex-column gap-2 small">
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Mã đăng ký:</span>
                                            <strong class="text-dark" id="detailPassCode"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Mã đơn hàng:</span>
                                            <strong class="text-dark" id="detailOrderCode"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Tên vé:</span>
                                            <strong class="text-dark" id="detailTicketName"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Thời gian tạo:</span>
                                            <strong class="text-dark" id="detailCreatedAt"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Đối tượng:</span>
                                            <strong class="text-dark" id="detailTypeName"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Địa chỉ:</span>
                                            <strong class="text-dark" id="detailAddress"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Loại thẻ:</span>
                                            <strong class="text-dark" id="detailCardType"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Số chu kỳ:</span>
                                            <strong class="text-dark" id="detailCycle"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Loại hình phương tiện:</span>
                                            <strong class="text-dark" id="detailVehicleType"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Loại tuyến:</span>
                                            <strong class="text-dark" id="detailRouteType"></strong>
                                        </div>
                                        <div class="d-flex justify-content-between border-bottom pb-2">
                                            <span class="text-muted">Thời gian sử dụng:</span>
                                            <strong class="text-dark" id="detailValidity"></strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Cột phải: Thanh toán và Ảnh minh chứng -->
                            <div class="col-md-5">
                                <div class="d-flex flex-column gap-3 h-100">
                                    <!-- Block thanh toán -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                        <h6 class="fw-bold text-success border-bottom pb-2 mb-3">
                                            <i class="fas fa-wallet me-2"></i>Thanh toán
                                        </h6>
                                        <div class="d-flex flex-column gap-2 small">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Phương thức:</span>
                                                <strong class="text-dark" id="detailPaymentMethod"></strong>
                                            </div>
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Phí phát hành thẻ:</span>
                                                <strong class="text-success" id="detailIssuanceFee"></strong>
                                            </div>
                                            <div class="d-flex justify-content-between border-top pt-2">
                                                <span class="text-muted fw-bold">Phí mua vé:</span>
                                                <strong class="text-danger fs-5" id="detailPrice"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Block ảnh minh chứng -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white flex-grow-1 text-center">
                                        <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3 text-start">
                                            <i class="fas fa-image me-2"></i>Ảnh đăng ký
                                        </h6>
                                        <div class="bg-light p-2 rounded border" style="min-height: 120px; display: flex; align-items: center; justify-content: center;">
                                            <img id="detailImageProof" src="" class="img-fluid rounded" style="max-height: 180px; object-fit: contain; width: 100%;" onerror="this.src='https://placehold.co/300x200/e9ecef/495057?text=Khong+co+anh+minh+chung'">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showPassDetails(passCode, ticketName, createdAt, typeName, address, cardType, ticketTypeName, cycle, vehicleType, routeType, validity, imgUrl, paymentMethod, issuanceFee, price) {
                document.getElementById('detailPassCode').innerText = passCode;
                document.getElementById('detailOrderCode').innerText = passCode;
                document.getElementById('detailTicketName').innerText = ticketName;
                document.getElementById('detailCreatedAt').innerText = createdAt || 'Chưa cập nhật';
                document.getElementById('detailTypeName').innerText = typeName;
                document.getElementById('detailAddress').innerText = address;
                document.getElementById('detailCardType').innerText = cardType;
                document.getElementById('detailCycle').innerText = cycle;
                document.getElementById('detailVehicleType').innerText = vehicleType;
                document.getElementById('detailRouteType').innerText = routeType;
                document.getElementById('detailValidity').innerText = validity;
                
                document.getElementById('detailPaymentMethod').innerText = paymentMethod;
                document.getElementById('detailIssuanceFee').innerText = issuanceFee;
                
                // Định dạng tiền tệ
                const numericPrice = parseFloat(price);
                if (!isNaN(numericPrice)) {
                    document.getElementById('detailPrice').innerText = new Intl.NumberFormat('vi-VN').format(numericPrice) + ' đ';
                } else {
                    document.getElementById('detailPrice').innerText = price;
                }
                
                // Gắn ảnh minh chứng
                let cleanUrl = imgUrl;
                if (imgUrl.includes('data:image/')) {
                    cleanUrl = imgUrl.substring(imgUrl.indexOf('data:image/'));
                }
                document.getElementById('detailImageProof').src = cleanUrl;
                
                var passModal = new bootstrap.Modal(document.getElementById('passDetailsModal'));
                passModal.show();
            }

            function showTicketDetails(ticketCode, routeNumber, routeName, purchasedAt, status, price) {
                document.getElementById('detailTicketCode').innerText = ticketCode;
                document.getElementById('detailTicketRoute').innerText = "Tuyến " + routeNumber + " - " + routeName;
                
                // Định dạng thời gian mua đẹp mắt
                let cleanDate = (purchasedAt || '').replace('T', ' ').substring(0, 19);
                document.getElementById('detailTicketPurchasedAt').innerText = cleanDate || 'Chưa cập nhật';
                
                const statusBadge = document.getElementById('detailTicketStatus');
                let statusText = status;
                if (status === 'UNUSED') {
                    statusText = 'Chưa dùng';
                } else if (status === 'CHECKED_IN') {
                    statusText = 'Đã lên xe';
                } else if (status === 'COMPLETED') {
                    statusText = 'Đã sử dụng';
                }
                statusBadge.innerText = statusText;

                statusBadge.className = "badge px-3 py-2 fs-6 mb-0";
                if (status === 'UNUSED') {
                    statusBadge.classList.add('bg-success');
                } else if (status === 'CHECKED_IN') {
                    statusBadge.classList.add('bg-primary');
                } else if (status === 'COMPLETED') {
                    statusBadge.classList.add('bg-secondary');
                } else {
                    statusBadge.classList.add('bg-danger');
                }
                
                const numericPrice = parseFloat(price);
                if (!isNaN(numericPrice)) {
                    document.getElementById('detailTicketPrice').innerText = new Intl.NumberFormat('vi-VN').format(numericPrice) + ' đ';
                } else {
                    document.getElementById('detailTicketPrice').innerText = price;
                }
                
                var detailsModal = new bootstrap.Modal(document.getElementById('ticketDetailsModal'));
                detailsModal.show();
            }
        </script>

        <!-- Modal chi tiết vé lượt trực tuyến -->
        <div class="modal fade" id="ticketDetailsModal" tabindex="-1" aria-labelledby="ticketDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4 overflow-hidden">
                    <div class="modal-header bg-primary text-white border-0 py-3">
                        <h5 class="modal-title fw-bold" id="ticketDetailsModalLabel">
                            <i class="fas fa-info-circle me-2"></i>Chi tiết vé lượt trực tuyến
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4 bg-light">
                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white mb-3">
                            <h6 class="fw-bold text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-ticket-alt me-2"></i>Thông tin vé lượt
                            </h6>
                            <div class="d-flex flex-column gap-2 small">
                                <div class="d-flex justify-content-between border-bottom pb-2 align-items-center">
                                    <span class="text-muted">Mã vé:</span>
                                    <strong class="text-dark" id="detailTicketCode"></strong>
                                </div>
                                <div class="d-flex justify-content-between border-bottom pb-2 align-items-center">
                                    <span class="text-muted">Tuyến áp dụng:</span>
                                    <strong class="text-dark text-end" id="detailTicketRoute" style="max-width: 70%;"></strong>
                                </div>
                                <div class="d-flex justify-content-between border-bottom pb-2 align-items-center">
                                    <span class="text-muted">Thời gian mua:</span>
                                    <strong class="text-dark" id="detailTicketPurchasedAt"></strong>
                                </div>
                                <div class="d-flex justify-content-between border-bottom pb-2 align-items-center">
                                    <span class="text-muted">Trạng thái:</span>
                                    <span class="badge" id="detailTicketStatus"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                            <h6 class="fw-bold text-success border-bottom pb-2 mb-3">
                                <i class="fas fa-wallet me-2"></i>Thanh toán
                            </h6>
                            <div class="d-flex flex-column gap-2 small">
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted">Phương thức:</span>
                                    <strong class="text-dark">Thanh toán trực tuyến (VNPAY)</strong>
                                </div>
                                <div class="d-flex justify-content-between border-top pt-2 align-items-center">
                                    <span class="text-muted fw-bold">Tổng thanh toán:</span>
                                    <strong class="text-danger fs-5" id="detailTicketPrice"></strong>
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