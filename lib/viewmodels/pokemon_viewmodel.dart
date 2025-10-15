import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/pokemon_list.dart';
import '../services/pokemon_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

class PokemonViewModel extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  final StorageService _storageService = StorageService();

  // Pokemon List State
  List<PokemonListItem> _pokemonList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentOffset = 0;
  bool _hasMoreData = true;
  final int _limit = AppConstants.defaultLimit;

  // Search State
  List<PokemonListItem> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';
  List<String> _searchHistory = [];

  // Selected Pokemon State
  Pokemon? _selectedPokemon;
  bool _isLoadingPokemon = false;

  // Favorites State
  List<int> _favoritePokemonIds = [];
  List<Pokemon> _favoritePokemon = [];
  bool _isLoadingFavorites = false;

  // Getters
  List<PokemonListItem> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;

  List<PokemonListItem> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  List<String> get searchHistory => _searchHistory;

  Pokemon? get selectedPokemon => _selectedPokemon;
  bool get isLoadingPokemon => _isLoadingPokemon;

  List<int> get favoritePokemonIds => _favoritePokemonIds;
  List<Pokemon> get favoritePokemon => _favoritePokemon;
  bool get isLoadingFavorites => _isLoadingFavorites;

  PokemonViewModel() {
    _init();
  }

  /// Initialize ViewModel
  void _init() {
    _favoritePokemonIds = _storageService.getFavoritePokemonIds();
    _searchHistory = _storageService.getSearchHistory();
    loadPokemonList();
    if (_favoritePokemonIds.isNotEmpty) {
      loadFavoritePokemon();
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

  /// Load initial Pokemon list
  Future<void> loadPokemonList() async {
    try {
      _setLoading(true);
      _setError(null);
      _currentOffset = 0;
      _hasMoreData = true;

      final response = await _pokemonService.getPokemonList(
        offset: _currentOffset,
        limit: _limit,
      );

      _pokemonList = response.results;
      _currentOffset += _limit;
      _hasMoreData = response.next != null;

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load more Pokemon (pagination)
  Future<void> loadMorePokemon() async {
    if (_isLoadingMore || !_hasMoreData || _isSearching) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final response = await _pokemonService.getPokemonList(
        offset: _currentOffset,
        limit: _limit,
      );

      _pokemonList.addAll(response.results);
      _currentOffset += _limit;
      _hasMoreData = response.next != null;

    } catch (e) {
      _setError(e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search Pokemon
  Future<void> searchPokemon(String query) async {
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    try {
      _isSearching = true;
      _searchQuery = query;
      _setError(null);
      notifyListeners();

      final results = await _pokemonService.searchPokemon(query);
      _searchResults = results;
      
      // Keep _isSearching as true to show search results
      _isSearching = true;

      // Add to search history
      await _storageService.addToSearchHistory(query);
      _searchHistory = _storageService.getSearchHistory();

    } catch (e) {
      _setError(e.toString());
      _isSearching = false;
    } finally {
      notifyListeners();
    }
  }

  /// Clear search
  void _clearSearch() {
    _searchResults.clear();
    _isSearching = false;
    _searchQuery = '';
    notifyListeners();
  }

  /// Clear search and show all Pokemon
  void clearSearch() {
    _clearSearch();
  }

  /// Load Pokemon details
  Future<void> loadPokemon(String idOrName) async {
    try {
      _isLoadingPokemon = true;
      _selectedPokemon = null;
      _setError(null);
      notifyListeners();

      final pokemon = await _pokemonService.getPokemon(idOrName);
      _selectedPokemon = pokemon;

    } catch (e) {
      _setError(e.toString());
    } finally {
      _isLoadingPokemon = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(int pokemonId) async {
    try {
      final isFavorite = await _storageService.toggleFavorite(pokemonId);
      _favoritePokemonIds = _storageService.getFavoritePokemonIds();
      
      if (isFavorite) {
        // Add to favorites - load the Pokemon data
        try {
          final pokemon = await _pokemonService.getPokemon(pokemonId.toString());
          _favoritePokemon.add(pokemon);
        } catch (e) {
          // Handle error silently, the favorite was still added to storage
        }
      } else {
        // Remove from favorites
        _favoritePokemon.removeWhere((pokemon) => pokemon.id == pokemonId);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Error updating favorites: $e');
    }
  }

  /// Check if Pokemon is favorite
  bool isFavorite(int pokemonId) {
    return _favoritePokemonIds.contains(pokemonId);
  }

  /// Load all favorite Pokemon
  Future<void> loadFavoritePokemon() async {
    if (_favoritePokemonIds.isEmpty) {
      _favoritePokemon.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoadingFavorites = true;
      notifyListeners();

      final favoritePokemon = await _pokemonService.getPokemonByIds(_favoritePokemonIds);
      _favoritePokemon = favoritePokemon;

    } catch (e) {
      _setError('Error loading favorite Pokemon: $e');
    } finally {
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  /// Refresh Pokemon list
  Future<void> refresh() async {
    await loadPokemonList();
    if (_favoritePokemonIds.isNotEmpty) {
      await loadFavoritePokemon();
    }
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory.clear();
    notifyListeners();
  }

  /// Get Pokemon by list item
  Future<Pokemon?> getPokemonFromListItem(PokemonListItem item) async {
    try {
      return await _pokemonService.getPokemon(item.id.toString());
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _pokemonService.dispose();
    super.dispose();
  }
}
