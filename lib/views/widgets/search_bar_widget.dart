import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/pokemon_viewmodel.dart';
import '../../utils/extensions.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showSearchHistory = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          // Search TextField
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Search Pokémon...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onClear();
                        setState(() {
                          _showSearchHistory = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        setState(() {
                          _showSearchHistory = !_showSearchHistory;
                        });
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: context.theme.cardColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isEmpty) {
                widget.onClear();
              }
            },
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                widget.onSearch(value.trim());
                setState(() {
                  _showSearchHistory = false;
                });
              }
            },
            onTap: () {
              if (widget.controller.text.isEmpty) {
                setState(() {
                  _showSearchHistory = true;
                });
              }
            },
          ),
          
          // Search History
          if (_showSearchHistory)
            Consumer<PokemonViewModel>(
              builder: (context, pokemonViewModel, child) {
                final searchHistory = pokemonViewModel.searchHistory;
                
                if (searchHistory.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'No recent searches',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recent Searches',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                pokemonViewModel.clearSearchHistory();
                                setState(() {
                                  _showSearchHistory = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Clear',
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // History Items
                      ...searchHistory.take(5).map((query) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.search, size: 16),
                        title: Text(
                          query.capitalizeWords,
                          style: context.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          widget.controller.text = query;
                          widget.onSearch(query);
                          setState(() {
                            _showSearchHistory = false;
                          });
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.north_west, size: 16),
                          onPressed: () {
                            widget.controller.text = query;
                            setState(() {});
                          },
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
