import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

/// Script to upload mock data to Firebase
/// 
/// To run this script:
/// 1. Make sure you have configured Firebase in your project
/// 2. Run: flutter run lib/scripts/upload_data_to_firebase.dart
/// 
/// Or create a button in your admin screen to trigger the upload

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  print('📱 Firebase initialized successfully\n');
  
  // Create Firebase service instance
  final firebaseService = FirebaseService();
  
  // Upload all mock data
  await firebaseService.uploadAllMockData();
  
  print('\n🎉 Data upload completed!');
  print('You can now close this script.');
}
