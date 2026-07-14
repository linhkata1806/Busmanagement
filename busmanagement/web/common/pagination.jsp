<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            
            <%-- Nút Previous --%>
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage - 1}${not empty queryString ? '&' : ''}${queryString}" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            
            <%-- Hiển thị danh sách các trang --%>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}${not empty queryString ? '&' : ''}${queryString}">${i}</a>
                </li>
            </c:forEach>
            
            <%-- Nút Next --%>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage + 1}${not empty queryString ? '&' : ''}${queryString}" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
            
        </ul>
    </nav>
</c:if>
