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
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
            --bg-light: #f4f6f9;
        }
        body { background-color: var(--bg-light); }
        
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

        .custom-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            overflow: hidden;
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        .custom-table th {
            background-color: #f8f9fa;
            color: #6c757d;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            padding: 16px 20px;
            border-bottom: 2px solid #eef2f7;
        }
        .custom-table td {
            padding: 16px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f3f5;
            color: #495057;
            font-size: 0.95rem;
        }
        .custom-table tbody tr {
            transition: all 0.2s ease;
        }
        .custom-table tbody tr:hover {
            background-color: #f8fafe;
            transform: translateY(-1px);
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
         /* ===== FOOTER ===== */
        footer {
            background: #1a1a2e;
            color: rgba(255,255,255,0.7);
            padding: 30px 0;
            margin-top: 60px;
        }
        footer a { color: rgba(255,255,255,0.7); text-decoration: none; }
        footer a:hover { color: white; }

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 20px 0;
            color: white;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .page-header h3 {
            font-size: 1.45rem;
            letter-spacing: -0.3px;
        }
    </style>
</head>
<body>

<!-- ===== HEADER NAVIGATION ===== -->
<jsp:include page="/common/navbar.jsp" />

<div class="page-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <h3 class="fw-bold m-0"><i class="fas fa-heart text-danger me-2"></i>Danh sách tuyến yêu thích</h3>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm border">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container my-5 flex-grow-1" style="min-height: 700px;">

    <div class="d-flex flex-column min-vh-100">
        <c:choose>
            <c:when test="${empty favoriteRoutes}">
                <div class="text-center py-5 text-muted bg-white rounded-3 shadow-sm" id="emptyState">
                    <i class="far fa-heart fa-3x mb-3 text-black-50"></i>
                    <p class="m-0">Bạn chưa có tuyến xe yêu thích nào.</p>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="table-container table-responsive d-flex flex-column h-100" id="favoriteList">
                    <div class="flex-grow-1">
                        <table class="table custom-table" style="min-width: 900px;">
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 15%">Số tuyến</th>
                                    <th scope="col" style="width: 35%">Tên tuyến</th>
                                    <th scope="col" style="width: 25%"><i class="far fa-clock me-1"></i>Giờ chạy</th>
                                    <th scope="col" class="text-center" style="width: 25%">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="route" items="${favoriteRoutes}">
                                    <tr id="route-card-${route.routeID}">
                                        <td>
                                            <span class="route-number-badge">Tuyến ${route.routeNumber}</span>
                                        </td>
                                        <td>
                                            <span class="fw-bold text-dark">${route.routeName}</span>
                                        </td>
                                        <td>
                                            <small class="fw-medium text-muted">${route.operatingHours}</small>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}" class="btn-detail">
                                                    Xem <i class="fas fa-chevron-right ms-1" style="font-size: 0.8rem;"></i>
                                                </a>
                                                <button class="btn btn-sm btn-outline-danger fw-bold rounded-3 px-3" onclick="removeFav(${route.routeID})">
                                                    <i class="fas fa-heart-broken me-1"></i> Bỏ yêu thích
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <%@ include file="../../common/pagination.jsp" %>
                </div>
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
                // Xóa row ngay lập tức không cần hiệu ứng
                const row = document.getElementById('route-card-' + routeId);
                row.remove();
                
                // Nếu xóa hết thì hiện thông báo rỗng
                const tbody = document.querySelector('.custom-table tbody');
                if(!tbody || tbody.children.length === 0) {
                    location.reload(); // Tải lại để hiện khối emptyState
                }
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
