# 🚀 Hướng dẫn Deploy NoruManga chạy 24/7

Tài liệu này hướng dẫn đưa app lên cloud để đọc truyện **mọi lúc, mọi nơi** (kể cả khi máy tính của bạn tắt).

## Tổng quan kiến trúc sau khi deploy

```
Điện thoại / Máy tính (bất cứ đâu, qua Internet)
        │
        ├──> Frontend (Flutter Web)  →  Netlify     (link: https://norumanga.netlify.app)
        │
        └──> Backend (Spring Boot)   →  Render       (link: https://norumanga-api.onrender.com)
                     │
                     └──> Database  →  MongoDB Atlas  (đã có sẵn trên cloud)
```

Cả 3 thành phần đều chạy trên cloud 24/7. Máy bạn tắt vẫn hoạt động bình thường.

---

## ⚙️ CHUẨN BỊ (làm 1 lần)

### 1. Tài khoản cần có (đều miễn phí)

- [GitHub](https://github.com) — đã có (repo `minkoi0408/SU26-PRM393-Client`)
- [Render](https://render.com) — đăng ký bằng GitHub
- [Netlify](https://netlify.com) — đăng ký bằng GitHub

### 2. Đẩy code mới nhất lên GitHub

Các file deploy (Dockerfile, netlify.toml, ...) tôi đã tạo sẵn. Đẩy lên GitHub:

```bash
cd c:\Users\tuann\OneDrive\Desktop\prm\SU26-PRM393-Latest
git add .
git commit -m "Add deployment config for Render + Netlify"
git push origin main
```

---

## 🟢 PHẦN 1: Deploy Backend lên Render

### Bước 1 — Tạo Web Service

1. Vào https://dashboard.render.com → bấm **New +** → **Web Service**
2. Chọn **Build and deploy from a Git repository** → **Connect** repo `SU26-PRM393-Client`
3. Điền cấu hình:
   - **Name**: `norumanga-api` (tùy ý)
   - **Region**: Singapore (gần VN nhất)
   - **Branch**: `main`
   - **Root Directory**: `norumanga-server` ← QUAN TRỌNG
   - **Runtime**: `Docker` (Render tự nhận Dockerfile)
   - **Instance Type**: `Free`

### Bước 2 — Thêm biến môi trường (Environment Variables)

Ở phần **Environment**, bấm **Add Environment Variable** và thêm từng cái:

| Key                     | Value                                                                                                                  |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `MONGODB_URI`           | `mongodb+srv://hoannaa2011_db_user:02oU9OWEkGnIbpWC@prmcluster.myrtdxw.mongodb.net/prm_db?retryWrites=true&w=majority` |
| `JWT_SECRET`            | `bXktc3Ryb25nLXNlY3JldC1rZXktdGhhdC1tdXN0LWJlLWF0LWxlYXN0LTMyLWJ5dGVzLWxvbmc=`                                         |
| `CLOUDINARY_CLOUD_NAME` | `dijsfwqpj`                                                                                                            |
| `CLOUDINARY_API_KEY`    | `399639869693333`                                                                                                      |
| `CLOUDINARY_API_SECRET` | `4bk2ISxSEyP7PjJfTexoU2DWNVo`                                                                                          |

> 🔐 **Bảo mật**: Khi đã deploy ổn, nên đổi các mật khẩu/secret này (xem mục Bảo mật cuối tài liệu) vì chúng đang nằm trong lịch sử Git.

### Bước 3 — Cho phép MongoDB Atlas nhận kết nối từ Render

1. Vào https://cloud.mongodb.com → **Network Access**
2. Bấm **Add IP Address** → **Allow Access from Anywhere** (`0.0.0.0/0`) → **Confirm**
   _(Render dùng IP động nên cần mở; an toàn hơn thì whitelist dải IP của Render)_

### Bước 4 — Deploy

- Bấm **Create Web Service**. Render sẽ build Docker (mất 3-5 phút lần đầu).
- Khi xong, bạn được link kiểu: **`https://norumanga-api.onrender.com`**
- Kiểm tra: mở `https://norumanga-api.onrender.com/api/mangas` trên trình duyệt → thấy JSON danh sách truyện là THÀNH CÔNG ✅

> ⚠️ **Lưu ý gói Free của Render**: server "ngủ" sau 15 phút không có request. Lần truy cập đầu sau khi ngủ sẽ chậm ~30-50 giây (đang "thức dậy"), sau đó chạy bình thường. Muốn chạy luôn không ngủ thì nâng gói trả phí (~7 USD/tháng).

---

## 🔵 PHẦN 2: Deploy Frontend (Flutter Web) lên Netlify

### Bước 1 — Cập nhật URL backend

Mở file `norumanga-client/netlify.toml`, tìm dòng:

```
flutter build web --release --dart-define=API_BASE=https://CHANGE_ME.onrender.com
```

Thay `https://CHANGE_ME.onrender.com` bằng link Render thật của bạn (vd `https://norumanga-api.onrender.com`). Lưu lại, commit & push:

```bash
git add norumanga-client/netlify.toml
git commit -m "Set backend URL for Netlify build"
git push origin main
```

### Bước 2 — Tạo site trên Netlify

1. Vào https://app.netlify.com → **Add new site** → **Import an existing project**
2. Chọn **GitHub** → repo `SU26-PRM393-Client`
3. Cấu hình:
   - **Base directory**: `norumanga-client`
   - **Build command**: (để trống — đã có trong `netlify.toml`)
   - **Publish directory**: `norumanga-client/build/web`
4. Bấm **Deploy site**. Netlify tải Flutter SDK + build (mất 5-8 phút lần đầu).
5. Xong → bạn được link kiểu: **`https://ten-ngau-nhien.netlify.app`**
   _(Có thể đổi tên ở Site settings → Change site name)_

### Bước 3 — Xong!

Mở link Netlify trên **bất kỳ điện thoại/máy tính nào, dùng 4G/5G/WiFi đều được** → đọc truyện 24/7 🎉

---

## 🔄 Cập nhật app sau này

Mỗi khi bạn sửa code và `git push origin main`:

- Render tự build lại backend
- Netlify tự build lại frontend

Không cần làm gì thêm — đây gọi là **auto-deploy**.

---

## 🔐 Bảo mật (nên làm)

Các secret (mật khẩu DB, JWT, Cloudinary) hiện đang nằm trong code/lịch sử Git. Để an toàn thật sự:

1. **Đổi mật khẩu MongoDB**: Atlas → Database Access → Edit user → đổi password → cập nhật lại `MONGODB_URI` trên Render.
2. **Đổi Cloudinary API secret**: Cloudinary Dashboard → Settings → Security → Regenerate.
3. **Đổi JWT secret**: tạo chuỗi ngẫu nhiên mới (≥32 ký tự) → cập nhật `JWT_SECRET` trên Render.
4. Sau khi đổi, các giá trị mặc định cũ trong code sẽ vô hiệu.

---

## ❓ Xử lý sự cố thường gặp

| Triệu chứng                       | Nguyên nhân & cách xử lý                                                               |
| --------------------------------- | -------------------------------------------------------------------------------------- |
| App mở được nhưng không có truyện | Backend chưa chạy hoặc sai `API_BASE`. Mở link `/api/mangas` của Render kiểm tra.      |
| Lỗi CORS trên trình duyệt         | Backend đã mở CORS `*` sẵn; nếu vẫn lỗi, kiểm tra `API_BASE` có đúng `https://` không. |
| Backend lỗi kết nối DB            | Chưa mở Network Access `0.0.0.0/0` trên MongoDB Atlas.                                 |
| Lần đầu vào rất chậm              | Render Free đang "thức dậy". Đợi ~30-50 giây rồi tải lại.                              |
| Ảnh truyện không hiện             | Ảnh nằm trên Cloudinary (đã public) — kiểm tra mạng; thường không liên quan deploy.    |

---

## 📌 Tóm tắt link sau khi deploy (điền lại cho bạn nhớ)

- Backend (Render): `https://________________.onrender.com`
- Frontend (Netlify): `https://________________.netlify.app` ← **đây là link đọc truyện 24/7**
