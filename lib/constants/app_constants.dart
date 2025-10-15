class AppConstants {
  // API
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const String pokemonEndpoint = '/pokemon';
  static const String pokemonSpeciesEndpoint = '/pokemon-species';
  
  // Pagination
  static const int defaultLimit = 20;
  static const int maxLimit = 100;
  
  // Theme
  static const String themeKey = 'app_theme';
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  
  // Favorites
  static const String favoritesKey = 'favorite_pokemon';
  
  // Auth
  static const String userKey = 'current_user';
  
  // Images
  static const String pokemonImageBaseUrl = 
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String notFoundError = 'Pokemon not found.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String favoriteAdded = 'Added to favorites!';
  static const String favoriteRemoved = 'Removed from favorites!';
}

class PokemonTypes {
  static const Map<String, String> typeColors = {
    'normal': '#A8A878',
    'fire': '#F08030',
    'water': '#6890F0',
    'electric': '#F8D030',
    'grass': '#78C850',
    'ice': '#98D8D8',
    'fighting': '#C03028',
    'poison': '#A040A0',
    'ground': '#E0C068',
    'flying': '#A890F0',
    'psychic': '#F85888',
    'bug': '#A8B820',
    'rock': '#B8A038',
    'ghost': '#705898',
    'dragon': '#7038F8',
    'dark': '#705848',
    'steel': '#B8B8D0',
    'fairy': '#EE99AC',
  };
  
  static String getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? '#68A090';
  }
}
