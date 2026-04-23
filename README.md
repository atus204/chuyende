# Nha Bep Viet - Ung Dung Dat Do An

> Huong vi que huong, giao tan nha

---

## Gioi thieu

**Nha Bep Viet** la ung dung dat do an tieng Viet, xay dung bang Flutter/Dart. Giao dien hien dai, truc quan, toi uu cho trai nghiem nguoi dung mobile.

---

## Huong dan cai dat va chay ung dung

### Yeu cau he thong

Truoc khi bat dau, hay dam bao may tinh da cai day du cac phan mem sau:

- Flutter SDK phien ban 3.0 tro len
- Dart phien ban 3.0 tro len (duoc cai kem theo Flutter)
- Android Studio hoac Visual Studio Code
- Java Development Kit (JDK) phien ban 11 tro len
- Thiet bi Android/iOS that hoac may ao (Emulator/Simulator)

---

### Buoc 1 - Cai dat Flutter SDK

1. Truy cap trang chu Flutter de tai SDK:
   ```
   https://flutter.dev/docs/get-started/install/windows
   ```

2. Giai nen file zip vua tai ve vao mot thu muc, vi du:
   ```
   C:\flutter
   ```

3. Them duong dan Flutter vao bien moi truong PATH:
   - Mo "System Properties" > "Environment Variables"
   - Trong muc "User variables", chon "Path" roi nhan "Edit"
   - Nhan "New" va them vao:
     ```
     C:\flutter\bin
     ```
   - Nhan OK de luu

4. Mo lai Command Prompt hoac PowerShell va kiem tra cai dat:
   ```bash
   flutter --version
   ```
   Ket qua mong doi se hien thi phien ban Flutter dang su dung.

5. Chay lenh sau de kiem tra toan bo moi truong:
   ```bash
   flutter doctor
   ```
   Lenh nay se bao cao neu con thieu phan mem nao. Hay cai du het cac muc duoc danh dau loi truoc khi tiep tuc.

---

### Buoc 2 - Cai dat Android Studio

1. Tai Android Studio tai:
   ```
   https://developer.android.com/studio
   ```

2. Cai dat theo huong dan cua trinh cai dat.

3. Mo Android Studio, vao menu:
   ```
   File > Settings > Plugins
   ```
   Tim va cai plugin **Flutter** va **Dart**.

4. Khoi dong lai Android Studio.

5. Tao may ao Android (Emulator):
   - Vao menu: `Tools > Device Manager`
   - Nhan "Create Device"
   - Chon mot mau dien thoai (khuyen nghi: Pixel 6 hoac Pixel 7)
   - Chon he dieu hanh Android (khuyen nghi: Android 13 hoac 14)
   - Nhan "Finish" de hoan tat

---

### Buoc 3 - Mo du an

Cach 1 - Mo bang Android Studio:
1. Mo Android Studio
2. Chon "Open"
3. Duyet den thu muc du an:
   ```
   c:\Users\DELL\OneDrive\May tinh\manifest\PhanAnhTu\food_ordering_app
   ```
4. Nhan "OK"

Cach 2 - Mo bang Visual Studio Code:
1. Mo VS Code
2. Vao menu: `File > Open Folder`
3. Chon thu muc `food_ordering_app`
4. Nhan "Select Folder"

---

### Buoc 4 - Cai dat cac thu vien (dependencies)

Mo Terminal hoac Command Prompt, di chuyen vao thu muc du an:

```bash
cd "c:\Users\DELL\OneDrive\May tinh\manifest\PhanAnhTu\food_ordering_app"
```

Chay lenh sau de cai tat ca thu vien can thiet:

```bash
flutter pub get
```

Doi cho den khi lenh chay xong. Neu thanh cong, ban se thay thong bao tuong tu:
```
Got dependencies!
```

---

### Buoc 5 - Chay ung dung

**Cach 1 - Dung lenh (Command Prompt / PowerShell):**

Dam bao may ao dang chay hoac ket noi thiet bi that, sau do chay:

```bash
flutter run
```

Neu co nhieu thiet bi, Flutter se hoi ban muon chon thiet bi nao. Nhap so thu tu tuong ung va nhan Enter.

Neu muon chi dinh cu the thiet bi:

```bash
# Xem danh sach thiet bi kha dung
flutter devices

# Chay tren thiet bi cu the (thay [device-id] bang ID thuc te)
flutter run -d [device-id]
```

**Cach 2 - Dung Android Studio:**

1. Mo du an trong Android Studio
2. Chon thiet bi muon chay tren thanh cong cu phia tren
3. Nhan nut "Run" (hinh tam giac xanh) hoac nhan phim Shift + F10

**Cach 3 - Dung Visual Studio Code:**

1. Mo du an trong VS Code
2. Mo file `lib/main.dart`
3. Nhan F5 hoac vao menu: `Run > Start Debugging`
4. Chon thiet bi khi duoc hoi

