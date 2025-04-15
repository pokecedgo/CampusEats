import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_creator.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ThirdPartyAuthScreen extends StatefulWidget {
  @override
  _ThirdPartyAuthScreenState createState() => _ThirdPartyAuthScreenState();
}

class _ThirdPartyAuthScreenState extends State<ThirdPartyAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final UserCreator _userCreator = UserCreator();
  bool _isLoading = false;
  String? _generatedOtp;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      print('Sending OTP to email: $email'); // Debug log

      final otp = await _userCreator.generateAndStoreOTP(email);
      print('Generated OTP: $otp'); // Debug log

      // Call the Firebase Cloud Function to send the OTP email
      final sendOtpEmail = FirebaseFunctions.instance.httpsCallable('sendOtpEmail');
      final response = await sendOtpEmail.call({'email': email, 'otp': otp});
      print('Cloud Function response: $response'); // Debug log

      setState(() {
        _generatedOtp = otp;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to $email')),
      );
    } catch (e) {
      print('Error sending OTP: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final enteredOtp = _otpController.text.trim();
      print('Verifying OTP for email: $email'); // Debug log

      // Fetch the OTP from Firestore
      final otpDoc = await FirebaseFirestore.instance.collection('OTPs').doc(email).get();
      print('Fetched OTP document: ${otpDoc.data()}'); // Debug log

      if (!otpDoc.exists) {
        throw Exception('No OTP found for this email.');
      }

      final data = otpDoc.data()!;
      final storedOtp = data['otp'];
      final expiresAt = DateTime.parse(data['expiresAt']);

      if (DateTime.now().isAfter(expiresAt)) {
        throw Exception('OTP has expired.');
      }

      if (enteredOtp == storedOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully!')),
        );
        // Navigate to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('Invalid OTP.');
      }
    } catch (e) {
      print('Error verifying OTP: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email OTP Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20),
            if (_generatedOtp == null)
              ElevatedButton(
                onPressed: _sendOtp,
                child: _isLoading ? CircularProgressIndicator() : Text('Send OTP'),
              ),
            if (_generatedOtp != null) ...[
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: _isLoading ? CircularProgressIndicator() : Text('Verify OTP'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}