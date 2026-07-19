package util;

import java.util.List;

public class Page<T> {
    private List<T> items;
    private int currentPage;
    private int totalItems;
    private int pageSize;
    private int totalPages;

    public Page(List<T> items, int currentPage, int totalItems, int pageSize) {
        this.items = items;
        this.currentPage = currentPage;
        this.totalItems = totalItems;
        this.pageSize = pageSize;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
    }

    public Page(List<T> items, int currentPage, int totalItems) {
        this(items, currentPage, totalItems, 10); // Mặc định 10 dòng/trang
    }

    public List<T> getItems() {
        return items;
    }

    public void setItems(List<T> items) {
        this.items = items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / this.pageSize);
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
        this.totalPages = (int) Math.ceil((double) this.totalItems / pageSize);
    }

    public int getTotalPages() {
        return totalPages;
    }
}
