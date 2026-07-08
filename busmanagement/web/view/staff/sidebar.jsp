<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* CSS ĐỘC LẬP BẢO VỆ SIDEBAR KHỎI VỠ GIAO DIỆN */
    .bus-sidebar {
        background-color: #0d47a1 !important; /* Đổi sang màu xanh đậm giống của customer */
        min-height: 100vh;
        color: #e3effd;
    }
    .bus-sidebar .nav-link {
        color: rgba(255, 255, 255, 0.8) !important;
        border-radius: 0.375rem;
        transition: all 0.2s;
        font-weight: 500;
    }
    .bus-sidebar .nav-link:hover, .bus-sidebar .nav-link.active {
        color: #fff !important;
        background-color: rgba(255, 255, 255, 0.2) !important;
    }
    
    /* HỖ TRỢ CHIA ĐÔI MÀN HÌNH / MOBILE VIEW */
    @media (max-width: 767.98px) {
        .bus-sidebar {
            min-height: auto !important;
            width: 100% !important;
            position: relative !important;
            padding: 10px !important;
        }
        .bus-sidebar ul.nav {
            flex-direction: row !important;
            flex-wrap: nowrap !important;
            overflow-x: auto;
            padding-bottom: 5px;
            margin-bottom: 0 !important;
        }
        .bus-sidebar .nav-item {
            flex: 0 0 auto;
        }
        .bus-sidebar hr {
            display: none !important;
        }
        .bus-sidebar .position-absolute {
            position: static !important;
            padding: 0 !important;
            margin-top: 10px;
        }
    }
</style>

<nav class="col-md-3 col-lg-2 d-md-block bus-sidebar collapse p-3 shadow position-relative">
    <div class="d-flex align-items-center mb-4 px-2">
        <i class="fas fa-bus-alt fa-2x text-info me-2"></i>
        <span class="fs-5 fw-bold text-white">Bus Hà Nội</span>
    </div>
    <hr class="text-secondary">
    
    <ul class="nav flex-column gap-2 mb-5">
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="fas fa-chart-pie me-2"></i>Tổng quan
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'pass' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/monthly-pass">
                <i class="fas fa-id-card me-2"></i>Quản lý vé tháng
                <c:if test="${not empty pendingPasses and pendingPasses > 0}">
                    <span class="badge bg-danger float-end rounded-pill">${pendingPasses}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'route' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/route">
                <i class="fas fa-map-marked-alt me-2"></i>Quản lý tuyến xe
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'stop' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/stop">
                <i class="fas fa-map-signs me-2"></i>Quản lý điểm dừng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'trip' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/trip">
                <i class="fas fa-route me-2"></i>Quản lý chuyến xe
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'bus' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/bus">
                <i class="fas fa-bus me-2"></i>Quản lý xe buýt
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'notification' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/notification">
                <i class="fas fa-bell me-2"></i>Thông báo chung
            </a>
        </li>

        <c:if test="${sessionScope.USER.roleName == 'ADMIN'}">
            <hr class="border-secondary opacity-25 mx-3 my-2">
            <li class="nav-item mt-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-danger w-100 text-start text-white shadow-sm py-2 px-3 fw-semibold" style="transition: all 0.2s; border-radius: 0.375rem;">
                    <i class="fas fa-user-shield me-2"></i>Về trang Admin
                </a>
            </li>
        </c:if>
    </ul>
    
    <div class="position-absolute bottom-0 start-0 w-100 p-3">
        <hr class="text-secondary">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link py-2.5 px-3 fw-bold" style="color: #ff4d4d !important;">
            <i class="fas fa-sign-out-alt me-2" style="color: #ff4d4d !important;"></i>Đăng xuất
        </a>
    </div>
</nav>