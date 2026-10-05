// Dart (Flutter)
class CommunityMember {
  const CommunityMember({
    required this.name,
    required this.bike,
    required this.location,
    required this.ridesCompleted,
    required this.avatarInitial,
    this.isOnline = false,
  });

  final String name;
  final String bike;
  final String location;
  final int ridesCompleted;
  final String avatarInitial;
  final bool isOnline;
}

class CommunityGroup {
  const CommunityGroup({
    required this.name,
    required this.membersCount,
    required this.tag,
    required this.description,
  });

  final String name;
  final int membersCount;
  final String tag;
  final String description;
}

const sampleMembers = <CommunityMember>[
  CommunityMember(
    name: 'Marcus Vance',
    bike: 'Ducati Scrambler 800',
    location: 'Melbourne CBD',
    ridesCompleted: 34,
    avatarInitial: 'M',
    isOnline: true,
  ),
  CommunityMember(
    name: 'Elena Rostova',
    bike: 'BMW R 1250 GS',
    location: 'Yarra Valley',
    ridesCompleted: 52,
    avatarInitial: 'E',
    isOnline: true,
  ),
  CommunityMember(
    name: 'Tariq Al-Mansoor',
    bike: 'Yamaha MT-09',
    location: 'St Kilda',
    ridesCompleted: 19,
    avatarInitial: 'T',
    isOnline: false,
  ),
  CommunityMember(
    name: 'Chloe Bennett',
    bike: 'Triumph Bonneville T120',
    location: 'Mornington',
    ridesCompleted: 27,
    avatarInitial: 'C',
    isOnline: true,
  ),
];

const sampleGroups = <CommunityGroup>[
  CommunityGroup(
    name: 'Melbourne Weekend Cruisers',
    membersCount: 420,
    tag: 'Casual',
    description: 'Relaxed weekend coffee rides and scenic twisties.',
  ),
  CommunityGroup(
    name: 'Apex Track & Twisties',
    membersCount: 185,
    tag: 'Advanced',
    description: 'Technical mountain runs and track-day meetups.',
  ),
  CommunityGroup(
    name: 'Adventure & Dual Sport VIC',
    membersCount: 310,
    tag: 'Off-road',
    description: 'Gravel, fire trails, and multi-day camping rides.',
  ),
];
