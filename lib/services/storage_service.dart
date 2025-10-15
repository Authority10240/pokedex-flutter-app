import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get theme preference
  String getTheme() {
    return _prefs?.getString(AppConstants.themeKey) ?? AppConstants.lightTheme;
  }

  /// Set theme preference
  Future<void> setTheme(String theme) async {
    await _prefs?.setString(AppConstants.themeKey, theme);
  }

  /// Get favorite Pokemon IDs
  List<int> getFavoritePokemonIds() {
    final List<String>? favoriteStrings = 
        _prefs?.getStringList(AppConstants.favoritesKey);
    
    if (favoriteStrings == null) return [];
    
    return favoriteStrings
        .map((id) => int.tryParse(id))
        .where((id) => id != null)
        .cast<int>()
        .toList();
  }

  /// Set favorite Pokemon IDs
  Future<void> setFavoritePokemonIds(List<int> ids) async {
    final List<String> favoriteStrings = ids.map((id) => id.toString()).toList();
    await _prefs?.setStringList(AppConstants.favoritesKey, favoriteStrings);
  }

  /// Add Pokemon to favorites
  Future<void> addToFavorites(int pokemonId) async {
    final List<int> favorites = getFavoritePokemonIds();
    if (!favorites.contains(pokemonId)) {
      favorites.add(pokemonId);
      await setFavoritePokemonIds(favorites);
    }
  }

  /// Remove Pokemon from favorites
  Future<void> removeFromFavorites(int pokemonId) async {
    final List<int> favorites = getFavoritePokemonIds();
    favorites.remove(pokemonId);
    await setFavoritePokemonIds(favorites);
  }

  /// Check if Pokemon is favorite
  bool isFavorite(int pokemonId) {
    final List<int> favorites = getFavoritePokemonIds();
    return favorites.contains(pokemonId);
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(int pokemonId) async {
    if (isFavorite(pokemonId)) {
      await removeFromFavorites(pokemonId);
      return false;
    } else {
      await addToFavorites(pokemonId);
      return true;
    }
  }

  /// Save user data
  Future<void> saveUser(AppUser user) async {
    final String userJson = json.encode(user.toJson());
    await _prefs?.setString(AppConstants.userKey, userJson);
  }

  /// Get saved user data
  AppUser? getUser() {
    final String? userJson = _prefs?.getString(AppConstants.userKey);
    if (userJson == null) return null;
    
    try {
      final Map<String, dynamic> userData = json.decode(userJson);
      return AppUser.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Clear user data
  Future<void> clearUser() async {
    await _prefs?.remove(AppConstants.userKey);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  /// Save search history
  Future<void> saveSearchHistory(List<String> searches) async {
    await _prefs?.setStringList('search_history', searches);
  }

  /// Get search history
  List<String> getSearchHistory() {
    return _prefs?.getStringList('search_history') ?? [];
  }

  /// Add to search history
  Future<void> addToSearchHistory(String query) async {
    final List<String> history = getSearchHistory();
    
    // Remove if already exists
    history.remove(query);
    
    // Add to beginning
    history.insert(0, query);
    
    // Keep only last 10 searches
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    await saveSearchHistory(history);
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    await _prefs?.remove('search_history');
  }
}
