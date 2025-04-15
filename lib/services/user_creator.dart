import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserCreator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateAndStoreOTP(String email) async {
    // Generate a 6-digit OTP
    final otp = (Random().nextInt(900000) + 100000).toString();

    // Store the OTP in Firestore with an expiration time (e.g., 5 minutes)
    await _firestore.collection('OTPs').doc(email).set({
      'otp': otp,
      'expiresAt': DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
    });

    print('Generated OTP for $email: $otp');
    return otp;
  }
}
