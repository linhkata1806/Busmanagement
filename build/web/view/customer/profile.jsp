<%-- 
    Document   : profile
    Created on : Jun 26, 2026, 6:48:14 PM
    Author     : Administrator
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân | Bus Hà Nội</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h4>Cập nhật thông tin cá nhân</h4>
                </div>
                <div class="card-body">

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger text-center" role="alert">
                            ${errorMsg}
                        </div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success text-center" role="alert">
                            ${successMsg}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
                        
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và Tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${account.fullName}" required>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Địa chỉ Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${account.email}" required>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="phone" name="phone" 
                                   value="${account.phone}" 
                                   pattern="^0[0-9]{9}$" 
                                   title="Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0" required>
                        </div>

                        <div class="mb-4">
                            <label for="avatar" class="form-label">Đường dẫn ảnh đại diện (Link URL)</label>
                            <input type="text" class="form-control" id="avatar" name="avatar" 
                                   value="${account.avatar}">
                            
                            <c:if test="${not empty account.avatar}">
                                <div class="mt-2 text-center">
                                    <img src="${account.avatar}" alt="Avatar" class="rounded-circle" width="80" height="80" style="object-fit: cover;">
                                </div>
                            </c:if>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary fw-bold">Lưu thay đổi</button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>