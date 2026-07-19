<%-- 
    Document   : monthly-pass
    Created on : Jun 28, 2026, 8:10:52 PM
    Author     : Administrator
--%>

<%-- 
    Document   : monthly-pass
    Created on : Jun 28, 2026, 8:10:52 PM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý hồ sơ vé tháng - Bus Hà Nội</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --sidebar-bg: #1e293b;
                --bg-light: #f8f9fa;
                --primary-blue: #1a73e8;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .sidebar {
                background-color: var(--sidebar-bg);
                min-height: 100vh;
                color: #cbd5e1;
            }
            .sidebar .nav-link {
                color: #94a3b8;
                border-radius: 0.375rem;
                transition: all 0.2s;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255,255,255,0.1);
            }
            .main-content {
                padding: 2rem;
            }
            .filter-tab .nav-link {
                color: #64748b;
                font-weight: 600;
                padding: 0.6rem 1.2rem;
                border-radius: 0.5rem;
                transition: all 0.2s;
            }
            .filter-tab .nav-link.active {
                background-color: var(--primary-blue) !important;
                color: white !important;
            }
            .table-responsive {
                border-radius: 0.75rem;
            }
            .table-dark th {
                padding-top: 15px !important;
                padding-bottom: 15px !important;
                vertical-align: middle !important;
                font-size: 0.9rem !important;
                font-weight: 600 !important;
            }
            .table tbody td {
                padding-top: 12px !important;
                padding-bottom: 12px !important;
                vertical-align: middle !important;
            }
        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/view/staff/sidebar.jsp">
                    <jsp:param name="activeMenu" value="pass" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h2 class="fw-bold text-dark m-0">Quản lý vé tháng</h2>
                    </div>

                    <c:if test="${not empty sessionScope.msgSuccess}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 border-start border-success border-4" role="alert">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle me-2 fs-5"></i>
                                <div>${sessionScope.msgSuccess}</div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgSuccess" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.msgError}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 border-start border-danger border-4" role="alert">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                                <div>${sessionScope.msgError}</div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msgError" scope="session"/>
                    </c:if>

                    <div class="row g-3 mb-4 align-items-center">
                        <div class="col-md-7">
                            <ul class="nav nav-pills filter-tab gap-2 bg-white p-1.5 shadow-sm rounded-3 border d-inline-flex">
                                <li class="nav-item">
                                    <a class="nav-link ${currentStatus eq 'ALL' ? 'active' : ''}" href="?status=ALL&search=${searchQuery}">Tất cả</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${currentStatus eq 'PENDING' ? 'active' : ''}" href="?status=PENDING&search=${searchQuery}">Chờ duyệt</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${currentStatus eq 'APPROVED' ? 'active' : ''}" href="?status=APPROVED&search=${searchQuery}">Đã duyệt</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${currentStatus eq 'REJECTED' ? 'active' : ''}" href="?status=REJECTED&search=${searchQuery}">Bị từ chối</a>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-5">
                            <form action="${pageContext.request.contextPath}/staff/monthly-pass" method="GET" class="input-group shadow-sm">
                                <input type="hidden" name="status" value="${currentStatus}">
                                <input type="text" name="search" class="form-control border-end-0" placeholder="Tìm kiếm tên, mã vé..." value="${searchQuery}">
                                <button class="btn btn-primary px-4" type="submit"><i class="fas fa-search"></i></button>
                            </form>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 bg-white">
                        <div class="card-body p-0">
                            <div class="table-responsive d-flex flex-column h-100" style="min-height: 500px;">
                                <div class="flex-grow-1">
                                    <table class="table table-hover table-striped align-middle mb-0" style="min-width: 900px;">
                                        <thead class="table-dark">
                                            <tr>
                                                <th class="ps-4 py-3">Mã vé</th>
                                                <th class="py-3">Khách hàng</th>
                                                <th class="py-3">Loại tuyến xe</th>
                                                <th class="py-3">Thời gian hạn dùng</th>
                                                <th class="py-3">Trạng thái</th>
                                                <th class="text-center pe-4 py-3">Hành động xử lý</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty passList}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5 text-muted">
                                                            <div class="py-4">
                                                                <i class="fas fa-folder-open fa-3x mb-3 text-black-50 d-block"></i>
                                                                <span class="fw-semibold d-block fs-6">Không tìm thấy hồ sơ nào!</span>
                                                                <small class="text-secondary">Hệ thống trống hoặc bộ lọc tìm kiếm của bạn không có kết quả phù hợp.</small>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="p" items="${passList}">
                                                        <tr>
                                                            <td class="ps-4 fw-bold text-primary">#${p.passCode}</td>
    
                                                            <td>
                                                                <div class="fw-semibold text-dark">${p.fullName}</div>
                                                                <small class="text-muted text-xs">Mã TK: ${p.accountID}</small>
                                                            </td>
    
                                                            <td>
                                                                <span class="badge bg-light text-dark border px-2 py-1 mb-1 d-inline-block fw-medium">${p.typeName}</span>
                                                                <div class="small text-secondary">
                                                                    <c:choose>
                                                                        <c:when test="${empty p.routeNumber}">
                                                                            <i class="fas fa-globe text-success me-1" style="font-size: 0.75rem;"></i>Liên tuyến toàn mạng lưới
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="fas fa-map-marker-alt text-primary me-1" style="font-size: 0.75rem;"></i>Tuyến đơn: Số ${p.routeNumber}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </td>
    
                                                            <td class="small text-secondary">
                                                                <div>Từ: <span class="text-dark fw-medium">${p.startDate}</span></div>
                                                                <div>Đến: <span class="text-dark fw-medium">${p.endDate}</span></div>
                                                            </td>
    
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${p.status eq 'PENDING'}">
                                                                        <span class="badge bg-warning text-dark px-2 py-1.5"><i class="fas fa-clock me-1"></i>Chờ duyệt</span>
                                                                    </c:when>
                                                                    <c:when test="${p.status eq 'APPROVED'}">
                                                                        <span class="badge bg-success px-2 py-1.5"><i class="fas fa-check-circle me-1"></i>Đã duyệt</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-danger px-2 py-1.5"><i class="fas fa-times-circle me-1"></i>Bị từ chối</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
    
                                                            <!-- ĐÃ SỬA: Gom lại thành 1 nút duy nhất -->
                                                            <td class="text-center pe-4">
                                                                <button type="button" class="btn btn-outline-primary btn-sm px-3" title="Xem chi tiết hồ sơ"
                                                                        onclick="showDetailModal('${p.passID}', '${p.passCode}', '${p.fullName}', '${p.email}', '${p.phone}', '${pageContext.request.contextPath}/${p.imageProof}', '${p.status}')">
                                                                    <i class="fas fa-eye me-1"></i> View Detail
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <%@ include file="../../../common/pagination.jsp" %>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

        <!-- ĐÃ SỬA: Modal mới chứa toàn bộ thông tin và nút thao tác -->
        <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-light border-bottom-0 pb-2">
                        <h5 class="modal-title fw-bold text-dark"><i class="fas fa-file-invoice me-2 text-primary"></i>Chi tiết hồ sơ: <span id="modalPassCode" class="text-primary"></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 pt-2">
                        <!-- Xóa sạch code cũ, chỉ dùng 1 block thẻ row duy nhất này cho thông tin -->
                        <div class="row mb-3 bg-light p-3 rounded border align-items-center">
                            <div class="col-md-4 mb-2 mb-md-0">
                                <span class="text-secondary small d-block mb-1">Họ và tên khách hàng</span>
                                <strong class="fs-5 text-dark" id="modalFullName"></strong>
                            </div>
                            <div class="col-md-5 mb-2 mb-md-0 border-start">
                                <span class="text-secondary small d-block mb-1">Email liên hệ (Định danh)</span>
                                <strong class="fs-6 text-primary" id="modalEmail"></strong>
                            </div>
                            <div class="col-md-3 border-start">
                                <span class="text-secondary small d-block mb-1">Số điện thoại</span>
                                <strong class="fs-6 text-danger" id="modalPhone"></strong>
                            </div>
                        </div>
                        
                        <!-- Block ảnh minh chứng -->
                        <div class="text-center bg-dark p-2 rounded" style="border: 2px dashed #ccc; min-height: 200px; display: flex; align-items: center; justify-content: center;">
                            <img id="modalProofImg" src="" alt="Ảnh minh chứng" class="img-fluid w-100 rounded d-none" style="max-height: 55vh; object-fit: contain;">
                            <div id="noProofMessage" class="text-white opacity-50 py-4 text-center d-none">
                                <i class="far fa-image fa-3x mb-2 d-block"></i>
                                <span>Không có ảnh minh chứng</span>
                            </div>
                        </div>
                    </div>
                    <!-- Footer chứa nút thao tác linh hoạt -->
                    <div class="modal-footer bg-light" id="modalActionButtons">
                        <!-- JS sẽ tự động bơm nút Duyệt/Từ chối hoặc Đóng vào đây -->
                    </div>
                </div>
            </div>
        </div>

        <!-- JS điều khiển Modal -->
        <script>
                                                                        // Đã thay đổi tham số truyền vào: cccd -> email, phone
                                                                        function showDetailModal(passID, passCode, fullName, email, phone, imageUrl, status) {
                                                                            document.getElementById('modalPassCode').innerText = '#' + passCode;
                                                                            document.getElementById('modalFullName').innerText = fullName;

                                                                            // Xử lý hiển thị Email và Phone
                                                                            document.getElementById('modalEmail').innerText = (email && email !== 'null' && email !== '') ? email : 'Chưa cập nhật';
                                                                            document.getElementById('modalPhone').innerText = (phone && phone !== 'null' && phone !== '') ? phone : 'Chưa cập nhật';

                                                                            var imgEl = document.getElementById('modalProofImg');
                                                                            var msgEl = document.getElementById('noProofMessage');
                                                                            if (!imageUrl || imageUrl.endsWith('/') || imageUrl.endsWith('/null') || imageUrl.trim() === '') {
                                                                                imgEl.src = '';
                                                                                imgEl.classList.add('d-none');
                                                                                msgEl.classList.remove('d-none');
                                                                            } else {
                                                                                imgEl.src = imageUrl;
                                                                                imgEl.classList.remove('d-none');
                                                                                msgEl.classList.add('d-none');
                                                                            }

                                                                            var actionFooter = document.getElementById('modalActionButtons');
                                                                            actionFooter.innerHTML = '';

                                                                            if (status === 'PENDING') {
                                                                                actionFooter.innerHTML = `
                        <a href="${pageContext.request.contextPath}/staff/monthly-pass/reject?id=\${passID}" 
                           class="btn btn-outline-danger px-4" 
                           onclick="return confirm('Xác nhận TỪ CHỐI hồ sơ #\${passCode}?')">
                            <i class="fas fa-times me-1"></i> Từ chối
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/monthly-pass/approve?id=\${passID}" 
                           class="btn btn-success px-4" 
                           onclick="return confirm('Xác nhận DUYỆT hồ sơ #\${passCode}?')">
                            <i class="fas fa-check me-1"></i> Duyệt hồ sơ
                        </a>
                    `;
                                                                            } else {
                                                                                actionFooter.innerHTML = `
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>
                    `;
                                                                            }

                                                                            var myModal = new bootstrap.Modal(document.getElementById('detailModal'));
                                                                            myModal.show();
                                                                        }
        </script>
    </body>
</html>