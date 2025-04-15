import 'package:firebase_auth/firebase_auth.dart';

// Empty file for Firebase Service

/*
    Central file to manage all Firebase services
    - get Data from Firebase
    - update Data in Firebase
    - delete Data from Firebase
    - authenticate user
    - sign out user
    - sign in user
*/

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      // Log the email for debugging purposes (do not log passwords)
      print('Attempting login for email: $email');

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Log successful login
      print('Login successful for email: $email');
      return userCredential.user; // Return the authenticated user
    } on FirebaseAuthException catch (e) {
      // Log the error code for debugging
      print('FirebaseAuthException: ${e.code}');

      if (e.code == 'user-not-found') {
        throw Exception('No account found for this email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else {
        throw Exception('Login failed. Please try again later.');
      }
    } catch (e) {
      // Log unexpected errors
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}


