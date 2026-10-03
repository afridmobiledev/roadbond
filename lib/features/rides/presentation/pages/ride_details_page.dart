import 'package:flutter/material.dart';

import '../../domain/ride.dart';

class RideDetailsPage extends StatelessWidget {
  const RideDetailsPage({
    required this.ride,
    super.key,
  });

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            ride.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            ride.startLocation,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          _DetailRow(
            label: 'Date',
            value: _formatDate(ride.dateTime),
          ),
          _DetailRow(
            label: 'Distance',
            value: '${ride.distanceMiles} miles',
          ),
          _DetailRow(
            label: 'Skill level',
            value: ride.skillLevel,
          ),
          _DetailRow(
            label: 'Open spots',
            value: '${ride.availableSpots}',
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Join request sent.'),
                ),
              );
            },
            child: const Text('Request to join'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

String _formatDate(DateTime dateTime) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '${months[dateTime.month - 1]} ${dateTime.day}, $hour:$minute $period';
}