import 'dart:io';
import 'package:news_app/models/user_profile.dart';

/// An abstract base class defining the contract for our authentication service.
/// This allows for easy swapping of the concrete implementation (e.g., for testing).
abstract class AuthServiceBase {
  /// Attempts to log in a user with their registration number.
  /// Throws an exception if login fails.
  Future<UserProfile?> login(String regNo);

  /// Attempts to register a new user with the provided details.
  /// Returns the UserProfile if successful, or null if registration fails.
  Future<UserProfile?> registerUser({
    required String regNo,
    required String email,
    required String firstName,
    required String lastName,
    String? otherNames,
    required String department,
    required String programme,
    required String college,
    required dynamic role,
    required String gender, // Added gender field
    File? profilePictureFile,
  });

  /// Logs out the currently signed-in user.
  Future<void> logout();

  /// Gets the currently authenticated user's profile.
  Stream<UserProfile?> get userProfile;
}
