# 🔥 Setup Firebase Thủ Công (Không cần FlutterFire CLI)

## Bước 1: Tạo Firebase Project

1. Mở trình duyệt, vào: **https://console.firebase.google.com/**
2. Nhấn **"Add project"** (hoặc "Thêm dự án")
3. Nhập tên project: **`food-ordering-app`**
4. Nhấn **Continue**
5. Tắt Google Analytics (không bắt buộc)
6. Nhấn **"Create project"**
7. Đợi vài giây → Nhấn **"Continue"**

## Bước 2: Enable Firestore Database

1. Trong Firebase Console, menu bên trái → **Build** → **Firestore Database**
2. Nhấn **"Create database"**
3. Chọn location: **`asia-southeast1`** (Singapore - gần VN)
4. Chọn **"Start in test mode"** ← QUAN TRỌNG!
5. Nhấn **"Enable"**
6. Đợi vài giây cho database được tạo

## Bước 3: Thêm Web App

1. Trong Firebase Console, vào **Project Overview** (icon ⚙️ → Project settings)
2. Scroll xuống phần **"Your apps"**
3. Nhấn icon **Web** (`</>`)
4. App nickname: **`food-ordering-app-web`**
5. KHÔNG tick "Firebase Hosting"
6. Nhấn **"Register app"**
7. Bạn sẽ thấy Firebase config như này:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyAbc123...",
  authDomain: "food-ordering-app.firebaseapp.com",
  projectId: "food-ordering-app",
  storageBucket: "food-ordering-app.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abc123def456"
};
```

8. **COPY toàn bộ config này!**

## Bước 4: Cập nhật firebase_options.dart

Mở file **`lib/firebase_options.dart`** trong project Flutter của bạn.

Thay thế các giá trị `YOUR_...` bằng giá trị từ Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyAbc123...',                    // Copy từ firebaseConfig
  appId: '1:123456789012:web:abc123def456',    // Copy từ firebaseConfig
  messagingSenderId: '123456789012',            // Copy từ firebaseConfig
  projectId: 'food-ordering-app',               // Copy từ firebaseConfig
  authDomain: 'food-ordering-app.firebaseapp.com',
  storageBucket: 'food-ordering-app.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyAbc123...',                    // GIỐNG web
  appId: '1:123456789012:android:xyz789',      // Sẽ lấy sau (hoặc dùng web tạm)
  messagingSenderId: '123456789012',            // GIỐNG web
  projectId: 'food-ordering-app',               // GIỐNG web
  storageBucket: 'food-ordering-app.appspot.com',
);

// iOS và macOS tương tự
```

**Lưu ý:** Nếu chỉ test trên web/desktop, dùng config web cho tất cả platforms cũng được!

## Bước 5: Cập nhật main.dart

Mở **`lib/main.dart`**, thêm Firebase initialization:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## Bước 6: Upload Mock Data

### Cách 1: Thêm button vào Admin Screen

Mở **`lib/screens/admin/admin_screen.dart`**

Thêm import ở đầu file:
```dart
import '../../widgets/admin_upload_button.dart';
```

Thêm button vào body (ví dụ trong Column):
```dart
Column(
  children: [
    // ... các widget khác
    
    SizedBox(height: 20),
    AdminUploadButton(),  // ← Thêm dòng này
    
    // ... các widget khác
  ],
)
```

Chạy app:
```bash
flutter run -d chrome
```

Vào admin screen, nhấn button "Tải Mock Data lên Firebase"

### Cách 2: Chạy script

```bash
flutter run -d chrome lib/scripts/upload_data_to_firebase.dart
```

## Bước 7: Kiểm tra dữ liệu

1. Vào Firebase Console
2. Menu bên trái → **Firestore Database**
3. Bạn sẽ thấy các collections:
   - ✅ **food_items** (20 documents)
   - ✅ **categories** (9 documents)
   - ✅ **banners** (3 documents)
   - ✅ **admin_stats** (1 document)

## ✅ Xong!

Bây giờ app của bạn đã kết nối Firebase và có dữ liệu!

## 🎯 Test ngay:

```dart
// Trong bất kỳ widget nào:
final firebaseService = FirebaseService();

// Lấy tất cả món ăn
final items = await firebaseService.getFoodItems();
print('Có ${items.length} món ăn');

// Lấy món phổ biến
final popular = await firebaseService.getPopularItems();
print('Có ${popular.length} món phổ biến');
```

## ❓ Troubleshooting

### Lỗi: "Firebase not initialized"
→ Kiểm tra đã thêm `Firebase.initializeApp()` trong `main.dart` chưa

### Lỗi: "Invalid API key"
→ Kiểm tra lại config trong `firebase_options.dart`

### Lỗi: "Permission denied"
→ Kiểm tra Firestore đang ở **test mode**

### Không thấy dữ liệu trong Firestore
→ Chạy lại upload script hoặc nhấn button upload

## 📱 Cho Android (Tùy chọn)

Nếu muốn chạy trên Android:

1. Trong Firebase Console → Project Settings
2. Scroll xuống → Nhấn icon **Android**
3. Package name: **`com.example.food_ordering_app`**
4. Tải file **`google-services.json`**
5. Copy vào: **`android/app/google-services.json`**
6. Cập nhật **`android/build.gradle`**:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```
7. Cập nhật **`android/app/build.gradle`**:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## 🚀 Bắt đầu ngay:

```bash
# 1. Chạy app trên Chrome
flutter run -d chrome

# 2. Hoặc chạy script upload
flutter run -d chrome lib/scripts/upload_data_to_firebase.dart
```
