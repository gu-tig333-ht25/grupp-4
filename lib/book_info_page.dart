import 'package:flutter/material.dart';
import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'api_getbooks.dart';

// ------------------------------------------
// Global funktion för beskrivning
Future<String> fetchDescription(String workKey) async {
  if (workKey.isEmpty) return "No description available";
  final url = Uri.parse("https://openlibrary.org$workKey.json");
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['description'] is String) {
        return data['description'];
      } else if (data['description']?['value'] != null) {
        return data['description']['value'];
      }
    }
  } catch (e) {
    print("Error fetching description: $e");
  }
  return "No description available";
}

// ------------------------------------------
class BookPage extends StatelessWidget {
  final Books book;

  const BookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.read<BookProvider>();

    return FutureBuilder<Books>(
      future: bookProvider.getOrCreateBook(book),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text('Kunde inte ladda boken')));
        }

        final updatedBook = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/Orange-Book-Logo-scaled.jpg'),
                  height: AppBar().preferredSize.height,
                ),
                Text('Bookapp'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 122,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(updatedBook.coverUrl),
                        ),
                      ),
                    ),
                    Container(
                      height: 122,
                      width: 200,
                      margin: EdgeInsets.only(left: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Title: ${updatedBook.title}'),
                            Text('Author: ${updatedBook.author}'),
                            Text('Published: ${updatedBook.year}'),
                            Text('Genre: ${updatedBook.genre}'),
                            Text('Tropes: ${updatedBook.tropes.join(", ")}'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth,
                                child: FloatingActionButton.extended(
                                  onPressed: () async {
                                    final userProvider = context
                                        .read<UserProvider>();
                                    await userProvider.addBookToWantToRead(
                                      book,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '"${book.title}" added to Want to Read',
                                        ),
                                      ),
                                    );
                                  },
                                  label: Text('Want to read'),
                                  heroTag: "wantToRead",
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: FloatingActionButton.extended(
                                  onPressed: () async {
                                    final userProvider = context
                                        .read<UserProvider>();
                                    await userProvider.addBookToHaveRead(book);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '"${book.title}" added to Have Read',
                                        ),
                                      ),
                                    );
                                  },
                                  label: Text('Have read'),
                                  heroTag: "haveRead",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30, child: Text('Tags:')),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Testknappen
                    /*OutlinedButton(
                      onPressed: () async {
                        final bookProvider = context.read<BookProvider>();
                        await bookProvider.saveBookToFirebase(book);
                        await bookProvider.updateBookGenreAndTropes(
                          book.id,
                          "Romance",
                          ["Fluff", "Friends-to-lovers"],
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withAlpha(50),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'Test',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),*/

                    //Visa genreknappen (om den finns)
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withAlpha(50),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        updatedBook.genre.isNotEmpty
                            ? updatedBook.genre
                            : "No genre",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),

                    //Visa tropes dynamiskt (om det finns några)
                    if (updatedBook.tropes.isNotEmpty)
                      for (final trope in updatedBook.tropes)
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer.withAlpha(50),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            trope,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),

                    //Visa fallback om inga tropes finns alls
                    if (updatedBook.tropes.isEmpty)
                      OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer.withAlpha(50),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          "No tropes",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: SingleChildScrollView(
                      child: FutureBuilder<String>(
                        future: fetchDescription(updatedBook.workKey),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error loading description");
                          } else {
                            return Text(
                              snapshot.data ?? "No description available",
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
