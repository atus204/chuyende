import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String address;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.address = '',
    this.isAdmin = false,
  });
}

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Mock login – in production connect to Firebase / API
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Mock admin
    if (email == 'admin@nhaketa.com' && password == '123456') {
      _currentUser = const UserModel(
        id: 'admin_001',
        fullName: 'Quản trị viên',
        email: 'admin@nhaketa.com',
        phone: '0901234567',
        address: '123 Lý Thường Kiệt, Q.10, TP.HCM',
        isAdmin: true,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // Mock user login
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: 'Nguyễn Văn A',
        email: email,
        phone: '0912345678',
        address: '456 Trần Hưng Đạo, Q.1, TP.HCM',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile({
    String? fullName,
    String? phone,
    String? address,
    String? avatarUrl,
  }) {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      fullName: fullName ?? _currentUser!.fullName,
      email: _currentUser!.email,
      phone: phone ?? _currentUser!.phone,
      address: address ?? _currentUser!.address,
      avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
      isAdmin: _currentUser!.isAdmin,
    );
    notifyListeners();
  }
}
