import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

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
            iconTheme: IconThemeData(
              color: Colors.white, // ← ändrar färg på tillbaka-pilen
            ),
            title: Text('Paige'),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bokomslag
                    SizedBox(
                      height: 152,
                      width: 110,
                      child: Image.network(
                        updatedBook.coverUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(width: 8),

                    // Textkolumn
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${updatedBook.title}'),
                          SizedBox(height: 3),
                          Text('Author: ${updatedBook.author}'),
                          SizedBox(height: 3),
                          Text('Published: ${updatedBook.year}'),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    // Knappar
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            onPressed: () async {
                              final userProvider = context.read<UserProvider>();
                              await userProvider.addBookToWantToRead(book);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '"${book.title}" added to Want to Read',
                                  ),
                                ),
                              );
                            },
                            label: Text('Want to read'),
                            heroTag: "wantToRead", // unikt heroTag per bok
                          ),
                          SizedBox(height: 10),
                          FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            onPressed: () async {
                              final userProvider = context.read<UserProvider>();
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
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GENRE RAD
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Genre: '),
                        SizedBox(width: 6),
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
                      ],
                    ),
                    SizedBox(height: 10),
                    // TROPES RAD
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Tropes: '),
                        SizedBox(width: 6),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: updatedBook.tropes.isNotEmpty
                                ? updatedBook.tropes
                                      .map(
                                        (trope) => OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer
                                                .withAlpha(50),
                                            side: BorderSide(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          child: Text(
                                            trope,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList()
                                : [
                                    OutlinedButton(
                                      onPressed: null,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                            .withAlpha(50),
                                        side: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(12),
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
