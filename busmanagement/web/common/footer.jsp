<%@ page pageEncoding="UTF-8" %>
<style>
    /* ===== FOOTER COMMON STYLES ===== */
    footer {
        background-color: #1a1a2e !important;
        color: rgba(255,255,255,0.7) !important;
        padding: 30px 0 !important;
        margin-top: 60px !important;
    }
    footer a { 
        color: rgba(255,255,255,0.7) !important; 
        text-decoration: none !important; 
    }
    footer a:hover { 
        color: white !important; 
    }
    footer h6 { 
        color: white !important; 
    }
    footer small, footer .text-white-50 { 
        color: rgba(255,255,255,0.5) !important; 
    }
</style>
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3 text-center">
                <h6 class="text-white fw-bold">🚌 Bus Hà Nội</h6>
                <small class="text-white-50">Hệ thống quản lý xe bus công cộng thành phố Hà Nội.</small>
            </div>
            <div class="col-md-4 mb-3 text-center">
                <h6 class="text-white fw-bold">Liên kết</h6>
                <ul class="list-unstyled small">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/route-list">Danh sách tuyến</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-3 text-center">
                <h6 class="text-white fw-bold">Liên hệ</h6>
                <small class="text-white-50">
                    <i class="fas fa-phone me-1"></i>1900 xxxx<br>
                    <i class="fas fa-envelope me-1"></i>support@bushanoi.vn
                </small>
            </div>
        </div>
        <hr style="border-color: rgba(255,255,255,0.1)">
        <div class="text-center small">© 2024 Bus Hà Nội. All rights reserved.</div>
    </div>
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
