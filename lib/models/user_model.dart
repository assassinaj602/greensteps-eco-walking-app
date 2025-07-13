// User model for GreenSteps app
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final int ecoPoints;
  final double totalDistance;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime lastActive;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.ecoPoints = 0,
    this.totalDistance = 0.0,
    this.badges = const [],
    required this.createdAt,
    required this.lastActive,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      ecoPoints: map['ecoPoints'] ?? 0,
      totalDistance: (map['totalDistance'] ?? 0.0).toDouble(),
      badges: List<String>.from(map['badges'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastActive: DateTime.fromMillisecondsSinceEpoch(map['lastActive'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'ecoPoints': ecoPoints,
      'totalDistance': totalDistance,
      'badges': badges,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastActive': lastActive.millisecondsSinceEpoch,
    };
  }

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    int? ecoPoints,
    double? totalDistance,
    List<String>? badges,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      ecoPoints: ecoPoints ?? this.ecoPoints,
      totalDistance: totalDistance ?? this.totalDistance,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
