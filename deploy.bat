@echo off
REM ============================================
REM Script Deploy lên Railway cho Windows
REM ============================================

echo 🚂 Bắt đầu deploy lên Railway...
echo.

REM Kiểm tra Railway CLI đã cài chưa
where railway >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Railway CLI chưa được cài đặt!
    echo 📦 Đang cài đặt Railway CLI...
    call npm install -g @railway/cli
    echo ✅ Đã cài đặt Railway CLI
    echo.
)

REM Kiểm tra đã login chưa
echo 🔐 Kiểm tra đăng nhập Railway...
railway whoami >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Chưa đăng nhập Railway!
    echo 🔑 Vui lòng đăng nhập...
    call railway login
    echo.
)

REM Build Flutter web locally để test
echo 🔨 Build Flutter web để test...
call flutter build web --release
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build thất bại! Vui lòng kiểm tra lỗi.
    exit /b 1
)
echo ✅ Build thành công!
echo.

REM Deploy lên Railway
echo 🚀 Đang deploy lên Railway...
call railway up

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Deploy thành công!
    echo 🌐 Mở Railway dashboard để xem URL:
    call railway open
) else (
    echo.
    echo ❌ Deploy thất bại! Kiểm tra logs:
    call railway logs
    exit /b 1
)
