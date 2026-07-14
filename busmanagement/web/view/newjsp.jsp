<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm lộ trình - Xe Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
</head>
<body>

<!-- ===== HEADER NAVIGATION ===== -->
<jsp:include page="/common/navbar.jsp" />

<div>
    <div>
        <form action="${pageContext.request.contextPath}/find-route" method="get">
            <div>
                <div>
                    <label>Điểm khởi hành</label>
                    <select name="fromStopID" required>
                        <option value="">-- Chọn trạm xuất phát --</option>
                        <c:forEach var="stop" items="${stopNames}">
                            <option value="${stop.stopID}" ${selectedFrom.stopID == stop.stopID ? 'selected' : ''}>
                                ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div>
                    <span id="swapStops" style="cursor: pointer;">[Đổi chiều bến]</span>
                </div>
                
                <div>
                    <label>Điểm đến</label>
                    <select name="toStopID" required>
                        <option value="">-- Chọn bến đích --</option>
                        <c:forEach var="stop" items="${stopNames}">
                            <option value="${stop.stopID}" ${selectedTo.stopID == stop.stopID ? 'selected' : ''}>
                                ${stop.stopName.length() > 45 ? stop.stopName.substring(0, 45).concat('...') : stop.stopName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div>
                    <button type="submit">Tìm đường</button>
                </div>
            </div>
        </form>
    </div>
</div>

<div>

    <c:if test="${not empty error}">
        <div>
            Lỗi: ${error}
        </div>
    </c:if>

    <c:if test="${not empty selectedFrom && not empty selectedTo}">
        <div>
            <h4>Lộ trình kết nối gợi ý:</h4>
            <p>
                Hành trình từ: <strong>${selectedFrom.stopName}</strong> 
                đến <strong>${selectedTo.stopName}</strong>
            </p>
            <span>Tìm thấy <strong>${matchingRoutes != null ? matchingRoutes.size() : 0}</strong> giải pháp di chuyển trực tiếp</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty matchingRoutes}">
            <div>
                <c:forEach var="route" items="${matchingRoutes}">
                    <div>
                        <div>
                            <div>
                                <div>Tuyến ${route.routeNumber}</div>
                            </div>
                            
                            <div>
                                <h5>${route.routeName}</h5>
                                <small>
                                    Hướng đi chung: ${route.startPoint} -> ${route.endPoint}
                                </small>
                            </div>

                            <div>
                                <div>
                                    <small>Lên xe tại:</small>
                                    <strong>${selectedFrom.stopName}</strong>
                                </div>
                                <div>
                                    <small>Xuống xe tại:</small>
                                    <strong>${selectedTo.stopName}</strong>
                                </div>
                            </div>

                            <div>
                                <div>
                                    Giá vé: <fmt:formatNumber value="${route.ticketPrice}" pattern="#,###"/>đ
                                </div>
                                <a href="${pageContext.request.contextPath}/route-detail?id=${route.routeID}">
                                    Chi tiết tuyến
                                </a>
                            </div>
                        </div>
                        <br>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        
        <c:when test="${empty matchingRoutes && empty error && requestScope.searchPerformed}">
            <div>
                <h5>Hiện không có chuyến xe phù hợp</h5>
                <p>
                    Hệ thống không tìm thấy tuyến xe đơn lẻ nào chạy trực tiếp giữa hai trạm này. Bạn vui lòng chọn lại cặp bến khác hoặc tìm kiếm lộ trình đi xe liên tuyến.
                </p>
                <a href="${pageContext.request.contextPath}/home">Quay lại Trang chủ</a>
            </div>
        </c:when>
    </c:choose>
</div>

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
<script>
    // JS Đổi chỗ nhanh chiều bến đi và bến đến
    document.getElementById('swapStops')?.addEventListener('click', function () {
        const fromSelect = document.querySelector('select[name="fromStopID"]');
        const toSelect = document.querySelector('select[name="toStopID"]');
        const temp = fromSelect.value;
        fromSelect.value = toSelect.value;
        toSelect.value = temp;
    });
</script>
</body>
</html>