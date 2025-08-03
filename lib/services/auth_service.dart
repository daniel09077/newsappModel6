import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app/models/user_profile.dart';
import 'package:news_app/models/user_role.dart';
import 'package:news_app/services/auth_service_base.dart';

/// A service to handle all user authentication and profile management using Firebase.
class AuthService extends AuthServiceBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream to get the user profile of the currently logged-in user
  @override
  Stream<UserProfile?> get userProfile {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return null;
      }
      try {
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          return UserProfile.fromFirestore(data);
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
      return null;
    });
  }

  /// Registers a new user with Firebase Authentication and stores their profile in Firestore.
  @override
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
    required String gender,
    File? profilePictureFile,
  }) async {
    try {
      // Create a user with a simple, temporary password for registration.
      // In a production app, you would handle this more securely.
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: regNo, // Using regNo as a temporary password
      );

      String? profilePictureUrl;
      if (profilePictureFile != null) {
        // Upload profile picture to Firebase Storage if provided
        profilePictureUrl = await _uploadProfilePicture(userCredential.user!.uid, profilePictureFile);
      } else {
        // Set default profile picture based on gender
        profilePictureUrl = _getDefaultProfilePictureUrl(gender);
      }

      // Create a new UserProfile instance
      final userProfile = UserProfile(
        regNo: regNo,
        email: email,
        firstName: firstName,
        lastName: lastName,
        otherNames: otherNames,
        department: department,
        programme: programme,
        college: college,
        role: (role is UserRole) ? role : UserRole.student,
        gender: gender,
        profilePictureUrl: profilePictureUrl,
      );

      // Save user profile to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userProfile.toFirestore());

      return userProfile;
    } on FirebaseAuthException catch (e) {
      print('Registration failed: ${e.code}');
      // Handle different Firebase Auth exceptions here (e.g., weak-password, email-already-in-use)
      return null;
    } catch (e) {
      print('An unexpected error occurred during registration: $e');
      return null;
    }
  }

  /// Logs in a user using their email and registration number.
  @override
  Future<UserProfile?> login(String regNo) async {
    try {
      final querySnapshot = await _firestore.collection('users').where('regNo', isEqualTo: regNo).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final email = userDoc.data()['email'];

        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: regNo,
        );

        final userProfile = await _fetchUserProfile(userCredential.user!.uid);
        return userProfile;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.code}');
      return null;
    } catch (e) {
      print('An unexpected error occurred during login: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Helper function to upload a profile picture to Firebase Storage.
  Future<String?> _uploadProfilePicture(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('user_profiles/$uid/profile_picture.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  /// Helper function to fetch a user profile from Firestore.
  Future<UserProfile?> _fetchUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        return UserProfile.fromFirestore(data);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile from Firestore: $e');
      return null;
    }
  }

  /// Helper function to get the default profile picture URL based on gender.
  String _getDefaultProfilePictureUrl(String gender) {
    if (gender.toLowerCase() == 'male') {
      return 'assets/images/male.jpg';
    } else {
      return 'assets/images/female.jpg';
    }
  }
}
