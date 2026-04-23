# 🚂 Hướng Dẫn Deploy Flutter Web lên Railway

## 📋 Mục lục
1. [Chuẩn bị](#chuẩn-bị)
2. [Cách 1: Deploy từ GitHub (Khuyến nghị)](#cách-1-deploy-từ-github)
3. [Cách 2: Deploy từ CLI](#cách-2-deploy-từ-cli)
4. [Cách 3: Deploy tự động với GitHub Actions](#cách-3-deploy-tự-động)
5. [Cấu hình Firebase](#cấu-hình-firebase)
6. [Troubleshooting](#troubleshooting)

---

## 🎯 Chuẩn bị

### 1. Tài khoản Railway
- Truy cập: https://railway.app/
- Đăng ký/Đăng nhập bằng GitHub

### 2. Cài đặt công cụ cần thiết

**Node.js & npm:**
```bash
# Kiểm tra đã cài chưa
node --version
npm --version

# Nếu chưa có, tải tại: https://nodejs.org/
```

**Railway CLI:**
```bash
npm install -g @railway/cli
```

**Flutter:**
```bash
# Kiểm tra
flutter --version

# Nếu chưa có, tải tại: https://flutter.dev/
```

### 3. Kiểm tra các file cần thiết

Đảm bảo project có các file sau:
- ✅ `Dockerfile` - Cấu hình Docker
- ✅ `nginx.conf` - Cấu hình Nginx
- ✅ `.dockerignore` - Ignore files không cần
- ✅ `railway.toml` - Cấu hình Railway (optional)

---

## 🚀 Cách 1: Deploy từ GitHub (Khuyến nghị)

### Bước 1: Push code lên GitHub

```bash
# Khởi tạo Git (nếu chưa có)
git init

# Thêm tất cả files
git add .

# Commit
git commit -m "Initial commit - Ready for Railway deployment"

# Tạo branch main
git branch -M main

# Thêm remote repository (thay YOUR_USERNAME và YOUR_REPO)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push lên GitHub
git push -u origin main
```

### Bước 2: Kết nối Railway với GitHub

1. Vào https://railway.app/
2. Nhấn **"New Project"**
3. Chọn **"Deploy from GitHub repo"**
4. Chọn repository của bạn
5. Railway sẽ tự động:
   - Phát hiện `Dockerfile`
   - Build Docker image
   - Deploy app

### Bước 3: Đợi build hoàn tất

- Thời gian build: 5-10 phút
- Theo dõi tiến trình trong Railway Dashboard
- Xem logs nếu có lỗi

### Bước 4: Lấy URL và truy cập

1. Vào **Settings** → **Networking**
2. Nhấn **"Generate Domain"**
3. Copy URL (ví dụ: `food-ordering-app.up.railway.app`)
4. Mở URL trong trình duyệt

### Bước 5: Cập nhật app (tự động)

Mỗi lần push code mới, Railway tự động rebuild:

```bash
# Sửa code
git add .
git commit -m "Update features"
git push

# Railway tự động deploy!
```

---

## 🖥️ Cách 2: Deploy từ CLI

### Bước 1: Đăng nhập Railway

```bash
railway login
```

Trình duyệt sẽ mở, đăng nhập với GitHub.

### Bước 2: Khởi tạo project

```bash
# Tạo project mới
railway init

# Hoặc link với project có sẵn
railway link
```

### Bước 3: Deploy

**Cách nhanh - Dùng script có sẵn:**

Windows:
```bash
deploy.bat
```

Linux/Mac:
```bash
chmod +x deploy.sh
./deploy.sh
```

**Hoặc deploy thủ công:**

```bash
# Build Flutter web
flutter build web --release

# Deploy lên Railway
railway up
```

### Bước 4: Xem logs và URL

```bash
# Xem logs
railway logs

# Mở dashboard
railway open

# Xem thông tin project
railway status
```

---

## ⚙️ Cách 3: Deploy tự động với GitHub Actions

### Bước 1: Lấy Railway Token

1. Vào Railway Dashboard
2. Vào **Account Settings** → **Tokens**
3. Tạo token mới
4. Copy token

### Bước 2: Thêm Secrets vào GitHub

1. Vào GitHub repository
2. **Settings** → **Secrets and variables** → **Actions**
3. Thêm secrets:
   - `RAILWAY_TOKEN`: Token vừa copy
   - `RAILWAY_SERVICE_ID`: ID của service (lấy từ Railway Dashboard)

### Bước 3: Push code

File `.github/workflows/deploy-railway.yml` đã được tạo sẵn.

Mỗi lần push lên branch `main`, GitHub Actions sẽ tự động deploy:

```bash
git add .
git commit -m "Auto deploy with GitHub Actions"
git push
```

Xem tiến trình tại: **Actions** tab trên GitHub.

---

## 🔥 Cấu hình Firebase

### Bước 1: Tạo Firebase project

1. Vào https://console.firebase.google.com/
2. Tạo project mới
3. Thêm Web App

### Bước 2: Lấy Firebase config

Copy config từ Firebase Console:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};
```

### Bước 3: Cập nhật firebase_options.dart

Mở file `lib/firebase_options.dart` và thay thế config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_PROJECT.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT.appspot.com',
);
```

### Bước 4: Enable Firestore

1. Vào Firebase Console
2. **Firestore Database** → **Create database**
3. Chọn **Start in test mode** (hoặc production mode)
4. Chọn location gần nhất

### Bước 5: Upload dữ liệu mẫu (Optional)

```bash
# Chạy script upload data
flutter run lib/scripts/upload_data_to_firebase.dart
```

### Bước 6: Cấu hình Firestore Rules

Vào Firebase Console → Firestore → Rules, paste nội dung từ file `firestore.rules`.

### Bước 7: Rebuild và deploy

```bash
# Build lại
flutter build web --release

# Deploy lại
railway up
# hoặc
git push
```

---

## 🔧 Troubleshooting

### ❌ Build failed: "Flutter not found"

**Nguyên nhân:** Docker image không có Flutter.

**Giải pháp:** Đảm bảo `Dockerfile` dùng image có Flutter:
```dockerfile
FROM ghcr.io/cirruslabs/flutter:stable AS build
```

### ❌ "nginx: [emerg] open() failed"

**Nguyên nhân:** File `nginx.conf` không đúng hoặc thiếu.

**Giải pháp:** Kiểm tra file `nginx.conf` có trong project.

### ❌ App không load, blank screen

**Nguyên nhân:** 
- Firebase config chưa đúng
- CORS issues
- Base href không đúng

**Giải pháp:**

1. Kiểm tra Firebase config trong `firebase_options.dart`
2. Kiểm tra console logs trong browser (F12)
3. Thêm base href trong `web/index.html`:
```html
<base href="/">
```

### ❌ "Failed to load resource: net::ERR_BLOCKED_BY_CLIENT"

**Nguyên nhân:** Ad blocker chặn Firebase.

**Giải pháp:** Tắt ad blocker hoặc whitelist domain.

### ❌ Build timeout

**Nguyên nhân:** Build quá lâu (>10 phút).

**Giải pháp:**

1. Tối ưu Dockerfile với multi-stage build (đã có sẵn)
2. Giảm dependencies không cần thiết
3. Build local và push Docker image:

```bash
# Build image
docker build -t food-ordering-app .

# Tag image
docker tag food-ordering-app:latest YOUR_DOCKERHUB/food-ordering-app:latest

# Push lên Docker Hub
docker push YOUR_DOCKERHUB/food-ordering-app:latest

# Deploy từ Docker Hub trên Railway
```

### ❌ "Port already in use"

**Nguyên nhân:** Port 80 đã được dùng.

**Giải pháp:** Railway tự động map port, không cần thay đổi.

### 🔍 Xem logs chi tiết

```bash
# Railway CLI
railway logs

# Hoặc trong Railway Dashboard
# Deployments → Click vào deployment → View logs
```

---

## 💰 Chi phí Railway

Railway **KHÔNG miễn phí**:

### Hobby Plan: $5/tháng
- 500 hours execution time
- 8GB RAM
- 100GB bandwidth

### Pay-as-you-go:
- $0.000231/GB-hour (RAM)
- $0.10/GB (bandwidth)

### So sánh với các nền tảng khác:

| Platform | Giá | Bandwidth | Storage |
|----------|-----|-----------|---------|
| **Railway** | $5/tháng | 100GB | 100GB |
| **Firebase Hosting** | Miễn phí | 10GB/tháng | 10GB |
| **Vercel** | Miễn phí | 100GB/tháng | Unlimited |
| **Netlify** | Miễn phí | 100GB/tháng | Unlimited |

**💡 Khuyến nghị:**
- Nếu chỉ deploy Flutter Web → Dùng **Firebase Hosting** (miễn phí)
- Nếu cần backend API → Dùng **Railway cho backend** + **Firebase Hosting cho frontend**

---

## 📊 Monitor app

### Xem metrics

Railway Dashboard → Metrics:
- CPU usage
- Memory usage
- Network traffic
- Request count

### Xem logs real-time

```bash
railway logs --follow
```

### Set up alerts

Railway Dashboard → Settings → Notifications:
- Deploy success/failure
- Resource usage alerts
- Downtime alerts

---

## 🎯 Checklist Deploy

- [ ] Đã tạo tài khoản Railway
- [ ] Đã cài Railway CLI
- [ ] Đã có Dockerfile, nginx.conf, .dockerignore
- [ ] Đã cấu hình Firebase (firebase_options.dart)
- [ ] Đã test build local: `flutter build web --release`
- [ ] Đã push code lên GitHub
- [ ] Đã kết nối Railway với GitHub repo
- [ ] Đã generate domain trên Railway
- [ ] Đã test app trên URL Railway
- [ ] Đã enable Firestore và upload data
- [ ] Đã cấu hình Firestore rules

---

## 🚀 Quick Start

```bash
# 1. Build test
flutter build web --release

# 2. Deploy (chọn 1 trong 3 cách)

# Cách 1: GitHub (khuyến nghị)
git add .
git commit -m "Deploy to Railway"
git push

# Cách 2: CLI
railway login
railway init
railway up

# Cách 3: Script
./deploy.sh  # Linux/Mac
deploy.bat   # Windows

# 3. Lấy URL
railway open
```

---

## 📚 Tài liệu tham khảo

- Railway Docs: https://docs.railway.app/
- Flutter Web: https://flutter.dev/web
- Firebase: https://firebase.google.com/docs
- Docker: https://docs.docker.com/
- Nginx: https://nginx.org/en/docs/

---

## 🆘 Cần trợ giúp?

- Railway Discord: https://discord.gg/railway
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: Tag `flutter`, `railway`, `docker`

---

## ✅ Hoàn tất!

App của bạn đã live trên Railway! 🎉

**URL mẫu:** `https://food-ordering-app.up.railway.app`

Nhớ theo dõi chi phí trong Railway Dashboard để tránh bị tính phí quá mức.
