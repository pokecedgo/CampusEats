import 'package:flutter/material.dart';

// Global variables for student name and profile image
String studentName = "John Doe"; // Placeholder for student name
String profileImage = "assets/ravenclaw.jpg"; // Placeholder for profile image

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/ravenclaw.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // White Box
          Positioned(
            top: 420,
            left: 20,
            child: Container(
              width: 345, // Adjust the width
              height: 300, // Adjust the height
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 10, // Shadow blur
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Hogwarts Crest Image
                  Positioned(
                    top: 15,
                    left: 10,
                    child: Image.asset(
                      'assets/Hogwartscrest.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Text Container
                  Positioned(
                    top: 10,
                    left: 70,
                    child: Container(
                      width: 80, // Adjust the width dynamically
                      height: 60, // Adjust the height dynamically
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  Hogwarts',
                            style: TextStyle(
                              fontSize: 13, // Adjust font size dynamically
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(178, 139, 109, 76),
                            ),
                          ),
                          Divider(
                            color: const Color.fromARGB(255, 199, 112, 80),
                            thickness: 2, // Brown middle line
                          ),
                          Text(
                            '  University',
                            style: TextStyle(
                              fontSize: 12, // Adjust font size dynamically
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 156, 154, 154),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profile Section
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Column(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 50, 
                          backgroundImage: AssetImage(profileImage),
                        ),
                        SizedBox(height: 5), 
                        // Student Name
                        Text(
                          studentName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Student Role
                        Text(
                          'Student',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
