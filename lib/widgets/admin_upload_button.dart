import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';

class AdminUploadButton extends StatefulWidget {
  const AdminUploadButton({super.key});

  @override
  State<AdminUploadButton> createState() => _AdminUploadButtonState();
}

class _AdminUploadButtonState extends State<AdminUploadButton> {
  bool _isUploading = false;

  Future<void> _uploadData() async {
    setState(() => _isUploading = true);
    try {
      await context.read<FoodProvider>().seedFirestore();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã upload dữ liệu lên Firestore thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isUploading ? null : _uploadData,
      icon: _isUploading
          ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.cloud_upload),
      label: Text(_isUploading ? 'Đang upload...' : 'Upload Mock Data lên Firestore'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}
