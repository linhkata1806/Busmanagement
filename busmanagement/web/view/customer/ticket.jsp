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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --bg-light: #f8f9fa;
        }
        body { 
            background-color: var(--bg-light); 
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
    </style>
</head>
<body>

<div class="container my-5">
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
                                            <button class="btn btn-sm btn-outline-primary py-0.5 px-2 rounded-2">
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
                                        <div class="bg-light p-2.5 rounded-2 small text-secondary">
                                            <div class="mb-1"><strong>Đối tượng:</strong> <span class="text-dark">${mp.typeName}</span></div>
                                            <div><strong>Hiệu lực:</strong> <span class="text-dark">${mp.startDate} đến ${mp.endDate}</span></div>
                                        </div>
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
                                        <div class="bg-light p-2.5 rounded-2 small text-secondary">
                                            <div class="mb-1"><strong>Đối tượng ưu đãi:</strong> <span class="text-dark">${amp.typeName}</span></div>
                                            <div><strong>Hiệu lực:</strong> <span class="text-dark">${amp.startDate} đến ${amp.endDate}</span></div>
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

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>