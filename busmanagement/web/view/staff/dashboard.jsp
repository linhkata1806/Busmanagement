<%-- 
    Document   : dashboard
    Created on : Jun 28, 2026
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
        <title>Bảng điều khiển Nhân viên - Hệ thống Xe Buýt</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #1a73e8;
                --sidebar-bg: #1e293b;
                --bg-light: #f8f9fa;
                --card-hover-transform: translateY(-5px);
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            /* Sidebar Styling */
            .sidebar {
                background-color: var(--sidebar-bg);
                min-height: 100vh;
                color: #cbd5e1;
            }
            .sidebar .nav-link {
                color: #94a3b8;
                transition: all 0.2s;
                border-radius: 0.375rem;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255, 255, 255, 0.1);
            }
            /* Main Content & Cards */
            .main-content {
                padding: 2rem;
            }
            .stat-card {
                border: none;
                border-radius: 1rem;
                transition: transform 0.3s, box-shadow 0.3s;
            }
            .stat-card:hover {
                transform: var(--card-hover-transform);
                box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important;
            }
            .icon-box {
                width: 48px;
                height: 48px;
                border-radius: 0.75rem;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .quick-action-btn {
                transition: all 0.2s;
            }
            .quick-action-btn:hover {
                background-color: var(--primary-color) !important;
                color: white !important;
            }
        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp">
                    <jsp:param name="activeMenu" value="dashboard" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <div>
                            <h2 class="fw-bold m-0" style="color: #5c67f2 !important;"><i class="fas fa-chart-pie me-2"></i>Tổng quan</h2>
                            <p class="text-muted small m-0">Chào mừng quay trở lại, <span class="fw-bold text-primary">${staff.fullName}</span> (Nhân viên vận hành)</p>
                        </div>

                        <div class="text-end d-flex align-items-center justify-content-end gap-3">
                            <span class="badge bg-white text-secondary shadow-sm py-2 px-3 rounded-3 fs-6 border m-0">
                                <i class="far fa-calendar-alt text-primary me-2"></i>
                                Hôm nay: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                            </span>
                        </div>
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-4">
                            <div class="card h-100 border-0 shadow-sm stat-card rounded-4 bg-white">
                                <div class="card-body p-4 d-flex flex-column justify-content-between">
                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                        <div>
                                            <p class="text-uppercase fs-7 fw-bold text-muted mb-1">Vé tháng chờ duyệt</p>
                                            <h3 class="fw-extrabold text-dark m-0">${pendingPasses}</h3>
                                        </div>
                                        <div class="icon-box bg-warning bg-opacity-10 text-warning">
                                            <i class="fas fa-clock fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="pt-2 border-top">
                                        <a href="${pageContext.request.contextPath}/staff/monthly-pass" class="small text-decoration-none fw-bold text-warning d-flex align-items-center justify-content-between">
                                            <span>Xử lý hồ sơ ngay <i class="fas fa-external-link-alt ms-1" style="font-size: 0.75rem;"></i></span>
                                            <i class="fas fa-chevron-right text-muted"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card h-100 border-0 shadow-sm stat-card rounded-4 bg-white">
                                <div class="card-body p-4 d-flex flex-column justify-content-between">
                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                        <div>
                                            <p class="text-uppercase fs-7 fw-bold text-muted mb-1">Chuyến xe hôm nay</p>
                                            <h3 class="fw-extrabold text-dark m-0">${totalTripsToday}</h3>
                                        </div>
                                        <div class="icon-box bg-success bg-opacity-10 text-success">
                                            <i class="fas fa-bus fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="pt-2 border-top">
                                        <a href="${pageContext.request.contextPath}/staff/trip" class="small text-decoration-none fw-bold text-success d-flex align-items-center justify-content-between">
                                            <span>Vào trang quản lý chuyến <i class="fas fa-external-link-alt ms-1" style="font-size: 0.75rem;"></i></span>
                                            <i class="fas fa-chevron-right text-muted"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card h-100 border-0 shadow-sm stat-card rounded-4 bg-white">
                                <div class="card-body p-4 d-flex flex-column justify-content-between">
                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                        <div>
                                            <p class="text-uppercase fs-7 fw-bold text-muted mb-1">Tổng lượng thông báo</p>
                                            <h3 class="fw-extrabold text-dark m-0">${totalNotifications}</h3>
                                        </div>
                                        <div class="icon-box bg-primary bg-opacity-10 text-primary">
                                            <i class="fas fa-bell fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="pt-2 border-top">
                                        <a href="${pageContext.request.contextPath}/staff/notification" class="small text-decoration-none fw-bold text-primary d-flex align-items-center justify-content-between">
                                            <span>Xem lịch sử gửi <i class="fas fa-external-link-alt ms-1" style="font-size: 0.75rem;"></i></span>
                                            <i class="fas fa-chevron-right text-muted"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 bg-white">
                        <div class="card-header bg-transparent border-0 pt-4 px-4">
                            <h5 class="fw-bold text-secondary m-0"><i class="fas fa-bolt text-warning me-2"></i>Thao tác xử lý nhanh</h5>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3">
                                <div class="col-xl-3 col-md-6">
                                    <a href="${pageContext.request.contextPath}/staff/monthly-pass" class="btn btn-light w-100 py-3 text-start px-3 shadow-2xs rounded-3 quick-action-btn text-dark fw-semibold">
                                        <i class="fas fa-clipboard-check text-primary me-2 fa-lg"></i>Duyệt vé tháng
                                    </a>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <a href="${pageContext.request.contextPath}/staff/route" class="btn btn-light w-100 py-3 text-start px-3 shadow-2xs rounded-3 quick-action-btn text-dark fw-semibold">
                                        <i class="fas fa-map-marked-alt text-info me-2 fa-lg"></i>Mạng lưới tuyến
                                    </a>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <a href="${pageContext.request.contextPath}/staff/trip" class="btn btn-light w-100 py-3 text-start px-3 shadow-2xs rounded-3 quick-action-btn text-dark fw-semibold">
                                        <i class="fas fa-calendar-plus text-success me-2 fa-lg"></i>Lịch trình chuyến
                                    </a>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <a href="${pageContext.request.contextPath}/staff/notification/create" class="btn btn-light w-100 py-3 text-start px-3 shadow-2xs rounded-3 quick-action-btn text-dark fw-semibold">
                                        <i class="fas fa-bullhorn text-danger me-2 fa-lg"></i>Thông báo khẩn
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>