import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class BookPage extends StatelessWidget {
  final Books book; //Takes an instance of Books model, named book

  const BookPage({super.key, required this.book}); //Constructor for BookPage

  @override
  Widget build(BuildContext context) {
    final bookProvider = context
        .read<BookProvider>(); //Variable to access (read) BookProvider

    return FutureBuilder<Books>(
      //FutureBuilder executes asynchronous functions/code and rebuilds UI based on the function's result
      future: bookProvider.getOrCreateBook(
        book,
      ), //future: needs to be resolved in order to display something on the screen (in this case getOrCreateBook must finish executing first)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //While waiting for the future to resolve, show a loading spinner
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          //If the future resolved but returned no data, show an error message
          return Scaffold(
            body: Center(child: Text('Could not load book data')),
          );
        }
        // ("updatedBook": so it's always the latest version from firebase)
        final updatedBook = snapshot
            .data!; //If the future resolved and returned data, store it in updatedBook
        //(snapshot is not null, checked above, so snapshot.data is true)

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(
              color: Colors.white, // sets icon color of "return arrow"
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
                // Children with book information and buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 152,
                      width: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            updatedBook.coverUrl,
                          ), //Book cover image from updatedBook
                        ),
                      ),
                    ),
                    Container(
                      height: 152,
                      width: 200,
                      margin: EdgeInsets.only(left: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Shows info about the book the user clicked on
                            Text('Title: ${updatedBook.title}'),
                            SizedBox(height: 3),
                            Text('Author: ${updatedBook.author}'),
                            SizedBox(height: 3),
                            Text('Published: ${updatedBook.year}'),
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
                                  //Button (want to read) that is as wide as the remaining space
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final userProvider = context
                                        .read<UserProvider>();
                                    await userProvider.addBookToWantToRead(
                                      //when pressed, adds the book to the user's "want to read" list
                                      book, //book is the book instance passed to BookPage
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '"${book.title}" added to Want to Read', //Shows a snackbar confirming the added book
                                        ),
                                      ),
                                    );
                                  },
                                  label: Text('Want to read'),
                                  heroTag:
                                      "wantToRead", //heroTag is needed to differentiate between multiple FloatingActionButtons on the same screen
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: FloatingActionButton.extended(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final userProvider = context
                                        .read<UserProvider>();
                                    await userProvider.addBookToHaveRead(
                                      book,
                                    ); //when pressed, adds the book to the user's "have read" list
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '"${book.title}" added to Have Read', //Shows a snackbar confirming the added book
                                        ),
                                      ),
                                    );
                                  },
                                  label: Text('Have read'),
                                  heroTag:
                                      "haveRead", //different heroTag for this button
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for genre tags
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Genre: '),
                        SizedBox(width: 6),
                        OutlinedButton(
                          //Gives the same look as the tags in search_page (for consistency)
                          onPressed: () {}, //No action when pressing genre tag
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
                                ? updatedBook
                                      .genre //If genre is not empty, show the genre of "updatedBook"
                                : "No genre", //If genre is empty, show "No genre" in the tag/"button"
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
                    // Row of trope tags
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
                                ? updatedBook
                                      .tropes //If tropes list is not empty, map each trope to an OutlinedButton (there can be multiple trope tags)
                                      .map(
                                        (trope) => OutlinedButton(
                                          onPressed:
                                              () {}, //No action when pressing trope tag/"button"
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
                                            trope, //Displays the trope text
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
                                    //If tropes list is empty, show a single OutlinedButton saying "No tropes"
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

                // Description box
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
                      //Makes the description scrollable if it's too long to fit in the box
                      child: FutureBuilder<String>(
                        //Fetches the book description asynchronously
                        future: fetchDescription(
                          updatedBook.workKey,
                        ), //Waits for fetchDescription to complete
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            ); //While waiting, show a loading spinner
                          } else if (snapshot.hasError) {
                            return Text(
                              "Error loading description",
                            ); //Error message
                          } else {
                            return Text(
                              snapshot.data ??
                                  "No description available", //Returns the fetched description, or a default message if none is available
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

// Global function for description
Future<String> fetchDescription(String workKey) async {
  //Takes the workKey of a book as argument
  if (workKey.isEmpty) return "No description available";
  final url = Uri.parse(
    "https://openlibrary.org$workKey.json",
  ); //The URL to fetch the book data from Open Library API
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //If the HTTP request was successful:
      final data = jsonDecode(
        response.body,
      ); //"data" contains the decoded JSON response
      if (data['description'] is String) {
        return data['description']; //If description is a string, return it
      } else if (data['description']?['value'] != null) {
        //If the description is an object with a 'value' field, return that
        return data['description']['value'];
      }
    }
  } catch (e) {
    print("Error fetching description: $e");
  }
  return "No description available";
}
