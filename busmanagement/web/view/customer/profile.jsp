<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />

    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
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
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }

        /* ===== HERO BANNER ===== */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 40px 0 100px;
            color: white;
            text-align: center;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            object-fit: cover;
            border: 3px solid #ffffff;
        }

        /* ===== MAIN CONTAINER ===== */
        .profile-layout {
            margin-top: -60px;
            position: relative;
            z-index: 10;
        }
        .custom-card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            border: none;
            margin-bottom: 24px;
        }
        
        /* ===== STATS ===== */
        .mini-stat-card {
            background: #fff;
            border-radius: 10px;
            padding: 15px;
            border: 1px solid #e8eaed;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
            min-height: 80px; /* Thêm chiều cao tối thiểu chống lệch hàng khi co giãn màn hình */
        }
        .mini-stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.08) !important;
            border-color: #1a73e8;
        }
        .mini-stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-right: 12px;
        }

        /* ===== TABLES ===== */
        .table-profile th {
            color: #5f6368;
            font-weight: 600;
            width: 35%;
            padding: 14px 20px;
            border-bottom: 1px solid #f1f3f4;
        }
        .table-profile td {
            color: #202124;
            padding: 14px 20px;
            border-bottom: 1px solid #f1f3f4;
        }
        /* ===== FOOTER ===== */
        footer {
            background: #1a1a2e;
            color: rgba(255,255,255,0.7);
            padding: 30px 0;
            margin-top: 60px;
        }
        footer a { color: rgba(255,255,255,0.7); text-decoration: none; }
        footer a:hover { color: white; }
    </style>
