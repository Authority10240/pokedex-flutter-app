class PokemonListItem {
  final String name;
  final String url;
  final int id;

  PokemonListItem({
    required this.name,
    required this.url,
    required this.id,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/")
    final url = json['url'] as String;
    final id = int.tryParse(url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
    
    return PokemonListItem(
      name: json['name'] ?? '',
      url: url,
      id: id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'id': id,
    };
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItem> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List)
              .map((item) => PokemonListItem.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}
