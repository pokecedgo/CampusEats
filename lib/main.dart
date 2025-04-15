import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; 
import 'screens/third_party_auth_screen.dart'; // Ensure this path is correct
import 'services/UserCreator.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// false/true to activate user creation
const bool ActivateOnRun = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (ActivateOnRun) {
    // Create a new user when the program starts
    final userCreator = UserCreator();
    try {
      await userCreator.createUser(
        email: 'bob@hogwarts.edu.com', // Will be converted to bob@hogwarts.edu
        password: 'securePassword123',
        phoneNumber: '8456768997(test number)', // Will be converted to +8455515968
        diningDollars: 100,
        mealSwipes: 50,
      );
      print('User created successfully.');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(), 
      routes: {
        '/thirdPartyAuth': (context) => ThirdPartyAuthScreen(), 
      },
    );
  }
}