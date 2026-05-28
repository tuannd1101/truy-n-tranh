# Screen: Reading History Screen (Lịch sử đọc)

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, nút Back bên trái, tiêu đề "Lịch sử đọc", icon "Xóa tất cả" bên phải.
- **Filter Bar:**
  - Dropdown để lọc theo thời gian: "Hôm nay", "7 ngày qua", "30 ngày qua", "Tất cả".
  - Icon lọc bên phải.
- **Body:**
  - **Grouped List:** Nhóm theo ngày (Hôm nay, Hôm qua, [Ngày/Tháng]).
  - Mỗi group có header dạng sticky (dính ở đầu khi scroll).
  - Mỗi item trong group:
    - Ảnh bìa nhỏ bên trái (60x90px).
    - Tên truyện, Chapter đã đọc, Thời gian đọc (ví dụ: "2 giờ trước").
    - Swipe left để xóa khỏi lịch sử.
- **Empty State:**
  - Icon đồng hồ lớn màu xám.
  - Text "Chưa có lịch sử đọc".
  - Nút "Khám phá truyện" dẫn về Home.

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Group header: Nền xám nhạt (#F0F0F0), text Đen đậm, padding 8px.
- Item: Nền trắng, có divider xám nhạt giữa các item.
- Thời gian: Text xám nhỏ (#6C757D).

## Logic & API States (Chuẩn bị cho Backend)

- Fetch lịch sử từ API hoặc Local Storage.
- Tự động lưu lịch sử khi user đọc chapter (gọi API hoặc lưu local).
- Xóa từng item: Gọi API DELETE hoặc xóa local.
- Xóa tất cả: Hiện confirm dialog trước khi xóa.
- Nhóm dữ liệu theo ngày sử dụng logic groupBy.
- Hiển thị loading skeleton khi đang fetch data.
