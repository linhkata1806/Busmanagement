<%-- 
    Document   : favorite
    Created on : Jun 28, 2026, 11:08:29 AM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tuyến xe yêu thích - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <style>
        body { background-color: #f8f9fa; }
        .route-card {
            transition: all 0.3s ease;
        }
        .route-card.removing {
            opacity: 0;
            transform: scale(0.9);
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h3 class="fw-bold text-secondary m-0">
            <i class="fas fa-heart text-danger me-2"></i>Danh sách tuyến yêu thích
        </h3>
        <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <div class="row g-3" id="favoriteList">
        <c:choose>
            <c:when test="${empty favoriteRoutes}">
                <div class="col-12 text-center py-5 text-muted bg-white rounded-3 shadow-sm" id="emptyState">
                    <i class="far fa-heart fa-3x mb-3 text-black-50"></i>
                    <p class="m-0">Bạn chưa có tuyến xe yêu thích nào.</p>
                </div>
            </c:when>
            
            <c:otherwise>
                <c:forEach var="route" items="${favoriteRoutes}">
                    <div class="col-md-6 col-lg-4 route-card" id="route-card-${route.routeID}">
                        <div class="card h-100 border-0 shadow-sm rounded-3">
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <span class="badge bg-warning text-dark fs-6 me-2">Tuyến ${route.routeNumber}</span>
                                </div>
                                <h5 class="fw-bold text-dark">${route.routeName}</h5>
                                <p class="text-muted small mb-3">
                                    <i class="fas fa-clock me-1"></i> ${route.operatingHours}
                                </p>
                                <hr class="opacity-25">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" 
                                       class="btn btn-sm btn-outline-primary fw-bold">
                                        <i class="fas fa-info-circle me-1"></i> Xem chi tiết
                                    </a>
                                    
                                    <button class="btn btn-sm btn-light text-danger fw-bold border" 
                                            onclick="removeFav(${route.routeID})">
                                        <i class="fas fa-heart-broken me-1"></i> Bỏ yêu thích
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function removeFav(routeId) {
        if(!confirm("Bạn có chắc chắn muốn bỏ yêu thích tuyến này?")) return;

        fetch('${pageContext.request.contextPath}/customer/favorite', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                'routeId': routeId,
                'action': 'remove'
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Hiệu ứng mờ dần và xóa thẻ
                const card = document.getElementById('route-card-' + routeId);
                card.classList.add('removing');
                setTimeout(() => {
                    card.remove();
                    // Nếu xóa hết thì hiện thông báo rỗng
                    const list = document.getElementById('favoriteList');
                    if(list.children.length === 0 || (list.children.length === 1 && list.children[0].id === 'emptyState')) {
                        location.reload(); // Tải lại để hiện khối 
                    }
                }, 300);
            } else {
                alert('Có lỗi xảy ra: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Lỗi kết nối máy chủ!');
        });
    }
</script>

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
</body>
</html>
