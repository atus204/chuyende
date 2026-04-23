#!/bin/bash

# ============================================
# Script test Docker build locally
# ============================================

echo "🐳 Test Docker build locally..."
echo ""

# Kiểm tra Docker đã cài chưa
if ! command -v docker &> /dev/null
then
    echo "❌ Docker chưa được cài đặt!"
    echo "📥 Vui lòng cài Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Build Docker image
echo "🔨 Building Docker image..."
docker build -t food-ordering-app:test .

if [ $? -ne 0 ]; then
    echo "❌ Build thất bại!"
    exit 1
fi

echo "✅ Build thành công!"
echo ""

# Run container
echo "🚀 Starting container on port 8080..."
docker run -d -p 8080:80 --name food-ordering-test food-ordering-app:test

if [ $? -ne 0 ]; then
    echo "❌ Không thể start container!"
    exit 1
fi

echo "✅ Container đang chạy!"
echo ""
echo "🌐 Mở trình duyệt và truy cập: http://localhost:8080"
echo ""
echo "📋 Các lệnh hữu ích:"
echo "  - Xem logs: docker logs food-ordering-test"
echo "  - Stop container: docker stop food-ordering-test"
echo "  - Remove container: docker rm food-ordering-test"
echo "  - Remove image: docker rmi food-ordering-app:test"
echo ""
echo "🛑 Để dừng test, chạy:"
echo "  docker stop food-ordering-test && docker rm food-ordering-test"
