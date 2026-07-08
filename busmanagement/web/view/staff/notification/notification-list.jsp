<%-- 
    Document   : notification-list
    Created on : Jun 28, 2026, 10:28:25 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý thông báo - Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --sidebar-bg: #1e293b;
                --bg-light: #f8f9fa;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', sans-serif;
            }
            .sidebar {
                background-color: var(--sidebar-bg);
                min-height: 100vh;
                color: #cbd5e1;
            }
            .sidebar .nav-link {
                color: #94a3b8;
                border-radius: 0.375rem;
                transition: all 0.2s;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255,255,255,0.1);
            }
            .main-content {
                padding: 2rem;
            }
            .table-responsive {
                border-radius: 0.75rem;
            }
            .table-dark th {
                padding-top: 15px !important;
                padding-bottom: 15px !important;
                vertical-align: middle !important;
                font-size: 0.9rem !important;
                font-weight: 600 !important;
            }
            .table tbody td {
                padding-top: 12px !important;
                padding-bottom: 12px !important;
                vertical-align: middle !important;
            }
        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/view/staff/sidebar.jsp">
                    <jsp:param name="activeMenu" value="notification" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h2 class="fw-bold m-0" style="color: #5c67f2 !important;"><i class="fas fa-bell me-2"></i>Thông báo chung</h2>
                        <a href="${pageContext.request.contextPath}/staff/notification/create" class="btn btn-primary fw-semibold">
                            <i class="fas fa-plus-circle me-2"></i>Tạo thông báo mới
                        </a>
                    </div>

                    <c:if test="${not empty sessionScope.msgSuccess}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.msgSuccess}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgSuccess" scope="session"/>
                    </c:if>

                    <div class="card border-0 shadow-sm rounded-4 bg-white">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped align-middle mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Người nhận</th>
                                            <th>Loại</th>
                                            <th>Tiêu đề</th>
                                            <th>Nội dung</th>
                                            <th>Ngày tạo</th>
                                            <th class="text-center">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty notifications}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <i class="fas fa-bullhorn fa-2x mb-2 d-block text-black-50"></i>
                                                        Chưa có thông báo nào được phát hành.
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="n" items="${notifications}">
                                                    <tr>
                                                        <td class="ps-4 text-secondary">#${n.notificationID}</td>
                                                        <td><span class="badge bg-dark">Mã TK: ${n.accountID}</span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${n.notificationType.name() eq 'SYSTEM'}"><span class="badge bg-primary">${n.notificationType}</span></c:when>
                                                                <c:when test="${n.notificationType.name() eq 'ALERT' || n.notificationType.name() eq 'ROUTE_DELAY'}"><span class="badge bg-danger">${n.notificationType}</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${n.notificationType}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="fw-semibold text-dark">${n.title}</td>
                                                        <td class="text-muted small text-truncate" style="max-width: 200px;">${n.content}</td>
                                                        <td class="small text-secondary">${n.createdAt}</td>
                                                        <td class="text-center">
                                                            <div class="d-inline-flex gap-2">
                                                                <a href="${pageContext.request.contextPath}/staff/notification/edit?id=${n.notificationID}" class="btn btn-sm btn-outline-primary px-2.5">
                                                                    <i class="fas fa-edit me-1"></i>Sửa
                                                                </a>
                                                                <form action="${pageContext.request.contextPath}/staff/notification/delete" method="POST" class="m-0" onsubmit="return confirm('Bạn chắc chắn muốn XÓA thông báo này?')">
                                                                    <input type="hidden" name="id" value="${n.notificationID}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger px-2.5">
                                                                        <i class="fas fa-trash-alt me-1"></i>Xóa
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
