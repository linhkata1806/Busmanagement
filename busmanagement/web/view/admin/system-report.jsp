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
    <title>Quy mô Hệ thống - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .db-card {
            border: none;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .db-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1) !important;
        }
        .icon-shape {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <jsp:include page="sidebar.jsp"><jsp:param name="activeMenu" value="system" /></jsp:include>
        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
                <h2 class="fw-bold text-dark mb-0">Thống Kê Thể Tích & Quy Mô Dữ Liệu</h2>
                <span class="badge bg-dark px-3 py-2 fs-7"><i class="fas fa-database me-2"></i>Schema trạng thái: Khỏe mạnh</span>
            </div>

            <div class="row g-4">
                
                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Accounts</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.accounts} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-primary text-white"><i class="fas fa-users"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Routes</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.routes} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-success text-white"><i class="fas fa-route"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Stops</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.stops} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-info text-white"><i class="fas fa-map-marker-alt"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Trips</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.trips} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-warning text-dark"><i class="fas fa-bus"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Tickets</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.tickets} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-danger text-white"><i class="fas fa-ticket-alt"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng MonthlyPasses</h6>
                                <h3 class="fw-bold mb-0 mt-1">${dbScale.passes} <span class="fs-6 text-muted font-normal">dòng</span></h3>
                            </div>
                            <div class="icon-shape bg-secondary text-white"><i class="fas fa-calendar-alt"></i></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="card db-card shadow-sm p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary text-uppercase fs-7 fw-bold">Bảng Notifications (Nhật ký gửi thông báo hệ thống)</h6>
                                <h4 class="fw-bold mb-0 mt-1">Hệ thống đang lưu trữ đầy đủ: <span class="text-primary">${dbScale.notifications}</span> bản ghi thông báo hàng loạt.</h4>
                            </div>
                            <div class="icon-shape bg-dark text-white"><i class="fas fa-bell"></i></div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>
</body>
</html>