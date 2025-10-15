import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/pokemon.dart';
import '../../utils/extensions.dart';
import '../../constants/app_constants.dart';
import 'type_chip_widget.dart';

class PokemonCardWidget extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const PokemonCardWidget({
    super.key,
    required this.pokemon,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = pokemon.types.isNotEmpty
        ? PokemonTypes.getTypeColor(pokemon.types.first).toColor()
        : Colors.grey;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.1),
                primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with ID and Favorite
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Pokemon Image
              Expanded(
                flex: 3,
                child: Center(
                  child: Hero(
                    tag: 'pokemon_${pokemon.id}',
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.catching_pokemon,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Pokemon Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        pokemon.name.capitalizeWords,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Types
                      if (pokemon.types.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: pokemon.types.take(2).map((type) => 
                            TypeChipWidget(type: type),
                          ).toList(),
                        ),
                      
                      const Spacer(),
                      
                      // Stats Preview (HP and Attack)
                      if (pokemon.stats.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 12,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              pokemon.stats.isNotEmpty 
                                  ? pokemon.stats.first.baseStat.toString()
                                  : '0',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.flash_on,
                              size: 12,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              pokemon.stats.length > 1 
                                  ? pokemon.stats[1].baseStat.toString()
                                  : '0',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
