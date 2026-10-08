// Dart (Flutter)
import 'package:firebase_auth/firebase_auth.dart';

import '../../profile/data/profile_repository.dart';
import '../../profile/domain/user_profile.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final ProfileRepository _profileRepo;

  AuthRepository({
    FirebaseAuth? auth,
    ProfileRepository? profileRepo,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _profileRepo = profileRepo ?? ProfileRepository();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register user in Firebase Auth and immediately generate blank rider profile
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'Registration succeeded but user is null.',
      );
    }

    final freshProfile = UserProfile.fresh(
      uid: user.uid,
      email: email.trim(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phone: phone.trim(),
    );

    await _profileRepo.createProfile(freshProfile);
    return freshProfile;
  }

  // Sign in existing user with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}