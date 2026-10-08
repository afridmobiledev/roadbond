// Dart (Flutter)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../profile/domain/user_profile.dart';

class CrewModel {
  final String id;
  final String name;
  final String description;
  final String tag;
  final String creatorName;
  final String creatorId;
  final int membersCount;
  final List<String> memberIds;

  const CrewModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.creatorName,
    required this.creatorId,
    required this.membersCount,
    required this.memberIds,
  });

  factory CrewModel.fromMap(Map<String, dynamic> map, String id) {
    final rawIds = map['memberIds'] as List<dynamic>? ?? [];
    return CrewModel(
      id: id,
      name: map['name'] as String? ?? 'Riding Crew',
      description: map['description'] as String? ?? '',
      tag: map['tag'] as String? ?? 'General',
      creatorName: map['creatorName'] as String? ?? 'Rider',
      creatorId: map['creatorId'] as String? ?? '',
      membersCount: (map['membersCount'] as num?)?.toInt() ?? rawIds.length,
      memberIds: rawIds.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'tag': tag,
      'creatorName': creatorName,
      'creatorId': creatorId,
      'membersCount': membersCount,
      'memberIds': memberIds,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  void _showCreateGroupDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagCtrl = TextEditingController(text: 'Cruisers');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a Riding Crew',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Crew Name',
                  hintText: 'e.g. Melbourne Twisties Club',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Weekly weekend rides across mountain ranges',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagCtrl,
                decoration: InputDecoration(
                  labelText: 'Category / Tag',
                  hintText: 'e.g. Sport, Adventure, Touring',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final desc = descCtrl.text.trim();
                    final tag = tagCtrl.text.trim();
                    final user = FirebaseAuth.instance.currentUser;

                    if (name.isEmpty || user == null) return;

                    // Fetch creator profile for name display
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();
                    final creatorName = userDoc.data()?['firstName'] != null
                        ? '${userDoc.data()?['firstName']} ${userDoc.data()?['lastName']}'
                        : 'Rider';

                    final newCrew = CrewModel(
                      id: '',
                      name: name,
                      description: desc,
                      tag: tag.isNotEmpty ? tag : 'Riders',
                      creatorName: creatorName.trim(),
                      creatorId: user.uid,
                      membersCount: 1,
                      memberIds: [user.uid],
                    );

                    await FirebaseFirestore.instance
                        .collection('groups')
                        .add(newCrew.toMap());

                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Publish Crew',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleJoinGroup(CrewModel group, String currentUid) async {
    final groupRef =
    FirebaseFirestore.instance.collection('groups').doc(group.id);
    final isMember = group.memberIds.contains(currentUid);

    if (isMember) {
      await groupRef.update({
        'memberIds': FieldValue.arrayRemove([currentUid]),
        'membersCount': FieldValue.increment(-1),
      });
    } else {
      await groupRef.update({
        'memberIds': FieldValue.arrayUnion([currentUid]),
        'membersCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_outlined, color: AppColors.textDark),
            tooltip: 'Create Crew',
            onPressed: () => _showCreateGroupDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildLiveBanner(),
          const SizedBox(height: 24),
          _buildSectionHeader('NEARBY RIDERS', 'Riders on the road'),
          const SizedBox(height: 12),
          _buildRidersList(currentUid),
          const SizedBox(height: 28),
          _buildSectionHeader('RIDING CREWS', 'Popular groups'),
          const SizedBox(height: 12),
          _buildGroupsList(currentUid),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLiveBanner() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLime,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$count riders active near you',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Never ride solo.\nFind your crew today.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSectionHeader(String overline, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildRidersList(String? currentUid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 145,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.textDark,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final riders = (snapshot.data?.docs ?? [])
            .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
            .where((r) => r.uid != currentUid)
            .toList();

        if (riders.isEmpty) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Text(
              'No other riders online right now',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          );
        }

        return SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: riders.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = riders[index];
              final initial = member.firstName.isNotEmpty
                  ? member.firstName[0].toUpperCase()
                  : 'R';

              return Container(
                width: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.cardSurfaceLight,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      member.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      member.motorcycle.isNotEmpty
                          ? member.motorcycle
                          : 'Rider',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${member.ridesCompleted} rides',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGroupsList(String? currentUid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      // Sorted in descending order by membersCount
      stream: FirebaseFirestore.instance
          .collection('groups')
          .orderBy('membersCount', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.textDark,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final groups = (snapshot.data?.docs ?? [])
            .map((doc) => CrewModel.fromMap(doc.data(), doc.id))
            .toList();

        if (groups.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.groups_3_outlined,
                  size: 40,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No riding crews yet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Be the first to create a crew for your area or bike style!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showCreateGroupDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Create First Crew'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: groups.map((group) {
            final isJoined =
                currentUid != null && group.memberIds.contains(currentUid);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          group.description,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardSurfaceLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                group.tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${group.membersCount} members',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '· by ${group.creatorName}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: currentUid != null
                        ? () => _toggleJoinGroup(group, currentUid)
                        : null,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isJoined
                          ? AppColors.primaryLime.withValues(alpha: 0.25)
                          : Colors.transparent,
                      side: BorderSide(
                        color: isJoined
                            ? AppColors.primaryLime
                            : AppColors.borderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      isJoined ? 'Joined' : 'Join',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isJoined
                            ? const Color(0xFF14532D)
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}