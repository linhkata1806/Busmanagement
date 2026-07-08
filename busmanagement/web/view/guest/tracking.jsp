<%-- 
    Document   : tracking
    Created on : Jul 8, 2026, 2:45:28 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi xe buýt trực tuyến</title>
    
    <!-- Thư viện Leaflet CSS & JS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    
    <style>
        body, html { margin: 0; padding: 0; height: 100%; font-family: Arial, sans-serif; }
        #map { height: 100vh; width: 100vw; }
        .map-overlay {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            background: rgba(255, 255, 255, 0.9);
            padding: 10px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="map-overlay">Theo dõi Xe buýt (Auto Refresh 5s)</div>
    <div id="map"></div>

    <script>
        // Khởi tạo bản đồ, focus vào khu vực Hà Nội
        var map = L.map('map').setView([21.0285, 105.8542], 13);

        // Nền bản đồ (Dùng OpenStreetMap miễn phí)
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        // Icon xe buýt tự custom (có thể thay bằng URL ảnh icon xe buýt của project)
        var busIcon = L.icon({
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3448/3448339.png',
            iconSize: [32, 32],
            iconAnchor: [16, 16],
            popupAnchor: [0, -16]
        });

        // Mảng lưu trữ các marker hiện tại trên map để update vị trí thay vì xóa đi vẽ lại
        var markers = {};

        function fetchBusLocations() {
            fetch('${pageContext.request.contextPath}/api/bus-location')
                .then(response => response.json())
                .then(data => {
                    // Mảng lưu các ID xe nhận được từ API đợt này
                    var activeTripIDs = [];

                    data.forEach(bus => {
                        activeTripIDs.push(bus.tripID);

                        // Nội dung hiển thị khi click vào Marker
                        var popupContent = `
                            <div style="font-size: 14px; min-width: 150px;">
                                <h4 style="margin:0 0 5px 0; color:#0d6efd;">Tuyến: \${bus.routeNumber}</h4>
                                <b>Biển số:</b> \${bus.licensePlate}<br/>
                                <b>Trạng thái:</b> RUNNING<br/>
                                <b>Hành khách:</b> \${bus.passengerCount} / \${bus.capacity}<br/>
                                <b>ETA trạm tiếp:</b> <span style="color:red; font-weight:bold;">\${bus.etaMinutes} phút</span>
                            </div>
                        `;

                        if (markers[bus.tripID]) {
                            // Nếu marker đã có trên map -> Di chuyển nó đến tọa độ mới
                            markers[bus.tripID].setLatLng([bus.lat, bus.lng]);
                            markers[bus.tripID].getPopup().setContent(popupContent);
                        } else {
                            // Nếu xe mới xuất hiện -> Tạo marker mới
                            var newMarker = L.marker([bus.lat, bus.lng], {icon: busIcon})
                                .bindPopup(popupContent)
                                .addTo(map);
                            markers[bus.tripID] = newMarker;
                        }
                    });

                    // Xóa các marker của xe đã ngừng chạy (Không còn trả về từ API)
                    Object.keys(markers).forEach(tripID => {
                        if (!activeTripIDs.includes(parseInt(tripID))) {
                            map.removeLayer(markers[tripID]);
                            delete markers[tripID];
                        }
                    });
                })
                .catch(error => console.error("Lỗi fetch API:", error));
        }

        // Gọi lần đầu tiên ngay khi tải trang
        fetchBusLocations();

        // Cài đặt Refresh sau mỗi 5 giây
        setInterval(fetchBusLocations, 5000);

    </script>
</body>
</html>