import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Set<String> selectedTags = {};
  bool showGenres = false;
  bool showTropes = false;

  void _toggleTag(String label) {
    setState(() {
      if (selectedTags.contains(label)) {
        selectedTags.remove(label);
      } else {
        selectedTags.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NAMN + LOGGA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sökfält
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search title or author',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.primaryContainer.withAlpha(20),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
            ),
          ),

          // Populära taggar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SelectableTagChip(
                  label: 'Romance',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true,
                ),
                _SelectableTagChip(
                  label: 'Fluff',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true,
                ),
                _SelectableTagChip(
                  label: 'Angst',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true,
                ),
                _SelectableTagChip(
                  label: 'Enemies to lovers',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filter-sektion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: const Text("Genres"),
                  leading: const Icon(Icons.category),
                  textColor: colorScheme.primary,
                  iconColor: colorScheme.primary,
                  onExpansionChanged: (expanded) {
                    setState(() => showGenres = expanded);
                  },
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SelectableTagChip(
                          label: 'Romance',
                          selectedTags: selectedTags,
                          onSelected: _toggleTag,
                          colorScheme: colorScheme,
                          usePopularStyle: true,
                        ),
                        _SelectableTagChip(
                          label: 'Fantasy',
                          selectedTags: selectedTags,
                          onSelected: _toggleTag,
                          colorScheme: colorScheme,
                          usePopularStyle: true,
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("Tropes"),
                  leading: const Icon(Icons.favorite),
                  textColor: colorScheme.primary,
                  iconColor: colorScheme.primary,
                  onExpansionChanged: (expanded) {
                    setState(() => showTropes = expanded);
                  },
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SelectableTagChip(
                          label: 'Angst',
                          selectedTags: selectedTags,
                          onSelected: _toggleTag,
                          colorScheme: colorScheme,
                          usePopularStyle: true,
                        ),
                        _SelectableTagChip(
                          label: 'Fluff',
                          selectedTags: selectedTags,
                          onSelected: _toggleTag,
                          colorScheme: colorScheme,
                          usePopularStyle: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search-knapp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => debugPrint("Valda taggar: $selectedTags"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Search tags'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Boklista scrollbar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size.fromHeight(140),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 100,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Boktitel $index",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Författare",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "#tag1  #tag2",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Komponent ---
class _SelectableTagChip extends StatelessWidget {
  final String label;
  final Set<String> selectedTags;
  final void Function(String) onSelected;
  final ColorScheme colorScheme;
  final bool usePopularStyle;

  const _SelectableTagChip({
    required this.label,
    required this.selectedTags,
    required this.onSelected,
    required this.colorScheme,
    this.usePopularStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTags.contains(label);

    final background = usePopularStyle
        ? colorScheme.secondaryContainer.withAlpha(50)
        : colorScheme.surfaceContainerHighest;
    final selectedColor = usePopularStyle
        ? colorScheme.secondaryContainer
        : colorScheme.secondaryContainer;
    final borderColor = usePopularStyle
        ? colorScheme.secondary
        : (isSelected ? colorScheme.secondary : colorScheme.outlineVariant);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(label),
      backgroundColor: background,
      selectedColor: selectedColor,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
