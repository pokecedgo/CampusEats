import 'package:firebase_auth/firebase_auth.dart';

class ThirdPartyAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void authenticate() {
    print('Authentication');
  }

  // Send SMS verification code
  Future<void> sendVerificationCode(String phoneNumber, Function(String) onCodeSent) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in the user if verification is completed
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('Phone number automatically verified and user signed in.');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        throw Exception('Failed to verify phone number: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Pass the verificationId to the callback
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code auto-retrieval timeout.');
      },
    );
  }

  // Verify the SMS code
  Future<void> verifyCode(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
    print('Phone number verified and user signed in.');
  }
}
