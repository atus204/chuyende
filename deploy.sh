#!/bin/bash

# ============================================
# Script Deploy lên Railway
# ============================================

echo "🚂 Bắt đầu deploy lên Railway..."
echo ""

# Kiểm tra Railway CLI đã cài chưa
if ! command -v railway &> /dev/null
then
    echo "❌ Railway CLI chưa được cài đặt!"
    echo "📦 Đang cài đặt Railway CLI..."
    npm install -g @railway/cli
    echo "✅ Đã cài đặt Railway CLI"
    echo ""
fi

# Kiểm tra đã login chưa
echo "🔐 Kiểm tra đăng nhập Railway..."
if ! railway whoami &> /dev/null
then
    echo "❌ Chưa đăng nhập Railway!"
    echo "🔑 Vui lòng đăng nhập..."
    railway login
    echo ""
fi

# Build Flutter web locally để test
echo "🔨 Build Flutter web để test..."
flutter build web --release
if [ $? -ne 0 ]; then
    echo "❌ Build thất bại! Vui lòng kiểm tra lỗi."
    exit 1
fi
echo "✅ Build thành công!"
echo ""

# Deploy lên Railway
echo "🚀 Đang deploy lên Railway..."
railway up

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deploy thành công!"
    echo "🌐 Mở Railway dashboard để xem URL:"
    railway open
else
    echo ""
    echo "❌ Deploy thất bại! Kiểm tra logs:"
    railway logs
    exit 1
fi
