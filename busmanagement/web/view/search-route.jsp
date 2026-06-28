<%-- 
    Document   : search-route
    Created on : Jun 22, 2026, 9:29:57 PM
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
    <title>Kết quả tìm kiếm tuyến - Xe Bus Hà Nội</title>
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

        /* MINI SEARCH BAR */
        .mini-search-header {
            background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%);
            padding: 30px 0;
            color: white;
            margin-bottom: 40px;
        }
        .search-input-group { max-width: 600px; margin: 0 auto; }
        .search-input-group .form-control { border-radius: 8px 0 0 8px; padding: 12px 16px; font-size: 1rem; border: none; }
        .search-input-group .form-control:focus { box-shadow: none; }
        .btn-search { background: var(--accent); color: #333; border: none; border-radius: 0 8px 8px 0; padding: 12px 24px; font-weight: 600; font-size: 1rem; transition: background 0.2s; }
        .btn-search:hover { background: #f9a825; }

        /* ROUTE CARD */
        .route-card { border: none; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); transition: transform 0.2s, box-shadow 0.2s; height: 100%; }
        .route-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
        .route-number-badge { background: var(--primary); color: white; font-size: 1.5rem; font-weight: 700; width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .route-name { font-weight: 700; font-size: 1rem; color: #1a1a2e; margin-bottom: 4px; }
        .route-endpoint { color: #888; font-size: 0.85rem; }
        .route-meta { border-top: 1px solid #f0f0f0; margin-top: 12px; padding-top: 12px; }
        .route-meta-item { font-size: 0.82rem; color: #666; }
        .route-meta-item i { color: var(--primary); margin-right: 4px; }
        .price-badge { background: #e8f5e9; color: #2e7d32; font-weight: 700; font-size: 0.9rem; padding: 4px 10px; border-radius: 20px; }
        .btn-detail { background: var(--primary); color: white; border: none; border-radius: 8px; padding: 8px 16px; font-size: 0.85rem; font-weight: 600; width: 100%; margin-top: 12px; transition: background 0.2s; text-align: center; text-decoration: none; display: inline-block;}
        .btn-detail:hover { background: var(--primary-dark); color: white; }
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
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

<div class="mini-search-header">
    <div class="container text-center">
        <h3 class="mb-3">Tìm kiếm Tuyến Xe Bus</h3>
        <form action="${pageContext.request.contextPath}/search-route" method="get">
            <div class="input-group search-input-group">
                <input type="text" class="form-control" name="keyword" 
                       placeholder="Nhập số tuyến (VD: 32) hoặc tên tuyến (VD: Nhổn)..." 
                       value="${keyword}" required>
                <button class="btn-search" type="submit">
                    <i class="fas fa-search me-1"></i>Tìm kiếm
                </button>
            </div>
        </form>
    </div>
</div>

<div class="container min-vh-50">
    <div class="mb-4">
        <h4 class="fw-bold">Kết quả tìm kiếm cho: <span class="text-primary">"${keyword}"</span></h4>
        <p class="text-muted">Tìm thấy <strong>${routes != null ? routes.size() : 0}</strong> tuyến phù hợp.</p>
    </div>

    <c:choose>
        <c:when test="${not empty routes}">
            <div class="row g-4">
                <c:forEach var="route" items="${routes}">
                    <div class="col-lg-4 col-md-6">
                        <div class="card route-card p-3">
                            <div class="d-flex align-items-start gap-3">
                                <div class="route-number-badge">${route.routeNumber}</div>
                                <div class="flex-grow-1">
                                    <div class="route-name">${route.routeName}</div>
                                    <div class="route-endpoint">
                                        <i class="fas fa-map-marker-alt text-success"></i> ${route.startPoint}
                                        <i class="fas fa-long-arrow-alt-right mx-1 text-muted"></i>
                                        <i class="fas fa-map-marker-alt text-danger"></i> ${route.endPoint}
                                    </div>
                                </div>
                            </div>

                            <div class="route-meta d-flex justify-content-between align-items-center flex-wrap gap-2">
                                <div>
                                    <div class="route-meta-item"><i class="fas fa-clock"></i>${route.operatingHours}</div>
                                    <c:if test="${not empty route.frequence}">
                                        <div class="route-meta-item mt-1"><i class="fas fa-sync-alt"></i>${route.frequency}</div>
                                    </c:if>
                                </div>
                                <span class="price-badge">
                                    <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" class="btn btn-detail">
                                <i class="fas fa-info-circle me-1"></i>Xem chi tiết
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 text-muted bg-light rounded-3 mt-4">
                <i class="fas fa-search-minus fa-4x mb-3 opacity-25"></i>
                <h5>Rất tiếc, không tìm thấy tuyến xe nào!</h5>
                <p>Vui lòng kiểm tra lại từ khóa hoặc quay về trang chủ.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary mt-2">Quay lại Trang chủ</a>
            </div>
        </c:otherwise>
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
                    <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
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
</body>
</html>
