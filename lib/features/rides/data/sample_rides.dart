import '../domain/ride.dart';

final sampleRides = <Ride>[
  Ride(
    id: 'hudson-valley-ride',
    title: 'Sunday Hudson Valley Ride',
    startLocation: 'Manhattan, NY',
    dateTime: DateTime(2026, 10, 11, 9),
    skillLevel: 'Intermediate',
    distanceMiles: 110,
    maxRiders: 12,
    joinedRiders: 7,
  ),
  Ride(
    id: 'brooklyn-coastal-loop',
    title: 'Brooklyn Coastal Loop',
    startLocation: 'Brooklyn Bridge Park, NY',
    dateTime: DateTime(2026, 10, 12, 10),
    skillLevel: 'Beginner friendly',
    distanceMiles: 45,
    maxRiders: 10,
    joinedRiders: 4,
  ),
  Ride(
    id: 'bear-mountain-scenic',
    title: 'Bear Mountain Scenic Ride',
    startLocation: 'Yonkers, NY',
    dateTime: DateTime(2026, 10, 18, 8, 30),
    skillLevel: 'Advanced',
    distanceMiles: 140,
    maxRiders: 8,
    joinedRiders: 6,
  ),
];