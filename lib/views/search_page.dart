import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_info_page.dart';
import '../providers/book_provider.dart';
import '../models/global_tags.dart';

class SearchPage extends StatefulWidget {
  //statefulpage as to change over time (like selecting tags)
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState(); //tells flutter that this widgets state will be managed by _SearchPageState
}

class _SearchPageState extends State<SearchPage> {
  //holds mutable data and logic
  final TextEditingController _searchController =
      TextEditingController(); //manages text user types in search box
  final Set<String> selectedTags = {}; //set = unique collection
  bool showGenres =
      false; //tracks whether or not genre and tropes are expanded, start collapsed
  bool showTropes = false;

  void _toggleTag(String label) {
    //helper function
    setState(() {
      //set state to rebuild UI when new tag is selected or unselected
      if (selectedTags.contains(label)) {
        //if pressed and already contains a checkmark, take checkmark away
        selectedTags.remove(label);
      } else {
        selectedTags.add(label); //otherwise add a checkmark
      }
    });
  }

  void _searchBooks(BuildContext context) {
    //helper function
    final query = _searchController.text
        .trim(); //read text user types, remove extra spaces
    if (query.isNotEmpty) {
      context.read<BookProvider>().fetchBooks(
        query,
      ); //if not empty call BookProvider
    }
  }

  @override
  Widget build(BuildContext context) {
    //UI
    final colorScheme = Theme.of(context).colorScheme; //colorscheme from main
    final bookProvider = context
        .watch<BookProvider>(); //watch for changes in book data, update UI

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paige',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        //makes whole page scrollable
        child: Column(
          children: [
            // Searchfield
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search title or author',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _searchBooks(
                      context,
                    ), //when pressing enter or send icon, run _searchBooks()
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
                onSubmitted: (_) => _searchBooks(
                  context,
                ), //when pressing enter or send icon, run _searchBooks()
              ),
            ),

            // Popular tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //header for popular tags
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
                      //lays out chips, wrap to new line when needed
                      spacing: 8,
                      runSpacing: 5,
                      children: [
                        for (final tag
                            in listPopular) //for each tag in listPopular, create a _SelectableTagChip
                          _SelectableTagChip(
                            label: tag,
                            selectedTags: selectedTags,
                            onSelected:
                                _toggleTag, //when pressed call _toggleTag
                            colorScheme: colorScheme,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    //lets Genres expand/collapse
                    title: const Text("Genres"),
                    leading: const Icon(Icons.category),
                    textColor: colorScheme.primary,
                    iconColor: colorScheme.primary,
                    onExpansionChanged: (expanded) {
                      //callback for bool value
                      setState(
                        () => showGenres = expanded,
                      ); //setState to change UI depending on expansion true/false
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
                              for (final genre
                                  in listGenre) //for each genre in listGenre make a chip
                                _SelectableTagChip(
                                  //same type of chip for tropes and genres
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
                  //Same as genres but for Tropes
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
                              for (final trope in listTropes)
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
            const SizedBox(
              height: 16,
            ), //SizedBox for some space inbetween widgets
            //Search function
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double
                    .infinity, //Button takes up the full available width of parent
                child: ElevatedButton(
                  onPressed: () async {
                    final bookProvider = context
                        .read<
                          BookProvider
                        >(); //being able to fetch books and their data from BookProvider

                    if (selectedTags.isNotEmpty) {
                      //if any filter chips are selected
                      await bookProvider.searchBooksByTags(
                        selectedTags,
                      ); //call searchBooksByTags based on those tags
                    } else {
                      _searchBooks(
                        context,
                      ); //if no tags selected call _searchBooks (search by author/title)
                    }
                  },
                  //Search button
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

            //Book list
            Builder(
              builder: (context) {
                if (bookProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); //show buffering spinner when loading
                }

                if (bookProvider.books.isEmpty) {
                  return const Center(
                    child: Text('No books found.'),
                  ); //if no results found, print that
                }

                return ListView.builder(
                  //build list of books if available
                  physics:
                      NeverScrollableScrollPhysics(), // disable scroll on the list
                  shrinkWrap:
                      true, // make the list occupy as little space as possible
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bookProvider
                      .books
                      .length, //make list as long as the results from bookProvider
                  itemBuilder: (context, index) {
                    final book = bookProvider
                        .books[index]; //grab current book from list using index
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ), //each book is wrapped in padding
                      child: OutlinedButton(
                        //every bookentry is an outlined button
                        onPressed: () {
                          Navigator.push(
                            //when pressed open a new page
                            context,
                            MaterialPageRoute(
                              //transition animation
                              builder: (_) => BookPage(
                                book: book,
                              ), //open BookPage with book object as the constructor
                            ),
                          );
                        },
                        //style for bookentries that are outlined buttons
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
                            //Book cover
                            Container(
                              //container for book cover
                              width: 60,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors
                                    .grey[300], //color incase cover image is not fetched
                                image: DecorationImage(
                                  //Displays image of bookcover
                                  fit: BoxFit
                                      .cover, //makes image fill the previous gray container completely
                                  image: NetworkImage(
                                    book.coverUrl,
                                  ), //load image from the URL
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Book info
                            Expanded(
                              //take up all remaining space on horizontal axis
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title, //dislay books title
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.author, //display books author
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.year >
                                            0 //if year published is greater than 0, display books publishing year
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

//Reusable widget for tag chips, the logic and styling
class _SelectableTagChip extends StatelessWidget {
  final String label; //text
  final Set<String> selectedTags; //SelectedTags says if tag is selected
  final void Function(String)
  onSelected; //callback to parent when chip is pressed
  final ColorScheme colorScheme;

  const _SelectableTagChip({
    required this.label,
    required this.selectedTags,
    required this.onSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTags.contains(
      label,
    ); //check if tag is already selected

    //colorscheme for
    final background = colorScheme.secondaryContainer.withAlpha(50);
    final selectedColor = colorScheme.secondaryContainer;
    final borderColor = isSelected
        ? colorScheme.secondary
        : colorScheme.secondary;

    return ChoiceChip(
      //built in material widget designed to toggle, the visual
      label: Text(label),
      selected: isSelected, //whether or not the chip is highlighted
      onSelected: (_) => onSelected(
        label,
      ), //when chip is pressed call onSelected (that gives the label)
      backgroundColor: background, //color when not selected
      selectedColor: selectedColor, //color when selected
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
