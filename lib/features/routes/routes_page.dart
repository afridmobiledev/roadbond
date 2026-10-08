// Dart (Flutter)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class RouteModel {
  final String id;
  final String title;
  final String subtitle;
  final String rating;
  final int distanceKm;
  final String difficulty;

  const RouteModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.distanceKm,
    required this.difficulty,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    return RouteModel(
      id: id,
      title: map['title'] as String? ?? 'Scenic Road',
      subtitle: map['subtitle'] as String? ?? '',
      rating: map['rating'] as String? ?? '5.0 ★',
      distanceKm: (map['distanceKm'] as num?)?.toInt() ?? 0,
      difficulty: map['difficulty'] as String? ?? 'All Levels',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'rating': rating,
      'distanceKm': distanceKm,
      'difficulty': difficulty,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper to populate starter routes if your collection is newly created
  Future<void> _seedStarterRoutes() async {
    final routesCol = FirebaseFirestore.instance.collection('routes');

    final starterRoutes = [
      const RouteModel(
        id: '',
        title: 'Great Ocean Road',
        subtitle: '243 km · Advanced',
        rating: '4.9 ★ (120 reviews)',
        distanceKm: 243,
        difficulty: 'Advanced',
      ),
      const RouteModel(
        id: '',
        title: 'Reefton Spur Loop',
        subtitle: '140 km · Intermediate',
        rating: '4.8 ★ (85 reviews)',
        distanceKm: 140,
        difficulty: 'Intermediate',
      ),
      const RouteModel(
        id: '',
        title: 'Kinglake National Park Run',
        subtitle: '75 km · Beginner friendly',
        rating: '4.6 ★ (64 reviews)',
        distanceKm: 75,
        difficulty: 'Beginner friendly',
      ),
    ];

    for (final route in starterRoutes) {
      await routesCol.add(route.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Routes & Rides',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('routes').snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          final allRoutes = docs
              .map((doc) => RouteModel.fromMap(doc.data(), doc.id))
              .toList();

          // Client-side real-time query filtering
          final filteredRoutes = allRoutes.where((route) {
            if (_searchQuery.isEmpty) return true;
            final matchTitle = route.title.toLowerCase().contains(_searchQuery);
            final matchSubtitle =
            route.subtitle.toLowerCase().contains(_searchQuery);
            return matchTitle || matchSubtitle;
          }).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search mountain twisties, coastal routes...',
                  prefixIcon:
                  const Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => _searchController.clear(),
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.textDark),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textDark,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (allRoutes.isEmpty)
                _buildEmptyDatabaseState()
              else if (filteredRoutes.isEmpty)
                  _buildNoSearchResultsState()
                else
                  ...filteredRoutes.map((route) => _routeItem(
                    route.title,
                    route.subtitle,
                    route.rating,
                  )),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyDatabaseState() {
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
            Icons.alt_route_rounded,
            size: 44,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          const Text(
            'No routes in database yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Click below to seed the starter motorcycle routes into your Cloud Firestore.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _seedStarterRoutes,
            icon: const Icon(Icons.cloud_upload_outlined, size: 16),
            label: const Text('Seed Starter Routes'),
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

  Widget _buildNoSearchResultsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text(
              'No routes found for "$_searchQuery"',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _routeItem(String title, String subtitle, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            rating,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }
}