<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử chuyến đi - Bus Hà Nội</title>
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
        
        .history-card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            border: none;
        }

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 20px 0;
            color: white;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .page-header h3 {
            font-size: 1.45rem;
            letter-spacing: -0.3px;
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
<body class="d-flex flex-column min-vh-100">

    <!-- ===== HEADER NAVIGATION ===== -->
    <c:set var="activePage" value="trip-history" />
    <jsp:include page="/common/navbar.jsp" />

    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                    <h3 class="fw-bold m-0"><i class="fas fa-history me-2"></i>Lịch sử chuyến đi của tôi</h3>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-5 flex-grow-1" style="min-height: 700px;">


        <div class="card history-card p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle text-center mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Ngày đi</th>
                            <th>Số tuyến</th>
                            <th>Biển số xe</th>
                            <th>Điểm bắt đầu</th>
                            <th>Điểm kết thúc</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty trips}">
                                <c:forEach var="trip" items="${trips}">
                                    <tr>
                                        <td><c:out value="${trip.date}" /></td>
                                        <td><span class="badge bg-primary px-3 py-2 fs-6">Tuyến <c:out value="${trip.routeNumber}" /></span></td>
                                        <td class="fw-bold"><c:out value="${trip.busPlate}" /></td>
                                        <td class="text-start"><c:out value="${trip.startPoint}" /></td>
                                        <td class="text-start"><c:out value="${trip.endPoint}" /></td>
                                        <td><span class="badge bg-success">Hoàn thành</span></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="fas fa-bus fa-3x mb-3 d-block opacity-25"></i>
                                        Bạn chưa thực hiện chuyến đi nào được ghi nhận trên hệ thống.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===== FOOTER ===== -->
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
