import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  //Huvudskärm för search_page
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //håller koll på vilka taggar som är valda
  final Set<String> selectedTags = {};
  bool showGenres = false; //om genre är öppen
  bool showTropes = false; //om tropes är öppen

  void _toggleTag(String label) {
    setState(() {
      if (selectedTags.contains(label)) {
        selectedTags.remove(label); //tar bort taggen om den redan är vald
      } else {
        selectedTags.add(label); //lägger till taggen om den inte är vald
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(
      context,
    ).colorScheme; //hämtar temat och färger från main
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
      body: SingleChildScrollView(
        //gör sidan scrollbar
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //börjar från vänster
          children: [
            TextField(
              //sökfält
              decoration: InputDecoration(
                hintText: 'Search title or author',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.primaryContainer.withValues(
                  alpha: 0.08,
                ), //opacity
                focusedBorder: OutlineInputBorder(
                  //hur sökfältet ser ut när musen hovrar över
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  //hur sökfältet ser ut när musen inte hovrar över
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Populära taggar
            Text(
              'Popular tags:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SelectableTagChip(
                  label: 'Romance',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true, //ger samma stil på alla knappar
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
                _SelectableTagChip(
                  label: 'Sci-fi',
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
                _SelectableTagChip(
                  label: 'Friends to lovers',
                  selectedTags: selectedTags,
                  onSelected: _toggleTag,
                  colorScheme: colorScheme,
                  usePopularStyle: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filtersektion
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),

            //Genrelistan
            ExpansionTile(
              title: const Text("Genres", style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.category),
              textColor: colorScheme.primary,
              iconColor: colorScheme.primary,
              onExpansionChanged: (bool expanded) {
                setState(() => showGenres = expanded);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Wrap(
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
                      _SelectableTagChip(
                        label: 'Sci-fi',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                        usePopularStyle: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //Tropeslistan
            ExpansionTile(
              title: const Text("Tropes", style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.favorite),
              textColor: colorScheme.primary,
              iconColor: colorScheme.primary,
              onExpansionChanged: (bool expanded) {
                setState(() => showTropes = expanded);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Wrap(
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
              ],
            ),

            const SizedBox(height: 24),

            // Search tagsknapp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Valda taggar: $selectedTags");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Search tags',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- Komponent ---

class _SelectableTagChip extends StatelessWidget {
  //klass för alla chip, gör usePopularStyle
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

    final background =
        usePopularStyle //dynamisk bakgrund och kant beroende på stil
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
      onSelected: (_) => onSelected(label), //kopplar med _toggleTag
      backgroundColor: background,
      selectedColor: selectedColor,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSecondaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
