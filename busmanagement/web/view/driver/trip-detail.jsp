<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Chuyến Đi - Tài Xế</title>
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
            .timeline {
                border-left: 3px solid #cbd5e1;
                padding-left: 20px;
                position: relative;
                list-style: none;
            }
            .timeline-item {
                position: relative;
                margin-bottom: 25px;
            }
            .timeline-item::before {
                content: '';
                width: 16px;
                height: 16px;
                border-radius: 50%;
                background-color: #3b82f6;
                border: 3px solid #fff;
                position: absolute;
                left: -29px;
                top: 4px;
                box-shadow: 0 0 0 3px #3b82f640;
            }
            .timeline-item.first::before {
                background-color: #10b981;
                box-shadow: 0 0 0 3px #10b98140;
            }
            .timeline-item.last::before {
                background-color: #ef4444;
                box-shadow: 0 0 0 3px #ef444440;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp">
                    <jsp:param name="activeMenu" value="trip" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2 text-dark fw-bold">Chi Tiết Chuyến Đi #${trip.tripID}</h1>
                        <a href="${pageContext.request.contextPath}/driver/trip" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>${sessionScope.error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <c:if test="${empty sessionScope.error}">
                        <div class="row g-4">
                            <div class="col-12 col-lg-4">
                                <div class="card shadow-sm border-0 rounded-3 mb-4">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold text-dark mb-0">Thông Tin Hành Trình</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="d-flex flex-column gap-3">
                                            <div>
                                                <small class="text-secondary fw-semibold">Trạng thái</small>
                                                <div class="mt-1">
                                                    <c:choose>
                                                        <c:when test="${trip.status == 'SCHEDULED'}">
                                                            <span class="badge bg-warning text-dark px-2.5 py-1.5 rounded">Chuẩn bị</span>
                                                        </c:when>
                                                        <c:when test="${trip.status == 'IN_PROGRESS'}">
                                                            <span class="badge bg-success px-2.5 py-1.5 rounded">Đang chạy</span>
                                                        </c:when>
                                                        <c:when test="${trip.status == 'COMPLETED'}">
                                                            <span class="badge bg-info px-2.5 py-1.5 rounded">Hoàn thành</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary px-2.5 py-1.5 rounded">${trip.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div>
                                                <small class="text-secondary fw-semibold">Tuyến đường</small>
                                                <div class="mt-1 fw-bold text-dark">${trip.routeNumber} - ${trip.routeName}</div>
                                            </div>
                                            <div>
                                                <small class="text-secondary fw-semibold">Biển kiểm soát xe</small>
                                                <div class="mt-1 fw-bold text-dark">${trip.busPlate}</div>
                                            </div>
                                            <div>
                                                <small class="text-secondary fw-semibold">Phụ xe phụ trách</small>
                                                <div class="mt-1 text-dark">${not empty trip.assistantName ? trip.assistantName : '<span class="text-secondary">Chưa phân công</span>'}</div>
                                            </div>
                                            <div>
                                                <small class="text-secondary fw-semibold">Ngày chạy</small>
                                                <div class="mt-1 text-dark">${trip.tripDate}</div>
                                            </div>
                                            <div>
                                                <small class="text-secondary fw-semibold">Khung giờ dự kiến</small>
                                                <div class="mt-1 text-dark">${trip.startTime} - ${trip.endTime}</div>
                                            </div>
                                            <c:if test="${not empty trip.actualStartTime}">
                                                <div>
                                                    <small class="text-secondary fw-semibold">Giờ xuất phát thực tế</small>
                                                    <div class="mt-1 text-success fw-bold">${trip.actualStartTime}</div>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty trip.actualEndTime}">
                                                <div>
                                                    <small class="text-secondary fw-semibold">Giờ hoàn thành thực tế</small>
                                                    <div class="mt-1 text-primary fw-bold">${trip.actualEndTime}</div>
                                                </div>
                                            </c:if>

                                            <div class="mt-3 pt-3 border-top">
                                                <c:choose>
                                                    <c:when test="${trip.status == 'SCHEDULED'}">
                                                        <form action="${pageContext.request.contextPath}/driver/trip/start" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn BẮT ĐẦU chuyến đi này?');">
                                                            <input type="hidden" name="tripID" value="${trip.tripID}">
                                                            <button type="submit" class="btn btn-success w-100 py-2">
                                                                <i class="fas fa-play me-2"></i>Bắt đầu chuyến đi
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${trip.status == 'IN_PROGRESS'}">
                                                        <form action="${pageContext.request.contextPath}/driver/trip/finish" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn KẾT THÚC chuyến đi này?');">
                                                            <input type="hidden" name="tripID" value="${trip.tripID}">
                                                            <button type="submit" class="btn btn-danger w-100 py-2">
                                                                <i class="fas fa-stop me-2"></i>Kết thúc chuyến đi
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-secondary w-100 py-2" disabled>
                                                            <i class="fas fa-check-circle me-2"></i>Chuyến đi đã kết thúc
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-lg-8">
                                <div class="card shadow-sm border-0 rounded-3">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold text-dark mb-0">Lộ Trình & Điểm Dừng</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <c:choose>
                                            <c:when test="${not empty routeStops}">
                                                <ul class="timeline mt-2">
                                                    <c:forEach var="s" items="${routeStops}" varStatus="status">
                                                        <li class="timeline-item ${status.first ? 'first' : (status.last ? 'last' : '')}">
                                                            <div class="fw-bold text-dark mb-1">
                                                                Trạm ${s.stopOrder}: ${s.stopName}
                                                            </div>
                                                            <div class="text-secondary fs-7 mb-1">
                                                                <i class="fas fa-map-marker-alt me-1 text-secondary"></i> ${s.address}
                                                            </div>
                                                            <div class="text-info fs-7 fw-semibold">
                                                                Khoảng cách từ trạm đầu: ${s.distanceFromStart} km
                                                            </div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-center py-4 text-secondary mb-0">Chưa thiết lập danh sách điểm dừng cho tuyến đường này.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </main>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>