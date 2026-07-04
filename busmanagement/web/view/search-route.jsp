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
    <jsp:include page="/common/head_imports.jsp" />
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

<!-- ===== HEADER NAVIGATION ===== -->
<jsp:include page="/common/navbar.jsp" />

<div class="page-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-5 text-center text-md-start mb-3 mb-md-0">
                <h3 class="fw-bold m-0"><i class="fas fa-search me-2"></i>Tìm kiếm Tuyến Xe Bus</h3>
            </div>
            <div class="col-md-7 col-lg-6 ms-auto">
                <form action="${pageContext.request.contextPath}/search-route" method="GET" class="d-flex shadow-sm">
                    <input type="text" name="keyword" class="form-control border-0 px-3 py-2 bg-white" placeholder="Tìm kiếm nhanh số tuyến hoặc tên tuyến..." style="font-size: 0.9rem; border-radius: 8px 0 0 8px;" value="${keyword}" required>
                    <button type="submit" class="btn btn-warning border-0 px-4 fw-semibold text-white d-flex align-items-center" style="background: var(--accent); border-radius: 0 8px 8px 0; font-size: 0.9rem;">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                </form>
            </div>
        </div>
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
                        <div class="card route-card p-3 h-100">
                            <!-- Phần đầu (Header) - dùng flex-grow-1 để giãn rộng đồng đều giữa các Card -->
                            <div class="flex-grow-1 mb-3">
                                <div class="d-flex align-items-start justify-content-between gap-2">
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
                                    <span class="price-badge flex-shrink-0">
                                        <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                    </span>
                                </div>
                            </div>

                            <!-- Phần giữa (Meta) - căn lề thẳng hàng vì phần trên đã giãn đều -->
                            <div class="route-meta">
                                <div class="route-meta-item"><i class="fas fa-clock"></i>${route.operatingHours}</div>
                                <c:if test="${not empty route.frequence}">
                                    <div class="route-meta-item mt-1"><i class="fas fa-sync-alt"></i>${route.frequence}</div>
                                </c:if>
                            </div>

                            <!-- Nút bấm ở cuối -->
                            <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" class="btn btn-detail mt-3">
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

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
</body>
</html>
