<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Soát vé & Check-in - Phụ xe</title>
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
        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            background: white;
        }
        /* Tiêu đề bảng đồng nhất chiều cao, căn giữa */
        .table-dark th {
            padding-top: 15px !important;
            padding-bottom: 15px !important;
            vertical-align: middle !important;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
        }
        /* Dòng dữ liệu so le đậm nhạt, chiều cao bằng nhau */
        .table tbody td {
            padding-top: 12px !important;
            padding-bottom: 12px !important;
            vertical-align: middle !important;
        }
        .table-responsive {
            border-radius: 0.75rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp">
                <jsp:param name="activeMenu" value="trip" />
            </jsp:include>
            
            <!-- Main Content Area -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 text-dark fw-bold">Soát vé & Check-in chuyến #${trip.tripID}</h1>
                    <a href="${pageContext.request.contextPath}/assistant/trip/detail?id=${trip.tripID}" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại chi tiết chuyến
                    </a>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2 fs-5"></i>
                        <div>${successMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                        <div>${errorMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-ban me-2"></i> ${error}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row g-4">
                            <!-- Left: Check In Form -->
                            <div class="col-12 col-lg-5">
                                <div class="card card-custom p-4">
                                    <h5 class="fw-bold mb-3 text-dark">Nhập mã soát vé</h5>
                                    <form action="passenger-check" method="POST">
                                        <input type="hidden" name="tripID" value="${trip.tripID}">
                                        <div class="mb-4">
                                            <label for="ticketCode" class="form-label text-secondary fw-semibold">Mã Vé Hành Khách</label>
                                            <input type="text" class="form-control form-control-lg text-uppercase" id="ticketCode" name="ticketCode" placeholder="Ví dụ: TK-1-1719..." required autocomplete="off" autofocus>
                                            <div class="form-text mt-2 text-secondary">
                                                Nhập chính xác chuỗi ký tự in trên vé để xác nhận lên xe.
                                            </div>
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-lg w-100 shadow-sm py-2.5">
                                            <i class="fas fa-user-check me-2"></i>Xác nhận Check-In
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <!-- Right: Checked In Passengers List -->
                            <div class="col-12 col-lg-7">
                                <div class="card card-custom p-4">
                                    <h5 class="fw-bold mb-3 text-dark">Hành khách đã lên xe (${checkedTickets.size()} người)</h5>
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped align-middle mb-0">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Mã Vé</th>
                                                    <th>Giá Vé</th>
                                                    <th>Thời gian soát</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty checkedTickets}">
                                                        <c:forEach var="tk" items="${checkedTickets}">
                                                            <tr>
                                                                <td class="fw-semibold text-primary">${tk.ticketCode}</td>
                                                                <td>
                                                                    <fmt:formatNumber value="${tk.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                                </td>
                                                                <td>
                                                                    ${tk.usedAt}
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-success px-2 py-1">Đã lên xe</span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="4" class="text-center py-4 text-secondary mb-0">Chưa có khách nào check-in trên chuyến này.</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
