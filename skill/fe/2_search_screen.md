# Screen: Search Screen

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, không có bóng đổ (elevation: 0). Chứa nút Back bên trái.
- **Search Bar:**
  - `TextField` với Icon Search bên trái, placeholder "Tìm kiếm truyện...".
  - Icon X (clear) bên phải để xóa text khi đã nhập.
  - Border radius 24px, nền xám nhạt (#F0F0F0).
- **Filter Section:**
  - Dòng chữ "Thể loại:" và danh sách `Chip` cuộn ngang.
  - Chip được chọn: Nền Vàng (#FFC107), chữ Đen.
  - Chip chưa chọn: Nền trắng, viền xám, chữ xám.
- **Body:**
  - **Trạng thái ban đầu (chưa search):** Hiển thị "Lịch sử tìm kiếm" với danh sách các từ khóa đã search (có icon X để xóa từng item).
  - **Đang search:** Hiển thị `CircularProgressIndicator` màu Vàng.
  - **Có kết quả:** `GridView.builder` hiển thị danh sách truyện (2 cột). Mỗi item gồm: Ảnh bìa, Tên truyện, Tag [Free]/[Premium].
  - **Không có kết quả:** Icon tìm kiếm lớn màu xám, text "Không tìm thấy kết quả cho '[từ khóa]'".

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Search Bar: Nền xám nhạt (#F0F0F0), text màu Đen (#1A1A1A).
- Filter Chips: Vàng (#FFC107) khi active, Trắng khi inactive.

## Logic & API States (Chuẩn bị cho Backend)

- Debounce 500ms khi user nhập text để tránh call API liên tục.
- Lưu lịch sử tìm kiếm vào Local Storage (SharedPreferences).
- Filter theo thể loại có thể kết hợp với search keyword.
- Hiển thị số lượng kết quả tìm được (ví dụ: "Tìm thấy 24 truyện").
