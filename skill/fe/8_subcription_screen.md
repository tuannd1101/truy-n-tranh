# Screen: Subscription Plan Screen

## Cấu trúc UI (Layout)

- **AppBar:** Tiêu đề "Nâng cấp Premium", nút Back.
- **Header:** Lời kêu gọi hấp dẫn (Ví dụ: "Đọc truyện không giới hạn, mở khóa toàn bộ chapter...").
- **Body:** - Danh sách các Card hiển thị gói (Ví dụ: Gói 1 Tháng, 6 Tháng, 1 Năm).
  - Card nào đang được chọn sẽ có hiệu ứng viền sáng lên và checkmark.
- **Bottom:** Nút "Tiến hành thanh toán" dính ở đáy màn hình.

## Màu sắc & Style (Theme)

- Card bình thường: Nền trắng, viền xám nhạt.
- Card được chọn: Viền Vàng (#FFC107) dày 2px, nền vàng rất nhạt (Opacity 0.1).
- Chữ số tiền: In đậm, to, màu Đen.

## Logic & API States (Chuẩn bị cho Backend)

- Fetch danh sách các gói từ API.
- Bắt buộc phải chọn 1 gói mới enable nút "Tiến hành thanh toán".
