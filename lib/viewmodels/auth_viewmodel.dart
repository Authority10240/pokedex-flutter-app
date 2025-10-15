import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  late final AuthService _authService;
  final StorageService _storageService = StorageService();
  final bool _firebaseEnabled;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  bool get firebaseEnabled => _firebaseEnabled;

  AuthViewModel({bool firebaseEnabled = false}) : _firebaseEnabled = firebaseEnabled {
    _authService = AuthService(firebaseEnabled: firebaseEnabled);
    _init();
  }

  /// Initialize auth state
  void _init() {
    if (_firebaseEnabled) {
      // Listen to auth state changes
      _authService.authStateChanges.listen((user) {
        if (user != null) {
          _currentUser = AppUser(
            id: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            photoUrl: user.photoURL,
            createdAt: user.metadata.creationTime ?? DateTime.now(),
          );
          _isAuthenticated = true;
          
          // Save user to local storage
          _storageService.saveUser(_currentUser!);
        } else {
          _currentUser = null;
          _isAuthenticated = false;
          _storageService.clearUser();
        }
        notifyListeners();
      });

      // Check if user is already signed in
      final firebaseUser = _authService.currentUser;
      if (firebaseUser != null) {
        _currentUser = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        );
        _isAuthenticated = true;
      } else {
        // Try to get user from local storage
        _currentUser = _storageService.getUser();
        _isAuthenticated = _currentUser != null;
      }
    } else {
      // Firebase not enabled, check local storage only
      _currentUser = _storageService.getUser();
      _isAuthenticated = _currentUser != null;
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _setError(null);
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _setError(null);
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register with email and password
  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _setError(null);
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      // Update local user object
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          displayName: displayName ?? _currentUser!.displayName,
          photoUrl: photoUrl ?? _currentUser!.photoUrl,
        );
        await _storageService.saveUser(_currentUser!);
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.deleteAccount();
      _currentUser = null;
      _isAuthenticated = false;
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
