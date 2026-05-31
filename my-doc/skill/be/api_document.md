# API Documentation - Manga Reader Backend (prm-backend)

This document contains a comprehensive review of all controllers, endpoints, input/output schemas (JSON), and functionality within the `prm-backend` project.

---

## 1. Standard Response Envelope (BaseApiResponse)

Every API response follows a unified JSON format defined by `BaseApiResponse<T>`.

### Success Response Format
```json
{
  "data": { ... },
  "message": "Success message details",
  "error": null
}
```

### Error Response Format
```json
{
  "data": null,
  "message": "Error description details",
  "error": {
    "code": "ERROR_CODE_STRING",
    "details": [
      "Detail message 1",
      "Detail message 2"
    ]
  }
}
```

---

## 2. Authentication Controller (`AuthController`)
**Base Path:** `/api/v1/auth`

### 2.1 Register User
- **Method:** `POST`
- **Path:** `/register`
- **Auth Required:** No
- **Functionality:** Register a new customer/user account.
- **Input (JSON Request Body):**
  ```json
  {
    "fullName": "Nguyen Van A",
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "User registered successfully",
    "error": null
  }
  ```

### 2.2 Login User
- **Method:** `POST`
- **Path:** `/login`
- **Auth Required:** No
- **Functionality:** Log in with email and password to receive a JWT access token.
- **Input (JSON Request Body):**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Output (JSON Response):**
  ```json
  {
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
        "id": "60d5ec49f3e46c23b8f2d591",
        "fullName": "Nguyen Van A",
        "email": "user@example.com",
        "role": "Customer"
      }
    },
    "message": "Login successful",
    "error": null
  }
  ```

### 2.3 Forgot Password
- **Method:** `POST`
- **Path:** `/forgot-password`
- **Auth Required:** No
- **Functionality:** Requests a password reset link/token to be sent to the user's email.
- **Input (JSON Request Body):**
  ```json
  {
    "email": "user@example.com"
  }
  ```
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Reset token sent successfully",
    "error": null
  }
  ```

### 2.4 Reset Password
- **Method:** `POST`
- **Path:** `/reset-password`
- **Auth Required:** No
- **Functionality:** Resets password using the token sent via email.
- **Input (JSON Request Body):**
  ```json
  {
    "token": "reset-token-received-from-email",
    "newPassword": "newsecurepassword123"
  }
  ```
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Password has been reset successfully",
    "error": null
  }
  ```

### 2.5 Get Authenticated User Details (`/me`)
- **Method:** `GET`
- **Path:** `/me`
- **Auth Required:** Yes (Bearer Token via `Authorization` header)
- **Functionality:** Returns details of the currently logged-in user.
- **Input (Header):**
  `Authorization: Bearer <JWT_TOKEN>`
- **Output (JSON Response):**
  ```json
  {
    "data": {
      "id": "60d5ec49f3e46c23b8f2d591",
      "fullName": "Nguyen Van A",
      "email": "user@example.com",
      "role": "Customer"
    },
    "message": "Thành công",
    "error": null
  }
  ```

---

## 3. Manga Controller (`MangaController`)
**Base Path:** `/api/mangas`

### 3.1 Get Latest Manga Series
- **Method:** `GET`
- **Path:** `/latest`
- **Auth Required:** No
- **Functionality:** Returns the top 10 most recently updated manga series.
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "60d5ec49f3e46c23b8f2d601",
        "title": "One Piece",
        "slug": "one-piece",
        "description": "Luffy sets sail to find the One Piece...",
        "coverUrl": "https://example.com/one-piece.jpg",
        "bannerUrl": "https://example.com/one-piece-banner.jpg",
        "authors": ["auth-1"],
        "artists": ["art-1"],
        "genres": ["genre-1"],
        "tags": ["tag-1"],
        "status": "ONGOING",
        "publicationDemographic": "SHONEN",
        "contentRating": "SAFE",
        "releaseYear": 1997,
        "lastChapter": "Chapter 1115",
        "lastUpdatedAt": "2026-05-29T14:00:00Z",
        "viewCount": 500000,
        "favoriteCount": 15000,
        "isPremium": false,
        "licenseStatus": "LICENSED",
        "sourceName": "Shueisha",
        "officialUrl": "https://mangaplus.shueisha.co.jp/"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 3.2 Get Recommended Manga Series
