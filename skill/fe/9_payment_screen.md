# Screen: Payment Screen (Method Selection & WebView)

## Cấu trúc UI (Layout)

- **Bước 1 (Chọn phương thức):** Modal Bottom Sheet hoặc màn hình nhỏ hiển thị 2 tùy chọn: MoMo và VNPay (Kèm logo).
- **Bước 2 (WebView):** Màn hình full sử dụng `webview_flutter`. Chứa URL redirect từ backend trả về.
- **Bước 3 (Kết quả):** Màn hình Success (Icon Check xanh lá/vàng, chúc mừng nâng cấp thành công) hoặc Failed (Icon X đỏ, thử lại).

## Màu sắc & Style (Theme)

- Đảm bảo logo MoMo (Hồng) và VNPay (Xanh/Đỏ) được hiển thị rõ ràng trên nền Trắng.
- Màn hình kết quả theo tone màu của hệ thống (Trắng nền, text Đen/Vàng).

## Logic & API States (Chuẩn bị cho Backend)

- Call API Create Payment -> Nhận URL -> Đẩy vào WebView.
- Lắng nghe URL change trong WebView: Nếu URL redirect về trang `yourdomain.com/payment-success` (Deep link/App link) thì tự động đóng WebView và show màn hình Thành công, call API reload lại Profile để cập nhật Role mới nhất.
