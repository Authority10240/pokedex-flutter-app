import 'package:flutter/material.dart';
import '../../models/pokemon.dart';
import '../../utils/extensions.dart';

class StatBarWidget extends StatelessWidget {
  final PokemonStat stat;
  final Color color;

  const StatBarWidget({
    super.key,
    required this.stat,
    required this.color,
  });

  String _getStatDisplayName(String statName) {
    switch (statName) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return statName.formatName;
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxStat = 255; // Maximum possible stat value
    final percentage = (stat.baseStat / maxStat).clamp(0.0, 1.0);
    
    return Row(
      children: [
        // Stat Name
        SizedBox(
          width: 80,
          child: Text(
            _getStatDisplayName(stat.name),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Stat Value
        SizedBox(
          width: 40,
          child: Text(
            stat.baseStat.toString(),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Stat Bar
        Expanded(
          child: Stack(
            children: [
              // Background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              // Progress
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatColor(stat.name),
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        _getStatColor(stat.name),
                        _getStatColor(stat.name).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatColor(String statName) {
    switch (statName) {
      case 'hp':
        return Colors.red;
      case 'attack':
        return Colors.orange;
      case 'defense':
        return Colors.blue;
      case 'special-attack':
        return Colors.purple;
      case 'special-defense':
        return Colors.green;
      case 'speed':
        return Colors.pink;
      default:
        return color;
    }
  }
}
