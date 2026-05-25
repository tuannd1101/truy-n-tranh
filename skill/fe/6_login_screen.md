# Screen: Login Screen

## Cấu trúc UI (Layout)

- Căn giữa màn hình.
- **Logo:** Hình ảnh logo app.
- **Form:** - `TextFormField` Email (Icon prefix: Mail).
  - `TextFormField` Password (Icon prefix: Lock, Icon suffix: Mắt ẩn/hiện mật khẩu).
  - Nút "Quên mật khẩu?" căn phải.
- **Action:** Nút "Đăng Nhập" full width. Bên dưới là TextSpan "Chưa có tài khoản? Đăng ký ngay".

## Màu sắc & Style (Theme)

- Background: Trắng.
- TextField: OutlineInputBorder màu xám nhạt (#CED4DA), khi focus đổi thành màu Đen.
- Nút "Đăng Nhập": Nền Vàng (#FFC107), chữ Đen, cao 50px, bo góc 12px.

## Logic & API States (Chuẩn bị cho Backend)

- Validate form: Email đúng định dạng, Password không được rỗng.
- Hiển thị Dialog loading khi đang call API Login, thông báo lỗi nếu sai tài khoản.
