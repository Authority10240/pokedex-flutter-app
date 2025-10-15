import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/pokemon_viewmodel.dart';
import '../../../utils/extensions.dart';
import '../../widgets/pokemon_card_widget.dart';
import '../pokemon/pokemon_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonViewModel>().loadFavoritePokemon();
    });
  }

  void _onPokemonTap(int pokemonId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemonId: pokemonId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        actions: [
          Consumer<PokemonViewModel>(
            builder: (context, pokemonViewModel, child) {
              final favoriteCount = pokemonViewModel.favoritePokemonIds.length;
              if (favoriteCount > 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '$favoriteCount ${favoriteCount == 1 ? 'Pokémon' : 'Pokémon'}',
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<PokemonViewModel>(
        builder: (context, pokemonViewModel, child) {
          if (pokemonViewModel.isLoadingFavorites) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pokemonViewModel.favoritePokemon.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Favorite Pokémon Yet',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any Pokémon to add them to your favorites!',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.explore),
                    label: const Text('Explore Pokémon'),
                  ),
                ],
              ),
            );
          }

          if (pokemonViewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pokemonViewModel.errorMessage!,
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => pokemonViewModel.loadFavoritePokemon(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => pokemonViewModel.loadFavoritePokemon(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isTablet ? 3 : 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pokemonViewModel.favoritePokemon.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonViewModel.favoritePokemon[index];
                return PokemonCardWidget(
                  pokemon: pokemon,
                  onTap: () => _onPokemonTap(pokemon.id),
                  onFavoriteToggle: () => pokemonViewModel.toggleFavorite(pokemon.id),
                  isFavorite: true, // All items in favorites are favorite
                );
              },
            ),
          );
        },
      ),
    );
  }
}
