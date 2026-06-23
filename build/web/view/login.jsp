`        
<%-- 
    Document   : login
    Created on : Jun 22, 2026, 2:11:31 PM
    Author     : Administrator
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <div class="login-container">
            <h2>Log In</h2>

            <c:if test="${not empty requestScope.error}">
                <div class="error-msg">${requestScope.error}</div>
            </c:if>

            <c:if test="${not empty sessionScope.success}">
                <div class="success-msg">${sessionScope.success}</div>
                <c:remove var="success" scope="session" />
            </c:if>

            <form action="login" method="POST">
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" minlength="4"
                           maxlength="50" autocomplete="username"
                           value="${requestScope.username}" required placeholder="Nhập username...">
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" 
                           minlength="6" autocomplete="current-password"
                           required placeholder="Nhập mật khẩu...">
                </div>

                <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
            </form>

            <a href="register" class="link-register">Chưa có tài khoản? Đăng ký ngay</a>
        </div>

    </body>
</html>
