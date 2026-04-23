# 🚀 Deploy Nhanh lên Railway

## ⚡ 3 Bước Deploy

### 1️⃣ Cài Railway CLI
```bash
npm install -g @railway/cli
```

### 2️⃣ Đăng nhập
```bash
railway login
```

### 3️⃣ Deploy
```bash
# Windows
deploy.bat

# Linux/Mac
chmod +x deploy.sh
./deploy.sh
```

---

## 🔥 Hoặc Deploy từ GitHub (Tự động)

### Bước 1: Push lên GitHub
```bash
git init
git add .
git commit -m "Deploy to Railway"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### Bước 2: Kết nối Railway
1. Vào https://railway.app/
2. **New Project** → **Deploy from GitHub repo**
3. Chọn repository
4. Đợi build xong (5-10 phút)
5. **Settings** → **Generate Domain**
6. Truy cập URL!

---

## 📝 Cấu hình Firebase (Quan trọng!)

### 1. Tạo Firebase project
- Vào https://console.firebase.google.com/
- Tạo project mới
- Thêm Web App

### 2. Copy config vào `lib/firebase_options.dart`
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

### 3. Enable Firestore
- Firebase Console → Firestore Database → Create database
- Chọn test mode
- Upload data: `flutter run lib/scripts/upload_data_to_firebase.dart`

---

## 💰 Chi phí

Railway: **$5/tháng** (Hobby plan)

**Miễn phí thay thế:**
- Firebase Hosting (khuyến nghị cho Flutter Web)
- Vercel
- Netlify

---

## 🔧 Troubleshooting

### Build failed?
```bash
# Kiểm tra build local
flutter build web --release

# Xem logs
railway logs
```

### App không load?
- Kiểm tra Firebase config
- Mở F12 xem console logs
- Kiểm tra `web/index.html` có `<base href="/">`

---

## 📚 Hướng dẫn chi tiết

Xem file `HUONG_DAN_DEPLOY_RAILWAY.md` để biết thêm chi tiết.

---

## ✅ Checklist

- [ ] Cài Railway CLI
- [ ] Cấu hình Firebase
- [ ] Test build: `flutter build web --release`
- [ ] Deploy: `railway up` hoặc push GitHub
- [ ] Generate domain trên Railway
- [ ] Test app trên URL

---

## 🎉 Xong!

URL mẫu: `https://your-app.up.railway.app`
