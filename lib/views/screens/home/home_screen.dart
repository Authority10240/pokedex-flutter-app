import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/pokemon_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/theme_viewmodel.dart';
import '../../../utils/extensions.dart';
import '../../widgets/pokemon_list_item.dart';
import '../../widgets/search_bar_widget.dart';
import '../pokemon/pokemon_detail_screen.dart';
import '../favorites/favorites_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    
    // Load Pokemon data on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pokemonViewModel = context.read<PokemonViewModel>();
      if (pokemonViewModel.pokemonList.isEmpty) {
        pokemonViewModel.loadPokemonList();
      }
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more when near the bottom
        context.read<PokemonViewModel>().loadMorePokemon();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onPokemonTap(int pokemonId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemonId: pokemonId),
      ),
    );
  }

  void _showProfileBottomSheet() {
    final authViewModel = context.read<AuthViewModel>();
    final themeViewModel = context.read<ThemeViewModel>();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // User Info
            if (authViewModel.currentUser != null) ...[
              CircleAvatar(
                radius: 30,
                backgroundColor: context.theme.primaryColor,
                child: Text(
                  authViewModel.currentUser!.email[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                authViewModel.currentUser!.displayName ?? 
                    authViewModel.currentUser!.email,
                style: context.textTheme.titleMedium,
              ),
              if (authViewModel.currentUser!.displayName != null)
                Text(
                  authViewModel.currentUser!.email,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              const SizedBox(height: 20),
            ],
            
            // Theme Toggle
            ListTile(
              leading: Icon(
                themeViewModel.isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
              ),
              title: Text(
                themeViewModel.isDarkMode 
                    ? 'Light Theme' 
                    : 'Dark Theme',
              ),
              onTap: () {
                themeViewModel.toggleTheme();
                Navigator.pop(context);
              },
            ),
            
            // Favorites
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
            
            // Sign Out
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await authViewModel.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          Consumer<PokemonViewModel>(
            builder: (context, pokemonViewModel, child) {
              final favoriteCount = pokemonViewModel.favoritePokemonIds.length;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  if (favoriteCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoriteCount > 99 ? '99+' : favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showProfileBottomSheet,
          ),
        ],
      ),
      body: Consumer<PokemonViewModel>(
        builder: (context, pokemonViewModel, child) {
          if (pokemonViewModel.isLoading && pokemonViewModel.pokemonList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pokemonViewModel.errorMessage != null && 
              pokemonViewModel.pokemonList.isEmpty) {
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
                    onPressed: () => pokemonViewModel.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => pokemonViewModel.refresh(),
            child: Column(
              children: [
                // Search Bar
                SearchBarWidget(
                  controller: _searchController,
                  onSearch: pokemonViewModel.searchPokemon,
                  onClear: pokemonViewModel.clearSearch,
                ),
                
                // Pokemon Grid
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.isTablet ? 4 : 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: pokemonViewModel.isSearching
                        ? pokemonViewModel.searchResults.length
                        : pokemonViewModel.pokemonList.length +
                            (pokemonViewModel.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      final pokemonList = pokemonViewModel.isSearching
                          ? pokemonViewModel.searchResults
                          : pokemonViewModel.pokemonList;

                      if (index >= pokemonList.length) {
                        // Loading more indicator
                        return const Card(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final pokemon = pokemonList[index];
                      return PokemonListItemWidget(
                        pokemon: pokemon,
                        onTap: () => _onPokemonTap(pokemon.id),
                        isFavorite: pokemonViewModel.isFavorite(pokemon.id),
                        onFavoriteToggle: () =>
                            pokemonViewModel.toggleFavorite(pokemon.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
