import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';

class AuthService {
  static AuthService? _instance;
  factory AuthService({bool firebaseEnabled = false}) {
    _instance ??= AuthService._internal(firebaseEnabled: firebaseEnabled);
    return _instance!;
  }
  AuthService._internal({required this.firebaseEnabled});

  final bool firebaseEnabled;
  FirebaseAuth? _auth;
  
  FirebaseAuth? get auth {
    if (firebaseEnabled) {
      _auth ??= FirebaseAuth.instance;
    }
    return _auth;
  }

  /// Get current user
  User? get currentUser => auth?.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    if (firebaseEnabled && auth != null) {
      return auth!.authStateChanges();
    } else {
      // Return empty stream if Firebase is not available
      return const Stream<User?>.empty();
    }
  }

  /// Convert Firebase User to AppUser
  AppUser? _userFromFirebase(User? user) {
    if (user == null) return null;
    
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!firebaseEnabled || auth == null) {
      throw Exception('Authentication not available - Firebase not configured');
    }
    
    try {
      final UserCredential result = await auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception(AppConstants.authError);
    }
  }

  /// Register with email and password
  Future<AppUser?> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!firebaseEnabled || auth == null) {
      throw Exception('Authentication not available - Firebase not configured');
    }
    
    try {
      final UserCredential result = await auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await result.user?.updateDisplayName(displayName);
      }

      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception(AppConstants.authError);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (!firebaseEnabled || auth == null) {
      // No Firebase to sign out from, just return success
      return;
    }
    
    try {
      await auth!.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    if (!firebaseEnabled || auth == null) {
      throw Exception('Password reset not available - Firebase not configured');
    }
    
    try {
      await auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (!firebaseEnabled || auth == null) {
      throw Exception('Profile update not available - Firebase not configured');
    }
    
    try {
      final user = auth!.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    if (!firebaseEnabled || auth == null) {
      throw Exception('Account deletion not available - Firebase not configured');
    }
    
    try {
      final user = auth!.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error deleting account: $e');
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      default:
        return e.message ?? AppConstants.authError;
    }
  }
}
