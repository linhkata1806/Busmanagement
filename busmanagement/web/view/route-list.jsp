<%-- 
    Document   : route-list
    Created on : Jun 22, 2026, 10:04:58 PM
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
    <title>Danh sách tuyến xe - Xe Bus Hà Nội</title>
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

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--primary) 0%, #1565c0 100%);
            padding: 20px 0;
            color: white;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .page-header h3 {
            font-size: 1.45rem;
            letter-spacing: -0.3px;
        }
        .page-header p {
            font-size: 0.88rem;
        }

        /* TABLE STYLING */
        .table-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            padding: 24px;
            border: none;
        }
        .custom-table {
            margin-bottom: 0;
            vertical-align: middle;
        }
        .custom-table thead th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 16px;
            border-bottom: 2px solid #dee2e6;
        }
        .custom-table tbody td {
            padding: 16px;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
        }
        .custom-table tbody tr:last-child td {
            border-bottom: none;
        }
        .route-number-badge {
            background-color: #e8f0fe;
            color: var(--primary);
            font-weight: 700;
            padding: 6px 12px;
            border-radius: 8px;
            display: inline-block;
        }
        .btn-detail {
            background: #e8f0fe;
            color: var(--primary);
            border: none;
            font-weight: 600;
            border-radius: 8px;
            padding: 6px 14px;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-detail:hover {
            background: var(--primary);
            color: white;
        }
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a></li>
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

<div class="page-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-5 text-center text-md-start mb-3 mb-md-0">
                <h3 class="fw-bold m-0"><i class="fas fa-list-ul me-2"></i>Danh mục tuyến xe Bus</h3>
            </div>
            <div class="col-md-7 col-lg-6 ms-auto">
                <form action="${pageContext.request.contextPath}/search-route" method="GET" class="d-flex shadow-sm">
                    <input type="text" name="keyword" class="form-control border-0 px-3 py-2 bg-white" placeholder="Tìm kiếm nhanh số tuyến hoặc tên tuyến..." style="font-size: 0.9rem; border-radius: 8px 0 0 8px;" required>
                    <button type="submit" class="btn btn-warning border-0 px-4 fw-semibold text-white d-flex align-items-center" style="background: var(--accent); border-radius: 0 8px 8px 0; font-size: 0.9rem;">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="container min-vh-50 mb-5">
    <div class="mb-4">
        <span class="badge bg-light text-dark p-2 border fs-6">
            Hiện có tổng cộng: <strong class="text-primary">${routes != null ? routes.size() : 0}</strong> tuyến đang phục vụ
        </span>
    </div>

    <c:choose>
        <%-- TRƯỜNG HỢP CÓ DỮ LIỆU --%>
        <c:when test="${not empty routes}">
            <div class="table-container table-responsive">
                <table class="table custom-table">
                    <thead>
                        <tr>
                            <th scope="col" style="width: 12%">Số tuyến</th>
                            <th scope="col" style="width: 25%">Tên tuyến</th>
                            <th scope="col" style="width: 28%">Lộ trình điểm đầu &rarr; cuối</th>
                            <th scope="col" style="width: 15%"><i class="far fa-clock me-1"></i>Giờ chạy</th>
                            <th scope="col" style="width: 10%"><i class="fas fa-tag me-1"></i>Giá vé</th>
                            <th scope="col" class="text-center" style="width: 10%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${routes}">
                            <tr>
                                <td>
                                    <span class="route-number-badge">Tuyến ${r.routeNumber}</span>
                                </td>
                                <td>
                                    <span class="fw-bold text-dark">${r.routeName}</span>
                                </td>
                                <td>
                                    <small class="text-muted d-block">
                                        <strong>${r.startPoint}</strong> <i class="fas fa-long-arrow-alt-right mx-1 text-secondary"></i> <strong>${r.endPoint}</strong>
                                    </small>
                                </td>
                                <td><small class="fw-medium">${r.operatingHours}</small></td>
                                <td>
                                    <span class="fw-bold text-success">
                                        <fmt:formatNumber value="${r.ticketPrice}" pattern="#,###"/>đ
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="route-detail?id=${r.routeID}" class="btn-detail">
                                        Xem <i class="fas fa-chevron-right ms-1" style="font-size: 0.8rem;"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        
        <%-- TRƯỜNG HỢP KHÔNG CÓ DỮ LIỆU --%>
        <c:otherwise>
            <div class="text-center py-5 text-muted bg-light rounded-3 border">
                <i class="fas fa-folder-open fa-4x mb-3 opacity-25"></i>
                <h5>Hiện tại hệ thống chưa cập nhật danh sách tuyến!</h5>
                <p class="small text-muted">Vui lòng quay lại sau hoặc liên hệ ban quản trị để biết thêm chi tiết.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-sm mt-2 px-3 rounded-pill">Quay lại Trang chủ</a>
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