<%-- 
    Document   : edit-notification
    Created on : Jun 28, 2026, 10:29:31 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa thông báo - Bus Hà Nội</title>
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
            }
            .main-content {
                padding: 2rem;
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
                    <div class="mb-4 pb-2 border-bottom">
                        <h2 class="fw-bold text-dark m-0">Chỉnh sửa thông báo</h2>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                        <form action="${pageContext.request.contextPath}/staff/notification/edit" method="POST" class="d-flex flex-column gap-3">
                            <input type="hidden" name="notificationId" value="${notif.notificationID}">

                            <div class="bg-light p-3 rounded-3 border">
                                <span class="small fw-bold text-secondary d-block mb-1">Mã đối tượng nhận thông báo (Không được phép thay đổi)</span>
                                <span class="fw-bold text-dark"><i class="fas fa-user-shield me-2 text-primary"></i>Tài khoản ID khách hàng: ${notif.accountID}</span>
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Loại thông báo</label>
                                <input type="text" class="form-control bg-light" value="${notif.notificationType}" readonly disabled>
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Tiêu đề thông báo</label>
                                <input type="text" name="title" class="form-control" value="${notif.title}" required autocomplete="off">
                            </div>

                            <div>
                                <label class="form-label small fw-bold">Nội dung thông báo</label>
                                <textarea name="content" class="form-control" rows="5" required>${notif.content}</textarea>
                            </div>

                            <div class="d-flex gap-2 justify-content-end pt-2 border-top">
                                <a href="${pageContext.request.contextPath}/staff/notification" class="btn btn-light px-4 fw-semibold">Hủy</a>
                                <button type="submit" class="btn btn-success px-4 fw-semibold">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>