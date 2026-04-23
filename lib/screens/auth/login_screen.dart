import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email hoặc mật khẩu không đúng'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header gradient
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Text('🍜', style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.loginSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.welcomeBack,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 28),

                      // Email
                      _buildLabel(AppStrings.email),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDeco('Nhập email của bạn', Icons.email_outlined),
                        validator: (v) =>
                            v == null || !v.contains('@') ? 'Email không hợp lệ' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildLabel(AppStrings.password),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: _inputDeco('Nhập mật khẩu', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.length < 6 ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Login button
                      CustomButton(
                        text: AppStrings.login,
                        isLoading: auth.isLoading,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('hoặc', style: TextStyle(color: AppColors.textGrey)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Guest login
                      CustomButton(
                        text: 'Dùng thử không cần tài khoản',
                        isOutlined: true,
                        icon: Icons.person_outline,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.home);
                        },
                      ),
                      const SizedBox(height: 28),

                      // Register link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                          child: RichText(
                            text: const TextSpan(
                              text: AppStrings.noAccount,
                              style: TextStyle(color: AppColors.textGrey),
                              children: [
                                TextSpan(
                                  text: AppStrings.register,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Hint
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Admin: admin@nhaketa.com / 123456',
                                style: const TextStyle(fontSize: 12, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
    );
  }
}
