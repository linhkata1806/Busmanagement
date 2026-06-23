<%-- 
    Document   : register
    Created on : Jun 22, 2026, 2:15:27 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <div class="register-container">
            <h2>ĐĂNG KÝ TÀI KHOẢN</h2>

            <c:if test="${not empty requestScope.error}">
                <div class="error-msg">${requestScope.error}</div>
            </c:if>

            <form action="register" method="POST">
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="fullName" value="${requestScope.fullName}" required placeholder="Vd: Nguyễn Văn A">
                </div>

                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" minlength="4"
                           maxlength="50"
                           value="${requestScope.username}" required placeholder="Nhập username...">
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" minlength="6"
                           autocomplete="new-password"
                           required placeholder="Nhập mật khẩu...">
                </div>

                <div class="form-group">
                    <label>Nhập lại mật khẩu</label>
                    <input type="password" name="repassword" minlength="6"
                           required placeholder="Nhập lại mật khẩu trên...">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="${requestScope.email}" required placeholder="Vd: email@domain.com">
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" pattern="0[0-9]{9}"
                           value="${requestScope.phone}" required placeholder="Vd: 0987654321">
                </div>

                <button type="submit" class="btn-submit">ĐĂNG KÝ</button>
            </form>

            <a href="login" class="link-login">Đã có tài khoản? Quay lại Đăng nhập</a>
        </div>

    </body>
</html>
