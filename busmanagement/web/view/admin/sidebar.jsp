<%-- 
    Document   : sidebar
    Created on : 06-07-2026, 19:24:56
    Author     : ASUS
--%>

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
        <i class="fas fa-user-shield fa-2x text-warning me-2"></i>
        <span class="fs-5 fw-bold text-white">Quản Trị Viên</span>
    </div>
    <hr class="text-secondary">

    <ul class="nav flex-column gap-2 mb-5">
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-chart-pie me-2"></i>Tổng quan
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'accounts' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/accounts">
                <i class="fas fa-users-cog me-2"></i>Quản lý Tài khoản
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'revenue' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/revenue-report">
                <i class="fas fa-chart-line me-2"></i>Báo cáo Doanh thu
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'system' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/system-report">
                <i class="fas fa-server me-2"></i>Tài nguyên Hệ thống
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link py-2.5 px-3 ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/profile">
                <i class="fas fa-id-badge me-2"></i>Hồ sơ cá nhân
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