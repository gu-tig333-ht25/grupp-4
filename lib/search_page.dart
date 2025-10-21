import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_info_page.dart';
import 'api_getbooks.dart';
import 'model.dart';
import 'tag_provider.dart'; // 👈 NY — importera din provider

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
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

  void _searchBooks(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<BookProvider>().fetchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookProvider = context.watch<BookProvider>();
    final tagProvider = context.watch<TagProvider>(); // 👈 NY

    // Visa laddningssnurra om taggarna inte hunnit laddas från Firebase
    if (tagProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Sökfält ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search title or author',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _searchBooks(context),
                  ),
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
                onSubmitted: (_) => _searchBooks(context),
              ),
            ),

            // --- Populära taggar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular tags:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: [
                        for (final tag in tagProvider.popularTags)
                          _SelectableTagChip(
                            label: tag,
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
            ),

            const SizedBox(height: 16),

            // --- Filter-sektion (Genres & Tropes) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final genre in tagProvider.genres)
                                _SelectableTagChip(
                                  label: genre,
                                  selectedTags: selectedTags,
                                  onSelected: _toggleTag,
                                  colorScheme: colorScheme,
                                ),
                            ],
                          ),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final trope in tagProvider.tropes)
                                _SelectableTagChip(
                                  label: trope,
                                  selectedTags: selectedTags,
                                  onSelected: _toggleTag,
                                  colorScheme: colorScheme,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Sökknapp ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _searchBooks(context),
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

            // --- Resultatlista ---
            Builder(
              builder: (context) {
                if (bookProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (bookProvider.books.isEmpty) {
                  return const Center(child: Text('No books found.'));
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookPage(book: book),
                            ),
                          );
                        },
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
                            // Omslag
                            Container(
                              width: 60,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(book.coverUrl),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Bokinfo
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.author,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.year > 0
                                        ? "Published: ${book.year}"
                                        : "",
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Komponent: väljbar tag ---
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
    final selectedColor = colorScheme.secondaryContainer;
    final borderColor = isSelected
        ? colorScheme.secondary
        : (usePopularStyle
              ? colorScheme.secondary
              : colorScheme.outlineVariant);

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
