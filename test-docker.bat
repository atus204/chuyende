@echo off
REM ============================================
REM Script test Docker build locally (Windows)
REM ============================================

echo 🐳 Test Docker build locally...
echo.

REM Kiểm tra Docker đã cài chưa
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker chưa được cài đặt!
    echo 📥 Vui lòng cài Docker Desktop: https://www.docker.com/products/docker-desktop
    exit /b 1
)

REM Build Docker image
echo 🔨 Building Docker image...
docker build -t food-ordering-app:test .

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build thất bại!
    exit /b 1
)

echo ✅ Build thành công!
echo.

REM Run container
echo 🚀 Starting container on port 8080...
docker run -d -p 8080:80 --name food-ordering-test food-ordering-app:test

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Không thể start container!
    exit /b 1
)

echo ✅ Container đang chạy!
echo.
echo 🌐 Mở trình duyệt và truy cập: http://localhost:8080
echo.
echo 📋 Các lệnh hữu ích:
echo   - Xem logs: docker logs food-ordering-test
echo   - Stop container: docker stop food-ordering-test
echo   - Remove container: docker rm food-ordering-test
echo   - Remove image: docker rmi food-ordering-app:test
echo.
echo 🛑 Để dừng test, chạy:
echo   docker stop food-ordering-test ^&^& docker rm food-ordering-test
