import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../models/pokemon_list.dart';
import '../constants/app_constants.dart';

class PokemonService {
  static final PokemonService _instance = PokemonService._internal();
  factory PokemonService() => _instance;
  PokemonService._internal();

  final http.Client _client = http.Client();

  /// Fetch a paginated list of Pokemon
  Future<PokemonListResponse> getPokemonList({
    int offset = 0,
    int limit = AppConstants.defaultLimit,
  }) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.pokemonEndpoint}?offset=$offset&limit=$limit'
      );
      
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PokemonListResponse.fromJson(data);
      } else {
        throw HttpException('Failed to load Pokemon list: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException(AppConstants.networkError);
    } catch (e) {
      throw Exception('Error fetching Pokemon list: $e');
    }
  }

  /// Fetch detailed Pokemon data by ID or name
  Future<Pokemon> getPokemon(String idOrName) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.pokemonEndpoint}/$idOrName'
      );
      
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);
        
        // Fetch species data for description
        try {
          final speciesData = await _getPokemonSpecies(pokemon.id);
          final description = _extractDescription(speciesData);
          return pokemon.copyWith(description: description);
        } catch (e) {
          // Return pokemon without description if species fetch fails
          return pokemon;
        }
      } else if (response.statusCode == 404) {
        throw Exception(AppConstants.notFoundError);
      } else {
        throw HttpException('Failed to load Pokemon: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException(AppConstants.networkError);
    } catch (e) {
      throw Exception('Error fetching Pokemon: $e');
    }
  }

  /// Search Pokemon by name
  Future<List<PokemonListItem>> searchPokemon(String query) async {
    try {
      // For simplicity, we'll fetch all Pokemon and filter locally
      // In a production app, you might want to implement server-side search
      final allPokemon = await getPokemonList(limit: 1000);
      
      return allPokemon.results
          .where((pokemon) => 
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Error searching Pokemon: $e');
    }
  }

  /// Get multiple Pokemon by IDs (for favorites)
  Future<List<Pokemon>> getPokemonByIds(List<int> ids) async {
    try {
      final List<Pokemon> pokemonList = [];
      
      for (final id in ids) {
        try {
          final pokemon = await getPokemon(id.toString());
          pokemonList.add(pokemon);
        } catch (e) {
          // Skip failed requests and continue with others
          continue;
        }
      }
      
      return pokemonList;
    } catch (e) {
      throw Exception('Error fetching favorite Pokemon: $e');
    }
  }

  /// Fetch Pokemon species data for description
  Future<Map<String, dynamic>> _getPokemonSpecies(int id) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.pokemonSpeciesEndpoint}/$id'
    );
    
    final response = await _client.get(url);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw HttpException('Failed to load Pokemon species: ${response.statusCode}');
    }
  }

  /// Extract English description from species data
  String _extractDescription(Map<String, dynamic> speciesData) {
    try {
      final flavorTextEntries = speciesData['flavor_text_entries'] as List?;
      if (flavorTextEntries != null) {
        // Find English flavor text
        final englishEntry = flavorTextEntries.firstWhere(
          (entry) => entry['language']['name'] == 'en',
          orElse: () => flavorTextEntries.first,
        );
        
        String description = englishEntry['flavor_text'] ?? '';
        // Clean up the description by removing form feed and newline characters
        description = description.replaceAll('\f', ' ').replaceAll('\n', ' ');
        return description.trim();
      }
    } catch (e) {
      // Return empty string if extraction fails
    }
    return '';
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
