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

  // Chip labels: "All" + unique skill levels from the data
  late final List<String> _filters = [
    _allLabel,
    ...{for (final ride in sampleRides) ride.skillLevel},
  ];

  String _selected = _allLabel;

  @override
  Widget build(BuildContext context) {
    // Recomputed on every rebuild after setState
    final rides = _selected == _allLabel
        ? sampleRides
        : sampleRides.where((r) => r.skillLevel == _selected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RoadBond'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Discover rides',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Find your next route and ride with your crew.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final filter in _filters)
                ChoiceChip(
                  label: Text(filter),
                  selected: _selected == filter,
                  // setState triggers rebuild with new filtered list
                  onSelected: (_) => setState(() => _selected = filter),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (rides.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(
                child: Text(
                  'No rides found for this level.\nTry another skill level.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            for (final ride in rides) ...[
              RideCard(
                ride: ride,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RideDetailsPage(ride: ride),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}