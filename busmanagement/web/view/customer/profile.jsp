<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Bus Hà Nội</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

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
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }

        /* ===== HERO BANNER ===== */
        .hero {
            background: var(--primary);
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
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
                🚌 Bus <span>Hà Nội</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
            </button>
            <div class="collapse navbar-collapse" id="navMenu">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle active" href="#" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i> Chào, <strong>${sessionScope.USER.fullName}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/customer/profile"><i class="fas fa-user me-2 text-primary"></i>Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2 text-danger"></i>Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero">
        <div class="container">
            <c:choose>
                <c:when test="${not empty account.avatar}">
                    <img src="${account.avatar}" alt="Avatar" class="profile-avatar">
                </c:when>
                <c:otherwise>
                    <img src="https://ui-avatars.com/api/?name=${account.fullName}&background=ffffff&color=0d47a1&size=120" alt="Avatar" class="profile-avatar">
                </c:otherwise>
            </c:choose>
            <h2 class="fw-bold mb-1">${account.fullName}</h2>
            <p class="mb-0 text-white-50">@${account.username}</p>
        </div>
    </div>

    <div class="container profile-layout">
        <div class="row">
            
            <div class="col-lg-4">
                
                <div class="card custom-card p-3">
                    <h5 class="fw-bold mb-3 text-secondary" style="font-size: 0.95rem;"><i class="fas fa-link me-2"></i>LỐI TẮT NHANH</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-light text-start border-2"><i class="fas fa-th-large me-2 text-primary"></i> Dashboard Tổng quan</a>
                        <a href="${pageContext.request.contextPath}/customer/ticket" class="btn btn-light text-start"><i class="fas fa-ticket-alt me-2 text-success"></i> Vé của tôi</a>
                        <a href="${pageContext.request.contextPath}/customer/favorite" class="btn btn-light text-start"><i class="fas fa-heart me-2 text-danger"></i> Tuyến yêu thích</a>
                        <a href="${pageContext.request.contextPath}/customer/notification" class="btn btn-light text-start"><i class="fas fa-bell me-2 text-warning"></i> Thông báo hệ thống</a>
                    </div>
                </div>

                <div class="card custom-card p-3">
                    <h5 class="fw-bold mb-3 text-secondary" style="font-size: 0.95rem;"><i class="fas fa-id-card-alt me-2"></i>VÉ THÁNG ĐANG SỬ DỤNG</h5>
                    <c:choose>
                        <c:when test="${not empty activeMonthlyPass}">
                            <div class="p-3 bg-light rounded border-start border-success border-4">
                                <div class="fw-bold text-success mb-1">Vé tháng xe bus</div>
                                <div class="small text-muted mb-1">Loại đối tượng: ${activeMonthlyPass.type}</div>
                                <div class="small text-muted mb-1">Tuyến đăng ký: ${activeMonthlyPass.routeName}</div>
                                <div class="small text-muted mb-2">Hiệu lực: ${activeMonthlyPass.expiryDate}</div>
                                <span class="badge bg-success">Đang hoạt động</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-3 bg-light rounded border-start border-primary border-4 mb-2">
                                <div class="fw-bold text-primary mb-1">Vé Tháng Mẫu</div>
                                <div class="small mb-1"><strong>Loại:</strong> Sinh viên</div>
                                <div class="small mb-1"><strong>Tuyến:</strong> 32 (Nhổn - Giáp Bát)</div>
                                <div class="small mb-2"><strong>Hiệu lực:</strong> 01/12/2025 - 31/12/2025</div>
                                <span class="badge bg-success">Đang hoạt động</span>
                            </div>
                            <p class="text-muted small text-center mb-0 mt-2">Bạn chưa sở hữu thêm vé tháng nào khác.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-lg-8">
                
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-md-3">
                        <div class="mini-stat-card shadow-sm">
                            <div class="mini-stat-icon" style="background: #e8f0fe; color: #1a73e8;"><i class="fas fa-ticket-alt"></i></div>
                            <div>
                                <div class="fw-bold text-dark h5 mb-0">${totalTickets}</div>
                                <span class="text-muted small">Vé hiện có</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <div class="mini-stat-card shadow-sm">
                            <div class="mini-stat-icon" style="background: #e6f4ea; color: #1e8e3e;"><i class="fas fa-id-card"></i></div>
                            <div>
                                <div class="fw-bold text-dark h5 mb-0">${totalPasses}</div>
                                <span class="text-muted small">Vé tháng</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <div class="mini-stat-card shadow-sm">
                            <div class="mini-stat-icon" style="background: #fef7e0; color: #f9ab00;"><i class="fas fa-heart"></i></div>
                            <div>
                                <div class="fw-bold text-dark h5 mb-0">${totalFavorites}</div>
                                <span class="text-muted small">Yêu thích</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <div class="mini-stat-card shadow-sm">
                            <div class="mini-stat-icon" style="background: #fce8e6; color: #d93025;"><i class="fas fa-bell"></i></div>
                            <div>
                                <div class="fw-bold text-dark h5 mb-0">${unreadNotifications}</div>
                                <span class="text-muted small">Thông báo mới</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card custom-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="fw-bold text-dark mb-0"><i class="fas fa-user-shield me-2 text-primary"></i>Thông tin tài khoản</h5>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/customer/changePassword" class="btn btn-sm btn-outline-secondary"><i class="fas fa-key me-1"></i> Đổi mật khẩu</a>
                            <a href="${pageContext.request.contextPath}/customer/editProfile" class="btn btn-sm btn-primary" style="background-color: var(--primary-light);"><i class="fas fa-edit me-1"></i> Sửa thông tin</a>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-profile align-middle mb-0">
                            <tbody>
                                <tr>
                                    <th>Tên đăng nhập</th>
                                    <td class="fw-bold text-secondary">${account.username}</td>
                                </tr>
                                <tr>
                                    <th>Họ và tên</th>
                                    <td>${account.fullName}</td>
                                </tr>
                                <tr>
                                    <th>Địa chỉ Email</th>
                                    <td>${account.email}</td>
                                </tr>
                                <tr>
                                    <th>Số điện thoại</th>
                                    <td>${account.phone}</td>
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
                                                <td>${trip.date}</td>
                                                <td><span class="badge bg-primary px-2">${trip.routeNumber}</span></td>
                                                <td>${trip.busPlate}</td>
                                                <td class="text-start">${trip.startPoint}</td>
                                                <td class="text-start">${trip.endPoint}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td>15/12/2025</td>
                                            <td><span class="badge bg-primary px-2">01</span></td>
                                            <td>29B-12345</td>
                                            <td class="text-start text-truncate" style="max-width: 130px;">Bến xe Gia Lâm</td>
                                            <td class="text-start text-truncate" style="max-width: 130px;">Bờ Hồ</td>
                                        </tr>
                                        <tr>
                                            <td>14/12/2025</td>
                                            <td><span class="badge bg-primary px-2">32</span></td>
                                            <td>30H-56789</td>
                                            <td class="text-start text-truncate" style="max-width: 130px;">Bến xe Cầu Giấy</td>
                                            <td class="text-start text-truncate" style="max-width: 130px;">Bến xe Mỹ Đình</td>
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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>