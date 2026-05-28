# Screen: Manga Reading Screen

## Cấu trúc UI (Layout)

- **Chế độ đọc:** Hỗ trợ 2 chế độ:
  1. **Vertical Scroll:** Sử dụng `ListView.builder` để cuộn dọc qua các trang.
  2. **Horizontal Swipe:** Sử dụng `PageView.builder` để vuốt ngang giữa các trang.
- **AppBar (Ẩn/Hiện):**
  - Tap vào màn hình để toggle hiện/ẩn AppBar và Bottom Bar.
  - AppBar: Tiêu đề "Chapter [số]", nút Back, icon Settings.
  - Nền đen mờ (opacity 0.7) để text dễ đọc trên ảnh.
- **Body:**
  - Hiển thị ảnh chapter sử dụng `cached_network_image`.
  - Ảnh fit width, height tự động.
  - Loading: Hiển thị `CircularProgressIndicator` màu Vàng.
  - Error: Hiển thị icon lỗi và nút "Thử lại".
- **Bottom Bar (Ẩn/Hiện):**
  - Slider để xem progress đọc (trang hiện tại / tổng số trang).
  - Nút "Chapter trước" và "Chapter sau".
  - Text hiển thị "Trang X/Y".
- **Settings Panel (Modal Bottom Sheet):**
  - Chọn chế độ đọc: Vertical / Horizontal.
  - Điều chỉnh độ sáng màn hình (Slider).
  - Chế độ đọc ban đêm (Dark mode toggle).

## Màu sắc & Style (Theme)

- Background: Đen (#000000) để tập trung vào nội dung.
- AppBar & Bottom Bar: Đen mờ (rgba(0,0,0,0.7)), text Trắng.
- Nút navigation: Icon màu Vàng (#FFC107) khi active, Xám khi disabled.

## Logic & API States (Chuẩn bị cho Backend)

- Preload 2-3 trang trước và sau trang hiện tại để đọc mượt.
- Lưu progress đọc (chapter ID, page number) vào Local Storage.
- Khi đọc xong chapter, tự động chuyển sang chapter tiếp theo (có confirm dialog).
- Nếu chapter là Premium và user là Free, hiển thị overlay "Nâng cấp để đọc" với nút CTA.
- Hỗ trợ zoom in/out ảnh bằng gesture (pinch to zoom).
