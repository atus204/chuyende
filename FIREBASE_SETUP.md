# Hướng dẫn Setup Firebase cho App

## 1. Tạo tài khoản Firebase (nếu chưa có)
- Truy cập https://console.firebase.google.com
- Đăng nhập bằng Google Account

## 2. Tạo Project mới hoặc dùng project hiện tại
- Project ID hiện tại: `appdoanngoll`
- Đã có Firebase config trong `lib/firebase_options.dart`

## 3. Bật Firebase Authentication
1. Vào Firebase Console → Authentication
2. Click "Get Started"
3. Chọn tab "Sign-in method"
4. Enable "Email/Password"

## 4. Tạo Firestore Database
1. Vào Firebase Console → Firestore Database
2. Click "Create database"
3. Chọn "Start in **test mode**" (cho development)
4. Chọn location: `asia-southeast1` (Singapore)

## 5. Upload dữ liệu mẫu lên Firestore

### Cách 1: Dùng Admin Screen trong app
1. Chạy app: `flutter run -d chrome`
2. Login với tài khoản admin (tạo mới nếu chưa có)
3. Vào Admin Screen
4. Click nút "Upload Mock Data to Firebase"

### Cách 2: Chạy script upload
```dart
// Tạo file lib/scripts/seed_firestore.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../providers/food_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final foodProvider = FoodProvider();
  await foodProvider.seedFirestore();
  
  print('✅ Đã upload dữ liệu thành công!');
}
```

Chạy: `flutter run lib/scripts/seed_firestore.dart`

## 6. Firestore Security Rules (Production)

Sau khi test xong, cập nhật rules trong Firebase Console → Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Food items - public read, admin write
    match /food_items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Categories & Banners - public read, admin write
    match /categories/{catId} {
      allow read: if true;
      allow write: if request.auth != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    match /banners/{bannerId} {
      allow read: if true;
      allow write: if request.auth != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Orders - user can read their own, admin can read all
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                    (resource.data.userId == request.auth.uid || 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

## 7. Tạo tài khoản Admin đầu tiên

1. Đăng ký tài khoản mới trong app
2. Vào Firebase Console → Firestore → users collection
3. Tìm document của user vừa tạo
4. Thêm field: `isAdmin: true`

## 8. Test

- Đăng ký tài khoản mới
- Đăng nhập
- Xem danh sách món ăn (load từ Firestore)
- Thêm vào giỏ hàng
- Đặt hàng (lưu vào Firestore)
- Xem lịch sử đơn hàng

## Lưu ý

- **Test mode** cho phép mọi người đọc/ghi Firestore (chỉ dùng development)
- Nhớ cập nhật Security Rules trước khi deploy production
- Firebase có free tier: 50K reads/day, 20K writes/day
