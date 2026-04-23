// HƯỚNG DẪN: 
// 1. Vào Firebase Console → Project Settings → Your apps → Web app
// 2. Copy các giá trị từ firebaseConfig
// 3. Paste vào đúng vị trí bên dưới
// 4. Xóa file này và cập nhật file firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ============================================
  // PASTE FIREBASE CONFIG CỦA BẠN VÀO ĐÂY
  // ============================================
  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'PASTE_API_KEY_HERE',                    // ← Paste apiKey từ Firebase Console
    appId: 'PASTE_APP_ID_HERE',                      // ← Paste appId
    messagingSenderId: 'PASTE_SENDER_ID_HERE',       // ← Paste messagingSenderId
    projectId: 'PASTE_PROJECT_ID_HERE',              // ← Paste projectId
    authDomain: 'PASTE_PROJECT_ID_HERE.firebaseapp.com',  // ← Thay PASTE_PROJECT_ID_HERE
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',   // ← Thay PASTE_PROJECT_ID_HERE
  );

  // Dùng config web cho tất cả platforms (tạm thời)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PASTE_API_KEY_HERE',                    // GIỐNG web
    appId: 'PASTE_APP_ID_HERE',                      // GIỐNG web
    messagingSenderId: 'PASTE_SENDER_ID_HERE',       // GIỐNG web
    projectId: 'PASTE_PROJECT_ID_HERE',              // GIỐNG web
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PASTE_API_KEY_HERE',                    // GIỐNG web
    appId: 'PASTE_APP_ID_HERE',                      // GIỐNG web
    messagingSenderId: 'PASTE_SENDER_ID_HERE',       // GIỐNG web
    projectId: 'PASTE_PROJECT_ID_HERE',              // GIỐNG web
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',
    iosBundleId: 'com.example.foodOrderingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'PASTE_API_KEY_HERE',                    // GIỐNG web
    appId: 'PASTE_APP_ID_HERE',                      // GIỐNG web
    messagingSenderId: 'PASTE_SENDER_ID_HERE',       // GIỐNG web
    projectId: 'PASTE_PROJECT_ID_HERE',              // GIỐNG web
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',
    iosBundleId: 'com.example.foodOrderingApp',
  );
}

// ============================================
// VÍ DỤ:
// ============================================
// 
// Nếu Firebase Console cho bạn config này:
// 
// const firebaseConfig = {
//   apiKey: "AIzaSyAbc123def456",
//   authDomain: "my-app-12345.firebaseapp.com",
//   projectId: "my-app-12345",
//   storageBucket: "my-app-12345.appspot.com",
//   messagingSenderId: "123456789",
//   appId: "1:123456789:web:abc123"
// };
//
// Thì bạn sẽ điền như sau:
//
// static const FirebaseOptions web = FirebaseOptions(
//   apiKey: 'AIzaSyAbc123def456',
//   appId: '1:123456789:web:abc123',
//   messagingSenderId: '123456789',
//   projectId: 'my-app-12345',
//   authDomain: 'my-app-12345.firebaseapp.com',
//   storageBucket: 'my-app-12345.appspot.com',
// );
