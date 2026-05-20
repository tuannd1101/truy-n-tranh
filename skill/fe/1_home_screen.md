# Screen: Home Screen

## Cấu trúc UI (Layout)

- **AppBar:** Màu trắng, không có bóng đổ (elevation: 0). Chứa Logo app bên trái, icon Search và icon Profile bên phải (màu đen).
- **Body:** Sử dụng `SingleChildScrollView` chứa các phần:
  1. **Banner Carousel:** Hiển thị 3-5 truyện Hot. Có PageIndicator bên dưới (chấm vàng cho trang hiện tại, xám cho trang khác).
  2. **Section "Truyện Mới Cập Nhật":** Dạng cuộn ngang (`ListView.builder` horizontal). Mỗi item gồm Ảnh bìa (bo góc 8px), Tên truyện (tối đa 2 dòng, overflow: ellipsis), và Tag [Free] màu xanh lá hoặc [Premium] màu Vàng (#FFC107).
  3. **Section "Đề Cử Cho Bạn":** Dạng lưới (`GridView.builder`).
- **BottomNavigationBar:** 3 tabs (Home, Thư viện, Profile). Tab đang chọn có màu Vàng (#FFC107), tab không chọn màu Xám (#212529).

## Màu sắc & Style (Theme)

- Background: Trắng sữa (#F8F9FA).
- Text: Đen (#1A1A1A) cho tiêu đề, Xám (#6C757D) cho mô tả/tác giả.
- Nút bấm/Tag nổi bật: Vàng mật ong (#FFC107).

## Logic & API States (Chuẩn bị cho Backend)

- Hiển thị `CircularProgressIndicator` màu Vàng khi đang fetch API list truyện.
- Có pull-to-refresh để gọi lại API reload trang chủ.
