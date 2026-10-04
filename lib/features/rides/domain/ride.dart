// Dart (Flutter)
class Ride {
  const Ride({
    required this.id,
    required this.title,
    required this.startLocation,
    required this.dateTime,
    required this.skillLevel,
    required this.distanceMiles,
    required this.maxRiders,
    required this.joinedRiders,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String startLocation;
  final DateTime dateTime;
  final String skillLevel;
  final int distanceMiles;
  final int maxRiders;
  final int joinedRiders;
  final String imageUrl;

  int get availableSpots => maxRiders - joinedRiders;
}