import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserData(String uid, String phoneNumber, int diningDollars, int mealSwipes) async {
    try {
      await _firestore.collection('StudentData').doc(uid).set({
        'phoneNumber': phoneNumber,
        'diningDollars': diningDollars,
        'mealSwipes': mealSwipes,
      });
      print('User data added successfully.');
    } catch (e) {
      print('Error adding user data: $e');
      throw Exception('Failed to add user data.');
    }
  }
}
