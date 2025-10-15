import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../utils/extensions.dart';

class TypeChipWidget extends StatelessWidget {
  final String type;

  const TypeChipWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = PokemonTypes.getTypeColor(type).toColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        type.capitalize,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
