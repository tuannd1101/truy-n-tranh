# Screen: Favorites Screen (Truyện yêu thích)

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, nút Back bên trái, tiêu đề "Truyện yêu thích", icon Search bên phải.
- **Sort & Filter Bar:**
  - Dropdown sắp xếp: "Mới thêm", "Tên A-Z", "Tên Z-A", "Cập nhật mới nhất".
  - Chip filter theo thể loại (có thể chọn nhiều).
- **Body:**
  - **GridView.builder** (2 cột) hiển thị danh sách truyện yêu thích.
  - Mỗi item:
    - Ảnh bìa với overlay gradient từ dưới lên.
    - Tên truyện (tối đa 2 dòng).
    - Icon trái tim đỏ ở góc trên phải.
    - Badge "Mới" nếu có chapter mới cập nhật.
  - Long press item để hiện menu: "Bỏ yêu thích", "Chia sẻ".
- **Empty State:**
  - Icon trái tim lớn màu xám.
  - Text "Chưa có truyện yêu thích".
  - Text nhỏ "Nhấn vào icon ❤️ ở trang chi tiết để thêm truyện yêu thích".
  - Nút "Khám phá ngay" dẫn về Home.

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Icon trái tim: Đỏ (#FF0000) khi đã yêu thích.
- Badge "Mới": Nền Vàng (#FFC107), chữ Đen, bo góc 4px.
- Overlay gradient: từ transparent đến rgba(0,0,0,0.6).

## Logic & API States (Chuẩn bị cho Backend)

- Fetch danh sách yêu thích từ API.
- Thêm/Bỏ yêu thích: Gọi API POST/DELETE và cập nhật UI ngay lập tức (optimistic update).
- Kiểm tra chapter mới: So sánh last_updated_at với lần cuối user xem.
- Sắp xếp và filter local sau khi fetch data.
- Pull-to-refresh để cập nhật danh sách.
- Hiển thị số lượng truyện yêu thích ở AppBar (ví dụ: "Yêu thích (24)").
