# Screen: Settings Screen (Cài đặt)

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, nút Back bên trái, tiêu đề "Cài đặt".
- **Body:** Sử dụng `ListView` với các section:

### 1. **Section: Hiển thị**

- **Chế độ tối (Dark Mode):** Switch toggle.
- **Ngôn ngữ:** ListTile với trailing "Tiếng Việt >", tap để chọn ngôn ngữ.

### 2. **Section: Đọc truyện**

- **Chế độ đọc mặc định:** Radio buttons (Vertical / Horizontal).
- **Tự động chuyển chapter:** Switch toggle.
- **Chất lượng ảnh:** Dropdown (Thấp / Trung bình / Cao / Tự động).

### 3. **Section: Thông báo**

- **Thông báo chapter mới:** Switch toggle.
- **Thông báo khuyến mãi:** Switch toggle.

### 4. **Section: Tài khoản**

- **Đổi mật khẩu:** ListTile với icon key, tap để mở form đổi mật khẩu.
- **Xóa tài khoản:** ListTile với text màu đỏ, tap để hiện confirm dialog.

### 5. **Section: Khác**

- **Điều khoản sử dụng:** ListTile với icon document.
- **Chính sách bảo mật:** ListTile với icon shield.
- **Liên hệ hỗ trợ:** ListTile với icon email.
- **Đánh giá ứng dụng:** ListTile với icon star.
- **Phiên bản:** ListTile với trailing "v1.0.0" (không tap được).

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Section header: Text xám đậm (#6C757D), uppercase, font size 12px, padding 16px.
- ListTile: Nền trắng, có divider xám nhạt.
- Switch active: Màu Vàng (#FFC107).
- Text nguy hiểm (Xóa tài khoản): Màu đỏ (#DC3545).

## Logic & API States (Chuẩn bị cho Backend)

- Lưu settings vào Local Storage (SharedPreferences).
- Sync một số settings với server (notification preferences, reading mode).
- Dark mode: Thay đổi theme của app toàn cục.
- Ngôn ngữ: Sử dụng i18n/localization package.
- Đổi mật khẩu: Gọi API với old_password và new_password.
- Xóa tài khoản: Hiện dialog confirm 2 lần, sau đó gọi API DELETE và logout.
- Đánh giá app: Mở link đến App Store/Play Store.
