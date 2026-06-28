<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xe Bus Hà Nội - Trang chủ</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
        }

        /* ===== HEADER ===== */
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
        .nav-link:hover { color: white !important; }
        .btn-nav-login {
            border: 2px solid white;
            color: white !important;
            border-radius: 20px;
            padding: 6px 18px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-nav-login:hover { background: white; color: var(--primary) !important; }
        .btn-nav-register {
            background: var(--accent);
            color: #333 !important;
            border-radius: 20px;
            padding: 6px 18px;
            font-weight: 600;
            margin-left: 8px;
            transition: all 0.2s;
        }
        .btn-nav-register:hover { background: #f9a825; }
        .dropdown-menu { border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }

        /* ===== HERO ===== */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%);
            padding: 60px 0 80px;
            color: white;
        }
        .hero h1 { font-size: 2.2rem; font-weight: 700; margin-bottom: 10px; }
        .hero p { font-size: 1.1rem; opacity: 0.9; margin-bottom: 30px; }

        /* ===== SEARCH BOX ===== */
        .search-box {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            margin-top: -40px;
            position: relative;
            z-index: 10;
        }
        .search-tabs .nav-link {
            color: #666 !important;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            padding: 10px 20px;
        }
        .search-tabs .nav-link.active {
            color: var(--primary) !important;
            border-bottom: 3px solid var(--primary);
            background: transparent;
        }
        .search-input-group .form-control {
            border-radius: 8px 0 0 8px;
            padding: 12px 16px;
            font-size: 1rem;
            border: 2px solid #e0e0e0;
            border-right: none;
        }
        .search-input-group .form-control:focus {
            border-color: var(--primary);
            box-shadow: none;
        }
        .btn-search {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 0 8px 8px 0;
            padding: 12px 24px;
            font-weight: 600;
            font-size: 1rem;
            transition: background 0.2s;
        }
        .btn-search:hover { background: var(--primary-dark); }
        .route-finder-form .form-select {
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
        }
        .route-finder-form .form-select:focus {
            border-color: var(--primary);
            box-shadow: none;
        }
        .btn-find-route {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 32px;
            font-weight: 600;
            width: 100%;
            font-size: 1rem;
        }
        .btn-find-route:hover { background: var(--primary-dark); }
        .swap-icon {
            cursor: pointer;
            color: var(--primary);
            font-size: 1.2rem;
            padding: 10px;
            transition: transform 0.3s;
        }
        .swap-icon:hover { transform: rotate(180deg); }

        /* ===== POPULAR ROUTES ===== */
        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 6px;
        }
        .section-subtitle { color: #888; margin-bottom: 30px; }
        .route-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
        }
        .route-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        .route-number-badge {
            background: var(--primary);
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .route-name { font-weight: 700; font-size: 1rem; color: #1a1a2e; margin-bottom: 4px; }
        .route-endpoint { color: #888; font-size: 0.85rem; }
        .route-meta { border-top: 1px solid #f0f0f0; margin-top: 12px; padding-top: 12px; }
        .route-meta-item { font-size: 0.82rem; color: #666; }
        .route-meta-item i { color: var(--primary); margin-right: 4px; }
        .price-badge {
            background: #e8f5e9;
            color: #2e7d32;
            font-weight: 700;
            font-size: 0.9rem;
            padding: 4px 10px;
            border-radius: 20px;
        }
        .btn-detail {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            width: 100%;
            margin-top: 12px;
            transition: background 0.2s;
        }
        .btn-detail:hover { background: var(--primary-dark); color: white; }
        .btn-view-all {
            border: 2px solid var(--primary);
            color: var(--primary);
            border-radius: 8px;
            padding: 10px 32px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-view-all:hover { background: var(--primary); color: white; }

        /* ===== FOOTER ===== */
        footer {
            background: #1a1a2e;
            color: rgba(255,255,255,0.7);
            padding: 30px 0;
            margin-top: 60px;
        }
        footer a { color: rgba(255,255,255,0.7); text-decoration: none; }
        footer a:hover { color: white; }

        /* ===== BUS MAP & NEWS SECTION ===== */
        .news-section {
            background-color: #ffffff;
            padding: 60px 0;
            border-top: 1px solid #eaeaea;
        }
        
        .info-card-custom {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .info-card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            border-color: var(--primary);
        }
        
        .info-icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: rgba(26, 115, 232, 0.1);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 16px;
        }
        
        .article-card {
            display: flex;
            gap: 20px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            height: 100%;
        }
        
        .article-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
            border-color: var(--primary);
        }
        
        .article-img {
            width: 150px;
            height: 100%;
            object-fit: cover;
            flex-shrink: 0;
        }
        
        .article-content {
            padding: 16px 20px 16px 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .article-badge {
            background: #fff2e8;
            color: #ff5500;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 4px;
            align-self: flex-start;
            margin-bottom: 8px;
        }
        
        .article-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 6px;
            line-height: 1.4;
        }
        
        .article-desc {
            font-size: 0.85rem;
            color: #64748b;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .article-meta {
            font-size: 0.8rem;
            color: #94a3b8;
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
        }
        
        .read-more-btn {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: gap 0.2s;
            margin-left: auto;
        }
        
        .read-more-btn:hover {
            gap: 8px;
            color: var(--primary-dark);
            text-decoration: underline;
        }
    </style>
</head>
<body>

<!-- ===== HEADER NAVIGATION ===== -->
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
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/guide">Hướng dẫn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <%-- ĐÃ ĐĂNG NHẬP --%>
                    <c:when test="${not empty USER}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i>
                                Chào, <strong>${USER.fullName}</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">
                                        <i class="fas fa-user me-2 text-primary"></i>Hồ sơ
                                    </a>
                                </li>
                                <c:if test="${USER.roleName == 'CUSTOMER'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/customer/ticket">
                                            <i class="fas fa-ticket-alt me-2 text-primary"></i>Vé của tôi
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <%-- CHƯA ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link btn-nav-login" href="${pageContext.request.contextPath}/login">
                                Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link btn-nav-register" href="${pageContext.request.contextPath}/register">
                                Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== HERO ===== -->
<div class="hero">
    <div class="container text-center">
        <h1><i class="fas fa-bus me-2"></i>Hệ thống Xe Bus Hà Nội</h1>
        <p>Tìm tuyến xe, tra cứu lịch trình nhanh chóng và tiện lợi</p>
    </div>
</div>

<!-- ===== SEARCH BOX ===== -->
<div class="container">
    <div class="search-box">
        <ul class="nav search-tabs mb-3" id="searchTab">
            <li class="nav-item">
                <a class="nav-link active" data-bs-toggle="tab" href="#tab-search">
                    <i class="fas fa-search me-1"></i>Tìm tuyến
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#tab-finder">
                    <i class="fas fa-route me-1"></i>Tìm đường đi
                </a>
            </li>
        </ul>

        <div class="tab-content">
            <%-- TAB 1: TÌM TUYẾN (UC-03) --%>
            <div class="tab-pane fade show active" id="tab-search">
                <form action="${pageContext.request.contextPath}/search-route" method="get">
                    <div class="input-group search-input-group">
                        <input type="text" class="form-control"
                               name="keyword"
                               placeholder="Nhập số tuyến (VD: 32) hoặc tên tuyến (VD: Nhổn)..."
                               value="${param.keyword}"
                               required>
                        <button class="btn-search" type="submit">
                            <i class="fas fa-search me-1"></i>Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>

            <%-- TAB 2: TÌM ĐƯỜNG ĐI (UC-04) --%>
            <div class="tab-pane fade" id="tab-finder">
                <form action="${pageContext.request.contextPath}/find-route" method="get" class="route-finder-form">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-map-marker-alt text-success me-1"></i>Trạm đi
                            </label>
                            <select class="form-select" name="fromStop" required>
                                <option value="">-- Chọn trạm đi --</option>
                                <c:forEach var="stop" items="${stopNames}">
                                    <option value="${stop.stopID}">${stop.stopName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-1 text-center">
                            <span class="swap-icon" id="swapStops" title="Đổi chiều">
                                <i class="fas fa-exchange-alt"></i>
                            </span>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-map-marker-alt text-danger me-1"></i>Trạm đến
                            </label>
                            <select class="form-select" name="toStop" required>
                                <option value="">-- Chọn trạm đến --</option>
                                <c:forEach var="stop" items="${stopNames}">
                                    <option value="${stop.stopID}">${stop.stopName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-1">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn-find-route">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- ===== POPULAR ROUTES ===== -->
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <div class="section-title">🚌 Tuyến xe nổi bật</div>
            <div class="section-subtitle">Các tuyến xe bus phổ biến tại Hà Nội</div>
        </div>
        <a href="${pageContext.request.contextPath}/route-list" class="btn btn-view-all">
            Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty popularRoutes}">
            <div class="row g-4">
                <c:forEach var="route" items="${popularRoutes}">
                    <div class="col-lg-4 col-md-6">
                        <div class="card route-card p-3">
                            <div class="d-flex align-items-start gap-3">
                                <div class="route-number-badge">${route.routeNumber}</div>
                                <div class="flex-grow-1">
                                    <div class="route-name">${route.routeName}</div>
                                    <div class="route-endpoint">
                                        <i class="fas fa-map-marker-alt text-success"></i>
                                        ${route.startPoint}
                                        <i class="fas fa-long-arrow-alt-right mx-1 text-muted"></i>
                                        <i class="fas fa-map-marker-alt text-danger"></i>
                                        ${route.endPoint}
                                    </div>
                                </div>
                            </div>

                            <div class="route-meta d-flex justify-content-between align-items-center flex-wrap gap-2">
                                <div>
                                    <div class="route-meta-item">
                                        <i class="fas fa-clock"></i>${route.operatingHours}
                                    </div>
                                    <c:if test="${not empty route.frequence}">
                                        <div class="route-meta-item mt-1">
                                            <i class="fas fa-sync-alt"></i>${route.frequence}
                                        </div>
                                    </c:if>
                                </div>
                                <span class="price-badge">
                                    <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}"
                               class="btn btn-detail">
                                <i class="fas fa-info-circle me-1"></i>Xem chi tiết
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 text-muted">
                <i class="fas fa-bus fa-3x mb-3 opacity-25"></i>
                <p>Chưa có tuyến xe nào.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ===== BUS MAP & LATEST NEWS SECTION ===== -->
<div class="container mt-5 pt-4 pb-5">
    <hr class="mb-5" style="border-color: #eaeaea;">
    
    <div class="row g-5">
        <!-- Left Column: Smart Bus Map Info -->
        <div class="col-lg-5">
            <div class="section-title mb-1"><i class="fas fa-map-marked-alt text-primary me-2"></i> Bản đồ xe buýt thông minh</div>
            <div class="section-subtitle mb-4">Giải pháp chuyển đổi số giao thông công cộng Thủ đô</div>
            
            <div class="d-flex flex-column gap-4">
                <div class="info-card-custom">
                    <div class="info-icon-wrapper">
                        <i class="fas fa-satellite-dish"></i>
                    </div>
                    <h6 class="fw-bold text-dark">Định vị thời gian thực</h6>
                    <p class="small text-muted mb-0">Theo dõi trực quan lịch trình xe chạy, thời gian xe đến trạm dừng theo thời gian thực giúp bạn chủ động thời gian.</p>
                </div>
                
                <div class="info-card-custom">
                    <div class="info-icon-wrapper">
                        <i class="fas fa-route"></i>
                    </div>
                    <h6 class="fw-bold text-dark">Tối ưu hóa lộ trình</h6>
                    <p class="small text-muted mb-0">Thuật toán tìm đường thông minh tự động đề xuất phương án đi xe buýt ngắn nhất, tốn ít chi phí nhất và ít phải chuyển tuyến nhất.</p>
                </div>
                
                <div class="info-card-custom">
                    <div class="info-icon-wrapper">
                        <i class="fas fa-leaf"></i>
                    </div>
                    <h6 class="fw-bold text-dark">Giao thông xanh bền vững</h6>
                    <p class="small text-muted mb-0">Khuyến khích người dân sử dụng phương tiện công cộng thông qua hệ thống quản lý vé điện tử, góp phần giảm tải ùn tắc và bảo vệ môi trường.</p>
                </div>
            </div>
        </div>
        
        <!-- Right Column: Hot News & Articles -->
        <div class="col-lg-7">
            <div class="section-title mb-1"><i class="fas fa-fire text-danger me-2"></i> Tin tức & Sự kiện nóng hổi</div>
            <div class="section-subtitle mb-4">Các tin bài mới nhất về chủ đề Bus Map & Đô thị thông minh</div>
            
            <div class="d-flex flex-column gap-3">
                <!-- Article 1 -->
                <div class="article-card">
                    <img src="https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=300&auto=format&fit=crop&q=60" alt="Hanoi Bus" class="article-img">
                    <div class="article-content flex-grow-1">
                        <div>
                            <span class="article-badge">HOT NEWS</span>
                            <h6 class="article-title">Hà Nội ra mắt bản đồ số xe buýt thông minh tích hợp định vị GPS</h6>
                            <p class="article-desc">Hành khách giờ đây có thể theo dõi vị trí thực tế của xe buýt qua bản đồ số trực quan, hạn chế tối đa thời gian chờ đợi tại trạm.</p>
                        </div>
                        <div class="article-meta">
                            <span><i class="far fa-newspaper me-1"></i> VnExpress</span>
                            <span><i class="far fa-clock me-1"></i> Hôm qua</span>
                            <a href="https://vnexpress.net" target="_blank" class="read-more-btn">Đọc báo <i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
                
                <!-- Article 2 -->
                <div class="article-card">
                    <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=300&auto=format&fit=crop&q=60" alt="Bus Map App" class="article-img">
                    <div class="article-content flex-grow-1">
                        <div>
                            <span class="article-badge" style="background:#e6f7ff; color:#1890ff;">XU HƯỚNG</span>
                            <h6 class="article-title">Ứng dụng Bus Map giúp giảm 30% tình trạng trễ giờ của hành khách</h6>
                            <p class="article-desc">Khảo sát mới đây cho thấy hệ thống tìm đường thông minh trên bản đồ số giúp người dân tiếp cận giao thông công cộng dễ dàng hơn.</p>
                        </div>
                        <div class="article-meta">
                            <span><i class="far fa-newspaper me-1"></i> Tuổi Trẻ</span>
                            <span><i class="far fa-clock me-1"></i> 2 ngày trước</span>
                            <a href="https://tuoitre.vn" target="_blank" class="read-more-btn">Đọc báo <i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
                
                <!-- Article 3 -->
                <div class="article-card">
                    <img src="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=300&auto=format&fit=crop&q=60" alt="Eco Transportation" class="article-img">
                    <div class="article-content flex-grow-1">
                        <div>
                            <span class="article-badge" style="background:#f6ffed; color:#52c41a;">MỚI</span>
                            <h6 class="article-title">Phát triển hệ thống giao thông công cộng Hà Nội hướng tới đô thị xanh</h6>
                            <p class="article-desc">Đẩy mạnh tích hợp các giải pháp thẻ vé thông minh và bản đồ số cho toàn bộ mạng lưới xe buýt và đường sắt đô thị trong năm 2026.</p>
                        </div>
                        <div class="article-meta">
                            <span><i class="far fa-newspaper me-1"></i> Thanh Niên</span>
                            <span><i class="far fa-clock me-1"></i> 3 ngày trước</span>
                            <a href="https://thanhnien.vn" target="_blank" class="read-more-btn">Đọc báo <i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ===== FOOTER ===== -->
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
<script>
    // Swap From/To stop
    document.getElementById('swapStops')?.addEventListener('click', function () {
        const fromSelect = document.querySelector('select[name="fromStop"]');
        const toSelect = document.querySelector('select[name="toStop"]');
        const temp = fromSelect.value;
        fromSelect.value = toSelect.value;
        toSelect.value = temp;
    });
</script>
</body>
</html>
