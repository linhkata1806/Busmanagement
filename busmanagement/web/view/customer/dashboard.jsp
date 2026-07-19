<%-- 
    Document   : dashboard
    Created on : Jun 26, 2026, 1:42:42 PM
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
    <title>Dashboard - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />

    <style>
        :root {
            --primary: #1a73e8; /* Màu xanh đậm chuẩn giống hình */
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
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            font-weight: 500;
        }

        /* ===== HERO / BANNER XANH ĐẬM ===== */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 40px 0 100px; /* Padding dưới dài ra để chứa thẻ overlap */
            color: white;
            text-align: center;
        }
        .dashboard-avatar {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            object-fit: cover;
            border: 3px solid #ffffff;
        }
        .hero h2 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .hero p {
            opacity: 0.9;
            font-size: 1rem;
        }

        /* ===== DASHBOARD STATS (4 THẺ OVERLAP) ===== */
        .dashboard-stats {
            margin-top: -60px; /* Kéo thẻ lên đè vào banner */
            position: relative;
            z-index: 10;
        }
        .stat-link {
            text-decoration: none;
            color: inherit;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: 0.2s;
            height: 100%;
        }
        .stat-link:hover .stat-card {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }
        /* Phối màu chuẩn cho 4 thẻ thống kê */
        .bg-ticket { background: #e8f0fe; color: #1a73e8; }
        .bg-pass { background: #e6f4ea; color: #1e8e3e; }
        .bg-favorite { background: #fef7e0; color: #f9ab00; }
        .bg-notification { background: #fce8e6; color: #d93025; }
        
        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: #202124;
            line-height: 1.2;
        }
        .stat-title {
            color: #5f6368;
            font-size: 0.85rem;
            text-transform: uppercase;
            font-weight: 600;
            margin-top: 5px;
        }

        /* ===== HỘP TÌM KIẾM (SEARCH BOX) ===== */
        .search-box {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .search-tabs .nav-link {
            color: #5f6368 !important;
            font-weight: 600;
            border-bottom: 2px solid transparent;
            padding: 10px 20px;
        }
        .search-tabs .nav-link.active {
            color: var(--primary-light) !important;
            border-bottom: 2px solid var(--primary-light);
            background: transparent;
        }
        .search-input-group .form-control {
            padding: 12px 16px;
            border: 1px solid #dadce0;
        }
        .btn-search {
            background: var(--primary-light);
            color: white;
            border: none;
            padding: 12px 25px;
            font-weight: 600;
        }
        .btn-search:hover { background: var(--primary); }

        /* ===== THẺ TUYẾN XE NỔI BẬT ===== */
        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #202124;
        }
        .route-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e8eaed;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            transition: 0.2s;
        }
        .route-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        .route-number-badge {
            background: var(--primary-light);
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            width: 55px;
            height: 55px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            flex-shrink: 0;
        }
        .route-name {
            font-weight: 700;
            font-size: 1rem;
            color: #202124;
            margin-bottom: 5px;
        }
        .route-endpoint {
            font-size: 0.85rem;
            color: #5f6368;
        }
        .route-meta {
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px dashed #e8eaed;
            font-size: 0.85rem;
            color: #5f6368;
        }
        .price-badge {
            color: #1e8e3e;
            font-weight: 700;
            font-size: 0.95rem;
        }
        .btn-detail {
            background: var(--primary-light);
            color: white;
            font-weight: 600;
            width: 100%;
            border-radius: 8px;
            padding: 8px;
            margin-top: 15px;
        }
        .btn-detail:hover {
            background: var(--primary);
            color: white;
        }
    </style>
</head>
<body>

    <!-- ===== HEADER NAVIGATION ===== -->
    <c:set var="activePage" value="dashboard" />
    <jsp:include page="/common/navbar.jsp" />

    <div class="hero">
        <div class="container">
            <c:choose>
                <c:when test="${not empty sessionScope.USER.avatar}">
                    <img src="${sessionScope.USER.avatar}" alt="Avatar" class="dashboard-avatar">
                </c:when>
                <c:otherwise>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.USER.fullName}&background=ffffff&color=0d47a1&size=120" alt="Avatar" class="dashboard-avatar">
                </c:otherwise>
            </c:choose>
            <h2>Xin chào, ${sessionScope.USER.fullName}!</h2>
            <p><i class="fas fa-envelope me-2"></i>${sessionScope.USER.email}</p>
        </div>
    </div>

    <div class="container dashboard-stats">
        <div class="row g-4">
            
            <div class="col-lg-3 col-md-6">
                <a href="${pageContext.request.contextPath}/customer/ticket?tab=ticket" class="stat-link d-block h-100">
                    <div class="stat-card">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-ticket"><i class="fas fa-ticket-alt"></i></div>
                            <div class="ms-3">
                                <div class="stat-number">${totalTickets}</div>
                                <div class="stat-title">Vé lượt chưa dùng</div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-lg-3 col-md-6">
                <a href="${pageContext.request.contextPath}/customer/ticket?tab=pass" class="stat-link d-block h-100">
                    <div class="stat-card">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-pass"><i class="fas fa-id-card"></i></div>
                            <div class="ms-3">
                                <div class="stat-number">${totalPasses}</div>
                                <div class="stat-title">Vé tháng hiệu lực</div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-lg-3 col-md-6">
                <a href="${pageContext.request.contextPath}/customer/favorite" class="stat-link d-block h-100">
                    <div class="stat-card">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-favorite"><i class="fas fa-heart"></i></div>
                            <div class="ms-3">
                                <div class="stat-number">${totalFavorites}</div>
                                <div class="stat-title">Tuyến yêu thích</div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-lg-3 col-md-6">
                <a href="${pageContext.request.contextPath}/customer/notification" class="stat-link d-block h-100">
                    <div class="stat-card">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-notification"><i class="fas fa-bell"></i></div>
                            <div class="ms-3">
                                <div class="stat-number">${unreadNotifications}</div>
                                <div class="stat-title">Thông báo mới</div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

        </div>
    </div>

    <div class="container mt-5">
        <div class="search-box">
            <ul class="nav search-tabs mb-4" id="searchTab">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" href="#tab-search">
                        <i class="fas fa-search me-1"></i> Tìm tuyến
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#tab-finder">
                        <i class="fas fa-route me-1"></i> Tìm đường đi
                    </a>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="tab-search">
                    <form action="${pageContext.request.contextPath}/search-route" method="get">
                        <div class="input-group search-input-group">
                            <input type="text" class="form-control" name="keyword" placeholder="Nhập số tuyến (VD: 32) hoặc tên tuyến (VD: Nhổn)..." value="${param.keyword}" required>
                            <button class="btn btn-search" type="submit"><i class="fas fa-search me-1"></i> Tìm kiếm</button>
                        </div>
                    </form>
                </div>

                <div class="tab-pane fade" id="tab-finder">
                    <form action="${pageContext.request.contextPath}/find-route" method="get">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-5">
                                <select class="form-select" name="fromStop" required>
                                    <option value="">-- Trạm đi --</option>
                                    <c:forEach var="stop" items="${stopNames}">
                                        <option value="${stop.stopID}">
                                            ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-1 text-center">
                                <span class="btn btn-light rounded-circle" id="swapStops"><i class="fas fa-exchange-alt"></i></span>
                            </div>
                            <div class="col-md-5">
                                <select class="form-select" name="toStop" required>
                                    <option value="">-- Trạm đến --</option>
                                    <c:forEach var="stop" items="${stopNames}">
                                        <option value="${stop.stopID}">
                                            ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-1">
                                <button type="submit" class="btn btn-search w-100"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-5 mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <div class="section-title">🚌 Tuyến xe nổi bật</div>
                <div class="text-muted small mt-1">Các tuyến xe bus phổ biến tại Hà Nội</div>
            </div>
            <a href="${pageContext.request.contextPath}/route-list" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty popularRoutes}">
                <div class="row g-4">
                    <c:forEach var="route" items="${popularRoutes}">
                        <div class="col-lg-4 col-md-6">
                            <div class="card route-card p-3 h-100">
                                <div class="d-flex align-items-start gap-3">
                                    <div class="route-number-badge shadow-sm">${route.routeNumber}</div>
                                    <div class="flex-grow-1">
                                        <div class="route-name">${route.routeName}</div>
                                        <div class="route-endpoint">
                                            <i class="fas fa-map-marker-alt text-success me-1"></i>${route.startPoint}<br>
                                            <i class="fas fa-arrow-down ms-1 text-muted small" style="margin: 2px 0;"></i><br>
                                            <i class="fas fa-map-marker-alt text-danger me-1"></i>${route.endPoint}
                                        </div>
                                    </div>
                                </div>

                                <div class="route-meta d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="mb-1"><i class="fas fa-clock me-1 text-primary"></i> ${route.operatingHours}</div>
                                        <c:if test="${not empty route.frequence}">
                                            <div><i class="fas fa-sync-alt me-1 text-primary"></i> ${route.frequence}</div>
                                        </c:if>
                                    </div>
                                    <div class="price-badge">
                                        <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" class="btn btn-detail mt-auto">
                                    <i class="fas fa-info-circle me-1"></i> Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-muted bg-white rounded shadow-sm border">
                    <i class="fas fa-bus fa-3x mb-3 opacity-25"></i>
                    <p>Chưa có thông tin tuyến xe nổi bật nào.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />
    <script>
        document.getElementById("swapStops")?.addEventListener("click", function () {
            const fromSelect = document.querySelector("select[name='fromStop']");
            const toSelect = document.querySelector("select[name='toStop']");
            const temp = fromSelect.value;
            fromSelect.value = toSelect.value;
            toSelect.value = temp;
        });
    </script>
</body>
</html>