import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      phone: _phoneCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.registerTitle,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        AppStrings.registerSubtitle,
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(AppStrings.fullName),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: _deco('Nguyễn Văn A', Icons.person_outline),
                        validator: (v) =>
                            v == null || v.length < 2 ? 'Vui lòng nhập tên của bạn' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(AppStrings.phoneNumber),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _deco('0912345678', Icons.phone_outlined),
                        validator: (v) =>
                            v == null || v.length < 10 ? 'Số điện thoại không hợp lệ' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(AppStrings.email),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _deco('example@email.com', Icons.email_outlined),
                        validator: (v) =>
                            v == null || !v.contains('@') ? 'Email không hợp lệ' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(AppStrings.password),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: _deco('Tối thiểu 6 ký tự', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppColors.textGrey),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.length < 6 ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(AppStrings.confirmPassword),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        decoration: _deco('Nhập lại mật khẩu', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppColors.textGrey),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) =>
                            v != _passCtrl.text ? 'Mật khẩu không khớp' : null,
                      ),
                      const SizedBox(height: 32),

                      CustomButton(
                        text: 'Tạo tài khoản',
                        icon: Icons.person_add_outlined,
                        isLoading: auth.isLoading,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: const TextSpan(
                              text: AppStrings.hasAccount,
                              style: TextStyle(color: AppColors.textGrey),
                              children: [
                                TextSpan(
                                  text: AppStrings.login,
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
      );

  InputDecoration _deco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
      );
}
