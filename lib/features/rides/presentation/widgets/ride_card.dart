import 'package:flutter/material.dart';

import '../../domain/ride.dart';

class RideCard extends StatelessWidget {
  const RideCard({
    required this.ride,
    required this.onTap,
    super.key,
  });

  final Ride ride;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ride.title,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('${ride.startLocation} • ${ride.distanceMiles} miles'),
              const SizedBox(height: 4),
              Text(
                '${ride.skillLevel} • ${ride.availableSpots} spots available',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}