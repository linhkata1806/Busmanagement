<%-- 
    Document   : revenue-report
    Created on : 06-07-2026, 19:35:30
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Báo cáo Doanh thu - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <jsp:include page="sidebar.jsp"><jsp:param name="activeMenu" value="revenue" /></jsp:include>
        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <h2 class="fw-bold mb-4">Biểu đồ Doanh thu (Hôm nay)</h2>
            <div class="card p-4 shadow-sm">
                <canvas id="revenueChart" style="max-height: 400px;"></canvas>
            </div>
        </main>
    </div>
</div>

<script>
    // Nhận dữ liệu JSON từ Servlet đẩy qua
    const data = ${chartDataJson}; 
    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: data,
        options: { responsive: true }
    });
</script>
</body>
</html>