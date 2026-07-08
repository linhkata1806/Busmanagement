<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chuyến Đi Của Tôi - Tài Xế</title>
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
            .table-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                background: white;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../sidebar.jsp">
                    <jsp:param name="activeMenu" value="trip" />
                </jsp:include>

                <!-- Main Content Area -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2 text-dark fw-bold">Chuyến Đi Của Tôi</h1>
                    </div>

                    <!-- Trips List Table Card -->
                    <div class="table-card p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col">Mã chuyến</th>
                                        <th scope="col">Tuyến</th>
                                        <th scope="col">Biển số xe</th>
                                        <th scope="col">Phụ xe</th>
                                        <th scope="col">Ngày chạy</th>
                                        <th scope="col">Giờ chạy</th>
                                        <th scope="col">Trạng thái</th>
                                        <th scope="col" class="text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty assignedTrips}">
                                            <c:forEach var="t" items="${assignedTrips}">
                                                <tr>
                                                    <td class="fw-semibold">#${t.tripID}</td>
                                                    <td><span class="badge bg-secondary px-2 py-1">${t.routeNumber}</span> ${t.routeName}</td>
                                                    <td><span class="text-dark fw-semibold">${t.busPlate}</span></td>
                                                    <td>${not empty t.assistantName ? t.assistantName : '<span class="text-secondary">Chưa phân công</span>'}</td>
                                                    <td>${t.tripDate}</td>
                                                    <td>${t.startTime} - ${t.endTime}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${t.status == 'SCHEDULED'}">
                                                                <span class="badge bg-warning text-dark px-2.5 py-1.5 rounded">Chuẩn bị</span>
                                                            </c:when>
                                                            <c:when test="${t.status == 'IN_PROGRESS'}">
                                                                <span class="badge bg-success px-2.5 py-1.5 rounded">Đang chạy</span>
                                                            </c:when>
                                                            <c:when test="${t.status == 'COMPLETED'}">
                                                                <span class="badge bg-info px-2.5 py-1.5 rounded">Hoàn thành</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger px-2.5 py-1.5 rounded">${t.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/driver/trip/detail?id=${t.tripID}" class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center py-4 text-secondary">
                                                    Không tìm thấy chuyến đi nào được phân công cho bạn.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