---

### Buoc 6 - Khi gap loi thuong gap

**Loi: "flutter" is not recognized**

Nguyen nhan: Chua them Flutter vao bien moi truong PATH.
Cach sua: Thuc hien lai Buoc 1 muc 3, sau do mo lai terminal.

---

**Loi: No devices found**

Nguyen nhan: Chua bat may ao hoac chua ket noi thiet bi that.
Cach sua:
- Doi voi may ao: Mo Android Studio > Device Manager > Nhan nut Play de khoi dong may ao
- Doi voi thiet bi that: Bat "Developer Options" va "USB Debugging" tren dien thoai, ket noi qua cap USB

---

**Loi: Gradle build failed**

Cach sua: Chay lan luot cac lenh sau:

```bash
flutter clean
flutter pub get
flutter run
```

---

**Loi: SDK location not found**

Cach sua: Mo Android Studio, vao `File > Settings > Appearance & Behavior > System Settings > Android SDK`, sao chep duong dan SDK, sau do tao file `local.properties` trong thu muc `android/` cua du an voi noi dung:

```
sdk.dir=C:\\Users\\[TenNguoiDung]\\AppData\\Local\\Android\\Sdk
```

Thay `[TenNguoiDung]` bang ten theo may tinh cua ban.

---

## Tai khoan demo

| Loai tai khoan | Email | Mat khau |
|----------------|-------|----------|
| Quan tri vien | admin@nhaketa.com | 123456 |
| Nguoi dung | bat ky email hop le | toi thieu 6 ky tu |
| Khach | nhan nut "Dung thu khong can tai khoan" | khong can |

---

## Cong nghe su dung

```yaml
Flutter: ^3.0.0
Dart: ^3.0.0
provider: ^6.1.1
google_fonts: ^6.1.0
cached_network_image: ^3.3.1
smooth_page_indicator: ^1.1.0
intl: ^0.19.0
```

---

## Cau truc du an

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart    # Bang mau
│   │   └── app_theme.dart     # ThemeData
│   └── constants/
│       ├── app_routes.dart    # Ten routes
│       └── app_strings.dart   # Chuoi tieng Viet
├── data/
│   └── mock_data.dart         # Du lieu mau (18 mon)
├── models/
│   ├── food_item.dart
│   ├── cart_item.dart
│   └── order_model.dart
├── providers/
│   ├── cart_provider.dart     # Gio hang + Don hang
│   └── auth_provider.dart     # Dang nhap
├── widgets/
│   ├── food_card.dart         # Card mon an (ngang/doc)
│   └── custom_button.dart     # Nut tuy chinh
├── screens/
│   ├── splash/                # Splash + Onboarding
│   ├── auth/                  # Login + Register
│   ├── home/                  # Trang chu
│   ├── menu/                  # Thuc don
│   ├── food_detail/           # Chi tiet mon
│   ├── cart/                  # Gio hang
│   ├── checkout/              # Thanh toan + Thanh cong
│   ├── orders/                # Don hang
│   ├── profile/               # Ho so
│   └── admin/                 # Quan tri
└── main.dart
```

---

## Design System

| Thanh phan | Gia tri |
|------------|---------|
| Mau chinh | #FF6B35 (cam dat) |
| Mau phu | #E85520 |
| Mau nhan | #FFD166 (vang nang) |
| Mau nen toi | #1A1A2E (xanh dem) |
| Mau nen sang | #F8F8F8 |
| Font chu | Poppins (Google Fonts) |
| Bo goc | 14 den 20px |
| Do bong | rgba(0,0,0,0.06) blur 12px |

---

## Tinh nang da hoan thanh

| Man hinh | Mo ta |
|----------|--------|
| Splash Screen | Man hinh khoi dong voi animation |
| Onboarding | 3 slide gioi thieu voi PageView |
| Dang nhap | Form voi validation day du |
| Dang ky | Form tao tai khoan |
| Trang chu | Banner carousel, danh muc, mon pho bien |
| Thuc don | Tim kiem, loc, sap xep |
| Chi tiet mon | Anh hero, so luong, ghi chu |
| Gio hang | Swipe xoa, voucher, tong tien |
| Thanh toan | Dia chi, phuong thuc thanh toan |
| Xac nhan don | Man hinh thanh cong |
| Don hang | Tab dang xu ly va lich su, timeline trang thai |
| Ho so | Thong ke, settings, logout |
| Quan tri | Quan ly mon an, don hang, nguoi dung |

---

## Huong phat trien tiep theo

- Tich hop Firebase Authentication va Firestore
- Thanh toan online: Momo, VNPay, Stripe
- Push notifications voi Firebase Cloud Messaging
- He thong danh gia va review mon an
- Dark mode
- Da ngon ngu
- Toi uu hoa hieu suat va caching

---

## Lien he

Neu ban quan tam den du an hoac muon hop tac, vui long lien he.
