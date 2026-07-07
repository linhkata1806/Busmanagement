<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .bus-sidebar {
        background-color: #1e293b;
        min-height: 100vh;
        color: #cbd5e1;
    }
    .bus-sidebar .nav-link {
        color: #94a3b8;
        border-radius: 0.375rem;
        transition: all 0.2s;
        font-weight: 500;
    }
    .bus-sidebar .nav-link:hover, .bus-sidebar .nav-link.active {
        color: #fff;
        background-color: rgba(255, 255, 255, 0.1);
    }
</style>

<nav class="col-md-3 col-lg-2 d-md-block bus-sidebar collapse p-3 shadow position-relative">
    <div class="d-flex align-items-center mb-4 px-2">
        <i class="fas fa-bus-alt fa-2x text-info me-2"></i>
        <span class="fs-5 fw-bold text-white">Phụ Xe Bus</span>
    </div>
    <hr class="text-secondary">

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
                <c:if test="${not empty sessionScope.globalUnreadCount and sessionScope.globalUnreadCount > 0}">
                    <span class="badge bg-danger float-end rounded-pill">${sessionScope.globalUnreadCount}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/assistant/profile">
                <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
            </a>
        </li>
    </ul>

    <div class="position-absolute bottom-0 start-0 w-100 p-3">
        <hr class="text-secondary">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link py-2.5 px-3 text-danger fw-bold">
            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
        </a>
    </div>
</nav>