- **Method:** `GET`
- **Path:** `/recommended`
- **Auth Required:** No
- **Functionality:** Returns the top 10 most viewed manga series.
- **Output (JSON Response):** Same format as `/latest`.

### 3.3 Get Manga by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** No
- **Functionality:** Get details of a single manga series by ID.
- **Output (JSON Response):** Returns a single `MangaResponseDTO` inside the envelope.

### 3.4 Get Manga by Slug
- **Method:** `GET`
- **Path:** `/slug/{slug}`
- **Auth Required:** No
- **Functionality:** Fetch a manga series by its URL-friendly slug (e.g. `one-piece`).
- **Output (JSON Response):** Returns a single `MangaResponseDTO` inside the envelope.

### 3.5 Search Manga
- **Method:** `GET`
- **Path:** `/search`
- **Query Params:**
  - `q` (string): Keyword query.
  - `page` (int, default = 0): Page index.
  - `size` (int, default = 20): Page size.
- **Auth Required:** No
- **Functionality:** Searches manga titles/slugs/descriptions.
- **Output (JSON Response):**
  ```json
  {
    "data": {
      "content": [
        { "id": "...", "title": "..." }
      ],
      "pageable": { ... },
      "totalElements": 1,
      "totalPages": 1,
      "last": true,
      "size": 20,
      "number": 0,
      "first": true,
      "numberOfElements": 1,
      "empty": false
    },
    "message": "Success",
    "error": null
  }
  ```

### 3.6 Filter Manga List
- **Method:** `GET`
- **Path:** `/`
- **Query Params:**
  - `genreId` (string, optional)
  - `tagId` (string, optional)
  - `status` (MangaStatus Enum, optional)
  - `licenseStatus` (LicenseStatus Enum, optional)
  - `page` (int, default = 0)
  - `size` (int, default = 20)
- **Auth Required:** No
- **Functionality:** Query manga list filtered dynamically by genre, tags, status, and/or license status.
- **Output (JSON Response):** Returns Spring `Page<MangaResponseDTO>` format (same as Search).

### 3.7 Create Manga Series
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Creates a new manga series entry.
- **Input (JSON Request Body):**
  ```json
  {
    "title": "My Hero Academia",
    "slug": "my-hero-academia",
    "originalTitle": "僕のヒーローアカデミア",
    "alternativeTitles": ["Boku no Hero Academia"],
    "description": "In a world where superpowers are common...",
    "coverUrl": "https://example.com/mha-cover.jpg",
    "bannerUrl": "https://example.com/mha-banner.jpg",
    "authorIds": ["auth-1"],
    "artistIds": ["art-1"],
    "genreIds": ["genre-1"],
    "tagIds": ["tag-1"],
    "originalLanguage": "ja",
    "status": "ONGOING",
    "publicationDemographic": "SHONEN",
    "contentRating": "SAFE",
    "releaseYear": 2014,
    "isPremium": false,
    "licenseStatus": "LICENSED",
    "sourceName": "Shueisha",
    "officialUrl": "https://mangaplus.shueisha.co.jp/"
  }
  ```
- **Output (JSON Response):** Returns the created `MangaResponseDTO` object.

### 3.8 Update Manga Series
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Updates manga details.
- **Input (JSON Request Body):** Same format as Create Manga.
- **Output (JSON Response):** Returns the updated `MangaResponseDTO` object.

