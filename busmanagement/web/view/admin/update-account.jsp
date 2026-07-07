<%-- 
    Document   : update-account
    Created on : 06-07-2026, 19:34:15
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Cập nhật Tài khoản</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-warning text-dark">
                            <h4 class="mb-0">Cập nhật Tài khoản: ${account.username}</h4>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/account/update" method="POST">
                                <input type="hidden" name="accountId" value="${account.accountID}">

                                <div class="mb-3">
                                    <label class="form-label">Username (Không thể sửa)</label>
                                    <input type="text" class="form-control" value="${account.username}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" name="fullName" class="form-control" required value="${account.fullName}">
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
                                <button type="submit" class="btn btn-warning w-100">Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-secondary w-100 mt-2">Hủy</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
