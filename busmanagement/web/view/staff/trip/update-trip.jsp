<%-- 
    Document   : update-trip
    Created on : Jun 30, 2026, 11:37:35 AM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật chuyến xe #${trip.tripID} - Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #1a73e8;
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
                transition: all 0.2s;
                border-radius: 0.375rem;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255, 255, 255, 0.1);
            }
            .main-content {
                padding: 2rem;
            }
            .form-card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }
        </style>
    </head>
    <body>

        <c:set var="selRoute" value="${not empty r_routeID ? r_routeID : trip.routeID}" />
        <c:set var="selBus" value="${not empty r_busID ? r_busID : trip.busID}" />
        <c:set var="selDriver" value="${not empty r_driverID ? r_driverID : trip.driverID}" />
        <c:set var="selAssistant" value="${not empty r_assistantID ? r_assistantID : trip.assistantID}" />
        <c:set var="valDate" value="${not empty r_tripDate ? r_tripDate : trip.tripDate}" />
        <c:set var="valStart" value="${not empty r_startTime ? r_startTime : trip.startTime}" />
        <c:set var="valEnd" value="${not empty r_endTime ? r_endTime : trip.endTime}" />
        <c:set var="selDir" value="${not empty r_direction ? r_direction : trip.direction}" />
        <c:set var="selStatus" value="${not empty r_status ? r_status : trip.status}" />

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/view/staff/sidebar.jsp">
                    <jsp:param name="activeMenu" value="trip" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <div>
                            <h2 class="fw-bold m-0" style="color: #5c67f2 !important;">Sửa chuyến xe #${trip.tripID}</h2>
                            <p class="text-muted small m-0">Cập nhật thông tin lịch trình, phương tiện hoặc đổi trạng thái.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/trip" class="btn btn-light border fw-semibold">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-xl-8 col-lg-10">

                            <c:if test="${not empty msgError}">
                                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i><strong>Lỗi cập nhật:</strong> ${msgError}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <div class="card form-card bg-white p-4 p-sm-5">
                                <form action="${pageContext.request.contextPath}/staff/trip/update" method="POST" class="row g-4">

                                    <input type="hidden" name="id" value="${trip.tripID}">

                                    <div class="col-md-12">
                                        <label class="form-label small fw-bold text-secondary">Trạng thái chuyến xe</label>
                                        <select name="status" class="form-select py-2 fw-bold text-primary" required>
                                            <option value="SCHEDULED" ${selStatus == 'SCHEDULED' ? 'selected' : ''}>SCHEDULED (Đã lên lịch)</option>
                                            <option value="IN_PROGRESS" ${selStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS (Đang chạy)</option>
                                            <option value="COMPLETED" ${selStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED (Đã hoàn thành)</option>
                                            <option value="CANCELLED" ${selStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED (Đã hủy)</option>
                                        </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label small fw-bold text-secondary">Tuyến xe chạy lịch trình</label>
                                        <select name="routeID" class="form-select py-2" required>
                                            <c:forEach var="r" items="${routes}">
                                                <option value="${r.routeID}" ${selRoute == r.routeID ? 'selected' : ''}>Tuyến đơn số ${r.routeNumber} (${r.routeName})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label small fw-bold text-secondary">Gán phương tiện vận chuyển</label>
                                        <select name="busID" class="form-select py-2" required>
                                            <c:forEach var="b" items="${buses}">
                                                <option value="${b.busID}" ${selBus == b.busID ? 'selected' : ''}>${b.licensePlate} — Sức chứa: ${b.capacity} chỗ</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-secondary">Tài xế chính</label>
                                        <select name="driverID" class="form-select py-2" required>
                                            <c:forEach var="d" items="${drivers}">
                                                <option value="${d.accountID}" ${selDriver == d.accountID ? 'selected' : ''}>${d.fullName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-secondary">Nhân viên phụ xe</label>
                                        <select name="assistantID" class="form-select py-2">
                                            <option value="" ${empty selAssistant ? 'selected' : ''}>-- Không bố trí (Để trống) --</option>
                                            <c:forEach var="a" items="${assistants}">
                                                <option value="${a.accountID}" ${selAssistant == a.accountID ? 'selected' : ''}>${a.fullName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-bold text-secondary">Ngày vận hành</label>
                                        <input type="date" name="tripDate" class="form-control py-2" value="${valDate}" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-bold text-secondary">Giờ xuất bến</label>
                                        <input type="time" name="startTime" class="form-control py-2" value="${valStart}" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-bold text-secondary">Giờ cập bến</label>
                                        <input type="time" name="endTime" class="form-control py-2" value="${valEnd}" required>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label small fw-bold text-secondary d-block mb-2">Chiều chạy</label>
                                        <div class="form-check form-check-inline me-4">
                                            <input class="form-check-input" type="radio" name="direction" id="dir1" value="1" ${selDir == 1 or selDir == '1' ? 'checked' : ''}>
                                            <label class="form-check-label fw-semibold text-dark small" for="dir1">Lượt đi (Bến xuất phát &rarr; Bến cuối)</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="direction" id="dir2" value="2" ${selDir == 2 or selDir == '2' ? 'checked' : ''}>
                                            <label class="form-check-label fw-semibold text-dark small" for="dir2">Lượt về (Bến cuối &rarr; Bến xuất phát)</label>
                                        </div>
                                    </div>

                                    <div class="col-md-12 d-flex gap-2 justify-content-end border-top pt-4 mt-4">
                                        <a href="${pageContext.request.contextPath}/staff/trip" class="btn btn-light px-4 py-2 border fw-semibold">Hủy bỏ</a>
                                        <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold shadow-sm">
                                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>