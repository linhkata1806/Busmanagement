<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông Báo Hệ Thống - Tài Xế</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --bg-light: #f8fafc;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .main-content {
                padding: 2rem;
            }
            .noti-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                background: white;
                transition: all 0.2s;
            }
            .noti-card.unread {
                border-left: 4px solid #3b82f6;
                background-color: #f8fafc;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../sidebar.jsp">
                    <jsp:param name="activeMenu" value="notification" />
                </jsp:include>

                <!-- Main Content Area -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2 text-dark fw-bold">Thông Báo Hệ Thống</h1>
                        <span class="badge bg-primary px-2.5 py-1.5 rounded-pill">Chưa đọc: ${unreadCount}</span>
                    </div>

                    <!-- Notifications List -->
                    <div class="d-flex flex-column gap-3">
                        <c:choose>
                            <c:when test="${not empty notiList}">
                                <c:forEach var="n" items="${notiList}">
                                    <div class="noti-card p-4 ${n.isRead() ? '' : 'unread'}">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <span class="badge bg-secondary mb-2">${n.notificationType}</span>
                                                <h5 class="fw-bold text-dark mb-0">${n.title}</h5>
                                            </div>
                                            <small class="text-secondary fw-semibold">${n.createdAt}</small>
                                        </div>
                                        <p class="text-secondary mb-3">${n.content}</p>
                                        <c:if test="${not n.isRead()}">
                                            <form action="${pageContext.request.contextPath}/driver/notification" method="POST">
                                                <input type="hidden" name="notificationID" value="${n.notificationID}">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-check me-1"></i>Đã đọc
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-secondary noti-card p-4">
                                    <i class="fas fa-bell-slash fa-3x mb-3 text-light"></i>
                                    <p class="mb-0">Hộp thư thông báo trống.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
