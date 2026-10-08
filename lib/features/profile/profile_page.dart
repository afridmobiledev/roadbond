// Dart (Flutter)
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_colors.dart';
import '../auth/data/auth_repository.dart';
import '../auth/onboarding_page.dart';
import 'data/profile_repository.dart';
import 'domain/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileRepo = ProfileRepository();
  final _authRepo = AuthRepository();
  final _picker = ImagePicker();

  bool _isProcessingPhoto = false;

  static const List<String> _riderEmojis = [
    '🏍️',
    '⚡',
    '🔥',
    '🦅',
    '🏁',
    '🚀',
    '🐺',
    '💀',
    '🌪️',
    '🛡️',
    '🏆',
    '⛰️',
    '🎯',
    '🦁',
    '👑',
    '🤘',
  ];

  Future<void> _handleSignOut() async {
    await _authRepo.signOut();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (route) => false,
    );
  }

  // Pick from gallery, crop in circle, compress to Base64, and save to Firestore
  // Dart (Flutter)
  Future<void> _pickCropAndSavePhoto(String currentUid) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (picked == null) return;

      // Circular crop matching LinkedIn / FB avatars
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressQuality: 70,
        maxWidth: 256,
        maxHeight: 256,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: AppColors.textDark,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.primaryLime,
            cropStyle: CropStyle.circle,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            cropStyle: CropStyle.circle,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (cropped == null) return;

      setState(() => _isProcessingPhoto = true);

      // Convert cropped image bytes to Base64 data string
      final bytes = await File(cropped.path).readAsBytes();
      final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Save directly into the user's document in Cloud Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .update({'photoUrl': base64String});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update photo: $e'),
            backgroundColor: AppColors.textDark,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessingPhoto = false);
    }
  }

  void _showAvatarOptions(
      BuildContext context,
      String currentUid,
      String initialLetter,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Avatar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),

                // 1. Upload & Crop Photo (LinkedIn / FB circular crop)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_camera_back_outlined,
                      color: AppColors.textDark,
                    ),
                  ),
                  title: const Text(
                    'Upload & Crop Photo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Select photo and crop circle avatar',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickCropAndSavePhoto(currentUid);
                  },
                ),

                const Divider(color: AppColors.borderLight),
                const SizedBox(height: 6),

                // 2. Select Emoji Badge
                const Text(
                  'Or pick a Rider Emoji:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _riderEmojis.length,
                  itemBuilder: (context, index) {
                    final emoji = _riderEmojis[index];
                    return InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUid)
                            .update({'photoUrl': emoji});
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardSurfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),

                // 3. Reset to letter
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUid)
                          .update({'photoUrl': ''});
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Reset to Name Initial',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarWidget(String photo, String initialLetter) {
    if (_isProcessingPhoto) {
      return const CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primaryLime,
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textDark,
          ),
        ),
      );
    }

    // Check if Base64 encoded image
    if (photo.startsWith('data:image')) {
      try {
        final base64Data = photo.split(',').last;
        final decodedBytes = base64Decode(base64Data);
        return CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLime,
          backgroundImage: MemoryImage(decodedBytes),
        );
      } catch (_) {
        // Fall back to initial letter if decode fails
      }
    }

    final isEmoji = photo.isNotEmpty;

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primaryLime,
      child: Text(
        isEmoji ? photo : initialLetter,
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: isEmoji ? 22 : 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      return const Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Center(
          child: Text(
            'No active user found. Please sign in.',
            style: TextStyle(color: AppColors.textDark),
          ),
        ),
      );
    }

    return StreamBuilder<UserProfile?>(
      stream: _profileRepo.streamProfile(currentUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.textDark),
            ),
          );
        }

        final profile = snapshot.data;
        final displayName = profile?.fullName.isNotEmpty == true
            ? profile!.fullName
            : 'Rider';
        final firstName = profile?.firstName.isNotEmpty == true
            ? profile!.firstName.toLowerCase()
            : 'rider';
        final initialLetter = displayName.substring(0, 1).toUpperCase();
        final photo = profile?.photoUrl ?? '';

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: Image.asset(
                        'lib/assets/images/profile_hero.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                        const ColoredBox(color: Color(0xFF1E2124)),
                      ),
                    ),
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ROAD BOND RIDER',
                                  style: TextStyle(
                                    color: AppColors.primaryLime,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Hey, $firstName.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Tap avatar to open crop/emoji options
                                GestureDetector(
                                  onTap: () => _showAvatarOptions(
                                    context,
                                    currentUid,
                                    initialLetter,
                                  ),
                                  child: Stack(
                                    children: [
                                      _buildAvatarWidget(photo, initialLetter),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: AppColors.primaryLime,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _handleSignOut,
                                  icon: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  tooltip: 'Sign out',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ROAD EXPLORER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile?.bio.isNotEmpty == true
                              ? profile!.bio
                              : 'Ready for new adventures. Tap your avatar above to crop a profile picture or pick an emoji badge!',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.borderLight),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _metric(
                              '${profile?.ridesCompleted ?? 0}',
                              'Rides attended',
                            ),
                            _divider(),
                            _metric(
                              '${(profile?.totalDistanceKm ?? 0).toInt()}',
                              'Driven miles',
                            ),
                            _divider(),
                            _metric('0', 'Places found'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR RIDE HISTORY',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Places you love',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRideHistory(profile?.ridesCompleted ?? 0),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRideHistory(int ridesCount) {
    if (ridesCount == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.two_wheeler_outlined,
              size: 40,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 10),
            Text(
              'No rides recorded yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Join upcoming community group rides to build your history.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _placeCard(
            'Black Spur',
            'Completed ride',
            'lib/assets/images/black_spur.png',
          ),
          const SizedBox(width: 12),
          _placeCard(
            'Coastal Run',
            'Completed ride',
            'lib/assets/images/coastal_run.png',
          ),
        ],
      ),
    );
  }

  static Widget _divider() => Container(
    width: 1,
    height: 32,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: AppColors.borderLight,
  );

  static Widget _metric(String val, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            val,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  static Widget _placeCard(String title, String subtitle, String imagePath) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}