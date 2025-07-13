import 'dart:math';
import '../models/goal_model.dart';

class GoalService {
  // Predefined eco goals
  static final List<Map<String, dynamic>> _ecoGoals = [
    {
      'title': 'Green Walker',
      'description': 'Walk 2 kilometers today',
      'targetValue': 2,
      'unit': 'km',
      'points': 20,
    },
    {
      'title': 'Eco Explorer',
      'description': 'Walk 3 kilometers today',
      'targetValue': 3,
      'unit': 'km',
      'points': 30,
    },
    {
      'title': 'Nature Lover',
      'description': 'Walk 5 kilometers today',
      'targetValue': 5,
      'unit': 'km',
      'points': 50,
    },
    {
      'title': 'Carbon Saver',
      'description': 'Take an eco-friendly route',
      'targetValue': 1,
      'unit': 'route',
      'points': 15,
    },
    {
      'title': 'Green Commuter',
      'description': 'Walk instead of driving',
      'targetValue': 1,
      'unit': 'trip',
      'points': 25,
    },
    {
      'title': 'Park Visitor',
      'description': 'Visit a green zone',
      'targetValue': 1,
      'unit': 'visit',
      'points': 10,
    },
    {
      'title': 'Bike Rider',
      'description': 'Use bicycle for 5 km',
      'targetValue': 5,
      'unit': 'km',
      'points': 40,
    },
    {
      'title': 'Eco Champion',
      'description': 'Complete 3 eco activities',
      'targetValue': 3,
      'unit': 'activities',
      'points': 60,
    },
  ];

  // Generate daily goal
  static EcoGoal generateDailyGoal() {
    final random = Random();
    final goalTemplate = _ecoGoals[random.nextInt(_ecoGoals.length)];
    final now = DateTime.now();

    return EcoGoal(
      id: 'goal_${now.year}${now.month}${now.day}',
      title: goalTemplate['title'],
      description: goalTemplate['description'],
      targetValue: goalTemplate['targetValue'],
      unit: goalTemplate['unit'],
      points: goalTemplate['points'],
      date: DateTime(now.year, now.month, now.day),
    );
  }

  // Check if goal is completed based on user stats
  static bool checkGoalCompletion(
    EcoGoal goal,
    double userDistance,
    int userActivities,
  ) {
    switch (goal.unit) {
      case 'km':
        return userDistance >= goal.targetValue;
      case 'route':
      case 'trip':
      case 'visit':
      case 'activities':
        return userActivities >= goal.targetValue;
      default:
        return false;
    }
  }

  // Get badge for points milestone
  static String? getBadgeForPoints(int points) {
    if (points >= 1000) return 'Eco Legend 🌍';
    if (points >= 500) return 'Green Champion 🏆';
    if (points >= 250) return 'Nature Hero 🌳';
    if (points >= 100) return 'Eco Warrior ⚡';
    if (points >= 50) return 'Green Walker 🚶';
    return null;
  }

  // Get motivational messages
  static List<String> getMotivationalMessages() {
    return [
      'Every step counts! 🌱',
      'You\'re making a difference! 🌍',
      'Keep walking for our planet! 🚶‍♀️',
      'Green is the new black! 💚',
      'Small steps, big impact! 👣',
      'Nature loves your effort! 🌳',
      'Eco-friendly is the way! ♻️',
      'Walking towards a better future! 🌅',
    ];
  }
}