### 3.9 Delete Manga Series
- **Method:** `DELETE`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin role only required)
- **Functionality:** Deletes a manga series entry by ID.
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Manga deleted",
    "error": null
  }
  ```

---

## 4. Chapter Controller (`ChapterController` & `MangaChapterController`)

### 4.1 Get Chapter by ID (Flat Endpoint)
- **Method:** `GET`
- **Path:** `/api/chapters/{id}`
- **Auth Required:** No
- **Functionality:** Get full details of a specific chapter including its ordered list of pages.
- **Output (JSON Response):**
  ```json
  {
    "data": {
      "id": "chapter-1-id",
      "mangaId": "manga-1-id",
      "volumeNumber": 1,
      "chapterNumber": 1.0,
      "title": "Romance Dawn",
      "language": "en",
      "sourceType": "INTERNAL",
      "isPremium": false,
      "pageCount": 3,
      "publishedAt": "2026-05-29T14:00:00Z",
      "pages": [
        {
          "pageIndex": 0,
          "imageUrl": "https://example.com/p1.jpg",
          "width": 1080,
          "height": 1920,
          "contentText": "Once upon a time..."
        },
        {
          "pageIndex": 1,
          "imageUrl": "https://example.com/p2.jpg",
          "width": 1080,
          "height": 1920,
          "contentText": ""
        }
      ]
    },
    "message": "Success",
    "error": null
  }
  ```

### 4.2 Get Chapters by Manga (Nested Endpoint)
- **Method:** `GET`
- **Path:** `/api/mangas/{mangaId}/chapters`
- **Auth Required:** No
- **Functionality:** Lists all chapters belonging to a specific manga series ordered by chapter number ascending.
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "chapter-1-id",
        "mangaId": "manga-1-id",
        "volumeNumber": 1,
        "chapterNumber": 1.0,
        "title": "Romance Dawn",
        "language": "en",
        "sourceType": "INTERNAL",
        "isPremium": false,
        "pageCount": 52,
        "publishedAt": "2026-05-29T14:00:00Z"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 4.3 Get Paginated Chapters by Manga
- **Method:** `GET`
- **Path:** `/api/mangas/{mangaId}/chapters/paged`
- **Query Params:**
  - `page` (int, default = 0)
  - `size` (int, default = 50)
- **Auth Required:** No
- **Functionality:** Returns paginated chapter lists.
- **Output (JSON Response):** Spring `Page<ChapterResponseDTO>` format.

### 4.4 Get Specific Chapter by Number & Language
- **Method:** `GET`
- **Path:** `/api/mangas/{mangaId}/chapters/number/{chapterNumber}`
- **Query Params:**
  - `lang` (string, default = "en"): ISO language code.
- **Auth Required:** No
- **Functionality:** Returns the full chapter detail containing pages for a specific chapter number.
- **Output (JSON Response):** Same format as `GET /api/chapters/{id}` (`ChapterDetailResponseDTO`).

### 4.5 Create Manga Chapter
- **Method:** `POST`
- **Path:** `/api/mangas/{mangaId}/chapters`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Upload/Create a new chapter inside a manga series.
- **Input (JSON Request Body):**
  ```json
  {
    "volumeNumber": 1,
    "chapterNumber": 2.0,
    "title": "The Man in the Straw Hat",
    "language": "en",
    "sourceType": "INTERNAL",
    "isPremium": false,
    "pages": [
      {
        "pageIndex": 0,
        "imageUrl": "https://example.com/p1.jpg",
        "width": 1080,
        "height": 1920,
        "contentText": "..."
      }
    ],
    "publishedAt": "2026-05-29T14:00:00Z"
  }
  ```
- **Output (JSON Response):** Returns the created `ChapterDetailResponseDTO`.

### 4.6 Update Manga Chapter
- **Method:** `PUT`
- **Path:** `/api/mangas/{mangaId}/chapters/{chapterId}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Updates chapter contents or pages.
- **Input (JSON Request Body):** Same format as Create Chapter.
- **Output (JSON Response):** Returns updated `ChapterDetailResponseDTO`.

