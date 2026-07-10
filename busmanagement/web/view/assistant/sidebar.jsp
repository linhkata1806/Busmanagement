<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* CSS ĐỘC LẬP BẢO VỆ SIDEBAR KHỎI VỠ GIAO DIỆN */
    .bus-sidebar {
        background-color: #0d47a1 !important; /* Đổi sang màu xanh đậm giống của staff/admin */
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

    /* ĐỊNH DẠNG DROPDOWN MENU KHI CHIA ĐÔI MÀN HÌNH / MOBILE */
    .dropdown-menu-dark .dropdown-item {
        color: rgba(255, 255, 255, 0.85) !important;
        font-weight: 500;
        transition: all 0.2s;
    }
    .dropdown-menu-dark .dropdown-item:hover {
        background-color: rgba(255, 255, 255, 0.1) !important;
        color: #fff !important;
    }
    .dropdown-menu-dark .dropdown-item.active {
        background-color: rgba(255, 255, 255, 0.2) !important;
        color: #fff !important;
        font-weight: 600;
    }
    
    /* HỖ TRỢ CHIA ĐÔI MÀN HÌNH / MOBILE VIEW */
    @media (max-width: 767.98px) {
        nav.bus-sidebar {
            display: block !important; /* Luôn hiển thị thanh dropdown */
            min-height: auto !important;
            width: 100% !important;
            position: relative !important;
            padding: 12px 15px !important;
            background-color: #0d47a1 !important;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .bus-sidebar .desktop-brand,
        .bus-sidebar hr,
        .bus-sidebar ul.nav,
        .bus-sidebar .logout-container {
            display: none !important;
        }
    }
</style>

<nav class="col-md-3 col-lg-2 d-md-block bus-sidebar collapse p-3 shadow position-relative">
    <!-- TIÊU ĐỀ KHI TRÊN DESKTOP -->
    <div class="desktop-brand d-flex align-items-center mb-4 px-2">
        <i class="fas fa-bus-alt fa-2x text-info me-2"></i>
        <span class="fs-5 fw-bold text-white">Phụ Xe Bus</span>
    </div>
    <hr class="text-secondary">
    
    <!-- MENU DROPDOWN KHI CHIA ĐÔI MÀN HÌNH / MOBILE -->
    <div class="mobile-nav-container w-100 d-md-none">
        <div class="dropdown">
            <button class="btn btn-outline-light dropdown-toggle w-100 py-2.5 px-3 text-start d-flex align-items-center justify-content-between" type="button" id="mobileMenuDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="background-color: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.25); border-radius: 0.5rem;">
                <span class="fw-semibold text-white">
                    <c:choose>
                        <c:when test="${param.activeMenu == 'dashboard'}">
                            <i class="fas fa-chart-pie text-info me-2"></i>Tổng quan
                        </c:when>
                        <c:when test="${param.activeMenu == 'trip'}">
                            <i class="fas fa-route text-info me-2"></i>Chuyến đi của tôi
                        </c:when>
                        <c:when test="${param.activeMenu == 'notification'}">
                            <i class="fas fa-bell text-info me-2"></i>Thông báo
                        </c:when>
                        <c:when test="${param.activeMenu == 'profile'}">
                            <i class="fas fa-user-circle text-info me-2"></i>Thông tin cá nhân
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-bus-alt text-info me-2"></i>Phụ Xe Bus
                        </c:otherwise>
                    </c:choose>
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-dark w-100 shadow border-0 mt-2" aria-labelledby="mobileMenuDropdown" style="background-color: #0d47a1; border: 1px solid rgba(255,255,255,0.15); border-radius: 0.5rem; padding: 0.5rem;">
                <li>
                    <a class="dropdown-item py-2 px-3 rounded-2 ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/dashboard">
                        <i class="fas fa-chart-pie me-2"></i>Tổng quan
                    </a>
                </li>
                <li>
                    <a class="dropdown-item py-2 px-3 rounded-2 ${param.activeMenu == 'trip' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/trip">
                        <i class="fas fa-route me-2"></i>Chuyến đi của tôi
                    </a>
                </li>
                <li>
                    <a class="dropdown-item py-2 px-3 rounded-2 ${param.activeMenu == 'notification' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/notification">
                        <i class="fas fa-bell me-2"></i>Thông báo
                        <c:if test="${not empty unreadCount and unreadCount > 0}">
                            <span class="badge bg-danger ms-2 rounded-pill">${unreadCount}</span>
                        </c:if>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item py-2 px-3 rounded-2 ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/profile">
                        <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
                    </a>
                </li>
                <li><hr class="dropdown-divider border-secondary opacity-25"></li>
                <li>
                    <a class="dropdown-item py-2 px-3 rounded-2 fw-bold text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
    
    <!-- DANH SÁCH MENU TRÊN DESKTOP -->
    <ul class="nav flex-column gap-2 mb-5">
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/dashboard">
                <i class="fas fa-chart-pie me-2"></i>Tổng quan
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'trip' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/trip">
                <i class="fas fa-route me-2"></i>Chuyến đi của tôi
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'notification' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/notification">
                <i class="fas fa-bell me-2"></i>Thông báo
                <c:if test="${not empty unreadCount and unreadCount > 0}">
                    <span class="badge bg-danger float-end rounded-pill">${unreadCount}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/profile">
                <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
            </a>
        </li>
    </ul>
    
    <!-- ĐĂNG XUẤT TRÊN DESKTOP -->
    <div class="logout-container position-absolute bottom-0 start-0 w-100 p-3">
        <hr class="text-secondary">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link py-2.5 px-3 fw-bold" style="color: #ff4d4d !important;">
            <i class="fas fa-sign-out-alt me-2" style="color: #ff4d4d !important;"></i>Đăng xuất
        </a>
    </div>
</nav>
