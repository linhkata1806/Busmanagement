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
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }
        .navbar .dropdown-menu {
            border: none;
        }

        .nav-pills .nav-link.active {
            background-color: var(--primary);
        }
        .ticket-card {
            transition: transform 0.2s;
        }
        .ticket-card:hover {
            transform: translateY(-3px);
        }
        /* ===== FOOTER ===== */
        footer {
            background: #1a1a2e;
            color: rgba(255,255,255,0.7);
            padding: 30px 0;
            margin-top: 60px;
        }
        footer a { color: rgba(255,255,255,0.7); text-decoration: none; }
        footer a:hover { color: white; }
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

    <ul class="nav nav-pills mb-4 shadow-sm bg-white p-2 rounded-3">
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
                                <div class="card h-100 border-0 shadow-sm rounded-3 ticket-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="badge bg-primary fs-6 fw-bold">${t.ticketCode}</span>
                                            <span class="badge ${t.status == 'UNUSED' ? 'bg-success' : 'bg-secondary'}">${t.status}</span>
                                        </div>
                                        <h5 class="fw-bold text-dark mb-1">Tuyến ${t.routeNumber}</h5>
                                        <p class="text-muted small mb-3 text-truncate">${t.routeName}</p>
                                        <hr class="text-muted opacity-25 my-2">
                                        <div class="d-flex justify-content-between align-items-center text-secondary small">
                                            <span>Giá vé: <strong class="text-success"><fmt:formatNumber value="${t.price}" pattern="#,###"/> đ</strong></span>
                                            <button class="btn btn-sm btn-outline-primary py-0.5 px-2 rounded-2" 
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
                                <div class="card h-100 border-0 shadow-sm border-start border-primary border-4 rounded-3 ticket-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold text-primary fs-6"><i class="fas fa-barcode me-1"></i>${mp.passCode}</span>
                                            <span class="badge ${mp.status == 'APPROVED' ? 'bg-success' : (mp.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-danger')}">${mp.status}</span>
                                        </div>
                                        <h6 class="text-dark fw-bold mb-1">Tuyến áp dụng: ${mp.routeNumber}</h6>
                                        <p class="small text-muted text-truncate mb-3">${mp.routeName}</p>
                                        <div class="bg-light p-2 rounded-2 small text-secondary">
                                            <div class="mb-1"><strong>Đối tượng:</strong> <span class="text-dark">${mp.typeName}</span></div>
                                            <div><strong>Hiệu lực:</strong> <span class="text-dark">${mp.startDate} đến ${mp.endDate}</span></div>
                                        </div>
                                        <c:if test="${mp.status == 'APPROVED' && not empty mp.qrCodeToken}">
                                            <div class="mt-2 text-primary fw-semibold small bg-primary bg-opacity-10 p-2 rounded-2 border border-primary border-opacity-25 text-center">
                                                <i class="fas fa-qrcode me-1"></i>Token soát vé:<br>
                                                <strong class="text-dark" style="font-size: 0.7rem; letter-spacing: 0.5px; word-break: break-all;">${mp.qrCodeToken}</strong>
                                            </div>
                                        </c:if>
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
                                <div class="card h-100 border-0 shadow-sm border-start border-success border-4 rounded-3 ticket-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold text-success fs-6"><i class="fas fa-globe me-1"></i>${amp.passCode}</span>
                                            <span class="badge ${amp.status == 'APPROVED' ? 'bg-success' : (amp.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-danger')}">${amp.status}</span>
                                        </div>
                                        <h5 class="text-success fw-bold mb-1"><i class="fas fa-bus me-1"></i>Toàn mạng lưới</h5>
                                        <p class="small text-muted mb-3">Áp dụng cho mọi tuyến thuộc hệ thống kết nối Bus Hà Nội</p>
                                        <div class="bg-light p-2 rounded-2 small text-secondary">
                                            <div class="mb-1"><strong>Đối tượng ưu đãi:</strong> <span class="text-dark">${amp.typeName}</span></div>
                                            <div><strong>Hiệu lực:</strong> <span class="text-dark">${amp.startDate} đến ${amp.endDate}</span></div>
                                        </div>
                                        <c:if test="${amp.status == 'APPROVED' && not empty amp.qrCodeToken}">
                                            <div class="mt-2 text-success fw-semibold small bg-success bg-opacity-10 p-2 rounded-2 border border-success border-opacity-25 text-center">
                                                <i class="fas fa-qrcode me-1"></i>Token soát vé:<br>
                                                <strong class="text-dark" style="font-size: 0.7rem; letter-spacing: 0.5px; word-break: break-all;">${amp.qrCodeToken}</strong>
                                            </div>
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

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
</body>
</html>