### 4.7 Delete Manga Chapter
- **Method:** `DELETE`
- **Path:** `/api/mangas/{mangaId}/chapters/{chapterId}`
- **Auth Required:** Yes (Admin role only required)
- **Functionality:** Deletes a chapter.
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Chapter deleted",
    "error": null
  }
  ```

---

## 5. Creator Controller (`CreatorController`)
**Base Path:** `/api/creators`

### 5.1 Get All Creators (or Search)
- **Method:** `GET`
- **Path:** `/`
- **Query Params:**
  - `name` (string, optional): Search by name.
  - `page` (int, default = 0, used if searching)
  - `size` (int, default = 20, used if searching)
- **Auth Required:** No
- **Functionality:** Get all creators, or page-search them if a `name` query parameter is provided.
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "creator-1-id",
        "name": "Eiichiro Oda",
        "slug": "eiichiro-oda",
        "originalName": "尾田 栄一郎",
        "avatarUrl": "https://example.com/oda-avatar.jpg"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 5.2 Get Creator by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** No
- **Functionality:** Fetches creator details by ID.
- **Output (JSON Response):** Returns single `CreatorResponseDTO` inside the envelope.

### 5.3 Create Creator
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Creates a new author/artist creator.
- **Input (JSON Request Body):**
  ```json
  {
    "name": "Eiichiro Oda",
    "slug": "eiichiro-oda",
    "originalName": "尾田 栄一郎",
    "biography": "Born on January 1, 1975...",
    "avatarUrl": "https://example.com/oda-avatar.jpg"
  }
  ```
- **Output (JSON Response):** Returns the created `CreatorResponseDTO`.

### 5.4 Update Creator
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Updates creator details.
- **Input (JSON Request Body):** Same format as Create Creator.
- **Output (JSON Response):** Returns updated `CreatorResponseDTO`.

### 5.5 Delete Creator
- **Method:** `DELETE`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Functionality:** Deletes a creator.
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Creator deleted",
    "error": null
  }
  ```

---

## 6. Genre Controller (`GenreController`)
**Base Path:** `/api/genres`

### 6.1 Get All Genres
- **Method:** `GET`
- **Path:** `/`
- **Auth Required:** No
- **Functionality:** Get the list of all genres.
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "genre-1-id",
        "name": "Action",
        "slug": "action"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 6.2 Get Genre by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** No
- **Output (JSON Response):** Returns single `GenreResponseDTO` inside the envelope.

### 6.3 Create Genre
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Input (JSON Request Body):**
  ```json
  {
    "name": "Action",
    "slug": "action"
  }
  ```
- **Output (JSON Response):** Returns created `GenreResponseDTO`.

### 6.4 Update Genre
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Input (JSON Request Body):** Same format as Create Genre.
- **Output (JSON Response):** Returns updated `GenreResponseDTO`.

