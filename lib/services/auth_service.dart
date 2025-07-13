import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Configure GoogleSignIn for web vs mobile
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // For web, we need to specify the client ID
    clientId:
        kIsWeb
            ? '873506873374-p1lvhgu83mu7qm9onobu1jbnroth83kc.apps.googleusercontent.com'
            : null,
  );

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web-specific sign-in flow
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        authProvider.addScope('email');
        authProvider.addScope('profile');

        final UserCredential userCredential = await _auth.signInWithPopup(
          authProvider,
        );

        // Create user in Firestore if new
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          final user = userCredential.user!;
          final appUser = AppUser(
            uid: user.uid,
            name: user.displayName ?? 'Green Walker',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
          );
          await FirebaseService.createUser(appUser);
        }

        return userCredential;
      } else {
        // Mobile sign-in flow
        // Sign out any existing user first
        await _googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        // Create user in Firestore if new
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          final user = userCredential.user!;
          final appUser = AppUser(
            uid: user.uid,
            name: user.displayName ?? 'Green Walker',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
          );
          await FirebaseService.createUser(appUser);
        }

        return userCredential;
      }
    } catch (e) {
      throw Exception('Google Sign In failed: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      if (kIsWeb) {
        await _auth.signOut();
      } else {
        await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      }
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Delete account
  static Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }
}
