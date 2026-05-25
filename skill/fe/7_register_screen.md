# Screen: Register Screen

## Cấu trúc UI (Layout)

- Tương tự Login, nhưng có thêm AppBar với nút Back.
- **Form:**
  - `TextFormField` Họ và Tên.
  - `TextFormField` Email.
  - `TextFormField` Password.
  - `TextFormField` Nhập lại Password.
- **Action:** Nút "Đăng Ký" full width.

## Màu sắc & Style (Theme)

- Dùng chung bộ style TextField và Button của Login Screen (Vàng/Đen/Trắng).

## Logic & API States (Chuẩn bị cho Backend)

- Validate form: Khớp mật khẩu.
- Call API Register -> Báo thành công -> Điều hướng về trang Login.
