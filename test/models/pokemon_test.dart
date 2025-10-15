import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/models/pokemon.dart';

void main() {
  group('Pokemon Model Tests', () {
    test('should create Pokemon from JSON correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/',
        'height': 7,
        'weight': 69,
        'types': [
          {
            'type': {'name': 'grass'}
          },
          {
            'type': {'name': 'poison'}
          }
        ],
        'stats': [
          {
            'base_stat': 45,
            'effort': 0,
            'stat': {'name': 'hp'}
          }
        ],
        'abilities': [
          {
            'ability': {'name': 'overgrow'},
            'is_hidden': false,
            'slot': 1
          }
        ],
        'sprites': {
          'other': {
            'official-artwork': {
              'front_default': 'https://example.com/bulbasaur.png'
            }
          }
        }
      };

      // Act
      final pokemon = Pokemon.fromJson(json);

      // Assert
      expect(pokemon.id, equals(1));
      expect(pokemon.name, equals('bulbasaur'));
      expect(pokemon.height, equals(7));
      expect(pokemon.weight, equals(69));
      expect(pokemon.types, hasLength(2));
      expect(pokemon.types, contains('grass'));
      expect(pokemon.types, contains('poison'));
      expect(pokemon.stats, hasLength(1));
      expect(pokemon.stats.first.name, equals('hp'));
      expect(pokemon.abilities, hasLength(1));
      expect(pokemon.abilities.first.name, equals('overgrow'));
    });

    test('should handle missing fields gracefully', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'bulbasaur',
      };

      // Act
      final pokemon = Pokemon.fromJson(json);

      // Assert
      expect(pokemon.id, equals(1));
      expect(pokemon.name, equals('bulbasaur'));
      expect(pokemon.url, equals(''));
      expect(pokemon.types, isEmpty);
      expect(pokemon.stats, isEmpty);
      expect(pokemon.abilities, isEmpty);
      expect(pokemon.height, equals(0));
      expect(pokemon.weight, equals(0));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final pokemon = Pokemon(
        id: 1,
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
        types: ['grass', 'poison'],
        height: 7,
        weight: 69,
        stats: [
          PokemonStat(name: 'hp', baseStat: 45, effort: 0),
        ],
        abilities: [
          PokemonAbility(name: 'overgrow', isHidden: false, slot: 1),
        ],
        imageUrl: 'https://example.com/bulbasaur.png',
        description: 'A grass type Pokemon',
      );

      // Act
      final json = pokemon.toJson();

      // Assert
      expect(json['id'], equals(1));
      expect(json['name'], equals('bulbasaur'));
      expect(json['types'], contains('grass'));
      expect(json['types'], contains('poison'));
      expect(json['height'], equals(7));
      expect(json['weight'], equals(69));
      expect(json['description'], equals('A grass type Pokemon'));
    });

    test('should implement equality correctly', () {
      // Arrange
      final pokemon1 = Pokemon(
        id: 1,
        name: 'bulbasaur',
        url: '',
        types: [],
        height: 0,
        weight: 0,
        stats: [],
        abilities: [],
        imageUrl: '',
      );

      final pokemon2 = Pokemon(
        id: 1,
        name: 'different-name',
        url: '',
        types: [],
        height: 0,
        weight: 0,
        stats: [],
        abilities: [],
        imageUrl: '',
      );

      final pokemon3 = Pokemon(
        id: 2,
        name: 'bulbasaur',
        url: '',
        types: [],
        height: 0,
        weight: 0,
        stats: [],
        abilities: [],
        imageUrl: '',
      );

      // Act & Assert
      expect(pokemon1, equals(pokemon2)); // Same ID
      expect(pokemon1, isNot(equals(pokemon3))); // Different ID
      expect(pokemon1.hashCode, equals(pokemon2.hashCode));
      expect(pokemon1.hashCode, isNot(equals(pokemon3.hashCode)));
    });

    test('should create copy with updated values', () {
      // Arrange
      final original = Pokemon(
        id: 1,
        name: 'bulbasaur',
        url: '',
        types: ['grass'],
        height: 7,
        weight: 69,
        stats: [],
        abilities: [],
        imageUrl: '',
        description: 'Original description',
      );

      // Act
      final copy = original.copyWith(
        name: 'updated-name',
        description: 'Updated description',
      );

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.name, equals('updated-name'));
      expect(copy.description, equals('Updated description'));
      expect(copy.types, equals(original.types));
      expect(copy.height, equals(original.height));
    });
  });

  group('PokemonStat Tests', () {
    test('should create PokemonStat from JSON correctly', () {
      // Arrange
      final json = {
        'base_stat': 45,
        'effort': 0,
        'stat': {'name': 'hp'}
      };

      // Act
      final stat = PokemonStat.fromJson(json);

      // Assert
      expect(stat.baseStat, equals(45));
      expect(stat.effort, equals(0));
      expect(stat.name, equals('hp'));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final stat = PokemonStat(name: 'attack', baseStat: 62, effort: 0);

      // Act
      final json = stat.toJson();

      // Assert
      expect(json['name'], equals('attack'));
      expect(json['base_stat'], equals(62));
      expect(json['effort'], equals(0));
    });
  });

  group('PokemonAbility Tests', () {
    test('should create PokemonAbility from JSON correctly', () {
      // Arrange
      final json = {
        'ability': {'name': 'overgrow'},
        'is_hidden': false,
        'slot': 1
      };

      // Act
      final ability = PokemonAbility.fromJson(json);

      // Assert
      expect(ability.name, equals('overgrow'));
      expect(ability.isHidden, equals(false));
      expect(ability.slot, equals(1));
    });

    test('should handle hidden ability correctly', () {
      // Arrange
      final json = {
        'ability': {'name': 'chlorophyll'},
        'is_hidden': true,
        'slot': 3
      };

      // Act
      final ability = PokemonAbility.fromJson(json);

      // Assert
      expect(ability.name, equals('chlorophyll'));
      expect(ability.isHidden, equals(true));
      expect(ability.slot, equals(3));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final ability = PokemonAbility(
        name: 'blaze',
        isHidden: false,
        slot: 1,
      );

      // Act
      final json = ability.toJson();

      // Assert
      expect(json['name'], equals('blaze'));
      expect(json['is_hidden'], equals(false));
      expect(json['slot'], equals(1));
    });
  });
}
