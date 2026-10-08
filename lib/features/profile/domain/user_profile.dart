// Dart (Flutter)
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String bio;
  final String motorcycle;
  final String photoUrl;
  final int ridesCompleted;
  final double totalDistanceKm;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.bio = '',
    this.motorcycle = '',
    this.photoUrl = '',
    this.ridesCompleted = 0,
    this.totalDistanceKm = 0.0,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  // Fresh initial profile created upon sign-up
  factory UserProfile.fresh({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'bio': bio,
      'motorcycle': motorcycle,
      'photoUrl': photoUrl,
      'ridesCompleted': ridesCompleted,
      'totalDistanceKm': totalDistanceKm,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      email: map['email'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      motorcycle: map['motorcycle'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      ridesCompleted: (map['ridesCompleted'] as num?)?.toInt() ?? 0,
      totalDistanceKm: (map['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}