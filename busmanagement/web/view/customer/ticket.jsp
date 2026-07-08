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
                --primary: #0d47a1;
                --primary-light: #1565c0;
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
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">

        <!-- ===== HEADER NAVIGATION ===== -->
        <c:set var="activePage" value="ticket" />
        <jsp:include page="/common/navbar.jsp" />

        <div class="container my-5 flex-grow-1" style="min-height: 700px;">
            <div class="d-flex align-items-center mb-4">
                <h3 class="fw-bold text-secondary m-0">
                    <i class="fas fa-wallet me-2 text-primary"></i>Lịch sử mua & Đăng ký dịch vụ vé
                </h3>
            </div>

            <ul class="nav nav-pills nav-pills-custom mb-4">
                <li class="nav-item">
                    <a class="nav-link fw-bold py-2.5 px-4 ${activeTab eq 'ticket' ? 'active' : ''}" 
                       href="?tab=ticket">
                        <i class="fas fa-ticket-alt me-2"></i>Vé lượt trực tuyến
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-bold py-2.5 px-4 ${activeTab eq 'pass' ? 'active' : ''}" 
                       href="?tab=pass">
                        <i class="fas fa-id-card me-2"></i>Vé tháng (Cố định & Liên tuyến)
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
                                        <div class="ticket-card-custom h-100">
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
                                                            onclick="showTicketQR('${t.ticketCode}', '${t.routeNumber}', '${t.status}')">
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

                    <h5 class="fw-bold text-secondary mb-3 mt-2"><i class="fas fa-route me-2"></i>Vé tháng tuyến cố định</h5>
                    <div class="row g-3 mb-5">
                        <c:choose>
                            <c:when test="${empty routePassList}">
                                <div class="col-12 text-center py-5 text-muted shadow-sm bg-white rounded-3">
                                    <i class="fas fa-id-card fa-3x mb-3 text-black-50"></i>
                                    <p class="mb-3">Không tìm thấy dữ liệu đăng ký vé tháng của tuyến cố định.</p>
                                    <a href="${pageContext.request.contextPath}/route-list" class="btn btn-outline-primary fw-bold px-4 py-2 rounded-3">
                                        <i class="fas fa-search me-2"></i>Chọn tuyến để đăng ký
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mp" items="${routePassList}">
                                    <div class="col-md-4">
                                        <div class="ticket-card-custom h-100">
                                            <div class="ticket-card-header" style="border-bottom-color: #dee2e6;">
                                                <span class="fw-bold text-primary fs-7"><i class="fas fa-id-card me-1"></i>${mp.passCode}</span>
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
                                                <h6 class="text-dark fw-bold mb-1">Tuyến áp dụng: ${mp.routeNumber}</h6>
<<<<<<< HEAD
                                                <p class="small text-muted text-truncate mb-3">${mp.routeName}</p>
                                                <div class="bg-light p-2 rounded-2 small text-secondary">
                                                    <div class="mb-1"><strong>Đối tượng:</strong> <span class="text-dark">${mp.typeName}</span></div>
                                                    <div><strong>Hiệu lực:</strong> <span class="text-dark">${mp.startDate} đến ${mp.endDate}</span></div>             
                                                </div>
                                                <c:if test="${not empty mp.imageProof}">
                                                    <button class="btn btn-sm btn-outline-info w-100 mt-2 fw-semibold" 
                                                            onclick="showProofImage('${pageContext.request.contextPath}/${mp.imageProof}')">
                                                        <i class="fas fa-image me-1"></i>Ảnh giấy tờ đã nộp
                                                    </button>
                                                </c:if>
                                                <c:if test="${(mp.status == 'APPROVED' or mp.status == 'EXPIRED') and not empty mp.qrCodeToken}">
                                                    <button class="btn btn-sm btn-outline-success w-100 mt-2 fw-semibold" 
                                                            onclick="showQRCode('${mp.qrCodeToken}', '${mp.status}')">
                                                        <i class="fas fa-qrcode me-1"></i>Mã QR Check-in
                                                    </button>
                                                </c:if>
