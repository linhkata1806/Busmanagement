# Bus Management System (PRJ301 Final Project)

Hướng dẫn dành cho các thành viên của dự án **BusManagement**, bao gồm cấu trúc thư mục, quy trình làm việc với Git và cách thiết lập môi trường chạy dự án.

---

# Project Structure

```
.
├── busmanagement/      # Source code Java Web
├── docs/               # Documentation & analysis
└── .gitignore
```

| Thư mục          | Mục đích                                                                                          |
| ---------------- | ------------------------------------------------------------------------------------------------- |
| `busmanagement/` | Chứa toàn bộ mã nguồn của dự án. Khi mở bằng NetBeans, hãy chọn đúng thư mục này.                 |
| `docs/`          | Lưu tài liệu, sơ đồ, dữ liệu phân tích và file cấu hình mẫu.                                      |
| `.gitignore`     | Quy định các file không được theo dõi bởi Git. Không tự ý chỉnh sửa nếu chưa thống nhất với nhóm. |

---

# Git Workflow

## 1. Clone hoặc cập nhật dự án

### Trường hợp 1: Clone mới

```bash
git clone https://github.com/linhkata1806/Busmanagement.git
```

### Trường hợp 2: Đồng bộ dự án đã có

```bash
git fetch -p
git checkout main
git pull origin main
```

---

## 2. Tạo branch làm việc

Kiểm tra các branch hiện có:

```bash
git branch -a
```

Chuyển sang branch tính năng được phân công:

```bash
git checkout <feature-branch>
```

Tạo branch cá nhân:

```bash
git checkout -b feature/<your-name>
```

> **Lưu ý**
>
> Branch mới luôn được tạo từ branch hiện tại. Hãy chắc chắn bạn đang đứng đúng branch tính năng trước khi dùng `git checkout -b`.

---

## 3. Đồng bộ trước khi Push

Trước khi đưa mã nguồn lên GitHub, hãy đồng bộ với branch gốc.

Merge thử trên máy local:

```bash
git merge <feature-branch>
```

Nếu không còn conflict và dự án chạy bình thường:

```bash
git push origin feature/<your-name>
```

---

## 4. Tạo Pull Request

* Push branch cá nhân lên GitHub.
* Tạo Pull Request.
* Chờ review.
* Chỉ merge khi được leader phê duyệt.

---

# Database Configuration

File:

```text
busmanagement/web/WEB-INF/ConnectDB.properties
```

Mỗi thành viên sử dụng cấu hình SQL Server riêng.

File này **không được Git theo dõi**, vì vậy sau khi clone dự án:

1. Copy file mẫu từ `docs/template`.
2. Dán vào:

```
busmanagement/web/WEB-INF/
```

3. Chỉnh sửa:

* Username
* Password
* Port

theo SQL Server trên máy của bạn.

---

# Clean and Build

Trong các trường hợp dưới đây, **không nên bấm Run ngay**.

Hãy thực hiện:

```
Clean and Build
↓
Run
```

Áp dụng khi:

* Vừa clone hoặc pull dự án.
* Đổi tên file hoặc package.
* Refactor cấu trúc thư mục.
* Thêm thư viện `.jar`.

> Việc này giúp NetBeans và Tomcat biên dịch lại toàn bộ dự án, làm mới cache và hạn chế các lỗi như `ClassNotFoundException`, lỗi package hoặc HTTP Status 500.

---

# Một số quy tắc làm việc

* Không commit trực tiếp lên `main`.
* Luôn pull trước khi merge hoặc push.
* Chỉ tạo Pull Request khi tính năng đã được kiểm tra.
* Không chỉnh sửa `.gitignore` nếu chưa thống nhất với nhóm.
* Giải quyết toàn bộ conflict trên máy local trước khi tạo Pull Request.

---