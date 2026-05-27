# Báo Cáo Cấu Trúc Backend & API Documentation

Tài liệu này cung cấp thông tin về kiến trúc backend vừa được thiết lập và chuẩn hóa, phục vụ cho Frontend tích hợp dễ dàng hơn.

## 1. Kiến Trúc Backend (3N Layer)
Dự án được cấu trúc theo chuẩn mô hình 3 lớp (3-tier architecture):
- **Controller** (`prm.prmbackend.controller`): Tiếp nhận request từ Mobile/Web, gọi Service và trả về `BaseApiResponse`.
- **Service** (`prm.prmbackend.service`): Chứa logic nghiệp vụ (business logic).
- **Repository**: Chứa các Interface giao tiếp với cơ sở dữ liệu (PostgreSQL).
- **Config & Exception**: Chứa cấu hình Security, cấu hình Redis và xử lý lỗi tập trung.

## 2. Base API Response
Mọi API trong hệ thống đều sẽ trả về chung một định dạng chuẩn thông qua class `BaseApiResponse<T>`.

**Cấu trúc JSON:**
```json
{
  "timestamp": "2026-05-27T16:34:00Z",
  "message": "Success",
  "data": { ... },       // Thay đổi tùy theo API, null nếu có lỗi
  "errors": { ... }      // Chứa chi tiết lỗi (ví dụ: validation), null nếu thành công
}
```

## 3. Quản lý Lỗi Tập Trung (Global Exception Handler)
Thay vì trả về Stack Trace khó đọc, backend sẽ tự động bắt các lỗi và trả về mã lỗi (`ErrorCode`) thống nhất.

**Ví dụ khi có lỗi Validation (Truyền thiếu trường):**
```json
{
  "timestamp": "2026-05-27T16:35:00Z",
  "message": "Validation failed",
  "data": null,
  "errors": {
    "email": "Invalid email format",
    "password": "Password must be at least 6 characters"
  }
}
```

## 4. Các API Hiện Tại

### 4.1. Đăng ký tài khoản (Local)
- **Method:** `POST`
- **Endpoint:** `/api/v1/auth/register`
- **Description:** Đăng ký tài khoản mới bằng Full Name, Email và Password.
- **Request Body:**
```json
{
  "fullName": "Nguyen Van A",
  "email": "user@example.com",
  "password": "securepassword123"
}
```
- **Response (201 Created):**
```json
{
  "timestamp": "2026-05-27T16:36:00Z",
  "message": "User registered successfully",
  "data": null,
  "errors": null
}
```

### 4.2. Đăng nhập (Local)
- **Method:** `POST`
- **Endpoint:** `/api/v1/auth/login`
- **Description:** Đăng nhập lấy JWT Token.
- **Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```
- **Response (200 OK):**
```json
{
  "timestamp": "2026-05-27T16:35:00Z",
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token.12345",
    "user": {
      "id": "1",
      "fullName": "Nguyen Van A",
      "email": "user@example.com",
      "role": "Free"
    }
  },
  "errors": null
}
```

### 4.3. Quên mật khẩu
- **Method:** `POST`
- **Endpoint:** `/api/v1/auth/forgot-password`
- **Description:** Gửi yêu cầu lấy lại mật khẩu (Mock sẽ không gửi email thật mà chỉ báo thành công).
- **Request Body:**
```json
{
  "email": "user@example.com"
}
```
- **Response (200 OK):**
```json
{
  "timestamp": "2026-05-27T16:35:00Z",
  "message": "Password reset instructions have been sent to your email",
  "data": null,
  "errors": null
}
```

### 4.4. Đặt lại mật khẩu
- **Method:** `POST`
- **Endpoint:** `/api/v1/auth/reset-password`
- **Description:** Đặt lại mật khẩu dựa trên OTP / Token.
- **Request Body:**
```json
{
  "token": "123456",
  "newPassword": "newsecurepassword123"
}
```
- **Response (200 OK):**
```json
{
  "timestamp": "2026-05-27T16:35:00Z",
  "message": "Password has been reset successfully",
  "data": null,
  "errors": null
}
```

### 4.5. Lấy thông tin cá nhân (Get Me)
- **Method:** `GET`
- **Endpoint:** `/api/v1/auth/me`
- **Description:** Lấy thông tin của user hiện tại (Dùng token, Mock cứng ID = 1).
- **Headers:** `Authorization: Bearer <token>`
- **Response (200 OK):**
```json
{
  "timestamp": "2026-05-27T16:35:00Z",
  "message": "Success",
  "data": {
    "id": "1",
    "fullName": "Nguyen Van A",
    "email": "user@example.com",
    "role": "free"
  },
  "errors": null
}
```

## 5. Các cấu hình thư viện đã thêm
- **Spring Data Redis**: Để quản lý Token và OTP.
- **PostgreSQL Driver**: Kết nối cơ sở dữ liệu.
- **JJWT**: Phục vụ cho sinh và mã hóa/giải mã JWT.
- **Spring Security**: Bảo mật API, thiết lập tạm thời cho phép public tất cả API bắt đầu bằng `/api/v1/auth/**`.
