<%-- 
    Document   : create-account
    Created on : 06-07-2026, 19:33:46
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Tạo Tài Khoản Mới - Admin</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Thêm Tài Khoản Mới</h4>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty errorMsg}">
                                <div class="alert alert-danger">${errorMsg}</div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/admin/account/create" method="POST">
                                <div class="mb-3">
                                    <label class="form-label">Username</label>
                                    <input type="text" name="username" class="form-control" required value="${username}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mặc định</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" name="fullName" class="form-control" required value="${fullName}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" name="email" class="form-control" required value="${email}" 
                                           pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" 
                                           title="Vui lòng nhập đúng định dạng email (VD: nguyenvanb@gmail.com)">    
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phone" class="form-control" required value="${phone}" 
                                           pattern="^0[0-9]{9}$" 
                                           title="Số điện thoại phải bắt đầu bằng số 0 và có đúng 10 chữ số (VD: 0901234567)">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Phân quyền</label>
                                    <select name="roleId" class="form-select" required>
                                        <option value="2">STAFF</option>
                                        <option value="3">DRIVER</option>
                                        <option value="4">ASSISTANT</option>
                                        <option value="5">CUSTOMER</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-success w-100">Xác nhận tạo tài khoản</button>
                                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-secondary w-100 mt-2">Quay lại</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
