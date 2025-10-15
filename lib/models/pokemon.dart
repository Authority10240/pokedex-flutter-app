class Pokemon {
  final int id;
  final String name;
  final String url;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final String imageUrl;
  final String description;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.imageUrl,
    this.description = '',
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      types: json['types'] != null
          ? (json['types'] as List)
              .map((type) => type['type']['name'] as String)
              .toList()
          : [],
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      stats: json['stats'] != null
          ? (json['stats'] as List)
              .map((stat) => PokemonStat.fromJson(stat))
              .toList()
          : [],
      abilities: json['abilities'] != null
          ? (json['abilities'] as List)
              .map((ability) => PokemonAbility.fromJson(ability))
              .toList()
          : [],
      imageUrl: json['sprites']?['other']?['official-artwork']?['front_default'] ?? 
                json['sprites']?['front_default'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'types': types,
      'height': height,
      'weight': weight,
      'stats': stats.map((stat) => stat.toJson()).toList(),
      'abilities': abilities.map((ability) => ability.toJson()).toList(),
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  Pokemon copyWith({
    int? id,
    String? name,
    String? url,
    List<String>? types,
    int? height,
    int? weight,
    List<PokemonStat>? stats,
    List<PokemonAbility>? abilities,
    String? imageUrl,
    String? description,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      types: types ?? this.types,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      stats: stats ?? this.stats,
      abilities: abilities ?? this.abilities,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class PokemonStat {
  final String name;
  final int baseStat;
  final int effort;

  PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'] ?? '',
      baseStat: json['base_stat'] ?? 0,
      effort: json['effort'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'base_stat': baseStat,
      'effort': effort,
    };
  }
}

class PokemonAbility {
  final String name;
  final bool isHidden;
  final int slot;

  PokemonAbility({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['ability']['name'] ?? '',
      isHidden: json['is_hidden'] ?? false,
      slot: json['slot'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_hidden': isHidden,
      'slot': slot,
    };
  }
}
