import 'package:news_app/models/user_role.dart';

class UserProfile {
  final String regNo;
  final String email;
  final String firstName; // New field
  final String lastName; // New field
  final String? otherNames; // New optional field
  final String department;
  final String programme;
  final String college;
  final UserRole role;
  final String gender; // New field
  final String? profilePictureUrl;

  UserProfile({
    required this.regNo,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.otherNames,
    required this.department,
    required this.programme,
    required this.college,
    required this.role,
    required this.gender,
    this.profilePictureUrl,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      regNo: data['regNo'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      otherNames: data['otherNames'],
      department: data['department'] ?? '',
      programme: data['programme'] ?? '',
      college: data['college'] ?? '',
      role: (data['role'] == 'admin') ? UserRole.admin : UserRole.student,
      gender: data['gender'] ?? 'male', // Default to male if not present
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'regNo': regNo,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'otherNames': otherNames,
      'department': department,
      'programme': programme,
      'college': college,
      'role': role == UserRole.admin ? 'admin' : 'student',
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
