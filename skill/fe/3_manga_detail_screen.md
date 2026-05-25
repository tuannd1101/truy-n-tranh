# Screen: Manga Detail Screen

## Cấu trúc UI (Layout)

- Sử dụng `CustomScrollView` với `SliverAppBar`.
- **SliverAppBar:** Hình ảnh cover truyện làm background mờ, hình ảnh bìa chính nằm đè lên. Khi cuộn lên sẽ thu gọn thành AppBar chứa tên truyện.
- **Body:**
  1. **Info Section:** Tên truyện (Chữ to, đậm), Tác giả, Thể loại (dạng tags).
  2. **Action Buttons:**
     - Nút "Đọc ngay" to, nổi bật (Nền Vàng, chữ Đen).
     - Nút icon "Thêm yêu thích" (Trái tim).
  3. **Description:** Đoạn text mô tả truyện, có tính năng "Xem thêm / Thu gọn".
  4. **Chapter List:** `ListView` danh sách tập truyện. Mỗi row gồm: Tên/Số chapter, Ngày cập nhật. Nếu là chapter Premium, hiển thị icon Ổ khóa (🔒) màu Vàng bên phải.

## Màu sắc & Style (Theme)

- Nền màn hình: Trắng. Nền các chapter xen kẽ: Trắng và Trắng xám nhạt để dễ nhìn.
- Nút "Đọc ngay": `ElevatedButton`, bo góc 12px, nền #FFC107.

## Logic & API States (Chuẩn bị cho Backend)

- Cần có state kiểm tra: Nếu truyện chưa có chapter nào, disable nút "Đọc ngay".
- Tích hợp chạm vào Chapter có ổ khóa -> Hiện Snackbar hoặc Dialog yêu cầu nâng cấp tài khoản.
