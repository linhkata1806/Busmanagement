<%-- 
    Document   : find-route
    Created on : Jun 22, 2026, 9:58:48 PM
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
    <title>Tìm kiếm lộ trình - Xe Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
        }
        .navbar { background: var(--primary) !important; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar-brand { font-weight: 700; font-size: 1.3rem; color: white !important; }
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }
        .nav-link:hover { color: white !important; }
        .btn-nav-login { border: 2px solid white; color: white !important; border-radius: 20px; padding: 6px 18px; font-weight: 600; transition: all 0.2s; }
        .btn-nav-login:hover { background: white; color: var(--primary) !important; }
        .btn-nav-register { background: var(--accent); color: #333 !important; border-radius: 20px; padding: 6px 18px; font-weight: 600; margin-left: 8px; transition: all 0.2s; }
        .btn-nav-register:hover { background: #f9a825; }
        .dropdown-menu { border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        footer { background: #1a1a2e; color: rgba(255,255,255,0.7); padding: 30px 0; margin-top: 60px; }
        footer a { color: rgba(255,255,255,0.7); text-decoration: none; }
        footer a:hover { color: white; }

        /* MINI SEARCH BAR AREA */
        .search-section {
            background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%);
            padding: 30px 0;
            color: white;
            margin-bottom: 40px;
        }
        .search-card { background: white; border: none; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); padding: 20px; }
        .form-select { padding: 10px 12px; border-radius: 8px; border: 1px solid #ddd; color: #333; }
        .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.25); }
        .btn-search { background: var(--accent); color: #333; border: none; border-radius: 8px; padding: 10px 24px; font-weight: 600; width: 100%; transition: background 0.2s; }
        .btn-search:hover { background: #f9a825; }
        .swap-btn { background: #f8f9fa; border: 1px solid #ddd; color: var(--primary); width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto; cursor: pointer; transition: all 0.2s; }
        .swap-btn:hover { background: var(--primary); color: white; }

        /* ROUTE MATCHER CARD */
        .match-card { border: none; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); background: white; transition: transform 0.2s; }
        .match-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .route-badge { background: var(--primary); color: white; font-size: 1.4rem; font-weight: 700; padding: 12px 20px; border-radius: 12px; text-align: center; min-width: 75px; }
        .station-indicator { position: relative; padding-left: 24px; }
        .station-indicator::before { content: ''; position: absolute; left: 6px; top: 8px; bottom: 8px; width: 2px; border-left: 2px dashed #ccc; }
        .station-point { position: relative; margin-bottom: 15px; }
        .station-point:last-child { margin-bottom: 0; }
        .station-point::after { content: ''; position: absolute; left: -22px; top: 6px; width: 10px; height: 10px; border-radius: 50%; background: white; }
        .point-up::after { border: 3px solid #2e7d32; }
        .point-down::after { border: 3px solid #d32f2f; }
        .btn-detail { background: #e8f0fe; color: var(--primary); border: none; font-weight: 600; border-radius: 8px; padding: 8px 16px; transition: all 0.2s; text-decoration: none; display: inline-block; }
        .btn-detail:hover { background: var(--primary); color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            🚌 Bus <span>Hà Nội</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/guide">Hướng dẫn</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a></li>
            </ul>
            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${not empty USER}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i> Chào, <strong>${USER.fullName}</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile"><i class="fas fa-user me-2 text-primary"></i>Hồ sơ</a></li>
                                <c:if test="${USER.roleName == 'CUSTOMER'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/ticket"><i class="fas fa-ticket-alt me-2 text-primary"></i>Vé của tôi</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link btn-nav-login" href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                        <li class="nav-item"><a class="nav-link btn-nav-register" href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div class="search-section">
    <div class="container">
        <form action="${pageContext.request.contextPath}/find-route" method="get" class="search-card">
            <div class="row g-3 align-items-center">
                <div class="col-md-5">
                    <label class="form-label text-dark small fw-bold"><i class="fas fa-map-marker-alt text-success me-1"></i>Điểm khởi hành</label>
                    <select class="form-select" name="fromStopID" required>
                        <option value="">-- Chọn trạm xuất phát --</option>
                        <c:forEach var="stop" items="${stopNames}">
                            <option value="${stop.stopID}" ${param.fromStopID == stop.stopID ? 'selected' : ''}>
                                ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-1 text-center">
                    <label class="form-label d-none d-md-block">&nbsp;</label>
                    <button type="button" class="swap-btn" id="swapStops" title="Đổi chiều bến" style="margin-top: 3px;">
                        <i class="fas fa-exchange-alt"></i>
                    </button>
                </div>
                <div class="col-md-5">
                    <label class="form-label text-dark small fw-bold"><i class="fas fa-map-marker-alt text-danger me-1"></i>Điểm đến</label>
                    <select class="form-select" name="toStopID" required>
                        <option value="">-- Chọn bến đích --</option>
                        <c:forEach var="stop" items="${stopNames}">
                            <option value="${stop.stopID}" ${param.toStopID == stop.stopID ? 'selected' : ''}>
                                ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-1">
                    <label class="form-label d-none d-md-block">&nbsp;</label>
                    <button type="submit" class="btn-search py-2" style="height: 46px; display: flex; align-items: center; justify-content: center; margin-top: 3px;">
                        <i class="fas fa-route"></i>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="container min-vh-50 mb-5">

    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center fw-bold my-4 p-3 shadow-sm rounded-3" role="alert">
            <i class="fas fa-exclamation-circle me-2 fs-5"></i> ${error}
        </div>
    </c:if>

    <c:if test="${not empty selectedFrom && not empty selectedTo}">
        <div class="mb-4">
            <h4 class="fw-bold text-dark">Lộ trình kết nối gợi ý:</h4>
            <p class="text-muted fs-5">
                Hành trình từ: <strong class="text-primary">${selectedFrom.stopName}</strong> 
                đến <strong class="text-primary">${selectedTo.stopName}</strong>
            </p>
            <span class="badge bg-light text-dark p-2 border">Tìm thấy <strong>${matchingRoutes != null ? matchingRoutes.size() : 0}</strong> giải pháp di chuyển trực tiếp</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty matchingRoutes}">
            <div class="row g-3">
                <c:forEach var="route" items="${matchingRoutes}">
                    <div class="col-12">
                        <div class="card match-card p-4">
                            <div class="row align-items-center g-3">
                                <div class="col-md-2 text-center text-md-start">
                                    <div class="route-badge">Tuyến ${route.routeNumber}</div>
                                </div>
                                
                                <div class="col-md-4">
                                    <h5 class="fw-bold m-0 text-dark">${route.routeName}</h5>
                                    <small class="text-muted d-block mt-1">
                                        Hướng đi chung: ${route.startPoint} <i class="fas fa-long-arrow-alt-right mx-1"></i> ${route.endPoint}
                                    </small>
                                </div>

                                <div class="col-md-4">
                                    <div class="station-indicator">
                                        <div class="station-point point-up text-dark">
                                            <small class="text-muted d-block">Lên xe tại:</small>
                                            <strong>${selectedFrom.stopName}</strong>
                                        </div>
                                        <div class="station-point point-down text-dark">
                                            <small class="text-muted d-block">Xuống xe tại:</small>
                                            <strong>${selectedTo.stopName}</strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-2 text-md-end text-center">
                                    <div class="mb-2 fw-bold text-success fs-5">
                                        <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                    </div>
                                    <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" class="btn btn-detail">
                                        Chi tiết tuyến <i class="fas fa-chevron-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        
        <c:when test="${empty matchingRoutes && empty error && requestScope.searchPerformed}">
            <div class="text-center py-5 text-muted bg-white rounded-3 mt-4 border shadow-sm">
                <i class="fas fa-bus-slash fa-4x mb-3 opacity-25 text-secondary"></i>
                <h5 class="fw-bold text-dark">Hiện không có chuyến xe phù hợp</h5>
                <p class="max-width-600 mx-auto small text-muted px-3 mt-2">
                    Hệ thống không tìm thấy tuyến xe đơn lẻ nào chạy trực tiếp giữa hai trạm này. Bạn vui lòng chọn lại cặp bến khác hoặc tìm kiếm lộ trình đi xe liên tuyến.
                </p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm mt-3 px-4 rounded-pill fw-semibold">Quay lại Trang chủ</a>
            </div>
        </c:when>
    </c:choose>
</div>

<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3">
                <h6 class="text-white fw-bold">🚌 Bus Hà Nội</h6>
                <small>Hệ thống quản lý xe bus công cộng thành phố Hà Nội.</small>
            </div>
            <div class="col-md-4 mb-3">
                <h6 class="text-white fw-bold">Liên kết</h6>
                <ul class="list-unstyled small">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/route-list">Danh sách tuyến</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-3">
                <h6 class="text-white fw-bold">Liên hệ</h6>
                <small>
                    <i class="fas fa-phone me-1"></i>1900 xxxx<br>
                    <i class="fas fa-envelope me-1"></i>support@bushanoi.vn
                </small>
            </div>
        </div>
        <hr style="border-color: rgba(255,255,255,0.1)">
        <div class="text-center small">© 2024 Bus Hà Nội. All rights reserved.</div>
    </div>
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // JS Đổi chỗ nhanh chiều bến đi và bến đến
    document.getElementById('swapStops')?.addEventListener('click', function () {
        const fromSelect = document.querySelector('select[name="fromStopID"]');
        const toSelect = document.querySelector('select[name="toStopID"]');
        const temp = fromSelect.value;
        fromSelect.value = toSelect.value;
        toSelect.value = temp;
    });
</script>
</body>
</html>
