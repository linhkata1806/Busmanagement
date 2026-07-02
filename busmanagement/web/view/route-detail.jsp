<%--
Document   : route-detail
Created on : Jun 22, 2026, 9:46:35 PM
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
        <title>Chi tiết lộ trình - Xe Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary: #1a73e8;
                --primary-dark: #1557b0;
                --accent: #fbbc04;
            }
            .navbar {
                background: var(--primary) !important;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
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
            .nav-link:hover {
                color: white !important;
            }
            .btn-nav-login {
                border: 2px solid white;
                color: white !important;
                border-radius: 20px;
                padding: 6px 18px;
                font-weight: 600;
                transition: all 0.2s;
            }
            .btn-nav-login:hover {
                background: white;
                color: var(--primary) !important;
            }
            .btn-nav-register {
                background: var(--accent);
                color: #333 !important;
                border-radius: 20px;
                padding: 6px 18px;
                font-weight: 600;
                margin-left: 8px;
                transition: all 0.2s;
            }
            .btn-nav-register:hover {
                background: #f9a825;
            }
            .dropdown-menu {
                border: none;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

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

            /* DETAIL HEADER */
            .detail-header {
                background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%);
                padding: 40px 0;
                color: white;
                margin-bottom: 40px;
            }
            .route-badge {
                background: var(--accent);
                color: #333;
                font-size: 1.8rem;
                font-weight: 800;
                padding: 10px 24px;
                border-radius: 12px;
                display: inline-block;
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }

            /* INFO CARD */
            .info-card {
                border: none;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.06);
                background: white;
            }
            .info-item {
                display: flex;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .info-item:last-child {
                border-bottom: none;
            }
            .info-icon {
                width: 40px;
                height: 40px;
                background: #e8f0fe;
                color: var(--primary);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                font-size: 1.1rem;
            }

            /* TIMELINE STOPS */
            .timeline-stops {
                position: relative;
                padding-left: 30px;
                margin-left: 15px;
            }
            .timeline-stops::before {
                content: '';
                position: absolute;
                left: 5px;
                top: 10px;
                bottom: 10px;
                width: 3px;
                background: #e0e0e0;
            }
            .timeline-item {
                position: relative;
                padding-bottom: 25px;
            }
            .timeline-item:last-child {
                padding-bottom: 0;
            }
            .timeline-marker {
                position: absolute;
                left: -30px;
                top: 4px;
                width: 14px;
                height: 14px;
                border-radius: 50%;
                background: white;
                border: 3px solid var(--primary);
                z-index: 2;
                transition: all 0.2s;
            }
            .timeline-item:first-child .timeline-marker {
                border-color: #2e7d32;
                background: #e8f5e9;
            }
            .timeline-item:last-child .timeline-marker {
                border-color: #d32f2f;
                background: #ffebee;
            }
            .timeline-item:hover .timeline-marker {
                transform: scale(1.2);
                background: var(--accent);
            }
            .stop-index {
                color: #888;
                font-weight: 600;
                font-size: 0.9rem;
                margin-right: 8px;
            }
            .stop-name {
                font-weight: 600;
                color: #1a1a2e;
                font-size: 1.05rem;
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

        <c:choose>
            <c:when test="${not empty route}">
                <div class="detail-header">
                    <div class="container text-center text-md-start">
                        <div class="row align-items-center g-3">
                            <div class="col-md-auto text-center">
                                <div class="route-badge">Tuyến ${route.routeNumber}</div>
                            </div>
                            <div class="col-md">
                                <h2 class="fw-bold m-0 d-flex align-items-center">
                                    ${route.routeName}
                                    
                                    <%-- NÚT THẢ TIM ĐÃ SỬA CHUẨN --%>
                                    <i class="fa-heart ms-3 ${isFavorite ? 'fas text-danger' : 'far text-white'}" 
                                       style="cursor: pointer; font-size: 1.8rem; transition: transform 0.2s;"
                                       onclick="toggleFavorite(${route.routeID}, ${not empty sessionScope.USER}, this)"
                                       title="${isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">
                                    </i>
                                </h2>
                                <p class="lead m-0 mt-1 opacity-75">
                                    <i class="fas fa-map-marked-alt me-1"></i> Chi tiết lộ trình hành trình xe buýt công cộng
                                </p>
                            </div>
                            <div class="col-md-auto text-md-end text-center mt-3 mt-md-0">
                                <a href="javascript:history.back()" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container mb-5">
                    <div class="row g-4">
                        <div class="col-lg-5">
                            <div class="card info-card p-4">
                                <h4 class="fw-bold mb-4 text-dark">Thông tin chung</h4>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-play"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Bến đi đầu chặng</small>
                                        <span class="fw-600 text-dark">${route.startPoint}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-flag-checkered"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Bến cuối chặng</small>
                                        <span class="fw-600 text-dark">${route.endPoint}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-clock"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Giờ hoạt động</small>
                                        <span class="fw-600 text-dark">${route.operatingHours}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-sync-alt"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Tần suất chạy xe</small>
                                        <span class="fw-600 text-dark">${not empty route.frequence ? route.frequence : 'Đang cập nhật'}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-ticket-alt"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Giá vé lượt</small>
                                        <span class="fw-bold text-success fs-5">
                                            <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/> đ
                                        </span>
                                    </div>
                                </div>

                                <div class="info-item border-bottom-0 pb-0">
                                    <div class="info-icon"><i class="fas fa-toggle-on"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Trạng thái vận hành</small>
                                        <c:choose>
                                            <c:when test="${route.isActive}">
                                                <span class="badge bg-success">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Tạm dừng vận hành</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="mt-3 pt-3 border-top">
                                    <h6 class="fw-bold text-dark mb-2" style="font-size: 0.95rem;">
                                        <i class="fas fa-tags me-2 text-primary"></i>Đăng ký dịch vụ vé
                                    </h6>

                                    <div class="d-flex flex-column gap-2">
                                        <a href="${pageContext.request.contextPath}/customer/buy-ticket?routeId=${route.routeID}&ticketType=luot" 
                                           class="btn btn-primary btn-sm fw-bold w-100 shadow-sm" style="background-color: var(--primary);">
                                            <i class="fas fa-ticket-alt me-1"></i> Mua vé lượt trực tuyến
                                        </a>

                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/customer/buy-ticket?routeId=${route.routeID}&ticketType=thang" 
                                               class="btn btn-outline-primary btn-sm fw-bold w-50">
                                                <i class="fas fa-id-card me-1"></i> Vé tháng
                                            </a>

                                            <a href="${pageContext.request.contextPath}/customer/buy-ticket?routeId=${route.routeID}&ticketType=lien_chuyen" 
                                               class="btn btn-outline-primary btn-sm fw-bold w-50">
                                                <i class="fas fa-route me-1"></i> Liên chuyến
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-7">
                            <div class="card info-card p-4">
                                <h4 class="fw-bold mb-4 text-dark">Lộ trình các trạm dừng</h4>

                                <c:choose>
                                    <c:when test="${not empty stops}">
                                        <div class="timeline-stops">
                                            <c:forEach var="stop" items="${stops}" varStatus="status">
                                                <div class="timeline-item">
                                                    <div class="timeline-marker"></div>
                                                    <div class="d-flex align-items-baseline">
                                                        <span class="stop-index">${status.index + 1}.</span>
                                                        <div>
                                                            <span class="stop-name">${stop.stopName}</span>
                                                            <c:if test="${not empty stop.address}">
                                                                <small class="text-muted d-block mt-1"><i class="fas fa-map-marker-alt me-1"></i>${stop.address}</small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted">
                                            <i class="fas fa-map-signs fa-3x mb-2 opacity-50"></i>
                                            <p>Dữ liệu danh sách trạm dừng hiện chưa được cập nhật.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div> 
                </div> 
            </c:when>
            <c:otherwise>
                <div class="container my-5 py-5 text-center">
                    <div class="card info-card p-5 mx-auto" style="max-width: 600px;">
                        <i class="fas fa-exclamation-triangle fa-4x text-warning mb-3"></i>
                        <h3 class="fw-bold">Không tìm thấy thông tin tuyến!</h3>
                        <p class="text-muted">Tuyến xe bus bạn yêu cầu không tồn tại trên hệ thống hoặc đã dừng cung cấp thông tin.</p>
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 py-2 rounded-pill">Quay lại Trang chủ</a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

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
            function toggleFavorite(routeId, isLoggedIn, iconElement) {
                console.log("Đã click tim! RouteID:", routeId, "| LoggedIn:", isLoggedIn);

                // 1. Kiểm tra đăng nhập
                if (!isLoggedIn) {
                    alert("Bạn cần đăng nhập để thêm tuyến này vào mục yêu thích!");
                    window.location.href = '${pageContext.request.contextPath}/login';
                    return;
                }

                // 2. Lấy trạng thái hiện tại
                const isCurrentlyFav = iconElement.classList.contains('fas'); 
                const action = isCurrentlyFav ? 'remove' : 'add';

                // 3. Hiệu ứng UI nhỏ
                iconElement.style.transform = "scale(0.7)";
                setTimeout(() => iconElement.style.transform = "scale(1)", 200);

                // 4. Bắn AJAX bằng Fetch API
                fetch('${pageContext.request.contextPath}/customer/favorite', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({
                        'routeId': routeId,
                        'action': action
                    })
                })
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi mạng HTTP: " + response.status);
                    return response.json();
                })
                .then(data => {
                    console.log("Phản hồi từ server:", data);
                    if (data.success) {
                        // Cập nhật lại UI tim
                        if (action === 'add') {
                            iconElement.classList.remove('far', 'text-white');
                            iconElement.classList.add('fas', 'text-danger');
                            iconElement.title = 'Bỏ yêu thích';
                        } else {
                            iconElement.classList.remove('fas', 'text-danger');
                            iconElement.classList.add('far', 'text-white');
                            iconElement.title = 'Thêm vào yêu thích';
                        }
                    } else {
                        alert('Thao tác không thành công: ' + (data.message || 'Lỗi không xác định'));
                    }
                })
                .catch(error => {
                    console.error('Fetch Error:', error);
                    alert('Lỗi kết nối tới máy chủ!');
                });
            }
        </script>
    </body>
</html>