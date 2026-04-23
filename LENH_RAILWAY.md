# 📝 Tổng Hợp Lệnh Railway

## 🔧 Cài đặt & Setup

### Cài Railway CLI
```bash
npm install -g @railway/cli
```

### Kiểm tra version
```bash
railway --version
```

### Đăng nhập
```bash
railway login
```

### Kiểm tra đã login chưa
```bash
railway whoami
```

### Đăng xuất
```bash
railway logout
```

---

## 🚀 Deploy & Project Management

### Tạo project mới
```bash
railway init
```

### Link với project có sẵn
```bash
railway link
```

### Deploy app
```bash
railway up
```

### Deploy với service cụ thể
```bash
railway up --service <service-id>
```

### Deploy từ Dockerfile
```bash
railway up --dockerfile Dockerfile
```

---

## 📊 Monitoring & Logs

### Xem logs
```bash
railway logs
```

### Xem logs real-time (follow)
```bash
railway logs --follow
```

### Xem logs của service cụ thể
```bash
railway logs --service <service-name>
```

### Xem status project
```bash
railway status
```

### Xem thông tin project
```bash
railway list
```

---

## 🌐 Domain & Networking

### Generate domain
```bash
railway domain
```

### Mở app trong browser
```bash
railway open
```

### Xem URL của app
```bash
railway status
```

---

## ⚙️ Environment Variables

### Xem tất cả variables
```bash
railway variables
```

### Set variable
```bash
railway variables set KEY=VALUE
```

### Set nhiều variables
```bash
railway variables set KEY1=VALUE1 KEY2=VALUE2
```

### Xóa variable
```bash
railway variables delete KEY
```

---

## 🔄 Service Management

### List tất cả services
```bash
railway service
```

### Tạo service mới
```bash
railway service create
```

### Xóa service
```bash
railway service delete <service-name>
```

---

## 🗑️ Cleanup

### Unlink project
```bash
railway unlink
```

### Xóa project (trên web dashboard)
- Vào Railway Dashboard
- Settings → Danger Zone → Delete Project

---

## 🐳 Docker Commands (Local Testing)

### Build Docker image
```bash
docker build -t food-ordering-app .
```

### Run container locally
```bash
docker run -p 8080:80 food-ordering-app
```

### Run container in background
```bash
docker run -d -p 8080:80 --name food-app food-ordering-app
```

### Stop container
```bash
docker stop food-app
```

### Remove container
```bash
docker rm food-app
```

### Remove image
```bash
docker rmi food-ordering-app
```

### View logs
```bash
docker logs food-app
```

### View logs real-time
```bash
docker logs -f food-app
```

---

## 🔍 Debugging

### Xem logs chi tiết
```bash
railway logs --follow
```

### SSH vào container (nếu có)
```bash
railway run bash
```

### Chạy lệnh trong container
```bash
railway run <command>
```

### Restart service
```bash
railway restart
```

---

## 📦 Build & Test Local

### Build Flutter web
```bash
flutter build web --release
```

### Test Docker build
```bash
# Linux/Mac
./test-docker.sh

# Windows
test-docker.bat
```

### Test với Flutter web server
```bash
flutter run -d chrome
```

---

## 🔐 Authentication & Tokens

### Tạo token mới
- Vào Railway Dashboard
- Account Settings → Tokens
- Create New Token

### Sử dụng token trong CI/CD
```bash
export RAILWAY_TOKEN=<your-token>
railway up
```

---

## 📈 Monitoring & Analytics

### Xem metrics
- Vào Railway Dashboard
- Metrics tab

### Xem deployment history
```bash
railway list
```

### Xem resource usage
- Railway Dashboard → Metrics
- CPU, Memory, Network

---

## 🚨 Troubleshooting Commands

### Build failed - Xem logs
```bash
railway logs
```

### App không start - Restart
```bash
railway restart
```

### Port issues - Kiểm tra config
```bash
railway variables
```

### Clear cache và rebuild
```bash
railway up --force
```

---

## 💡 Tips & Tricks

### Deploy nhanh với alias
```bash
# Thêm vào ~/.bashrc hoặc ~/.zshrc
alias rd="railway up"
alias rl="railway logs --follow"
alias ro="railway open"
```

### Auto-deploy khi push GitHub
- Kết nối Railway với GitHub repo
- Mỗi lần push sẽ tự động deploy

### Sử dụng railway.toml
Tạo file `railway.toml`:
```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile"

[deploy]
numReplicas = 1
restartPolicyType = "ON_FAILURE"
```

---

## 📚 Tài liệu tham khảo

- Railway CLI Docs: https://docs.railway.app/develop/cli
- Railway API: https://docs.railway.app/reference/api
- Docker Docs: https://docs.docker.com/

---

## 🎯 Quick Reference

| Lệnh | Mô tả |
|------|-------|
| `railway login` | Đăng nhập |
| `railway init` | Tạo project mới |
| `railway up` | Deploy app |
| `railway logs` | Xem logs |
| `railway open` | Mở app trong browser |
| `railway status` | Xem status |
| `railway variables` | Xem env variables |
| `railway restart` | Restart service |

---

## ✅ Workflow Deploy Chuẩn

```bash
# 1. Build và test local
flutter build web --release

# 2. Test Docker (optional)
./test-docker.sh

# 3. Commit code
git add .
git commit -m "Update app"

# 4. Deploy
railway up

# 5. Xem logs
railway logs --follow

# 6. Mở app
railway open
```

---

## 🆘 Cần trợ giúp?

```bash
# Xem help
railway --help

# Xem help cho lệnh cụ thể
railway <command> --help

# Ví dụ
railway up --help
railway logs --help
```
