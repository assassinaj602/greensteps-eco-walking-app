import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/goal_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Test Firebase connection
  static Future<bool> testConnection() async {
    try {
      Firebase.app();
      await _firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // User Management
  static Future<void> createUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<AppUser?> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Points and Distance tracking
  static Future<void> addDistance(String uid, double distance) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final points = (distance * 10).round(); // 10 points per km

      await userRef.update({
        'totalDistance': FieldValue.increment(distance),
        'ecoPoints': FieldValue.increment(points),
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });

      // Add activity record
      await _firestore.collection('activities').add({
        'uid': uid,
        'distance': distance,
        'points': points,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'walking',
      });
    } catch (e) {
      throw Exception('Failed to add distance: $e');
    }
  }

  // Badge management
  static Future<void> addBadge(String uid, String badge) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'badges': FieldValue.arrayUnion([badge]),
      });
    } catch (e) {
      throw Exception('Failed to add badge: $e');
    }
  }

  // Goals management
  static Future<void> saveGoal(String uid, EcoGoal goal) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('goals')
          .doc(goal.id)
          .set(goal.toMap());
    } catch (e) {
      throw Exception('Failed to save goal: $e');
    }
  }

  static Future<EcoGoal?> getTodayGoal(String uid) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('goals')
              .where(
                'date',
                isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
              )
              .where('date', isLessThan: endOfDay.millisecondsSinceEpoch)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return EcoGoal.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> completeGoal(String uid, String goalId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('goals')
          .doc(goalId)
          .update({'isCompleted': true});
    } catch (e) {
      throw Exception('Failed to complete goal: $e');
    }
  }

  // Leaderboard
  static Future<List<AppUser>> getLeaderboard() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .orderBy('ecoPoints', descending: true)
              .limit(10)
              .get();

      return querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
