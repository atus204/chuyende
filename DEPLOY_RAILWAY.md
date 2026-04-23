# 🚂 Deploy Flutter Web lên Railway

## ⚠️ Lưu ý

Railway không hỗ trợ Flutter trực tiếp, nhưng có thể deploy Flutter Web bằng Docker + Nginx.

**Khuyến nghị:** Dùng Firebase Hosting (miễn phí, dễ hơn). Xem file `DEPLOY_FIREBASE_HOSTING.md`

Nếu vẫn muốn dùng Railway, làm theo hướng dẫn dưới đây.

---

## 📋 Các bước:

### Bước 1: Tạo Dockerfile

Tạo file `Dockerfile` trong thư mục root:

```dockerfile
# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy files
COPY pubspec.* ./
RUN flutter pub get

COPY . .

# Build web
RUN flutter build web --release

# Runtime stage - Nginx
FROM nginx:alpine

# Copy built web app
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Bước 2: Tạo nginx.conf

Tạo file `nginx.conf`:

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    server {
        listen 80;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;

        # Enable SPA routing
        location / {
            try_files $uri $uri/ /index.html;
        }

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
    }
}
```

### Bước 3: Tạo .dockerignore

Tạo file `.dockerignore`:

```
.git
.github
.idea
.vscode
*.md
build/
.dart_tool/
.packages
.pub-cache/
.pub/
android/
ios/
linux/
macos/
windows/
test/
```

### Bước 4: Deploy lên Railway

#### Cách 1: Deploy từ GitHub (Khuyến nghị)

1. **Push code lên GitHub:**

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/food-ordering-app.git
git push -u origin main
```

2. **Vào Railway:**
   - Truy cập: https://railway.app/
   - Đăng nhập với GitHub
   - Nhấn **"New Project"**
   - Chọn **"Deploy from GitHub repo"**
   - Chọn repository của bạn
   - Railway sẽ tự động detect Dockerfile và deploy

3. **Đợi build xong** (5-10 phút)

4. **Lấy URL:**
   - Vào Settings → Generate Domain
   - Copy URL (ví dụ: `food-ordering-app.up.railway.app`)

#### Cách 2: Deploy từ CLI

```bash
# 1. Cài Railway CLI
npm install -g @railway/cli

# 2. Đăng nhập
railway login

# 3. Khởi tạo project
railway init

# 4. Link với project
railway link

# 5. Deploy
railway up
```

### Bước 5: Cấu hình Environment Variables (Nếu cần)

Trong Railway Dashboard:
- Vào **Variables**
- Thêm các biến môi trường nếu cần

### Bước 6: Truy cập app

Mở URL Railway đã cung cấp trong trình duyệt.

---

## 💰 Chi phí

Railway **KHÔNG miễn phí**:
- $5/tháng cho Hobby plan
- Hoặc $0.000231/GB-hour

**So sánh:**
- Firebase Hosting: **Miễn phí** (10GB storage, 360MB/day)
- Vercel: **Miễn phí** (100GB bandwidth)
- Netlify: **Miễn phí** (100GB bandwidth)

---

## 🔄 Cập nhật app

### Từ GitHub (Tự động)

Mỗi lần push code lên GitHub, Railway sẽ tự động rebuild và deploy.

```bash
git add .
git commit -m "Update app"
git push
```

### Từ CLI

```bash
railway up
```

---

## 📊 Monitor app

### Xem logs

```bash
railway logs
```

Hoặc vào Railway Dashboard → Deployments → View logs

### Xem metrics

Railway Dashboard → Metrics:
- CPU usage
- Memory usage
- Network traffic

---

## ⚙️ Tối ưu hóa

### 1. Giảm kích thước Docker image

Cập nhật Dockerfile:

```dockerfile
# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# Build with optimizations
RUN flutter build web --release \
    --web-renderer canvaskit \
    --tree-shake-icons \
    --dart-define=FLUTTER_WEB_USE_SKIA=true

# Runtime stage - Nginx Alpine (nhỏ hơn)
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 2. Enable compression

Đã có trong `nginx.conf` (gzip)

### 3. Cache static files

Đã có trong `nginx.conf` (expires 1y)

---

## ❓ Troubleshooting

### Build failed

Kiểm tra logs:
```bash
railway logs
```

Thường do:
- Dockerfile sai cú pháp
- Dependencies thiếu
- Build timeout

### App không load

Kiểm tra:
- Port phải là 80 (Railway tự động map)
- Nginx config đúng
- Firebase config trong code đã đúng

### Slow build

Flutter build mất 5-10 phút là bình thường. Để tăng tốc:
- Dùng cache trong Dockerfile
- Build locally và push image lên Docker Hub

---

## 🎯 So sánh Railway vs Firebase Hosting

| Feature | Railway | Firebase Hosting |
|---------|---------|------------------|
| **Giá** | $5/tháng | Miễn phí |
| **Setup** | Cần Dockerfile | Chỉ cần CLI |
| **Build time** | 5-10 phút | 1-2 phút |
| **CDN** | Không | Có (toàn cầu) |
| **SSL** | Tự động | Tự động |
| **Custom domain** | Có | Có (miễn phí) |
| **Phù hợp** | Backend API | Static sites |

---

## 💡 Khuyến nghị

**Nếu chỉ deploy Flutter Web:**
→ Dùng **Firebase Hosting** (miễn phí, dễ hơn)

**Nếu cần backend API:**
→ Dùng **Railway cho backend** + **Firebase Hosting cho frontend**

**Nếu muốn all-in-one:**
→ Dùng **Firebase** (Hosting + Firestore + Auth + Storage)

---

## 📚 Files cần tạo

- [x] `Dockerfile` - Docker config
- [x] `nginx.conf` - Nginx config
- [x] `.dockerignore` - Ignore files

---

## 🚀 Bắt đầu ngay

```bash
# 1. Tạo các files (Dockerfile, nginx.conf, .dockerignore)
# 2. Push lên GitHub
git init
git add .
git commit -m "Add Docker config"
git push

# 3. Deploy trên Railway
# - Vào railway.app
# - New Project → Deploy from GitHub
# - Chọn repo → Deploy

# 4. Đợi build xong và truy cập URL
```

---

## 🎉 Xong!

App của bạn đã live trên Railway!

**Lưu ý:** Nhớ theo dõi chi phí trong Railway Dashboard.
