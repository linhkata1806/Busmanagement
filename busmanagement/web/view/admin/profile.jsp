<%-- 
    Document   : profile
    Created on : 06-07-2026, 19:36:04
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Hồ sơ Admin</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            .profile-header {
                background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
                color: white;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                padding: 2rem 1rem;
                text-align: center;
            }
            .profile-avatar {
                font-size: 5rem;
                color: #ffffff;
                background-color: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                padding: 15px;
                width: 110px;
                height: 110px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1rem;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .info-label {
                font-weight: 600;
                color: #6c757d;
            }
            .info-value {
                font-weight: 500;
                color: #212529;
            }
            .custom-card {
                border: none;
                border-radius: 12px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp"><jsp:param name="activeMenu" value="profile" /></jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-5">

                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <h3 class="fw-bold mb-4 text-dark"><i class="fas fa-id-badge me-2"></i>Hồ sơ Quản trị viên</h3>

                                <div class="card shadow custom-card">
                                    <div class="profile-header">
                                        <div class="profile-avatar">
                                            <i class="fas fa-user-shield"></i>
                                        </div>
                                        <h4 class="fw-bold mb-1">${profile.fullName}</h4>
                                    <p class="mb-0 text-light opacity-75">@${profile.username}</p>
                                </div>

                                <div class="card-body p-4">
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item d-flex justify-content-between align-items-center py-3 px-0 border-bottom">
                                            <span class="info-label"><i class="fas fa-envelope text-primary me-2"></i>Email</span>
                                            <span class="info-value">${profile.email}</span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center py-3 px-0 border-bottom">
                                            <span class="info-label"><i class="fas fa-phone-alt text-success me-2"></i>Số điện thoại</span>
                                            <span class="info-value">${profile.phone}</span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center py-3 px-0">
                                            <span class="info-label"><i class="fas fa-user-tag text-warning me-2"></i>Vai trò hệ thống</span>
                                            <span class="badge bg-danger px-3 py-2 fs-6 shadow-sm"><i class="fas fa-crown me-1"></i>${profile.roleName}</span>
                                        </li>
                                    </ul>

                                    <div class="mt-4 text-center">
                                        <button class="btn btn-outline-primary px-4 rounded-pill" disabled title="Tài khoản hệ thống không thể tự sửa">
                                        </button>
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