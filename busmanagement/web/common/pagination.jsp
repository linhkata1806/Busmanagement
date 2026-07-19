<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${totalPages > 1}">
    <!-- mt-auto giúp thanh phân trang tự động dính dưới đáy -->
    <nav aria-label="Page navigation" class="mt-auto pt-4 w-100">
        <ul class="pagination flex-nowrap mb-0" style="width: max-content; margin: 0 auto;" id="pagination-ul">
            
            <%-- Nút Shift Left --%>
            <li class="page-item" id="btn-shift-left">
                <a class="page-link shadow-sm" href="javascript:void(0)" onclick="shiftPagination(-1)" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            
            <%-- Hiển thị TẤT CẢ các trang, sẽ được ẩn/hiện bằng JS --%>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item page-number-item ${currentPage == i ? 'active' : ''}" data-page="${i}">
                    <a class="page-link shadow-sm" href="?page=${i}${not empty queryString ? '&' : ''}${queryString}">${i}</a>
                </li>
            </c:forEach>
            
            <%-- Nút Shift Right --%>
            <li class="page-item" id="btn-shift-right">
                <a class="page-link shadow-sm" href="javascript:void(0)" onclick="shiftPagination(1)" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
            
        </ul>
    </nav>

    <script>
        (function() {
            var totalPages = parseInt('${totalPages}');
            var currentPage = parseInt('${currentPage}');
            var maxVisible = 18;
            
            var windowStart = Math.max(1, currentPage - Math.floor(maxVisible / 2));
            var windowEnd = windowStart + maxVisible - 1;
            
            if (windowEnd > totalPages) {
                windowEnd = totalPages;
                windowStart = Math.max(1, windowEnd - maxVisible + 1);
            }
            
            function renderPaginationWindow() {
                var items = document.querySelectorAll('.page-number-item');
                items.forEach(function(item) {
                    var page = parseInt(item.getAttribute('data-page'));
                    if (page >= windowStart && page <= windowEnd) {
                        item.classList.remove('d-none');
                    } else {
                        item.classList.add('d-none');
                    }
                });
                
                var btnLeft = document.getElementById('btn-shift-left');
                var btnRight = document.getElementById('btn-shift-right');
                
                if (windowStart <= 1) {
                    if(btnLeft) btnLeft.classList.add('disabled');
                } else {
                    if(btnLeft) btnLeft.classList.remove('disabled');
                }
                
                if (windowEnd >= totalPages) {
                    if(btnRight) btnRight.classList.add('disabled');
                } else {
                    if(btnRight) btnRight.classList.remove('disabled');
                }
            }
            
            window.shiftPagination = function(step) {
                if (step === -1 && windowStart > 1) {
                    windowStart -= 1;
                    windowEnd -= 1;
                } else if (step === 1 && windowEnd < totalPages) {
                    windowStart += 1;
                    windowEnd += 1;
                }
                renderPaginationWindow();
            };
            
            renderPaginationWindow();
        })();
    </script>
</c:if>