### 6.5 Delete Genre
- **Method:** `DELETE`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Genre deleted",
    "error": null
  }
  ```

---

## 7. Tag Controller (`TagController`)
**Base Path:** `/api/tags`

### 7.1 Get All Tags
- **Method:** `GET`
- **Path:** `/`
- **Query Params:**
  - `group` (TagGroup Enum, optional): Filter tags by group (e.g. `THEME`, `GENRE`, `FORMAT`).
- **Auth Required:** No
- **Functionality:** Returns tags list (optionally filtered by tag group).
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "tag-1-id",
        "name": "Ninja",
        "slug": "ninja",
        "group": "THEME"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 7.2 Get Tag by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** No
- **Output (JSON Response):** Returns single `TagResponseDTO` inside the envelope.

### 7.3 Create Tag
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Input (JSON Request Body):**
  ```json
  {
    "name": "Ninja",
    "slug": "ninja",
    "group": "THEME"
  }
  ```
- **Output (JSON Response):** Returns created `TagResponseDTO`.

### 7.4 Update Tag
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Input (JSON Request Body):** Same format as Create Tag.
- **Output (JSON Response):** Returns updated `TagResponseDTO`.

### 7.5 Delete Tag
- **Method:** `DELETE`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager roles required)
- **Output (JSON Response):**
  ```json
  {
    "data": null,
    "message": "Tag deleted",
    "error": null
  }
  ```

---

## 8. Enum Types Specification

### MangaStatus
- `ONGOING`
- `COMPLETED`
- `HIATUS`
- `CANCELLED`

### LicenseStatus
- `UNLICENSED`
- `LICENSED`
- `EXTERNAL_LINK_ONLY`

### PublicationDemographic
- `SHONEN`
- `SHOJO`
- `SEINEN`
- `JOSEI`

### ContentRating
- `SAFE`
- `SUGGESTIVE`
- `EROTICA`
- `PORNOGRAPHIC`

### ChapterSourceType
- `INTERNAL`
- `EXTERNAL`

### TagGroup
- `THEME`
- `GENRE`
- `FORMAT`

### BillingCycle
- `MONTHLY` (30 days)
- `QUARTERLY` (90 days)
- `YEARLY` (365 days)

### PaymentMethod
- `MOMO`

### PaymentStatus
- `PENDING`
- `SUCCESS`
- `FAILED`

---

## 9. Bundle Controller (`BundleController`)
**Base Path:** `/api/bundles`

A bundle is a subscription package a user can purchase to upgrade their account
role (e.g. "Premium 1 Tháng"). Price is in VND (integer, no decimals).

### 9.1 Get Bundles
- **Method:** `GET`
- **Path:** `/`
- **Query Params:**
  - `all` (boolean, default = false): when `true`, returns all bundles
    (admin view, includes inactive). Default returns active bundles only.
- **Auth Required:** No (public read)
- **Output (JSON Response):**
  ```json
  {
    "data": [
      {
        "id": "bundle-1-id",
        "name": "Premium 1 Tháng",
        "description": "Truy cập không giới hạn...",
        "price": 49000,
        "billingCycle": "MONTHLY",
        "durationDays": 30,
        "roleName": "Premium",
        "features": ["Không quảng cáo", "Đọc chương mới trước 7 ngày"],
        "active": true,
        "createdAt": "2026-05-30T18:08:55.289Z",
        "updatedAt": "2026-05-30T18:08:55.289Z"
      }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 9.2 Get Bundle by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** No
- **Output:** Single `BundleResponseDTO` inside the envelope.

### 9.3 Create Bundle
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager)
- **Input (JSON Request Body):**
  ```json
  {
    "name": "Premium 3 Tháng",
    "description": "Tiết kiệm hơn với gói quý",
    "price": 129000,
    "billingCycle": "QUARTERLY",
    "roleName": "Premium",
    "features": ["Không quảng cáo", "Tải offline"],
    "active": true
  }
  ```
- **Output:** Created `BundleResponseDTO`.

### 9.4 Update Bundle
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager)
- **Input:** Same format as Create Bundle.
- **Output:** Updated `BundleResponseDTO`.

### 9.5 Delete Bundle
- **Method:** `DELETE`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager)
- **Output:** `{ "data": null, "message": "Bundle deleted", "error": null }`

---

## 10. Payment Controller (`PaymentController`)
**Base Path:** `/api/payments`