=======
                                                <p class="small text-muted text-truncate mb-3" title="${mp.routeName}">${mp.routeName}</p>
                                                <div class="bg-light p-3 rounded-3 small text-secondary mb-3">
                                                    <div class="mb-2 d-flex justify-content-between">
                                                        <span>Đối tượng:</span>
                                                        <strong class="text-dark">${mp.typeName}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between">
                                                        <span>Hiệu lực:</span>
                                                        <strong class="text-dark">${mp.startDate} đến ${mp.endDate}</strong>
                                                    </div>             
                                                </div>
                                                <div class="d-flex flex-column gap-2">
                                                    <c:if test="${not empty mp.imageProof}">
                                                        <button class="btn btn-sm btn-outline-secondary w-100 fw-semibold rounded-pill" 
                                                                onclick="showProofImage('${pageContext.request.contextPath}/${mp.imageProof}')">
                                                            <i class="fas fa-image me-1"></i>Ảnh giấy tờ đã nộp
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${mp.status == 'APPROVED' && not empty mp.qrCodeToken}">
                                                        <div class="mt-1 text-primary fw-semibold small bg-primary bg-opacity-10 p-2 rounded-2 border border-primary border-opacity-25 text-center">
                                                            <i class="fas fa-qrcode me-1"></i>Token soát vé:<br>
                                                            <strong class="text-dark" style="font-size: 0.7rem; letter-spacing: 0.5px; word-break: break-all;">${mp.qrCodeToken}</strong>
                                                        </div>
                                                    </c:if>
                                                </div>
>>>>>>> ffd2518946857c03765639a0b3387d3a48d1fd3d
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h5 class="fw-bold text-secondary mb-3"><i class="fas fa-globe me-2"></i>Vé tháng liên tuyến</h5>
                    <div class="row g-3">
                        <c:choose>
                            <c:when test="${empty allRoutePassList}">
                                <div class="col-12 text-center py-5 text-muted shadow-sm bg-white rounded-3">
                                    <i class="fas fa-globe fa-3x mb-3 text-black-50"></i>
                                    <p class="mb-3">Không tìm thấy dữ liệu đăng ký vé tháng liên tuyến toàn mạng lưới.</p>
                                    <a href="${pageContext.request.contextPath}/customer/buy-ticket?routeId=0&ticketType=lien_chuyen" class="btn btn-success fw-bold px-4 py-2 rounded-3">
                                        <i class="fas fa-check-circle me-2"></i>Đăng ký vé liên tuyến ngay
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="amp" items="${allRoutePassList}">
                                    <div class="col-md-4">
                                        <div class="ticket-card-custom h-100">
                                            <div class="ticket-card-header" style="border-bottom-color: #dee2e6;">
                                                <span class="fw-bold text-success fs-7"><i class="fas fa-globe me-1"></i>${amp.passCode}</span>
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
                                                <p class="small text-muted mb-3">Toàn bộ mạng lưới xe bus nội đô Hà Nội</p>
                                                <div class="bg-light p-3 rounded-3 small text-secondary mb-3">
                                                    <div class="mb-2 d-flex justify-content-between">
                                                        <span>Đối tượng:</span>
                                                        <strong class="text-dark">${amp.typeName}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between">
                                                        <span>Hiệu lực:</span>
                                                        <strong class="text-dark">${amp.startDate} đến ${amp.endDate}</strong>
                                                    </div>
                                                </div>

                                                <c:if test="${(amp.status == 'APPROVED' or amp.status == 'EXPIRED') and not empty amp.qrCodeToken}">
                                                    <button class="btn btn-sm btn-outline-success w-100 mt-2 fw-semibold" 
                                                            onclick="showQRCode('${amp.qrCodeToken}', '${amp.status}')">
                                                        <i class="fas fa-qrcode me-1"></i>Mã QR Check-in
                                                    </button>

                                                </c:if>
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
                statusBadge.innerText = status;
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
        <!-- Modal hiển thị QR Code -->
        <div class="modal fade" id="qrCodeModal" tabindex="-1" aria-labelledby="qrCodeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="qrCodeModalLabel"><i class="fas fa-qrcode"></i> Mã Soát Vé</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <!-- Chỗ này để nhét ảnh QR từ Google Chart -->
                        <img id="qrImage" src="" alt="QR Code" class="img-fluid mb-3 shadow-sm rounded" style="width: 200px; height: 200px;">
                        <p class="text-muted mb-1">Mã xác thực:</p>
                        <h5 id="qrText" class="fw-bold text-primary"></h5>
                        <p class="text-danger small mt-2" id="qrWarning" style="display: none;">Vé đã hết hạn, không thể sử dụng!</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showQRCode(codeData, status) {
                // Gọi Google Chart API để ép chuỗi codeData thành ảnh QR
                var qrUrl = "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" + encodeURIComponent(codeData);

                document.getElementById('qrImage').src = qrUrl;
                document.getElementById('qrText').innerText = codeData;

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
        <!-- ===== FOOTER ===== -->
        <jsp:include page="/common/footer.jsp" />
    </body>
</html>