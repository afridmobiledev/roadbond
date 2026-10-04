// Dart (Flutter)
import 'package:flutter/material.dart';
import '../../data/sample_rides.dart';
import '../widgets/ride_card.dart';
import 'ride_details_page.dart';

class DiscoverRidesPage extends StatefulWidget {
  const DiscoverRidesPage({super.key});

  @override
  State<DiscoverRidesPage> createState() => _DiscoverRidesPageState();
}

class _DiscoverRidesPageState extends State<DiscoverRidesPage> {
  static const _allLabel = 'All';

  late final List<String> _filters = [
    _allLabel,
    ...{for (final ride in sampleRides) ride.skillLevel},
  ];

  String _selected = _allLabel;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    // Recomputed on every filter/query modification
    final rides = sampleRides.where((ride) {
      final matchesSkill =
          _selected == _allLabel || ride.skillLevel == _selected;
      final searchText = '${ride.title} ${ride.startLocation}'.toLowerCase();
      final matchesQuery = searchText.contains(_query.toLowerCase());
      return matchesSkill && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F1),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: Branding and User Avatar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ROAD BOND RIDER',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE21B23),
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Discover rides',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF111111),
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Search routes, towns, or groups...',
                      hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF111111)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),

            // Horizontal Filter Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selected == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selected = filter),
                      selectedColor: const Color(0xFF111111),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF555555),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFFE5E2DC),
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming group rides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      '${rides.length} rides',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dynamic Ride Cards List
            if (rides.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No rides match your filter.\nTry adjusting your search criteria.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF777777), height: 1.4),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final ride = rides[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RideCard(
                          ride: ride,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RideDetailsPage(ride: ride),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: rides.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}