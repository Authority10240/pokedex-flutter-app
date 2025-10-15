import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../viewmodels/pokemon_viewmodel.dart';
import '../../../utils/extensions.dart';
import '../../../constants/app_constants.dart';
import '../../widgets/stat_bar_widget.dart';
import '../../widgets/type_chip_widget.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonId,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonViewModel>().loadPokemon(widget.pokemonId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PokemonViewModel>(
        builder: (context, pokemonViewModel, child) {
          if (pokemonViewModel.isLoadingPokemon) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (pokemonViewModel.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
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
                      onPressed: () => pokemonViewModel.loadPokemon(
                        widget.pokemonId.toString(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pokemon = pokemonViewModel.selectedPokemon;
          if (pokemon == null) {
            return const Scaffold(
              body: Center(child: Text('No data available')),
            );
          }

          final primaryColor = pokemon.types.isNotEmpty
              ? PokemonTypes.getTypeColor(pokemon.types.first).toColor()
              : Colors.grey;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // App Bar with Pokemon Image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: primaryColor,
                  actions: [
                    IconButton(
                      icon: Icon(
                        pokemonViewModel.isFavorite(pokemon.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () => pokemonViewModel.toggleFavorite(pokemon.id),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      pokemon.name.capitalizeWords,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background Pattern
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.1,
                              child: Image.asset(
                                'assets/pokeball_pattern.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          
                          // Pokemon Image
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Hero(
                                tag: 'pokemon_${pokemon.id}',
                                child: CachedNetworkImage(
                                  imageUrl: pokemon.imageUrl,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      Icons.catching_pokemon,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Pokemon ID
                          Positioned(
                            top: 100,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '#${pokemon.id.toString().padLeft(3, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Pokemon Details
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Types
                          Row(
                            children: [
                              Text(
                                'Type',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              ...pokemon.types.map((type) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TypeChipWidget(type: type),
                              )),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Physical Stats
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Height',
                                  '${(pokemon.height / 10).toStringAsFixed(1)} m',
                                  Icons.height,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  'Weight',
                                  '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
                                  Icons.monitor_weight,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Description
                          if (pokemon.description.isNotEmpty) ...[
                            Text(
                              'About',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pokemon.description,
                              style: context.textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Stats
                          Text(
                            'Base Stats',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ...pokemon.stats.map((stat) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: StatBarWidget(
                              stat: stat,
                              color: primaryColor,
                            ),
                          )),
                          
                          const SizedBox(height: 24),
                          
                          // Abilities
                          if (pokemon.abilities.isNotEmpty) ...[
                            Text(
                              'Abilities',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: pokemon.abilities.map((ability) => Chip(
                                label: Text(ability.name.formatName),
                                avatar: ability.isHidden
                                    ? const Icon(Icons.visibility_off, size: 16)
                                    : null,
                              )).toList(),
                            ),
                          ],
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: context.theme.primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
