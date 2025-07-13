// Route model for eco-friendly routes
class EcoRoute {
  final String startLocation;
  final String endLocation;
  final double distance;
  final String duration;
  final List<LatLng> polylinePoints;
  final String transportMode;
  final int ecoScore;
  final List<GreenZone> greenZones;

  EcoRoute({
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.polylinePoints,
    required this.transportMode,
    required this.ecoScore,
    this.greenZones = const [],
  });
}

// LatLng model for coordinates
class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

// Green zones model (parks, eco-friendly areas)
class GreenZone {
  final String name;
  final LatLng position;
  final double radius;
  final String type; // park, bike_path, electric_charging, etc.

  GreenZone({
    required this.name,
    required this.position,
    required this.radius,
    required this.type,
  });
}
