<%-- 
    Document   : notification
    Created on : Jun 28, 2026, 11:47:16 AM
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
    <title>Thông báo của tôi - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <style>
        :root {
            --primary: #0d47a1;
            --primary-light: #1565c0;
            --accent: #fbbc04;
            --bg-light: #f4f6f9;
        }
        
        body {
            background-color: var(--bg-light);
        }

        /* ===== NAVBAR ===== */
        .navbar {
            background: var(--primary) !important;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
            color: white !important;
        }
        .navbar-brand span {
            color: var(--accent);
        }
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            font-weight: 500;
        }

        /* ===== NOTIFICATION STYLES ===== */
        .noti-item {
            transition: all 0.3s ease;
            border-left: 5px solid transparent;
        }
        /* Highlight cho thông báo chưa đọc */
        .noti-unread {
            background-color: #f0f7ff !important;
            border-left-color: #0d6efd !important;
        }
        .noti-unread .noti-title {
            font-weight: 700 !important;
            color: #1a1a2e !important;
        }
        /* Hiệu ứng biến mất khi xóa */
        .noti-item.removing {
            transform: translateX(100%);
            opacity: 0;
        }
        .icon-circle {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        footer {
            background: #1a1a2e;
            color: rgba(255,255,255,0.7);
            padding: 30px 0;
            margin-top: 60px;
        }
        footer a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }
        footer a:hover {
            color: white;
        }
    </style>
</head>
<body>

    <!-- ===== HEADER NAVIGATION ===== -->
    <jsp:include page="/common/navbar.jsp" />

    <div class="container my-5" style="max-width: 850px; min-height: 700px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-dark m-0">
                <i class="fas fa-bell text-warning me-2"></i>Trung tâm thông báo
                <c:if test="${unreadCount > 0}">
                    <span class="badge bg-danger rounded-pill fs-6 ms-2" id="unreadBadge">${unreadCount} mới</span>
                </c:if>
            </h4>
            <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="list-group list-group-flush" id="notiContainer">
                
                <c:choose>
                    <c:when test="${empty notiList}">
                        <div class="text-center py-5 text-muted bg-white" id="emptyState">
                            <i class="far fa-bell-slash fa-3x mb-3 opacity-25"></i>
                            <p class="m-0 fs-6">Hộp thư của bạn hiện đang trống rỗng.</p>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <c:forEach var="noti" items="${notiList}">
                            
                            <%-- Thiết lập cấu trúc Icon/Màu sắc động theo từng Type --%>
                            <c:set var="iconClass" value="fas fa-info-circle" />
                            <c:set var="bgClass" value="bg-light text-secondary" />
                            
                            <c:choose>
                                <c:when test="${noti.notificationType == 'TICKET'}">
                                    <c:set var="iconClass" value="fas fa-ticket-alt" />
                                    <c:set var="bgClass" value="bg-success text-white" />
                                </c:when>
                                <c:when test="${noti.notificationType == 'PASS_APPROVED'}">
                                    <c:set var="iconClass" value="fas fa-id-card" />
                                    <c:set var="bgClass" value="bg-primary text-white" />
                                </c:when>
                                <c:when test="${noti.notificationType == 'SYSTEM_ALERT' || noti.notificationType == 'BUS_ALERT'}">
                                    <c:set var="iconClass" value="fas fa-exclamation-triangle" />
                                    <c:set var="bgClass" value="bg-warning text-dark" />
                                </c:when>
                                <c:when test="${noti.notificationType == 'PROMOTION'}">
                                    <c:set var="iconClass" value="fas fa-gift" />
                                    <c:set var="bgClass" value="bg-danger text-white" />
                                </c:when>
                            </c:choose>

                            <div class="list-group-item p-4 noti-item ${noti.isRead ? '' : 'noti-unread'}" id="noti-row-${noti.notificationID}">
                                <div class="d-flex gap-3">
                                    <div class="icon-circle ${bgClass} flex-shrink-0 shadow-sm">
                                        <i class="${iconClass}"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <h6 class="mb-0 noti-title text-dark fw-semibold">${noti.title}</h6>
                                            <small class="text-muted ms-2 flex-shrink-0" style="font-size: 0.8rem;">
                                                <i class="far fa-clock me-1"></i>${noti.createdAt.toString().replace('T', ' ').substring(0, 16)}
                                            </small>
                                        </div>
                                        <p class="mb-3 text-secondary" style="font-size: 0.95rem; line-height: 1.5;">${noti.content}</p>
                                        
                                        <div class="d-flex gap-2">
                                            <c:if test="${!noti.isRead}">
                                                <button class="btn btn-sm btn-outline-primary fw-semibold px-3" 
                                                        id="btn-read-${noti.notificationID}" 
                                                        onclick="executeAction(${noti.notificationID}, 'read')">
                                                    <i class="fas fa-check me-1"></i> Đánh dấu đã đọc
                                                </button>
                                            </c:if>
                                            <button class="btn btn-sm btn-light border text-muted px-2" 
                                                    onclick="executeAction(${noti.notificationID}, 'delete')" 
                                                    title="Xóa thông báo">
                                                <i class="fas fa-trash-alt text-danger"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
        
        <div class="mt-4">
            <%-- Phân trang --%>
            <jsp:include page="/common/pagination.jsp" />
        </div>
    </div>



    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        function executeAction(notiId, action) {
            if (action === 'delete' && !confirm("Bạn có chắc muốn xóa vĩnh viễn thông báo này?")) {
                return;
            }

            fetch('${pageContext.request.contextPath}/customer/notification', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'notiId': notiId,
                    'action': action
                })
            })
            .then(response => {
                if (!response.ok) throw new Error("HTTP error " + response.status);
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const row = document.getElementById('noti-row-' + notiId);
                    
                    if (action === 'read') {
                        // Xóa highlight chưa đọc
                        row.classList.remove('noti-unread');
                        const readBtn = document.getElementById('btn-read-' + notiId);
                        if (readBtn) readBtn.remove();
                        
                        // Trừ số đếm trên badge ở tiêu đề
                        const badge = document.getElementById('unreadBadge');
                        if (badge) {
                            let count = parseInt(badge.innerText);
                            count--;
                            if (count > 0) {
                                badge.innerText = count + " mới";
                            } else {
                                badge.remove();
                            }
                        }
                    } else if (action === 'delete') {
                        // Hiệu ứng trượt ngang biến mất
                        row.classList.add('removing');
                        setTimeout(() => {
                            row.remove();
                            const container = document.getElementById('notiContainer');
                            // Nếu không còn phần tử nào, tải lại trang để hiển thị trạng thái trống
                            if (container.children.length === 0) {
                                location.reload();
                            }
                        }, 300);
                    }
                } else {
                    alert('Thao tác thất bại từ hệ thống!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể kết nối đến máy chủ.');
            });
        }
    </script>
    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
