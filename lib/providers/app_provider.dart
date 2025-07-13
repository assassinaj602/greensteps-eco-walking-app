import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/goal_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';
import '../services/maps_service.dart';
import '../services/goal_service.dart';

class AppProvider with ChangeNotifier {
  LatLng? _currentLocation;
  EcoRoute? _currentRoute;
  EcoGoal? _todayGoal;
  List<AppUser> _leaderboard = [];
  bool _isLoading = false;
  String? _error;
  double _todayDistance = 0.0;
  int _todayActivities = 0;

  // Getters
  LatLng? get currentLocation => _currentLocation;
  EcoRoute? get currentRoute => _currentRoute;
  EcoGoal? get todayGoal => _todayGoal;
  List<AppUser> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get todayDistance => _todayDistance;
  int get todayActivities => _todayActivities;

  // Initialize app data
  Future<void> initialize(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get current location
      await getCurrentLocation();

      // Load today's goal
      await loadTodayGoal(uid);

      // Load leaderboard
      await loadLeaderboard();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      _currentLocation = await LocationService.getCurrentLocation();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to get location: $e';
      notifyListeners();
    }
  }

  // Find eco route
  Future<void> findEcoRoute({
    required String origin,
    required String destination,
    String mode = 'walking',
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentRoute = await MapsService.getEcoRoute(
        origin: origin,
        destination: destination,
        mode: mode,
      );

      if (_currentRoute == null) {
        _error = 'Could not find route';
      }
    } catch (e) {
      _error = 'Failed to find route: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add distance walked
  Future<void> addDistance(String uid, double distance) async {
    try {
      await FirebaseService.addDistance(uid, distance);
      _todayDistance += distance;
      _todayActivities++;

      // Check if goal is completed
      if (_todayGoal != null && !_todayGoal!.isCompleted) {
        bool isCompleted = GoalService.checkGoalCompletion(
          _todayGoal!,
          _todayDistance,
          _todayActivities,
        );

        if (isCompleted) {
          await FirebaseService.completeGoal(uid, _todayGoal!.id);
          _todayGoal = EcoGoal(
            id: _todayGoal!.id,
            title: _todayGoal!.title,
            description: _todayGoal!.description,
            targetValue: _todayGoal!.targetValue,
            unit: _todayGoal!.unit,
            points: _todayGoal!.points,
            date: _todayGoal!.date,
            isCompleted: true,
          );
        }
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to add distance: $e';
      notifyListeners();
    }
  }

  // Load today's goal
  Future<void> loadTodayGoal(String uid) async {
    try {
      _todayGoal = await FirebaseService.getTodayGoal(uid);

      // Generate new goal if none exists
      if (_todayGoal == null) {
        _todayGoal = GoalService.generateDailyGoal();
        await FirebaseService.saveGoal(uid, _todayGoal!);
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load goal: $e';
      notifyListeners();
    }
  }

  // Load leaderboard
  Future<void> loadLeaderboard() async {
    try {
      _leaderboard = await FirebaseService.getLeaderboard();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load leaderboard: $e';
      notifyListeners();
    }
  }

  // Start route tracking
  void startRouteTracking(String uid) {
    if (_currentRoute == null) return;

    // Simulate completing the route
    Future.delayed(const Duration(seconds: 2), () {
      addDistance(uid, _currentRoute!.distance);
    });
  }

  // Clear current route
  void clearRoute() {
    _currentRoute = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
