import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/models/pokemon_list.dart';
import 'package:pokedex_app/views/widgets/pokemon_list_item.dart';

void main() {
  group('PokemonListItem Widget Tests', () {
    late PokemonListItem testPokemon;
    late VoidCallback mockOnTap;
    late VoidCallback mockOnFavoriteToggle;

    setUp(() {
      testPokemon = PokemonListItem(
        id: 1,
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );
      
      mockOnTap = () {};
      mockOnFavoriteToggle = () {};
    });

    testWidgets('should display Pokemon name correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Bulbasaur'), findsOneWidget);
    });

    testWidgets('should display Pokemon ID correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('#001'), findsOneWidget);
    });

    testWidgets('should show filled heart when favorite', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: true,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should show empty heart when not favorite', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      void onTap() => wasTapped = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: onTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should call onFavoriteToggle when heart is tapped', (WidgetTester tester) async {
      // Arrange
      bool wasToggled = false;
      void onFavoriteToggle() => wasToggled = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: onFavoriteToggle,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // Assert
      expect(wasToggled, isTrue);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: testPokemon,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert - Check that the widget can be found and is properly structured
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle Pokemon with different IDs correctly', (WidgetTester tester) async {
      // Arrange
      final pokemon150 = PokemonListItem(
        id: 150,
        name: 'mewtwo',
        url: 'https://pokeapi.co/api/v2/pokemon/150/',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonListItem(
              pokemon: pokemon150,
              onTap: mockOnTap,
              isFavorite: false,
              onFavoriteToggle: mockOnFavoriteToggle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('#150'), findsOneWidget);
      expect(find.text('Mewtwo'), findsOneWidget);
    });
  });
}
