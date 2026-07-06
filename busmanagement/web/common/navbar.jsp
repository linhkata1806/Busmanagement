<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    /* ===== GLOBAL NAVBAR BUTTON STYLES (DESKTOP & MOBILE) ===== */
    .navbar-nav .btn-nav-login, 
    .navbar-nav .btn-nav-register {
        min-width: 105px !important;
        text-align: center !important;
    }

    /* ===== RESPONSIVE NAVBAR FOR TABLET & MOBILE VIEW ===== */
    @media (max-width: 991.98px) {
        .navbar-collapse.show, 
        .navbar-collapse.collapsing {
            display: flex !important;
            flex-direction: row !important;
            justify-content: space-between !important;
            align-items: flex-start !important;
            width: 100%;
        }
        .navbar-collapse.show {
            padding-top: 15px;
            padding-bottom: 10px;
        }
        .navbar-nav.me-auto {
            align-items: flex-start !important;
            width: 50% !important;
            margin-bottom: 0 !important;
        }
        .navbar-nav.ms-auto {
            align-items: flex-end !important;
            width: 50% !important;
        }
        .navbar-nav .nav-item {
            width: 100%;
            height: 45px; /* Giữ chiều cao cố định để 2 bên song song */
            display: flex;
            align-items: center;
            margin-bottom: 10px !important;
        }
        .navbar-nav.me-auto .nav-item {
            justify-content: flex-start;
        }
        .navbar-nav.ms-auto .nav-item {
            justify-content: flex-end;
        }
        /* Fix lỗi dropdown menu đẩy chữ tên người dùng trên mobile */
        .navbar-nav .nav-item.dropdown {
            display: block !important;
            height: 45px !important;
            position: relative;
        }
        .navbar-nav .nav-item.dropdown .nav-link {
            height: 45px;
            display: flex !important;
            align-items: center;
            justify-content: flex-end;
            padding: 0 !important;
            width: 100%;
        }
        .navbar-nav.me-auto .nav-link {
            display: inline-block !important;
            padding: 0 !important;
        }
        .navbar-nav .nav-link.btn-nav-login, 
        .navbar-nav .nav-link.btn-nav-register {
            margin-left: 0 !important;
            margin-top: 0 !important;
            padding: 6px 14px !important; /* Thu nhỏ padding để ôm sát chữ hơn */
            min-width: 105px;             /* Thu nhỏ chiều rộng tối thiểu */
            text-align: center;
            display: inline-block !important;
        }
    }
</style>
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            🚌 Bus <span>Hà Nội</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'guide' ? 'active' : ''}" href="${pageContext.request.contextPath}/guide">Hướng dẫn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'route' ? 'active' : ''}" href="${pageContext.request.contextPath}/route-list">Tuyến xe</a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${not empty USER}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle ${activePage == 'profile' || activePage == 'ticket' ? 'active' : ''}" href="#" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i> Chào, <strong>${USER.fullName}</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li>
                                    <a class="dropdown-item ${activePage == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/profile">
                                        <i class="fas fa-user me-2 text-primary"></i>Hồ sơ
                                    </a>
                                </li>
                                <c:if test="${USER.roleName == 'CUSTOMER'}">
                                    <li>
                                        <a class="dropdown-item ${activePage == 'ticket' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/ticket">
                                            <i class="fas fa-ticket-alt me-2 text-primary"></i>Vé của tôi
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link btn-nav-login" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link btn-nav-register" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
