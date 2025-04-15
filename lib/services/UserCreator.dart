/*
    UserCreator Class
    =================
    This class is responsible for creating a new user in Firebase Authentication 
    and storing the user's additional data (e.g., phone number, dining dollars, meal swipes) 
    in the Firestore database.

    Usage:
    ------
    1. Import the `UserCreator` class:
       ```dart
       import 'services/UserCreator.dart';
       ```

    2. Create an instance of the `UserCreator` class:
       ```dart
       final userCreator = UserCreator();
       ```

    3. Call the `createUser` method with the required parameters:
       ```dart
       await userCreator.createUser(
         email: 'newuser@hogwarts.edu',
         password: 'securePassword123',
         phoneNumber: '8455515968',
         diningDollars: 100,
         mealSwipes: 50,
       );
       ```

    Notes:
    ------
    - The `email` will automatically be converted to the `@hogwarts.edu` domain if it doesn't already have it.
    - The `phoneNumber` will automatically have a `+` prepended if it doesn't already start with one.
    - This class is intended to be used for manually creating users in the database, typically during development or administrative tasks.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCreator {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new user in Firebase Authentication and stores additional user data in Firestore.
  ///
  /// Parameters:
  /// - [email]: The email address of the user. If it doesn't end with `@hogwarts.edu`,
  ///   it will be automatically converted to the `@hogwarts.edu` domain.
  /// - [password]: The password for the user. Ensure it meets Firebase's password strength requirements.
  /// - [phoneNumber]: The user's phone number. If it doesn't start with a `+`, it will be automatically prepended.
  /// - [diningDollars]: The initial balance of dining dollars for the user.
  /// - [mealSwipes]: The initial number of meal swipes for the user.
  ///
  /// Throws:
  /// - [FirebaseAuthException]: If there is an issue with creating the user in Firebase Authentication.
  /// - [Exception]: For any other unexpected errors.
  Future<void> createUser({
    required String email,
    required String password,
    required String phoneNumber,
    required int diningDollars,
    required int mealSwipes,
  }) async {
    try {
      // Force email to be in @hogwarts.edu format
      if (!email.endsWith('@hogwarts.edu')) {
        email = email.split('@')[0] + '@hogwarts.edu';
      }

      // Ensure phone number starts with a "+" if needed
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }

      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Add user data to Firestore
      await _firestore.collection('StudentData').doc(uid).set({
        'email': email,
        'phoneNumber': phoneNumber,
        'diningDollars': diningDollars,
        'mealSwipes': mealSwipes,
      });

      print('User created successfully with UID: $uid');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use.');
        throw Exception('The email address is already in use.');
      } else if (e.code == 'weak-password') {
        print('The password is too weak.');
        throw Exception('The password is too weak.');
      } else {
        print('FirebaseAuthException: ${e.message}');
        throw Exception('Failed to create user: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}
