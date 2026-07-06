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
        <jsp:include page="/common/head_imports.jsp" />
        <!-- Leaflet CSS for Map -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
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

        <!-- ===== HEADER NAVIGATION ===== -->
        <jsp:include page="/common/navbar.jsp" />

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
                        </div>
                    </div>
                </div>

                <div class="container-fluid px-md-5 mb-5">
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

                                <div class="info-item">
                                    <div class="info-icon"><i class="fas fa-hourglass-half"></i></div>
                                    <div>
                                        <small class="text-muted d-block">Thời gian di chuyển dự kiến</small>
                                        <span class="fw-bold text-dark">${route.estimatedDuration} phút</span>
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
                            </div> <!-- closes mt-3 pt-3 border-top -->
                        </div> <!-- closes card info-card p-4 -->
                    </div> <!-- closes col-lg-5 -->

                    <div class="col-lg-7">
                            <c:if test="${not empty stops}">
                                <div class="card info-card p-0 overflow-hidden mb-4" style="border: 1px solid #ced4da;">
                                    <div class="bg-primary text-white p-3 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%) !important;">
                                        <h5 class="fw-bold m-0" style="font-size: 1.05rem;"><i class="fas fa-map-marked-alt me-2"></i>Bản đồ & Giả lập xe đang chạy</h5>
                                        <span class="badge bg-success"><i class="fas fa-sync-alt fa-spin me-1"></i> Live</span>
                                    </div>
                                    <div id="busMap" style="height: 380px; width: 100%;"></div>
                                </div>

                                <div class="card info-card p-4 mb-4">
                                    <h4 class="fw-bold mb-3 text-dark d-flex justify-content-between align-items-center" style="font-size: 1.15rem;">
                                        <span><i class="fas fa-bus-alt text-primary me-2"></i>Xe bus sắp tới</span>
                                        <span class="badge bg-success-subtle text-success fs-7 fw-normal" style="font-size: 0.8rem;"><i class="fas fa-satellite-dish me-1 animate-pulse"></i> Trực tuyến</span>
                                    </h4>
                                    <div class="d-flex flex-column gap-3" id="upcomingBusesList">
                                        <!-- Sẽ được điền động bằng JS giả lập -->
                                    </div>
                                </div>
                            </c:if>

                        </div>
                    </div> <!-- closes row g-4 -->

                    <!-- Section 2: Lộ trình các trạm dừng - Full Width -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card info-card p-4">
                                <h4 class="fw-bold mb-4 text-dark"><i class="fas fa-map-signs text-primary me-2"></i>Lộ trình các trạm dừng</h4>

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
                                                            <span class="badge bg-light text-primary border ms-2 small" style="font-size: 0.75rem;"><i class="fas fa-map-signs me-1"></i>+${stop.distanceFromStart} km</span>
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

        <!-- ===== FOOTER ===== -->
        <jsp:include page="/common/footer.jsp" />
        
        <c:if test="${not empty stops}">
            <!-- Leaflet JS -->
            <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
            <script>
                // 1. Chuyển đổi trạm dừng JSP thành dữ liệu JS
                const routeStops = [
                    <c:forEach var="stop" items="${stops}" varStatus="status">
                        {
                            id: ${stop.stopID},
                            name: "<c:out value='${stop.stopName}'/>",
                            distance: ${stop.distanceFromStart},
                            lat: 21.0285 + (${status.index} * 0.005) - (Math.sin(${status.index} * 0.5) * 0.003),
                            lng: 105.8542 + (${status.index} * 0.008) + (Math.cos(${status.index} * 0.5) * 0.002)
                        }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];

                // 2. Khởi tạo Leaflet Map
                const map = L.map('busMap').setView([routeStops[0].lat, routeStops[0].lng], 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap contributors'
                }).addTo(map);

                // 3. Vẽ lộ trình
                const latlngs = routeStops.map(s => [s.lat, s.lng]);
                const polyline = L.polyline(latlngs, {color: '#1a73e8', weight: 5, opacity: 0.8}).addTo(map);
                map.fitBounds(polyline.getBounds());

                // 4. Vẽ Marker các trạm dừng
                routeStops.forEach((stop, index) => {
                    let fillColor = '#1a73e8'; // Bến trung gian
                    if (index === 0) fillColor = '#2e7d32'; // Bến đi
                    else if (index === routeStops.length - 1) fillColor = '#d32f2f'; // Bến cuối
                    
                    const marker = L.circleMarker([stop.lat, stop.lng], {
                        radius: 7,
                        fillColor: fillColor,
                        color: '#ffffff',
                        weight: 2,
                        fillOpacity: 1
                    }).addTo(map);
                    marker.bindPopup(`<b>\${index + 1}. \${stop.name}</b><br>Lộ trình: +\${stop.distance} km`);
                });

                // 5. Khởi tạo xe bus giả lập
                const busIcon = L.divIcon({
                    className: 'custom-bus-icon',
                    html: `<div style="background-color: #fbbc04; border: 2px solid #0d47a1; border-radius: 50%; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.3);"><i class="fas fa-bus" style="color: #0d47a1; font-size: 13px;"></i></div>`,
                    iconSize: [32, 32],
                    iconAnchor: [16, 16]
                });

                let buses = [
                    {
                        id: 1,
                        plate: "29B-145.88",
                        currentSegment: 0,
                        progress: 0.1,
                        speed: 40,
                        marker: null
                    },
                    {
                        id: 2,
                        plate: "29B-289.33",
                        currentSegment: Math.max(1, Math.floor(routeStops.length / 2)),
                        progress: 0.3,
                        speed: 35,
                        marker: null
                    }
                ];

                function updateSimulation() {
                    buses.forEach(bus => {
                        // Tăng tiến độ dựa trên tốc độ
                        bus.progress += 0.015 * (bus.speed / 40);
                        if (bus.progress >= 1.0) {
                            bus.progress = 0;
                            bus.currentSegment = (bus.currentSegment + 1) % (routeStops.length - 1);
                        }
                        
                        const startStop = routeStops[bus.currentSegment];
                        const endStop = routeStops[bus.currentSegment + 1];
                        
                        const currentLat = startStop.lat + (endStop.lat - startStop.lat) * bus.progress;
                        const currentLng = startStop.lng + (endStop.lng - startStop.lng) * bus.progress;
                        
                        if (!bus.marker) {
                            bus.marker = L.marker([currentLat, currentLng], {icon: busIcon}).addTo(map);
                            bus.marker.bindPopup(`<b>Xe bus \${bus.plate}</b><br>Tốc độ: \${bus.speed} km/h<br>Đang di chuyển tới: \${endStop.name}`);
                        } else {
                            bus.marker.setLatLng([currentLat, currentLng]);
                            bus.marker.getPopup().setContent(`<b>Xe bus \${bus.plate}</b><br>Tốc độ: \${bus.speed} km/h<br>Đang di chuyển tới: \${endStop.name}`);
                        }
                    });
                    
                    updateBusesList();
                }

                function updateBusesList() {
                    const listContainer = document.getElementById('upcomingBusesList');
                    if (!listContainer) return;
                    
                    let html = '';
                    buses.forEach(bus => {
                        const nextStop = routeStops[bus.currentSegment + 1];
                        const totalDist = nextStop.distance - routeStops[bus.currentSegment].distance;
                        const remainingDist = Math.max(0.1, (totalDist * (1.0 - bus.progress))).toFixed(1);
                        const eta = Math.ceil((remainingDist / bus.speed) * 60);
                        
                        html += `
                            <div class="p-3 bg-light rounded-3 border-start border-warning border-4 d-flex justify-content-between align-items-center shadow-sm" style="cursor:pointer; transition: all 0.2s;" onclick="focusBus(\${bus.id})">
                                <div>
                                    <div class="fw-bold text-dark mb-1"><i class="fas fa-bus me-2 text-primary"></i>\${bus.plate}</div>
                                    <div class="small text-muted mb-1" style="font-size: 0.85rem;">Trạm tiếp theo: <strong>\${nextStop.name}</strong></div>
                                    <div class="small text-secondary" style="font-size: 0.8rem;">Cách bến: \${remainingDist} km | Tốc độ: \${bus.speed} km/h</div>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-warning text-dark px-2 py-1 mb-1" style="font-size: 0.75rem;">Sắp tới</span>
                                    <strong class="text-success d-block fs-5">\${eta} phút</strong>
                                </div>
                            </div>
                        `;
                    });
                    listContainer.innerHTML = html;
                }

                window.focusBus = function(busId) {
                    const bus = buses.find(b => b.id === busId);
                    if (bus && bus.marker) {
                        map.setView(bus.marker.getLatLng(), 15);
                        bus.marker.openPopup();
                    }
                };

                // Chạy vòng lặp giả lập mỗi 1 giây
                setInterval(updateSimulation, 1000);
                updateSimulation();
            </script>
        </c:if>
        
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