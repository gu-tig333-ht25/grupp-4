import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> { //håller koll på vilka taggar som är valda
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
    final colorScheme = Theme.of(context).colorScheme; //hämtar temat och färger från main

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
      body: SingleChildScrollView( //gör sidan scrollbar
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sökfält
            TextField(
              decoration: InputDecoration(
                hintText: 'Search title or author',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.primaryContainer.withValues(alpha: 0.08), //opacity
                focusedBorder: OutlineInputBorder( //hur sökfältet ser ut när musen hovrar över
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder( //hur sökfältet ser ut när musen inte hovrar över
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
                _TagChip(label: 'Romance', colorScheme: colorScheme),
                _TagChip(label: 'Fluff', colorScheme: colorScheme),
                _TagChip(label: 'Angst', colorScheme: colorScheme),
                _TagChip(label: 'Enemies to lovers', colorScheme: colorScheme),
                _TagChip(label: 'Sci-fi', colorScheme: colorScheme),
                _TagChip(label: 'Fantasy', colorScheme: colorScheme),
                _TagChip(label: 'Friends to lovers', colorScheme: colorScheme),                  
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
                      horizontal: 8.0, vertical: 4.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SelectableTagChip(
                        label: 'Romance',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                      ),
                      _SelectableTagChip(
                        label: 'Fantasy',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                      ),
                      _SelectableTagChip(
                        label: 'Sci-fi',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
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
                      horizontal: 8.0, vertical: 4.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SelectableTagChip(
                        label: 'Angst',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                      ),
                      _SelectableTagChip(
                        label: 'Fluff',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                      ),
                      _SelectableTagChip(
                        label: 'Enemies to lovers',
                        selectedTags: selectedTags,
                        onSelected: _toggleTag,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            
            // Search tags-knapp
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

      // Bottennavigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, //vilken sida vi är på just nu, index 0 = search
        onTap: (_) {},
      ),
    );
  }
}

// --- Komponenter ---

class _TagChip extends StatelessWidget { //chip = rundad ruta med text
  final String label;
  final ColorScheme colorScheme;

  const _TagChip({
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: colorScheme.secondaryContainer.withValues(alpha: 0.2),
      side: BorderSide(color: colorScheme.secondary), //kantfärg
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
    );
  }
}

class _SelectableTagChip extends StatelessWidget {
  final String label;
  final Set<String> selectedTags;
  final void Function(String) onSelected;
  final ColorScheme colorScheme;

  const _SelectableTagChip({
    required this.label,
    required this.selectedTags,
    required this.onSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTags.contains(label);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(label),
      selectedColor: colorScheme.secondaryContainer,
      backgroundColor: colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
