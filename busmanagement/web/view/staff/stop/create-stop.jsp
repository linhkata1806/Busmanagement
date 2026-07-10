<%-- 
    Document   : create-stop
    Created on : Jul 1, 2026, 6:20:53 PM
    Author     : Administrator
--%>

<%-- 
    Document   : create-stop
    Created on : Jul 1, 2026, 6:20:53 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Điểm Dừng Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- BỔ SUNG: Leaflet CSS cho bản đồ -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Thêm Điểm Dừng Mới</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- HIỂN THỊ LỖI -->
                        <c:if test="${not empty requestScope.msgError}">
                            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${requestScope.msgError}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/staff/stop/create" method="POST" id="stopForm">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên điểm dừng <span class="text-danger">*</span></label>
                                <input type="text" name="stopName" class="form-control" required placeholder="VD: Bến xe Mỹ Đình" value="${stopName}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ</label>
                                <input type="text" name="address" class="form-control" placeholder="Tùy chọn: Số 20 Phạm Hùng..." value="${address}">
                            </div>

                            <!-- BỔ SUNG: Bản đồ để click chọn tọa độ -->
                            <div class="mb-3">
                                <label class="form-label fw-bold text-success"><i class="fas fa-hand-pointer me-1"></i> Click trên bản đồ để tự động lấy tọa độ <span class="text-danger">*</span></label>
                                <div id="mapPick" style="height: 350px; width: 100%; border-radius: 8px; border: 1px solid #ced4da;"></div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Vĩ độ (Latitude) <span class="text-danger">*</span></label>
                                    <!-- Đổi thành readonly để user không tự gõ bậy -->
                                    <input type="text" id="latInput" name="latitude" class="form-control bg-light" required readonly placeholder="Đợi click bản đồ..." value="${latitude}">
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label fw-bold">Kinh độ (Longitude) <span class="text-danger">*</span></label>
                                    <!-- Đổi thành readonly để user không tự gõ bậy -->
                                    <input type="text" id="lngInput" name="longitude" class="form-control bg-light" required readonly placeholder="Đợi click bản đồ..." value="${longitude}">
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/staff/stop" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-1"></i> Lưu điểm dừng
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- BỔ SUNG: Leaflet JS & Logic Map -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // Khởi tạo bản đồ, mặc định ngắm về Hà Nội
        var map = L.map('mapPick').setView([21.0285, 105.8542], 12);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(map);

        var currentMarker = null;

        // Nếu form bị lỗi và trả về dữ liệu cũ (State Retention), tự động vẽ lại marker
        var existingLat = document.getElementById('latInput').value;
        var existingLng = document.getElementById('lngInput').value;
        
        if (existingLat && existingLng) {
            var latlng = [parseFloat(existingLat), parseFloat(existingLng)];
            currentMarker = L.marker(latlng).addTo(map);
            map.setView(latlng, 15);
        }

        // Bắt sự kiện Click lên bản đồ
        map.on('click', function(e) {
            var lat = e.latlng.lat.toFixed(6); // Lấy 6 số thập phân cho chuẩn xác
            var lng = e.latlng.lng.toFixed(6);

            // Tự động điền xuống input
            document.getElementById('latInput').value = lat;
            document.getElementById('lngInput').value = lng;

            // Di chuyển hoặc tạo mới Marker
            if (currentMarker) {
                currentMarker.setLatLng(e.latlng);
            } else {
                currentMarker = L.marker(e.latlng).addTo(map);
            }
        });

        // Xử lý chống móp méo bản đồ khi tải trang
        setTimeout(function() {
            map.invalidateSize();
        }, 300);

        // Validate chặn Submit nếu quên chưa chấm bản đồ
        document.getElementById('stopForm').addEventListener('submit', function(e) {
            if (!document.getElementById('latInput').value || !document.getElementById('lngInput').value) {
                e.preventDefault();
                alert("Vui lòng click lên bản đồ để chọn tọa độ cho điểm dừng!");
            }
        });
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>