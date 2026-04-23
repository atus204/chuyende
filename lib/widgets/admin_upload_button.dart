import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

/// Widget button to upload mock data from admin screen
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
      final firebaseService = FirebaseService();
      await firebaseService.uploadAllMockData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã tải dữ liệu lên Firebase thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isUploading ? null : _uploadData,
      icon: _isUploading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_upload),
      label: Text(_isUploading ? 'Đang tải lên...' : 'Tải Mock Data lên Firebase'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}
