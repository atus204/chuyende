import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: isSmall ? 40 : 52,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          child: _buildChild(),
        ),
      );
    }

    return Container(
      width: width ?? double.infinity,
      height: isSmall ? 40 : 52,
      decoration: BoxDecoration(
        gradient: disabled ? null : (backgroundColor == null ? AppColors.primaryGradient : null),
        color: disabled
            ? AppColors.textLight
            : backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmall ? 16 : 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 13 : 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: isSmall ? 13 : 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
