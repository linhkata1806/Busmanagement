<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận đăng ký dịch vụ vé - Bus Hà Nội</title>
        <jsp:include page="/common/head_imports.jsp" />

        <style>
            :root {
                --primary: #1a73e8;
                --primary-dark: #1557b0;
                --accent: #fbbc04;
                --bg-light: #f8f9fa;
            }
            body {
                background-color: var(--bg-light);
            }
            .navbar {
                background: var(--primary) !important;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            }
            .navbar-brand {
                font-weight: 700;
                font-size: 1.3rem;
                color: white !important;
            }
            .navbar-brand span {
                color: var(--accent);
            }
            .nav-link {
                color: rgba(255,255,255,0.9) !important;
                font-weight: 500;
            }

            /* Thiết kế hóa đơn dạng Vé xe Bus chuyên nghiệp */
            .ticket-container {
                max-width: 500px;
                margin: 0 auto;
            }
            .ticket-card {
                background: white;
                border-radius: 16px;
                border: 2px dashed #ced4da;
                position: relative;
                overflow: hidden;
            }
            .ticket-header {
                background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
                color: white;
                padding: 24px;
                text-align: center;
            }
            .ticket-body {
                padding: 28px;
            }
            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
                padding-bottom: 12px;
                border-bottom: 1px dashed #e9ecef;
            }
            .info-row:last-of-type {
                border-bottom: none;
            }
            .info-label {
                color: #6c757d;
                font-weight: 500;
                font-size: 0.95rem;
            }
            .info-value {
                color: #212529;
                font-weight: 600;
                font-size: 1rem;
            }

            /* Tạo vết răng cưa hai bên hông vé cho giống vé thật */
            .ticket-card::before, .ticket-card::after {
                content: '';
                position: absolute;
                top: 75px;
                width: 20px;
                height: 20px;
                background-color: var(--bg-light);
                border-radius: 50%;
                z-index: 3;
            }
            .ticket-card::before {
                left: -10px;
            }
            .ticket-card::after {
                right: -10px;
            }
        </style>
    </head>
    <body>
        <!-- ===== HEADER NAVIGATION ===== -->
        <jsp:include page="/common/navbar.jsp" />

        <div class="container my-5">
            <div class="ticket-container">

                <div class="mb-3 text-start">
                    <a href="javascript:history.back()" class="btn btn-light rounded-pill px-4 fw-bold text-dark shadow-sm">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i> ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMsg" scope="session" />
                </c:if>

                <div class="card ticket-card shadow-sm">
                    <div class="ticket-header">
                        <h5 class="fw-bold m-0 text-uppercase tracking-wide">
                            <c:choose>
                                <c:when test="${ticketType == 'thang'}">
                                    <i class="fas fa-id-card me-2"></i> Đăng ký vé tháng
                                </c:when>
                                <c:when test="${ticketType == 'lien_chuyen'}">
                                    <i class="fas fa-route me-2"></i> Đăng ký vé liên chuyến
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-ticket-alt me-2"></i> Mua vé lượt trực tuyến
                                </c:otherwise>
                            </c:choose>
                        </h5>
                    </div>

                    <div class="ticket-body">
                        <c:if test="${ticketType != 'lien_chuyen'}">
                            <div class="info-row">
                                <span class="info-label">Mã số tuyến:</span>
                                <span class="info-value text-primary">Tuyến ${route.routeNumber}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Tên lộ trình:</span>
                                <span class="info-value text-end text-truncate" style="max-width: 65%;" title="${route.routeName}">
                                    ${route.routeName}
                                </span>
                            </div>
                        </c:if>

                        <c:if test="${ticketType == 'lien_chuyen'}">
                            <div class="info-row">
                                <span class="info-label">Phạm vi áp dụng:</span>
                                <span class="info-value text-success">Toàn mạng lưới xe buýt</span>
                            </div>
                        </c:if>

                        <div class="info-row">
                            <span class="info-label">Loại dịch vụ:</span>
                            <span class="info-value text-dark">
                                <c:choose>
                                    <c:when test="${ticketType == 'thang'}">Vé tháng (1 Tuyến)</c:when>
                                    <c:when test="${ticketType == 'lien_chuyen'}">Vé tháng liên tuyến</c:when>
                                    <c:otherwise>Vé lượt tiêu chuẩn</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Ngày giao dịch:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${currentDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>

                        <c:set var="basePrice" value="${ticketType == 'luot' ? route.ticketPrice : (ticketType == 'thang' ? 100000 : 200000)}" />
                        <div class="info-row align-items-center mt-4 pt-3 border-top border-2">
                            <span class="info-label fw-bold text-dark fs-6">Tổng chi phí:</span>
                            <span class="info-value text-success fs-3 fw-bold" id="priceDisplay">
                                <fmt:formatNumber value="${displayPrice}" pattern="#,###"/> đ
                            </span>
                        </div>

                        <!-- ĐÃ SỬA: Đổi action, thêm enctype="multipart/form-data" -->
                        <form action="${pageContext.request.contextPath}/create-payment" method="POST" enctype="multipart/form-data" class="mt-4 needs-validation" novalidate>                            <!-- ĐÃ SỬA: name="routeID" cho khớp với Servlet -->
                            <input type="hidden" name="routeID" value="${route.routeID != null ? route.routeID : 0}">
                            <input type="hidden" name="ticketType" value="${ticketType}">
                            <!-- THÊM MỚI: input ẩn để gửi giá tiền về Servlet -->
                            <input type="hidden" name="price" id="hiddenPrice" value="${basePrice}">

                            <c:if test="${ticketType == 'thang' || ticketType == 'lien_chuyen'}">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-secondary small">ĐỐI TƯỢNG ĐĂNG KÝ VÉ THÁNG</label>
                                    <!-- ĐÃ SỬA: name="passTypeID" cho khớp với Servlet -->
                                    <select name="passTypeID" class="form-select rounded-3" id="passTypeSelect" onchange="updatePrice()">
                                        <c:choose>
                                            <c:when test="${ticketType == 'thang'}">
                                                <option value="1" data-discount="50">Học sinh / Sinh viên (1 Tuyến) - Giảm 50%</option>
                                                <option value="3" data-discount="100">Người cao tuổi - Miễn phí 100%</option>
                                                <option value="4" data-discount="0">Đối tượng khác (Phổ thông) - Nguyên giá</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="2" data-discount="50">Học sinh / Sinh viên (Liên Tuyến) - Giảm 50%</option>
                                                <option value="3" data-discount="100">Người cao tuổi - Miễn phí 100%</option>
                                                <option value="4" data-discount="0">Đối tượng khác (Phổ thông) - Nguyên giá</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-secondary small">MÃ HSSV / SỐ CCCD</label>
                                    <input type="text" name="cardNumber" class="form-control rounded-3" placeholder="Nhập 12 số CCCD định danh..." pattern="[0-9]{12}" maxlength="12" title="Số CCCD phải gồm đúng 12 chữ số" required>
                                </div>

                                <!-- ĐÃ SỬA: Khối Upload Ảnh Chuẩn -->
                                <div class="mb-3" id="proofUploadSection">
                                    <label class="form-label fw-bold text-secondary small">TẢI ẢNH THẺ HSSV / CCCD (MINH CHỨNG ƯU TIÊN)</label>
                                    <input type="file" name="imageProof" id="imageProofFile" class="form-control rounded-3" accept=".jpg,.jpeg,.png" required>
                                    <div class="form-text small text-muted">Chỉ nhận JPG/PNG, dung lượng tối đa 5MB.</div>
                                </div>

                                <!-- THÊM MỚI: Khung Preview Ảnh -->
                                <div class="mb-3 text-center d-none" id="previewContainer">
                                    <p class="mb-1 fw-bold text-secondary small text-start">Ảnh xem trước:</p>
                                    <img id="imagePreview" src="" alt="Preview" class="img-thumbnail shadow-sm rounded-3" style="max-height: 200px; object-fit: contain;">
                                </div>
                            </c:if>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-success fw-bold py-2.5 shadow-sm rounded-3 fs-6">
                                    <i class="fas fa-check-circle me-1"></i> XÁC NHẬN ĐĂNG KÝ
                                </button>
                                <a href="${pageContext.request.contextPath}/route-list" class="btn btn-light border py-2 fw-semibold text-muted rounded-3">
                                    Hủy bỏ giao dịch
                                </a>
                            </div>
                        </form>

                        <script>
                            // Cập nhật giá tiền
                            function updatePrice() {
                                const select = document.getElementById('passTypeSelect');
                                if (!select)
                                    return;
                                const discount = parseFloat(select.options[select.selectedIndex].getAttribute('data-discount'));
                                const basePrice = ${basePrice};
                                const finalPrice = basePrice * (100 - discount) / 100;

                                document.getElementById('priceDisplay').textContent = new Intl.NumberFormat('vi-VN').format(finalPrice) + ' đ';
                                document.getElementById('hiddenPrice').value = finalPrice; // Gán giá trị vào thẻ ẩn để gửi về Server
                            }

                            // Xử lý Preview và Validate dung lượng ảnh (Max 5MB)
                            document.getElementById('imageProofFile')?.addEventListener('change', function (e) {
                                const file = e.target.files[0];
                                const previewContainer = document.getElementById('previewContainer');
                                const imagePreview = document.getElementById('imagePreview');

                                if (file) {
                                    if (file.size > 5 * 1024 * 1024) {
                                        alert('Dung lượng ảnh vượt quá 5MB. Vui lòng chọn ảnh khác!');
                                        this.value = '';
                                        previewContainer.classList.add('d-none');
                                        return;
                                    }

                                    const reader = new FileReader();
                                    reader.onload = function (evt) {
                                        imagePreview.src = evt.target.result;
                                        previewContainer.classList.remove('d-none');
                                    }
                                    reader.readAsDataURL(file);
                                } else {
                                    previewContainer.classList.add('d-none');
                                }
                            });

                            window.addEventListener('DOMContentLoaded', () => {
                                updatePrice();
                            });
                        </script>



                    </div>
                </div>

                <p class="text-center text-muted small mt-3">
                    <i class="fas fa-shield-alt me-1 text-secondary"></i> Giao dịch bảo mật kỹ thuật số. Vé điện tử sẽ được cấp ngay sau khi xác nhận thành công.
                </p>
            </div>
        </div>

        <!-- ===== FOOTER ===== -->
        <jsp:include page="/common/footer.jsp" />
    </body>
</html>