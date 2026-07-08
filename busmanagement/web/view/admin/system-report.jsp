<%-- 
    Document   : system-report
    Created on : 06-07-2026, 21:00:44
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Tài nguyên Hệ thống - Admin</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            .card-link {
                text-decoration: none;
                display: block;
                height: 100%;
            }
            .db-card {
                border: none;
                border-radius: 12px;
                transition: all 0.3s ease;
            }
            .db-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            }
            .icon-shape {
                width: 55px;
                height: 55px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }
            .action-text {
                font-size: 0.85rem;
                opacity: 0;
                transition: opacity 0.3s, transform 0.3s;
                transform: translateX(-10px);
            }
            .db-card:hover .action-text {
                opacity: 1;
                transform: translateX(0);
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp"><jsp:param name="activeMenu" value="system" /></jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
                            <div>
                                <h2 class="fw-bold text-dark mb-0">Quản lý Tài nguyên & Quy mô Dữ liệu</h2>
                                <p class="text-muted small m-0 mt-1">Bấm vào từng khối dữ liệu để đi đến trang quản lý tương ứng.</p>
                            </div>
                            <span class="badge bg-dark px-3 py-2 fs-7"><i class="fas fa-database me-2"></i>Schema trạng thái: Khỏe mạnh</span>
                        </div>

                        <div class="row g-4">

                            <!-- BẢNG ACCOUNTS -->
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/admin/accounts" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Tài Khoản (Accounts)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.accounts} <span class="fs-6 text-muted font-normal">tài khoản</span></h3>
                                        </div>
                                        <div class="icon-shape bg-primary text-white"><i class="fas fa-users"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-primary fw-bold">
                                        Truy cập quản lý <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG ROUTES -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/staff/route" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Tuyến Xe (Routes)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.routes} <span class="fs-6 text-muted font-normal">tuyến xe</span></h3>
                                        </div>
                                        <div class="icon-shape bg-success text-white"><i class="fas fa-route"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-success fw-bold">
                                        Truy cập quản lý <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG STOPS -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/staff/stop" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Trạm Dừng (Stops)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.stops} <span class="fs-6 text-muted font-normal">trạm dừng</span></h3>
                                        </div>
                                        <div class="icon-shape bg-info text-white"><i class="fas fa-map-marker-alt"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-info fw-bold">
                                        Truy cập quản lý <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG TRIPS -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/staff/trip" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Lịch Trình (Trips)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.trips} <span class="fs-6 text-muted font-normal">chuyến xe</span></h3>
                                        </div>
                                        <div class="icon-shape bg-warning text-dark"><i class="fas fa-bus"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-warning fw-bold">
                                        Truy cập quản lý <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG TICKETS -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin/revenue-report" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Vé Lẻ (Tickets)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.tickets} <span class="fs-6 text-muted font-normal">vé đã bán</span></h3>
                                        </div>
                                        <div class="icon-shape bg-danger text-white"><i class="fas fa-ticket-alt"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-danger fw-bold">
                                        Xem báo cáo <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG MONTHLY PASSES -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/staff/monthly-pass" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Vé Tháng (Passes)</h6>
                                            <h3 class="fw-bold mb-0 mt-1 text-dark">${dbScale.passes} <span class="fs-6 text-muted font-normal">tổng số</span></h3>
                                        </div>
                                        <div class="icon-shape bg-secondary text-white"><i class="fas fa-calendar-alt"></i></div>
                                    </div>

                                    <div class="d-flex gap-2 mt-2">
                                        <span class="badge bg-warning text-dark border shadow-sm" title="Chờ duyệt"><i class="fas fa-clock me-1"></i>${dbScale.pendingPasses} Chờ</span>
                                        <span class="badge bg-success shadow-sm" title="Đã duyệt"><i class="fas fa-check-circle me-1"></i>${dbScale.approvedPasses} Duyệt</span>
                                        <span class="badge bg-danger shadow-sm" title="Từ chối"><i class="fas fa-times-circle me-1"></i>${dbScale.rejectedPasses} Hủy</span>
                                    </div>

                                    <div class="mt-3 text-end action-text text-secondary fw-bold border-top pt-2">
                                        Truy cập xét duyệt <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <!-- BẢNG NOTIFICATIONS -->
                        <div class="col-md-12">
                            <a href="${pageContext.request.contextPath}/staff/notification" class="card-link">
                                <div class="card db-card shadow-sm p-4 bg-white h-100">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="text-secondary text-uppercase fs-7 fw-bold">Nhật ký Thông báo (Notifications)</h6>
                                            <h4 class="fw-bold mb-0 mt-1 text-dark">Hệ thống đang lưu trữ: <span class="text-primary">${dbScale.notifications}</span> thông báo.</h4>
                                        </div>
                                        <div class="icon-shape bg-dark text-white"><i class="fas fa-bell"></i></div>
                                    </div>
                                    <div class="mt-3 text-end action-text text-dark fw-bold">
                                        Quản lý thông báo hàng loạt <i class="fas fa-arrow-right ms-1"></i>
                                    </div>
                                </div>
                            </a>
                        </div>

                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>