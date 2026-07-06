<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tổng Quan Vận Hành - Tài Xế</title>
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
            .bg-card-blue {
                background-color: #eff6ff;
                color: #1e40af;
            }
            .bg-card-green {
                background-color: #f0fdf4;
                color: #166534;
            }
            .bg-card-orange {
                background-color: #fffbeb;
                color: #9a3412;
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
                        <h1 class="h2 text-dark fw-bold">Tổng Quan Vận Hành</h1>
                        <div class="text-secondary fw-semibold">
                            Xin chào, <span class="text-primary">${sessionScope.USER.fullName}</span>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>${sessionScope.error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <div>${sessionScope.successMsg}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMsg" scope="session"/>
                    </c:if>

                    <div class="row g-4 mb-4">
                        <div class="col-12 col-sm-6 col-xl-4">
                            <div class="stat-card p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-secondary mb-1">Chuyến đi hiện tại</h6>
                                        <h4 class="fw-bold mb-0 text-dark">
                                            <c:choose>
                                                <c:when test="${not empty currentTrip}">Chuyến #${currentTrip.tripID}</c:when>
                                                <c:otherwise>Không có</c:otherwise>
                                            </c:choose>
                                        </h4>
                                    </div>
                                    <div class="stat-icon bg-card-blue"><i class="fas fa-bus"></i></div>
                                </div>
                                <c:if test="${not empty currentTrip}">
                                    <div class="mt-2 text-primary fw-semibold fs-7">
                                        Tuyến ${currentTrip.routeNumber} (${currentTrip.status})
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="col-12 col-sm-6 col-xl-4">
                            <div class="stat-card p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-secondary mb-1">Chuyến xe trong ngày</h6>
                                        <h4 class="fw-bold mb-0 text-dark">${todaysTrips} chuyến</h4>
                                    </div>
                                    <div class="stat-icon bg-card-green"><i class="fas fa-route"></i></div>
                                </div>
                                <div class="mt-2 text-success fs-7">Số chuyến phân công hôm nay</div>
                            </div>
                        </div>

                        <div class="col-12 col-sm-6 col-xl-4">
                            <a href="notification" class="text-decoration-none">
                                <div class="stat-card p-4">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-secondary mb-1">Thông báo chưa đọc</h6>
                                            <h4 class="fw-bold mb-0 text-dark">${pendingNotifications} thông báo</h4>
                                        </div>
                                        <div class="stat-icon bg-card-orange"><i class="fas fa-bell"></i></div>
                                    </div>
                                    <div class="mt-2 text-warning fs-7">Click để xem chi tiết</div>
                                </div>
                            </a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card shadow-sm border-0 rounded-3 mb-4">
                                <div class="card-header bg-white border-0 pt-4 px-4">
                                    <h5 class="fw-bold text-dark mb-0">Hành Trình Đang Vận Hành</h5>
                                </div>
                                <div class="card-body p-4">
                                    <c:choose>
                                        <c:when test="${not empty currentTrip}">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <div class="d-flex flex-column gap-2 mb-3 mb-md-0">
                                                        <div><strong>Tuyến đường:</strong> ${currentTrip.routeNumber} - ${currentTrip.routeName}</div>
                                                        <c:if test="${not empty currentRoute}">
                                                            <div><strong>Lộ trình:</strong> ${currentRoute.startPoint} <i class="fas fa-long-arrow-alt-right mx-1"></i> ${currentRoute.endPoint}</div>
                                                        </c:if>
                                                        <div><strong>Biển số xe:</strong> ${currentTrip.busPlate}</div>
                                                        <c:if test="${not empty currentBus}">
                                                            <div><strong>Loại xe:</strong> ${currentBus.busType} (${currentBus.capacity} chỗ)</div>
                                                        </c:if>
                                                        <div><strong>Phụ xe phụ trách:</strong> ${not empty currentTrip.assistantName ? currentTrip.assistantName : 'Không có phụ xe'}</div>
                                                        <div><strong>Giờ chạy dự kiến:</strong> ${currentTrip.startTime} - ${currentTrip.endTime}</div>
                                                        <div><strong>Ngày đi:</strong> ${currentTrip.tripDate}</div>
                                                        <div><strong>Trạng thái:</strong> 
                                                            <span class="badge ${currentTrip.status == 'IN_PROGRESS' ? 'bg-success' : 'bg-warning text-dark'} px-2.5 py-1.5 rounded">
                                                                ${currentTrip.status}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-md-end">
                                                    <div class="d-flex flex-column gap-2">
                                                        <c:choose>
                                                            <c:when test="${currentTrip.status == 'SCHEDULED'}">
                                                                <form action="${pageContext.request.contextPath}/driver/trip/start" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn BẮT ĐẦU chuyến đi này?');">
                                                                    <input type="hidden" name="tripID" value="${currentTrip.tripID}">
                                                                    <button type="submit" class="btn btn-success btn-lg w-100 shadow-sm">
                                                                        <i class="fas fa-play me-2"></i>Bắt đầu chuyến
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:when test="${currentTrip.status == 'IN_PROGRESS'}">
                                                                <form action="${pageContext.request.contextPath}/driver/trip/finish" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn KẾT THÚC chuyến đi này?');">
                                                                    <input type="hidden" name="tripID" value="${currentTrip.tripID}">
                                                                    <button type="submit" class="btn btn-danger btn-lg w-100 shadow-sm">
                                                                        <i class="fas fa-stop me-2"></i>Kết thúc chuyến
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-secondary btn-lg w-100 shadow-sm" disabled>
                                                                    <i class="fas fa-check-circle me-2"></i>Đã xử lý
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <a href="${pageContext.request.contextPath}/driver/trip/detail?id=${currentTrip.tripID}" class="btn btn-outline-secondary">
                                                            <i class="fas fa-info-circle me-2"></i>Xem lộ trình & điểm dừng
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5 text-secondary">
                                                <i class="fas fa-route fa-3x mb-3 text-light"></i>
                                                <p class="mb-0">Hiện tại bạn chưa có chuyến đi nào đang chạy hoặc sắp chạy.</p>
                                                <a href="${pageContext.request.contextPath}/driver/trip" class="btn btn-outline-primary mt-3">
                                                    <i class="fas fa-list me-2"></i>Xem danh sách lịch trình của tôi
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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