<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hướng Dẫn Sử Dụng - Bus Hà Nội</title>
    <jsp:include page="/common/head_imports.jsp" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #1557b0;
            --accent: #fbbc04;
            --bg-light: #f8fafc;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #334155;
        }

        /* ===== HEADER ===== */
        .navbar {
            background: var(--primary) !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
            color: white !important;
        }
        .navbar-brand span { color: var(--accent); }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }
        .nav-link:hover { color: white !important; }
        .nav-link.active { color: white !important; font-weight: 700; }

        /* ===== HERO ===== */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, #0d47a1 100%);
            padding: 50px 0;
            color: white;
            text-align: center;
        }

        /* ===== LAYOUT & CARDS ===== */
        .guide-sidebar {
            position: sticky;
            top: 20px;
        }
        .sidebar-menu {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            overflow: hidden;
        }
        .sidebar-item {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            color: #475569;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: all 0.2s;
        }
        .sidebar-item:hover {
            background: #f1f5f9;
            color: var(--primary);
        }
        .sidebar-item.active {
            background: #e8f0fe;
            color: var(--primary);
            border-left-color: var(--primary);
        }
        .sidebar-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .guide-card {
            background: white;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            padding: 30px;
            margin-bottom: 30px;
            scroll-margin-top: 20px;
        }

        .card-title-custom {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
        }

        /* ===== STEPS DESIGN ===== */
        .step-container {
            position: relative;
            padding-left: 35px;
            margin-bottom: 20px;
        }
        .step-container::before {
            content: '';
            position: absolute;
            left: 12px;
            top: 24px;
            bottom: -20px;
            width: 2px;
            background: #e2e8f0;
        }
        .step-container:last-child::before {
            display: none;
        }
        .step-number {
            position: absolute;
            left: 0;
            top: 0;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }
        .step-title {
            font-weight: 700;
            font-size: 0.95rem;
            color: #1e293b;
            margin-bottom: 4px;
        }

        /* ===== WEATHER WIDGET ===== */
        .weather-widget {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 8px 24px rgba(30, 60, 114, 0.2);
        }
        .weather-temp {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
        }
        .weather-forecast-day {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 12px;
            text-align: center;
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
<body>

<!-- ===== HEADER NAVIGATION ===== -->
<c:set var="activePage" value="guide" />
<jsp:include page="/common/navbar.jsp" />

<!-- ===== HERO BANNER ===== -->
<div class="hero">
    <div class="container">
        <h2 class="fw-bold mb-1">Hướng dẫn & Tra cứu Tiện ích</h2>
        <p class="text-white-50 mb-0">Hỗ trợ khách hàng tối ưu hóa lộ trình xe buýt và theo dõi thông tin trực tuyến</p>
    </div>
</div>

<!-- ===== MAIN BODY LAYOUT ===== -->
<div class="container mt-5">
    <div class="row">
        <!-- Sticky Left Sidebar Menu -->
        <div class="col-lg-3 mb-4">
            <div class="guide-sidebar">
                <div class="sidebar-menu">
                    <a href="#tim-duong" class="sidebar-item active">
                        <i class="fas fa-route"></i>Tìm đường tối ưu
                    </a>
                    <a href="#theo-doi-tram" class="sidebar-item">
                        <i class="fas fa-bell"></i>Theo dõi & Thông báo
                    </a>
                    <a href="#realtime" class="sidebar-item">
                        <i class="fas fa-clock"></i>Thời gian thực xe đến
                    </a>
                    <a href="#tuyen-tam-dung" class="sidebar-item">
                        <i class="fas fa-ban"></i>Tuyến xe tạm dừng
                    </a>
                    <a href="#thoi-tiet" class="sidebar-item">
                        <i class="fas fa-cloud-sun"></i>Thời tiết Hà Nội
                    </a>
                </div>
            </div>
        </div>

        <!-- Right Column Content -->
        <div class="col-lg-9">
            
            <!-- Section 1: Tìm đường -->
            <div id="tim-duong" class="guide-card">
                <h5 class="card-title-custom">
                    <i class="fas fa-route text-primary"></i>1. Hướng dẫn tìm đường đi tối ưu
                </h5>
                <p class="text-muted small mb-4">Tính năng tìm đường đi thông minh giúp bạn tìm lộ trình di chuyển tối ưu nhất bằng xe buýt giữa 2 địa điểm bất kỳ trong thành phố.</p>
                
                <div class="step-container">
                    <div class="step-number">1</div>
                    <div class="step-title">Chọn tab "Tìm Đường Đi" tại trang chủ</div>
                    <p class="small text-muted">Tại thanh tìm kiếm ở đầu trang chủ, nhấp chuyển đổi sang tab "Tìm Đường Đi" để kích hoạt chế độ tìm lộ trình đi qua các trạm dừng.</p>
                </div>
                <div class="step-container">
                    <div class="step-number">2</div>
                    <div class="step-title">Chọn Trạm đi và Trạm đến</div>
                    <p class="small text-muted">Lựa chọn trạm bắt đầu khởi hành của bạn và trạm kết thúc bạn muốn đến trong danh sách các trạm dừng thông minh có sẵn.</p>
                </div>
                <div class="step-container">
                    <div class="step-number">3</div>
                    <div class="step-title">Nhấp nút tìm kiếm và nhận đề xuất</div>
                    <p class="small text-muted">Hệ thống sẽ tính toán và hiển thị danh sách các tuyến xe buýt kết nối giữa 2 trạm này, kèm theo tổng số kilomet và giá vé dự kiến.</p>
                </div>
            </div>

            <!-- Section 2: Theo dõi trạm và thông báo -->
            <div id="theo-doi-tram" class="guide-card">
                <h5 class="card-title-custom">
                    <i class="fas fa-bell text-warning"></i>2. Cách theo dõi trạm dừng và nhận thông báo
                </h5>
                <p class="text-muted small mb-4">Nhận thông báo cập nhật về các thay đổi trạng thái của tuyến xe hoặc phê duyệt vé tháng trực tiếp trên tài khoản cá nhân của bạn.</p>
                
                <div class="step-container">
                    <div class="step-number">1</div>
                    <div class="step-title">Đăng nhập tài khoản cá nhân</div>
                    <p class="small text-muted">Hãy đảm bảo bạn đã đăng nhập để hệ thống có thể lưu trữ dữ liệu cá nhân hóa và quản lý vé.</p>
                </div>
                <div class="step-container">
                    <div class="step-number">2</div>
                    <div class="step-title">Đánh dấu Yêu thích tuyến xe</div>
                    <p class="small text-muted">Khi xem chi tiết một tuyến xe buýt, bạn nhấp vào biểu tượng Trái tim để lưu tuyến đó vào "Tuyến yêu thích". Hệ thống sẽ ưu tiên gửi các thông báo liên quan đến tuyến này cho bạn.</p>
                </div>
                <div class="step-container">
                    <div class="step-number">3</div>
                    <div class="step-title">Kiểm tra Hộp thư thông báo</div>
                    <p class="small text-muted">Bấm vào biểu tượng quả chuông hoặc chọn "Thông báo" trong menu cá nhân để đọc các thông tin quan trọng như phê duyệt thẻ vé tháng, tin tức phân luồng giao thông.</p>
                </div>
            </div>

            <!-- Section 3: Thời gian thực -->
            <div id="realtime" class="guide-card">
                <h5 class="card-title-custom">
                    <i class="fas fa-clock text-success"></i>3. Xem thời gian thực xe đến trạm dừng
                </h5>
                <p class="text-muted small mb-4">Hành khách có thể biết chính xác khoảng thời gian dự kiến (ETA) xe buýt sẽ tới điểm dừng hiện tại của mình.</p>
                
                <div class="step-container">
                    <div class="step-number">1</div>
                    <div class="step-title">Truy cập danh mục "Tuyến xe"</div>
                    <p class="small text-muted">Tìm kiếm và click vào tuyến xe buýt bạn chuẩn bị đi (Ví dụ: Tuyến số 32, Tuyến số 01...).</p>
                </div>
                <div class="step-container">
                    <div class="step-number">2</div>
                    <div class="step-title">Xem danh sách trạm dừng trực quan</div>
                    <p class="small text-muted">Bảng thông tin chi tiết của tuyến sẽ hiển thị toàn bộ danh sách các trạm dừng theo đúng trình tự di chuyển.</p>
                </div>
                <div class="step-container">
                    <div class="step-number">3</div>
                    <div class="step-title">Theo dõi ô thời gian dự kiến xe đến</div>
                    <p class="small text-muted">Tại mỗi trạm dừng sẽ có đồng hồ đếm ngược ước lượng thời gian thực tế mà chiếc xe gần nhất thuộc tuyến đó sẽ cập bến (ví dụ: Còn 5 phút, Còn 12 phút...).</p>
                </div>
            </div>

            <!-- Section 4: Tuyến dừng hoạt động -->
            <div id="tuyen-tam-dung" class="guide-card">
                <h5 class="card-title-custom">
                    <i class="fas fa-ban text-danger"></i>4. Các tuyến xe đang tạm dừng hoạt động
                </h5>
                <p class="text-muted small mb-4">Thông tin cập nhật chính xác từ trung tâm điều hành về các tuyến xe buýt đang tạm thời ngừng chạy (do bảo trì, sửa đường hoặc lý do bất khả kháng).</p>
                
                <c:choose>
                    <c:when test="${not empty suspendedRoutes}">
                        <div class="table-responsive">
                            <table class="table table-hover border">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" style="width: 100px;">Mã tuyến</th>
                                        <th scope="col">Tên tuyến</th>
                                        <th scope="col">Điểm bắt đầu</th>
                                        <th scope="col">Điểm kết thúc</th>
                                        <th scope="col" style="width: 120px;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="route" items="${suspendedRoutes}">
                                        <tr>
                                            <td class="fw-bold text-danger">${route.routeNumber}</td>
                                            <td>${route.routeName}</td>
                                            <td class="small">${route.startPoint}</td>
                                            <td class="small">${route.endPoint}</td>
                                            <td><span class="badge bg-danger">Tạm dừng</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-success d-flex align-items-center mb-0" role="alert">
                            <i class="fas fa-check-circle me-3 fs-4"></i>
                            <div>
                                <h6 class="alert-heading fw-bold mb-1" style="color: #1b5e20;">Hoạt động ổn định</h6>
                                <p class="small mb-0" style="color: #2e7d32;">Hiện tại, tất cả các tuyến xe buýt Hà Nội trong mạng lưới đều đang hoạt động bình thường theo đúng lịch trình quy định.</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Section 5: Dự báo thời tiết Hà Nội -->
            <div id="thoi-tiet" class="guide-card">
                <h5 class="card-title-custom">
                    <i class="fas fa-cloud-sun text-info"></i>5. Dự báo thời tiết tại Hà Nội
                </h5>
                <p class="text-muted small mb-4">Xem thông tin thời tiết trực tiếp tại Hà Nội để lên kế hoạch di chuyển bằng xe buýt một cách thuận lợi nhất.</p>
                
                <div class="weather-widget">
                    <div class="row align-items-center">
                        <div class="col-md-6 mb-3 mb-md-0 text-center text-md-start">
                            <div class="text-white-50 fw-semibold mb-1"><i class="fas fa-location-dot me-1"></i> Hà Nội, Việt Nam</div>
                            <div class="d-flex align-items-center justify-content-center justify-content-md-start my-2">
                                <i class="fas fa-spin-pulse fa-cloud-sun fs-1 me-3" id="weather-icon"></i>
                                <span class="weather-temp" id="weather-temp">--°C</span>
                            </div>
                            <div class="fw-bold" id="weather-desc" style="font-size: 1.1rem;">Đang tải thông tin thời tiết...</div>
                        </div>
                        <div class="col-md-6 border-start border-white-50">
                            <div class="row text-center g-2" id="forecast-container">
                                <!-- 3 Days Forecast will be inserted here -->
                                <div class="col-4">
                                    <div class="weather-forecast-day">
                                        <small class="text-white-50">--</small>
                                        <div class="my-2"><i class="fas fa-cloud"></i></div>
                                        <small class="fw-semibold">--/--</small>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="weather-forecast-day">
                                        <small class="text-white-50">--</small>
                                        <div class="my-2"><i class="fas fa-cloud"></i></div>
                                        <small class="fw-semibold">--/--</small>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="weather-forecast-day">
                                        <small class="text-white-50">--</small>
                                        <div class="my-2"><i class="fas fa-cloud"></i></div>
                                        <small class="fw-semibold">--/--</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3 pt-3 border-top border-white-10 text-white-50 small">
                        <div class="col-6"><i class="fas fa-droplet me-1"></i>Độ ẩm: <strong class="text-white" id="weather-humidity">--%</strong></div>
                        <div class="col-6"><i class="fas fa-wind me-1"></i>Gió: <strong class="text-white" id="weather-wind">-- km/h</strong></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ===== FOOTER ===== -->
<jsp:include page="/common/footer.jsp" />
<script>
    // 1. Sidebar Active State Sync on Scroll
    const sidebarItems = document.querySelectorAll('.sidebar-item');
    const sections = document.querySelectorAll('.guide-card');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            if (pageYOffset >= (sectionTop - 150)) {
                current = section.getAttribute('id');
            }
        });

        sidebarItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href') === `#${current}`) {
                item.classList.add('active');
            }
        });
    });

    // 2. Fetch Hanoi Realtime Weather từ Backend Java sử dụng WeatherAPI.com
    const contextPath = "${pageContext.request.contextPath}";
    const weatherUrl = contextPath + "/weather?city=Hanoi";

    function getDayName(dateStr) {
        const date = new Date(dateStr);
        const day = date.getDay();
        const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
        return days[day];
    }

    fetch(weatherUrl)
        .then(response => {
            if (!response.ok) throw new Error("API Connection Failed");
            return response.json();
        })
        .then(data => {
            const current = data.current;
            const forecastday = data.forecast.forecastday;
            
            // Cập nhật thông tin thời tiết hiện tại
            document.getElementById('weather-temp').innerText = Math.round(current.temp_c) + "°C";
            document.getElementById('weather-desc').innerText = current.condition.text;
            document.getElementById('weather-humidity').innerText = current.humidity + "%";
            document.getElementById('weather-wind').innerText = Math.round(current.wind_kph) + " km/h";
            
            // Cập nhật icon lớn
            const iconElement = document.getElementById('weather-icon');
            if (iconElement.tagName === 'I') {
                const img = document.createElement('img');
                img.id = 'weather-icon';
                img.src = 'https:' + current.condition.icon;
                img.className = 'me-3';
                img.style.width = '64px';
                img.style.height = '64px';
                iconElement.parentNode.replaceChild(img, iconElement);
            } else {
                iconElement.src = 'https:' + current.condition.icon;
            }
            
            // Cập nhật dự báo 3 ngày tiếp theo
            const forecastContainer = document.getElementById('forecast-container');
            forecastContainer.innerHTML = '';
            
            for(let i = 1; i <= 3; i++) {
                const dayData = forecastday[i];
                if (!dayData) continue;
                
                const dayName = i === 1 ? 'Ngày mai' : getDayName(dayData.date);
                const maxTemp = Math.round(dayData.day.maxtemp_c);
                const minTemp = Math.round(dayData.day.mintemp_c);
                const iconUrl = 'https:' + dayData.day.condition.icon;
                
                forecastContainer.innerHTML += 
                     '<div class="col-4">' +
                         '<div class="weather-forecast-day">' +
                             '<small class="text-white-50" style="font-size: 0.75rem;">' + dayName + '</small>' +
                             '<div class="my-2"><img src="' + iconUrl + '" style="width: 32px; height: 32px;" alt="icon" /></div>' +
                             '<small class="fw-semibold" style="font-size: 0.8rem;">' + minTemp + '°/' + maxTemp + '°</small>' +
                         '</div>' +
                     '</div>';
            }
        })
        .catch(err => {
            console.error("Error loading weather data:", err);
            document.getElementById('weather-desc').innerText = "Không thể tải dữ liệu thời tiết.";
        });
</script>

</body>
</html>
