Tôi cần nâng cấp và sửa giao diện:
A. Tại trang client:
1. Cải tiến hình ảnh cho logo đổi tên trang web thành NoruManga
2. Tại thanh navbar: xóa bỏ đi nút "Thư viện" và bỏ đi các source code liên quan đến screen Thư viện.
3. Tại thanh navbar: xóa bỏ đi nút "Cài đặt" và bỏ đi các source code liên quan đến screen Cài đặt.
4. Tại thanh navbar: thêm 1 nút "Đăng xuất" và thực thi logic cho việc Đăng xuất.
5. Trong screen "Tài khoản" gọi API từ backend để lấy thông tin profile, api đó có url là /api/v1/auth/me trong AuthController.java. Cập nhật các field thông tin và hiện lên screen. Xóa bỏ đi toàn div "Attribute", xóa đi div "Completed Arcs". Xóa bỏ đi phần "Cài đặt" trong screen này.
6. Ngoài ra tôi cần có thêm những tính năng này: Lưu truyện yêu thích, Xem lại lịch sử đọc, Xem thời gian Premium còn lại. Đối
với Lưu truyện yêu thích, Xem lại lịch sử đọc sẽ được tích hợp tại thanh navbar và cả trong screen Tài khoản, Xem thời gian Premium còn lại sẽ chỉ xem trong screen "Tài khoản"

B. Tại trang dashboard:
1. Tại thanh navbar: xóa bỏ đi nút "Content" và bỏ đi các source code liên quan đến screen Content.
2. Tại thanh navbar: xóa bỏ đi nút "Setting" và bỏ đi các source code liên quan đến screen Setting.
3. Tại thanh navbar: thêm nút "Logout" và thêm logic cho việc Logout.