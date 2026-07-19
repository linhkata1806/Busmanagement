<%-- 
    Document   : revenue-report
    Created on : 06-07-2026
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Báo cáo Doanh thu - Admin</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .filter-bar {
                background-color: #ffffff;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .kpi-card {
                border: none;
                border-radius: 12px;
                padding: 1.5rem;
                color: white;
                transition: transform 0.3s;
            }
            .kpi-card:hover {
                transform: translateY(-5px);
            }
            .kpi-total {
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            }
            .kpi-ticket {
                background: linear-gradient(135deg, #065f46, #10b981);
            }
            .kpi-pass {
                background: linear-gradient(135deg, #9a3412, #f59e0b);
            }

            .chart-container {
                background: #ffffff;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                height: 100%;
                min-height: 400px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp"><jsp:param name="activeMenu" value="revenue" /></jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

                        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                            <div>
                                <h2 class="fw-bold text-dark m-0">Báo cáo Doanh thu</h2>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/admin/revenue-report" method="GET" class="filter-bar mb-4">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label text-muted fw-bold fs-7">Khoảng thời gian</label>
                                <select name="period" class="form-select shadow-none">
                                    <option value="today" ${selectedPeriod == 'today' ? 'selected' : ''}>Hôm nay</option>
                                    <option value="this_month" ${selectedPeriod == 'this_month' || empty selectedPeriod ? 'selected' : ''}>Tháng này</option>
                                    <option value="last_month" ${selectedPeriod == 'last_month' ? 'selected' : ''}>Tháng trước</option>
                                    <option value="this_year" ${selectedPeriod == 'this_year' ? 'selected' : ''}>Năm nay</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold fs-7">Phân loại theo Tuyến</label>
                                <select name="routeId" class="form-select shadow-none">
                                    <option value="ALL"
                                            ${empty selectedRouteId ? 'selected' : ''}>
                                        Tất cả các tuyến
                                    </option>

                                    <c:forEach items="${routes}" var="r">
                                        <option value="${r.routeID}"
                                                ${selectedRouteId == r.routeID ? 'selected' : ''}>
                                            Tuyến ${r.routeNumber}: ${r.routeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100"><i class="fas fa-filter me-2"></i>Lọc dữ liệu</button>
                            </div>
                        </div>
                    </form>

                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="kpi-card kpi-total shadow-sm">
                                <h6 class="text-white-50 text-uppercase fw-bold mb-1">Tổng Doanh Thu</h6>
                                <h2 class="fw-bold mb-0">
                                    <fmt:formatNumber value="${not empty totalAll ? totalAll : 0}" pattern="#,##0" /> <span class="fs-5">VNĐ</span>
                                </h2>
                                <div class="mt-2 text-white-50 fs-7"><i class="fas fa-chart-line me-1"></i> Dữ liệu thực tế từ Database</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="kpi-card kpi-ticket shadow-sm">
                                <h6 class="text-white-50 text-uppercase fw-bold mb-1">Doanh thu Vé Lẻ</h6>
                                <h2 class="fw-bold mb-0">
                                    <fmt:formatNumber value="${not empty totalTicket ? totalTicket : 0}" pattern="#,##0" /> <span class="fs-5">VNĐ</span>
                                </h2>
                                <div class="mt-2 text-white-50 fs-7"><i class="fas fa-ticket-alt me-1"></i> Giao dịch thanh toán thành công</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="kpi-card kpi-pass shadow-sm">
                                <h6 class="text-white-50 text-uppercase fw-bold mb-1">Doanh thu Vé Tháng</h6>
                                <h2 class="fw-bold mb-0">
                                    <fmt:formatNumber value="${not empty totalPass ? totalPass : 0}" pattern="#,##0" /> <span class="fs-5">VNĐ</span>
                                </h2>
                                <div class="mt-2 text-white-50 fs-7">
                                    <i class="fas fa-calendar-check me-1"></i>

                                    Một tuyến:
                                    <fmt:formatNumber
                                        value="${not empty totalRoutePass ? totalRoutePass : 0}"
                                        pattern="#,##0" />
                                    đ

                                    &nbsp;|&nbsp;

                                    Liên tuyến:
                                    <fmt:formatNumber
                                        value="${not empty totalInterRoutePass
                                                 ? totalInterRoutePass : 0}"
                                        pattern="#,##0" />
                                    đ
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-lg-8">
                            <div class="chart-container d-flex flex-column">
                                <h5 class="fw-bold text-dark mb-4">Phân bổ Doanh thu theo Tuyến xe</h5>
                                <div class="flex-grow-1 position-relative">
                                    <canvas id="routeChart"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="chart-container d-flex flex-column">
                                <h5 class="fw-bold text-dark mb-4">Cơ cấu Nguồn thu</h5>
                                <div class="flex-grow-1 position-relative">
                                    <canvas id="proportionChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <script>
            // Bắt lỗi an toàn nếu Servlet chưa truyền mảng sang (tránh sập biểu đồ)
            const routeLabels = ${not empty labels ? labels : '[]'};
            const ticketDataArr = ${not empty ticketData ? ticketData : '[]'};
            const passDataArr = ${not empty passData ? passData : '[]'};

            // 1. BIỂU ĐỒ CỘT (Phân bổ theo tuyến)
            const routeCtx = document.getElementById('routeChart').getContext('2d');
            new Chart(routeCtx, {
                type: 'bar',
                data: {
                    labels: routeLabels.length > 0 ? routeLabels : ['Chưa có dữ liệu'],
                    datasets: [
                        {
                            label: 'Doanh thu Vé Lẻ',
                            data: ticketDataArr.length > 0 ? ticketDataArr : [0],
                            backgroundColor: '#3b82f6',
                            borderRadius: 4
                        },
                        {
                            label: 'Doanh thu Vé Tháng',
                            data: passDataArr.length > 0 ? passDataArr : [0],
                            backgroundColor: '#10b981',
                            borderRadius: 4
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value.toLocaleString('vi-VN') + ' đ';
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {position: 'bottom'},
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += context.parsed.y.toLocaleString('vi-VN') + ' VNĐ';
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });

            // Lấy trực tiếp tổng doanh thu từ Servlet để vẽ biểu đồ tròn
            const valTicket =
            ${not empty totalTicket ? totalTicket : 0};

            const valRoutePass =
            ${not empty totalRoutePass ? totalRoutePass : 0};

            const valInterRoutePass =
            ${not empty totalInterRoutePass
              ? totalInterRoutePass : 0};

            const totalRevenue =
                    valTicket + valRoutePass + valInterRoutePass;

            const hasRevenue = totalRevenue > 0;

            // 2. BIỂU ĐỒ TRÒN (Tỷ trọng nguồn thu)
            const propCtx = document.getElementById('proportionChart').getContext('2d');
            new Chart(propCtx, {
                type: 'doughnut',
                data: {
                    labels: hasRevenue
                            ? [
                                'Vé Lẻ',
                                'Vé tháng một tuyến',
                                'Vé tháng liên tuyến'
                            ]
                            : ['Chưa có dữ liệu'],

                    datasets: [{
                            data: hasRevenue
                                    ? [
                                        valTicket,
                                        valRoutePass,
                                        valInterRoutePass
                                    ]
                                    : [1],

                            backgroundColor: hasRevenue
                                    ? [
                                        '#3b82f6',
                                        '#10b981',
                                        '#f59e0b'
                                    ]
                                    : ['#e2e8f0'],

                            borderWidth: 0
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: {position: 'bottom'},
                        label: function (context) {
                            if (!hasRevenue) {
                                return 'Chưa có giao dịch';
                            }

                            const value = context.parsed;

                            const percentage =
                                    Math.round((value / totalRevenue) * 100);

                            return context.label
                                    + ': '
                                    + value.toLocaleString('vi-VN')
                                    + ' đ ('
                                    + percentage
                                    + '%)';
                        }
                    }
                }
            });
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>