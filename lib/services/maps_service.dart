import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';
import '../config/app_config.dart';

class MapsService {
  // Google Maps API key from config
  static const String _apiKey = AppConfig.googleMapsApiKey;
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';

  // Get eco-friendly route using Google Directions API
  static Future<EcoRoute?> getEcoRoute({
    required String origin,
    required String destination,
    String mode = 'walking', // walking, bicycling
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/directions/json?origin=$origin&destination=$destination&mode=$mode&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // Decode polyline
          final polylinePoints = _decodePolyline(
            route['overview_polyline']['points'],
          );

          // Calculate eco score based on mode and distance
          final distance = leg['distance']['value'] / 1000.0; // Convert to km
          int ecoScore = _calculateEcoScore(mode, distance);

          return EcoRoute(
            startLocation: leg['start_address'],
            endLocation: leg['end_address'],
            distance: distance,
            duration: leg['duration']['text'],
            polylinePoints: polylinePoints,
            transportMode: mode,
            ecoScore: ecoScore,
            greenZones: _getMockGreenZones(polylinePoints),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Mock geocoding for demo purposes
  static Future<LatLng?> geocodeAddress(String address) async {
    // Mock coordinates for demo
    final mockCoordinates = {
      'Central Park': LatLng(40.785091, -73.968285),
      'Times Square': LatLng(40.758896, -73.985130),
      'Brooklyn Bridge': LatLng(40.706086, -73.996864),
      'Current Location': LatLng(
        40.748817,
        -73.985428,
      ), // Empire State Building
    };

    return mockCoordinates[address] ?? LatLng(40.748817, -73.985428);
  }

  // Decode Google polyline
  static List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // Calculate eco score
  static int _calculateEcoScore(String mode, double distance) {
    int baseScore = 50;

    // Mode bonus
    if (mode == 'walking') baseScore += 40;
    if (mode == 'bicycling') baseScore += 30;

    // Distance penalty (longer routes get lower score)
    if (distance > 5) baseScore -= 20;
    if (distance > 10) baseScore -= 30;

    return baseScore.clamp(10, 100);
  }

  // Mock green zones
  static List<GreenZone> _getMockGreenZones(List<LatLng> polylinePoints) {
    if (polylinePoints.isEmpty) return [];

    return [
      GreenZone(
        name: 'Eco Park',
        position: polylinePoints[polylinePoints.length ~/ 3],
        radius: 100,
        type: 'park',
      ),
      GreenZone(
        name: 'Bike Path',
        position: polylinePoints[polylinePoints.length ~/ 2],
        radius: 50,
        type: 'bike_path',
      ),
    ];
  }
}
