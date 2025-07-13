class AppConfig {
  // Google Maps API Key
  // Get this from: https://console.cloud.google.com/apis/credentials
  // Enable: Maps SDK for Android, Maps SDK for iOS, Maps JavaScript API, Directions API
  static const String googleMapsApiKey =
      'YOUR_ACTUAL_API_KEY_HERE'; // Replace with your actual API key

  // Firebase Configuration
  static const String projectId = 'green-field-5618b';

  // App Configuration
  static const String appName = 'GreenSteps';
  static const String appVersion = '1.0.0';

  // Points Configuration
  static const int pointsPerKm = 10;
  static const int badgeThreshold = 100;

  // Default Location (San Francisco)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
}
