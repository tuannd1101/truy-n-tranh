# Screen: Library Screen (Thư viện)

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, không có bóng đổ (elevation: 0). Tiêu đề "Thư viện", icon Search bên phải.
- **Tab Bar:** 2 tabs:
  1. **Đang đọc:** Hiển thị các truyện đang đọc dở với progress bar.
  2. **Yêu thích:** Hiển thị các truyện đã bookmark/favorite.
- **Body (Tab "Đang đọc"):**
  - `ListView` hiển thị các truyện đang đọc.
  - Mỗi item gồm:
    - Ảnh bìa nhỏ bên trái (80x120px).
    - Tên truyện, Chapter đang đọc.
    - Progress bar (% đã đọc của chapter).
    - Nút "Đọc tiếp" màu Vàng.
  - Swipe left để xóa khỏi danh sách.
- **Body (Tab "Yêu thích"):**
  - `GridView.builder` (2 cột) hiển thị truyện yêu thích.
  - Mỗi item: Ảnh bìa, Tên truyện, Icon trái tim đỏ ở góc trên phải.
  - Long press để bỏ yêu thích.
- **Empty State:**
  - Icon sách lớn màu xám.
  - Text "Chưa có truyện nào trong thư viện".
  - Nút "Khám phá ngay" dẫn về Home.

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Tab indicator: Vàng (#FFC107), dày 3px.
- Progress bar: Vàng (#FFC107) cho phần đã đọc, Xám nhạt (#E0E0E0) cho phần còn lại.
- Nút "Đọc tiếp": Nền Vàng, chữ Đen, bo góc 8px.

## Logic & API States (Chuẩn bị cho Backend)

- Fetch danh sách "Đang đọc" từ API (hoặc Local Storage nếu offline).
- Fetch danh sách "Yêu thích" từ API.
- Tính toán progress: (current_page / total_pages) \* 100.
- Sync data với server khi có internet.
- Pull-to-refresh để cập nhật danh sách.