</head>
<body>

    <!-- ===== HEADER NAVIGATION ===== -->
    <c:set var="activePage" value="profile" />
    <jsp:include page="/common/navbar.jsp" />

    <div class="hero">
        <div class="container">
            <c:choose>
                <c:when test="${not empty account.avatar}">
                    <img src="${pageContext.request.contextPath}/${account.avatar}"
                         alt="Avatar"
                         class="profile-avatar">
                </c:when>
                <c:otherwise>
                    <img src="https://ui-avatars.com/api/?name=${account.fullName}&background=ffffff&color=0d47a1&size=120" alt="Avatar" class="profile-avatar">
                </c:otherwise>
            </c:choose>
            <h2 class="fw-bold mb-1"><c:out value="${account.fullName}" /></h2>
            <p class="mb-0 text-white-50">@<c:out value="${account.username}" /></p>
        </div>
    </div>

    <div class="container profile-layout">
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-check-circle me-2 fs-5"></i>
                <div>${sessionScope.successMsg}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>
        
        <div class="row">
            
            <div class="col-lg-4">
                


                <div class="card custom-card p-3">
                    <h5 class="fw-bold mb-3 text-secondary" style="font-size: 0.95rem;"><i class="fas fa-id-card-alt me-2"></i>VÉ THÁNG ĐANG SỬ DỤNG</h5>
                    <c:choose>
                        <c:when test="${not empty activeMonthlyPass}">
                            <div class="p-3 bg-light rounded border-start border-success border-4">
                                <div class="fw-bold text-success mb-1">Vé tháng xe bus</div>
                                <div class="small text-muted mb-1">Đối tượng: <strong>${activeMonthlyPass.typeName}</strong></div>
                                <div class="small text-muted mb-1">Phạm vi: 
                                    <strong>
                                        <c:choose>
                                            <c:when test="${empty activeMonthlyPass.routeNumber}">
                                                Liên tuyến toàn mạng lưới
                                            </c:when>
                                            <c:otherwise>
                                                Tuyến ${activeMonthlyPass.routeNumber}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                                <div class="small text-muted mb-2">Hạn sử dụng: <strong>${activeMonthlyPass.endDate}</strong></div>
                                <span class="badge bg-success">Đang hoạt động</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-3 text-muted">
                                <i class="fas fa-id-card fa-2x mb-2 opacity-50"></i>
                                <p class="small mb-0">Bạn chưa đăng ký vé tháng nào đang có hiệu lực.</p>
                                <a href="${pageContext.request.contextPath}/route-list" class="btn btn-sm btn-outline-primary mt-2">Đăng ký ngay</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-lg-8">
                
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-md-3">
                        <a href="${pageContext.request.contextPath}/customer/ticket?tab=ticket" class="text-decoration-none">
                            <div class="mini-stat-card shadow-sm">
                                <div class="mini-stat-icon" style="background: #e8f0fe; color: #1a73e8;"><i class="fas fa-ticket-alt"></i></div>
                                <div>
                                    <div class="fw-bold text-dark h5 mb-0">${totalTickets}</div>
                                    <span class="text-muted small">Vé hiện có</span>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <a href="${pageContext.request.contextPath}/customer/ticket?tab=pass" class="text-decoration-none">
                            <div class="mini-stat-card shadow-sm">
                                <div class="mini-stat-icon" style="background: #e6f4ea; color: #1e8e3e;"><i class="fas fa-id-card"></i></div>
                                <div>
                                    <div class="fw-bold text-dark h5 mb-0">${totalPasses}</div>
                                    <span class="text-muted small">Vé tháng</span>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <a href="${pageContext.request.contextPath}/customer/favorite" class="text-decoration-none">
                            <div class="mini-stat-card shadow-sm">
                                <div class="mini-stat-icon" style="background: #fef7e0; color: #f9ab00;"><i class="fas fa-heart"></i></div>
                                <div>
                                    <div class="fw-bold text-dark h5 mb-0">${totalFavorites}</div>
                                    <span class="text-muted small">Yêu thích</span>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <a href="${pageContext.request.contextPath}/customer/notification" class="text-decoration-none">
                            <div class="mini-stat-card shadow-sm">
                                <div class="mini-stat-icon" style="background: #fce8e6; color: #d93025;"><i class="fas fa-bell"></i></div>
                                <div>
                                    <div class="fw-bold text-dark h5 mb-0">${unreadNotifications}</div>
                                    <span class="text-muted small">Thông báo mới</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>

                <div class="card custom-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-user-shield me-2 text-primary"></i>Thông tin tài khoản</h5>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/customer/changePassword" class="btn btn-sm btn-outline-secondary"><i class="fas fa-key me-1"></i> Đổi mật khẩu</a>
                            <a href="${pageContext.request.contextPath}/customer/editProfile" class="btn btn-sm btn-primary" style="background-color: var(--primary);"><i class="fas fa-edit me-1"></i> Sửa thông tin</a>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-profile align-middle mb-0">
                            <tbody>
                                <tr>
                                    <th>Tên đăng nhập</th>
                                    <td class="fw-bold text-secondary"><c:out value="${account.username}" /></td>
                                </tr>
                                <tr>
                                    <th>Họ và tên</th>
                                    <td><c:out value="${account.fullName}" /></td>
                                </tr>
                                <tr>
                                    <th>Địa chỉ Email</th>
                                    <td><c:out value="${account.email}" /></td>
                                </tr>
                                <tr>
                                    <th>Số điện thoại</th>
                                    <td><c:out value="${account.phone}" /></td>
                                </tr>
                                <tr>
                                    <th>Vai trò</th>
                                    <td><span class="badge bg-primary-subtle text-primary px-2 py-1">Khách hàng</span></td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo</th>
                                    <td>${account.createdAt != null ? account.createdAt : "Chưa cập nhật"}</td>
                                </tr>
                                <tr>
                                    <th>Lần đăng nhập gần nhất</th>
                                    <td class="text-muted small">${account.lastLogin != null ? account.lastLogin : "Chưa ghi nhận"}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card custom-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-history me-2 text-primary"></i>Lịch sử chuyến đi gần đây</h5>
                        <a href="${pageContext.request.contextPath}/customer/trip-history" class="btn btn-sm btn-outline-primary rounded-pill px-3">Xem toàn bộ lịch sử</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle small text-center">
                            <thead class="table-light">
                                <tr>
                                    <th>Ngày đi</th>
                                    <th>Tuyến</th>
                                    <th>Số xe</th>
                                    <th>Điểm bắt đầu</th>
                                    <th>Điểm kết thúc</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentTrips}">
                                        <c:forEach var="trip" items="${recentTrips}">
                                            <tr>
                                                <td><c:out value="${trip.date}" /></td>
                                                <td><span class="badge bg-primary px-2"><c:out value="${trip.routeNumber}" /></span></td>
                                                <td><c:out value="${trip.busPlate}" /></td>
                                                <td class="text-start"><c:out value="${trip.startPoint}" /></td>
                                                <td class="text-start"><c:out value="${trip.endPoint}" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                <i class="fas fa-history fa-2x mb-2 d-block opacity-50"></i>
                                                Chưa ghi nhận lịch sử chuyến đi nào của bạn.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
</body>
</html>