class UserModel {
  final String email;
  final String name;
  final String phoneNumber;

  UserModel({
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  // Convert user data to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  // Create a user object from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
