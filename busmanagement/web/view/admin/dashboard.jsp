<%-- 
    Document   : dashboard
    Created on : 06-07-2026, 19:26:06
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Quản Trị - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1e3a8a;
            --primary-light: #3b82f6;
            --accent: #f59e0b;
            --bg-light: #f8fafc;
        }
        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-content {
            padding: 2rem;
        }
        .stat-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            transition: transform 0.2s;
            background: #ffffff;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .stat-card:hover {
            transform: translateY(-2px);
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }
        .bg-card-blue { background-color: #eff6ff; color: #1e40af; }
        .bg-card-green { background-color: #f0fdf4; color: #166534; }
        .bg-card-orange { background-color: #fffbeb; color: #9a3412; }
        
        /* Thêm hiệu ứng hover nhẹ cho link đi tới trang duyệt */
        .hover-link:hover {
            text-decoration: underline !important;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 text-dark fw-bold">Tổng Quan</h1>
                    <div class="text-secondary fw-semibold">
                        Xin chào, <span class="text-primary">${sessionScope.USER.fullName}</span>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-secondary mb-1">Tổng Tài Khoản Hệ Thống</h6>
                                    <h4 class="fw-bold mb-0 text-dark">${dashboardData.totalAccounts}</h4>
                                </div>
                                <div class="stat-icon bg-card-blue">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                            <div class="mt-2 text-primary fw-semibold fs-7">
                                Bao gồm nhân viên và khách hàng
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-secondary mb-1">Khách Hàng</h6>
                                    <h4 class="fw-bold mb-0 text-dark">${dashboardData.totalCustomers}</h4>
                                </div>
                                <div class="stat-icon bg-card-green">
                                    <i class="fas fa-user-tag"></i>
                                </div>
                            </div>
                            <div class="mt-2 text-success fs-7">
                                Số lượng khách hàng đăng ký
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="stat-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-secondary mb-1">Vé Tháng Chờ Duyệt</h6>
                                    <h4 class="fw-bold mb-0 text-dark">${dashboardData.pendingPasses}</h4>
                                </div>
                                <div class="stat-icon bg-card-orange">
                                    <i class="fas fa-ticket-alt"></i>
                                </div>
                            </div>
                            <div class="mt-2 text-warning fs-7 d-flex justify-content-between align-items-center">
                                <span>Cần staff xử lý</span>
                                <a href="${pageContext.request.contextPath}/staff/monthly-pass" class="text-decoration-none fw-bold text-warning hover-link">
                                    Đi tới trang duyệt 
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12">
                        <div class="card shadow-sm border-0 rounded-3 mb-4">
                            <div class="card-header bg-white border-0 pt-4 px-4">
                                <h5 class="fw-bold text-dark mb-0">Thao tác nhanh</h5>
                            </div>
                            <div class="card-body p-4 text-center py-5 text-secondary">
                                <i class="fas fa-user-shield fa-3x mb-3 text-light" style="color: #cbd5e1 !important;"></i>
                                <p class="mb-0">Với tư cách quản trị viên, bạn có toàn quyền kiểm soát hệ thống và thực thi các nghiệp vụ của nhân viên.</p>

                                <div class="d-flex justify-content-center gap-3 mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-primary shadow-sm">
                                        <i class="fas fa-users-cog me-2"></i>Truy cập Quản lý Tài khoản
                                    </a>

                                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-outline-success shadow-sm bg-white">
                                        <i class="fas fa-exchange-alt me-2"></i>Chuyển sang Giao diện Staff
                                    </a>
                                </div>
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