Records subscription purchases. On a successful payment the transaction is
persisted (the user's transaction history) and the user's role is upgraded to
the bundle's `roleName`. Currently only MoMo is supported and is treated as
immediately successful.

### 10.1 Purchase a Bundle
- **Method:** `POST`
- **Path:** `/`
- **Auth Required:** Yes (any authenticated user)
- **Input (JSON Request Body):**
  ```json
  {
    "bundleId": "bundle-1-id",
    "method": "MOMO",
    "transactionRef": "optional-external-ref"
  }
  ```
- **Functionality:** Creates a SUCCESS payment, saves it to history, and
  upgrades the caller's role to the bundle's `roleName`.
- **Output (JSON Response):**
  ```json
  {
    "data": {
      "id": "payment-1-id",
      "accountId": "account-1-id",
      "bundleId": "bundle-1-id",
      "bundleName": "Premium 1 Tháng",
      "amount": 49000,
      "method": "MOMO",
      "status": "SUCCESS",
      "transactionRef": "MOMO-1780164684687",
      "expiresAt": "2026-06-29T18:11:24.687Z",
      "createdAt": "2026-05-30T18:11:24.687Z",
      "updatedAt": "2026-05-30T18:11:24.687Z"
    },
    "message": "Thanh toán thành công",
    "error": null
  }
  ```

### 10.2 My Transaction History
- **Method:** `GET`
- **Path:** `/me`
- **Auth Required:** Yes (any authenticated user)
- **Functionality:** Returns the caller's transactions, newest first (READ-only).
- **Output:** `List<PaymentResponseDTO>` inside the envelope.

### 10.3 All Transactions (Admin)
- **Method:** `GET`
- **Path:** `/`
- **Query Params:** `page` (default 0), `size` (default 20)
- **Auth Required:** Yes (Admin or Manager)
- **Functionality:** READ-only paginated list of all transactions.
- **Output:** Spring `Page<PaymentResponseDTO>` inside the envelope.

### 10.4 Transactions by Account (Admin)
- **Method:** `GET`
- **Path:** `/account/{accountId}`
- **Query Params:** `page` (default 0), `size` (default 20)
- **Auth Required:** Yes (Admin or Manager)
- **Output:** Spring `Page<PaymentResponseDTO>` inside the envelope.


---

## 11. Role Controller (`RoleController`)
**Base Path:** `/api/roles`

Read-only role endpoints for the admin dashboard. No create/update/delete.

### 11.1 Get All Roles
- **Method:** `GET`
- **Path:** `/`
- **Auth Required:** Yes (Admin or Manager)
- **Output (JSON Response):**
  ```json
  {
    "data": [
      { "id": "role-1-id", "name": "Free", "description": "Free User" },
      { "id": "role-2-id", "name": "Premium", "description": "Premium User" }
    ],
    "message": "Success",
    "error": null
  }
  ```

### 11.2 Get Role by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager)
- **Output:** Single `RoleResponseDTO` inside the envelope.

---

## 12. User Controller (`UserController`)
**Base Path:** `/api/users`

Admin user management — view, view detail, and update. User creation and
deletion are intentionally NOT exposed.

### 12.1 Get Users (paginated)
- **Method:** `GET`
- **Path:** `/`
- **Query Params:**
  - `keyword` (string, optional): filter by full name or email (case-insensitive).
  - `roleId` (string, optional): filter by role id.
  - `page` (int, default = 0)
  - `size` (int, default = 20)
- **Auth Required:** Yes (Admin or Manager)
- **Output:** Spring `Page<UserDetailResponseDTO>` inside the envelope:
  ```json
  {
    "data": {
      "content": [
        {
          "id": "account-1-id",
          "fullName": "Nguyen Van A",
          "email": "a@example.com",
          "status": "ACTIVE",
          "roleId": "role-1-id",
          "roleName": "Free",
          "createdAt": "2026-05-30T16:12:32.004",
          "updatedAt": "2026-05-31T01:23:05.634"
        }
      ],
      "totalElements": 5,
      "totalPages": 1,
      "number": 0,
      "size": 20,
      "first": true,
      "last": true,
      "numberOfElements": 1,
      "empty": false
    },
    "message": "Success",
    "error": null
  }
  ```

### 12.2 Get User by ID
- **Method:** `GET`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager)
- **Output:** Single `UserDetailResponseDTO` inside the envelope.

### 12.3 Update User
- **Method:** `PUT`
- **Path:** `/{id}`
- **Auth Required:** Yes (Admin or Manager)
- **Functionality:** Updates editable fields. All fields optional — only
  non-null values are applied. `roleId` takes precedence over `roleName`.
- **Input (JSON Request Body):**
  ```json
  {
    "fullName": "Updated Name",
    "roleId": "role-2-id",
    "roleName": "Premium",
    "status": "ACTIVE"
  }
  ```
- **Output:** Updated `UserDetailResponseDTO`.
