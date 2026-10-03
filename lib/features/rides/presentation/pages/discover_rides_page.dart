import 'package:flutter/material.dart';

import '../../data/sample_rides.dart';
import '../widgets/ride_card.dart';
import 'ride_details_page.dart';

class DiscoverRidesPage extends StatelessWidget {
  const DiscoverRidesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          for (final ride in sampleRides) ...[
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