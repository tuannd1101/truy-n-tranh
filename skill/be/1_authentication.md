# Backend Skill: Authentication

This document outlines the required backend API logic for User Authentication, specifically designed to match the Flutter frontend logic and data models.

## 1. Data Model Requirements

### User Entity (Database)
The backend database should store the following fields to match the frontend `User` model:
- `id` (UUID or String, Primary Key)
- `email` (String, Unique, Not Null)
- `password_hash` (String, Not Null)
- `roleId`: String (Reference to Role)
- `status`: String ("ACTIVE", "INACTIVE", "BANNED")
- `createdAt`: LocalDateTime
- `updatedAt`: LocalDateTime
- `reset_password_token` (String, Nullable)
- `reset_password_expires_at` (Timestamp, Nullable)

## 2. API Endpoints

### 2.1. Register Account
**Endpoint:** `POST /api/v1/auth/register`

**Request Body:**
```json
{
  "full_name": "Nguyen Van A",
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Business Logic:**
1. **Validate input:** Check if `email` is in valid format, `password` meets strength requirements (e.g., min 6 chars), and `full_name` is not empty.
2. **Check duplicate:** Ensure `email` does not already exist in the database. Return `409 Conflict` if it does.
3. **Hash password:** Hash the incoming `password` securely (e.g., using BCrypt or Argon2).
4. **Create user:** Insert the new user into the database with default role `Free`.
5. **Return Response:** Optionally return a JWT token for auto-login, or simply a success message requiring manual login.

**Success Response (201 Created):**
```json
{
  "message": "Registration successful.",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "full_name": "Nguyen Van A",
    "role": "Free",
    "created_at": "2026-05-27T12:00:00Z"
  }
}
```

### 2.2. Login
**Endpoint:** `POST /api/v1/auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Business Logic:**
1. **Validate input:** Ensure both `email` and `password` fields are provided.
2. **Find user:** Look up the user by `email`. If not found, return `401 Unauthorized`.
3. **Verify password:** Compare the provided `password` with the stored `password_hash`. If mismatch, return `401 Unauthorized`.
4. **Generate Token:** Create a JWT token containing at least `id` and `role` in the payload.
5. **Return Response:** Return the token and user info.

**Success Response (200 OK):**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "full_name": "Nguyen Van A",
    "avatar_url": null,
    "role": "Free",
    "created_at": "2026-05-27T12:00:00Z"
  }
}
```

### 2.3. Forgot Password
**Endpoint:** `POST /api/v1/auth/forgot-password`

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Business Logic:**
1. **Validate input:** Check email format.
2. **Find user:** Look up user by email. (Best practice: always return a success message even if the user is not found to prevent email enumeration attacks).
3. **Generate Reset Token:** Create a unique, cryptographically secure token (e.g., valid for 15-30 minutes). Save this token and its expiration time to the user's record in the database.
4. **Send Email:** Send an email containing a link with the reset token (e.g., `https://your-domain.com/reset-password?token=XYZ`).

**Success Response (200 OK):**
```json
{
  "message": "If an account with that email exists, a password reset link has been sent."
}
```

### 2.4. Reset Password
**Endpoint:** `POST /api/v1/auth/reset-password`

**Request Body:**
```json
{
  "token": "reset_token_received_in_email",
  "new_password": "new_secure_password"
}
```

**Business Logic:**
1. **Validate input:** Ensure token and new password are provided and new password meets strength requirements.
2. **Find Token:** Look up the user by `reset_password_token`. If not found, return `400 Bad Request`.
3. **Check Expiration:** Verify that `reset_password_expires_at` is in the future. If expired, return `400 Bad Request`.
4. **Update Password:** Hash `new_password` and update the user's `password_hash` in the database.
5. **Clear Token:** Nullify `reset_password_token` and `reset_password_expires_at` so the token cannot be reused.

**Success Response (200 OK):**
```json
{
  "message": "Password has been successfully reset."
}
```

### 2.5. Get Current User (Me)
**Endpoint:** `GET /api/v1/auth/me`

**Headers:**
`Authorization: Bearer <token>`

**Business Logic:**
1. **Verify Token:** Check the JWT token for validity and expiration (usually done via Auth Middleware).
2. **Extract ID:** Get the user ID from the token payload.
3. **Fetch User:** Retrieve user details from the database.

**Success Response (200 OK):**
Return the `User` object (matches Login response's `user` field).

## 3. Context Entities (MongoDB)

Hệ thống sử dụng **MongoDB** nên các Entity sẽ được biểu diễn dưới dạng **Document**.

### 3.1. Role Collection (`roles`)
Lưu trữ các quyền trong hệ thống.
- `_id`: String (ObjectId)
- `name`: String (e.g. "Free", "Premium", "Admin")
- `description`: String

### 3.2. Account Collection (`accounts`)
Lưu trữ thông tin xác thực của người dùng.
- `_id`: String (ObjectId)
- `email`: String (Unique, Indexed)
- `password`: String (Hashed)
- `fullName`: String
- `roleId`: String (Reference to Role)
- `status`: String ("ACTIVE", "INACTIVE", "BANNED")
- `createdAt`: LocalDateTime
- `updatedAt`: LocalDateTime
