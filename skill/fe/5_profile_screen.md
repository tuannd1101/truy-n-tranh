# Screen: Profile Screen

## Cấu trúc UI (Layout)

- **Header:** Hiển thị Avatar tròn, Tên User, và Email. Có Badge hiển thị Role: "Guest", "Free User" (Màu xám) hoặc "Premium User" (Màu Vàng ánh kim).
- **Premium Banner:** Một Card nổi bật ngay dưới thông tin user mời gọi nâng cấp. (Nền đen (#1A1A1A), chữ Vàng (#FFC107), có nút "Nâng cấp ngay").
- **Menu List:** Dạng `ListTile` cho các chức năng:
  - Lịch sử đọc
  - Truyện yêu thích
  - Cài đặt
  - Đăng xuất (Text màu đỏ).

## Màu sắc & Style (Theme)

- Background tổng thể: Trắng sữa (#F8F9FA).
- Card, ListTile: Nền trắng (#FFFFFF), có bo góc và bóng đổ nhẹ.

## Logic & API States (Chuẩn bị cho Backend)

- Nếu user là Guest (chưa đăng nhập), ẩn thông tin cá nhân và hiển thị nút "Đăng nhập / Đăng ký" to ở giữa màn hình.
