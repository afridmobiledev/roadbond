// Dart (Flutter)
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_profile.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  // Create or overwrite rider profile in Firestore
  Future<void> createProfile(UserProfile profile) async {
    await _users.doc(profile.uid).set(
      profile.toMap(),
      SetOptions(merge: true),
    );
  }

  // Fetch rider profile by Firebase Auth UID
  Future<UserProfile?> fetchProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfile.fromMap(doc.data()!, uid);
  }

  // Real-time stream of the signed-in rider's profile
  Stream<UserProfile?> streamProfile(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserProfile.fromMap(snapshot.data()!, uid);
    });
  }
}