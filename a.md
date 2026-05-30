Tôi cần xây dựng một tính năng mới là một tính năng đăng ký gói.
User story: Là một người dùng Free tôi muốn nâng cấp trò của tài khoản lên.
Kế hoạch: 
Trong norumanga-server (là 1 project backend): 
1. Tôi cần thiết kế 1 entity bundle dùng để quản lý gói.
2. Thực hiện các tác vụ CRUD cho entity bundle.
3. Khi đã có 1 bundle cụ thể, tôi muốn làm chức năng payment cũng tương tự tôi cần entity để quản lý payment của người dùng.
4. Hiện tại tôi có 1 hình thức cho việc payment là momo.
5. Khi người payment thành công cho gói -> lưu lịch sử giao dịch -> Cập nhật vai trò của người.
6. Hiện tại tôi có 1 gói đăng ký theo tháng là Premium. Có thể thiết lập sẵn trong data init.
7. Ngoài ra cần thêm 1 số api cho việc quản lý gói và lịch sử giao dịch của người dùng. Đối với gói có thểm chỉnh sửa, nhưng lịch sử giao dịch người dùng thì chỉ READ only.

Khi hoàn tất backend hãy sang frontend và đáp ứng nhu cầu sau:
1. Tại frontend tại giao diện client đã có giao diện cho việc xem gói và thanh toán ở payment chỉ cần tích hợp call api để lấy thông tin gói và lưu giao dịch.
2. Ở giao diện dashboard sẽ có quản lý gói và xem lịch sử giao dịch của người dùng

Tôi cho phép bạn run hoặc tự động mà không cần tôi xét duyệt