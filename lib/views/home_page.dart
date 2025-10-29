import 'package:flutter/material.dart';
import 'package:template/views/book_info_page.dart';
import '../models/book_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A list of authors to fetch books for
  final List<String> authors = [
    "Julia Quinn",
    "Suzanne Collins",
    "Lars Kepler",
    "Fredrik Backman",
  ];

  // A map that stores books grouped by author name
  Map<String, List<Books>> booksByAuthor = {};

  // Indicates whether data is still being loaded
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Start fetching book data when the widget is first created
    fetchBooksForAuthors();
  }

  // Fetches books for each author
  Future<void> fetchBooksForAuthors() async {
    for (var author in authors) {
      // Create API URL with the author's name
      final url = Uri.parse(
        'https://openlibrary.org/search.json?author=${Uri.encodeComponent(author)}',
      );
      // Send a GET request to the Open Library API
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
        },
      );
      // if successful (HTTP 200)
      if (response.statusCode == 200) {
        // Decode JSON response body
        final data = jsonDecode(response.body);
        final docs = data['docs'] as List;

        // Convert JSON data into a list of Books objects (max 5 per author)
        final books = docs
            .map((e) => Books.fromJson(e))
            .take(5) // max 5 books per author
            .toList();

        // Store the list of books in the map (booksByAuthor) under the author's name
        booksByAuthor[author] = books;
      } else {
        // If the request failed, store an empty list for that author
        booksByAuthor[author] = [];
      }
    }

    // Update the UI to reflect that loading is complete
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paige'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          bookGenreListHorizontal(
            booksByAuthor["Julia Quinn"] ??
                [], // If authour's name doesn't exist locally return null
          ), // A horizontal list of authour's name and 5 of their books
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Suzanne Collins"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Lars Kepler"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Fredrik Backman"] ?? []),
        ],
      ),
    );
  }
}

// A horizontal list showing a author's name and 5 of their books
// This widget receives an already sorted list of books
Widget bookGenreListHorizontal(List<Books> bookInfo) {
  // The first books author in the list becomes the title
  String bookAuthor = bookInfo.isNotEmpty
      ? bookInfo.first.author
      : "Unknown author";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title
      Container(
        margin: EdgeInsets.only(bottom: 4),
        child: Text(
          bookAuthor,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Horizontal scrollable list
      SizedBox(
        height: 180, // Important! Otherwise ListView has no height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bookInfo.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 12,
              ), // Adds left margin between items, but no margin before the first item
              child: GestureDetector(
                // Navigates to the book info page for the selected book object
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookPage(book: bookInfo[index]),
                    ),
                  );
                },
                child: Container(
                  width: 125,
                  height: 155,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        bookInfo[index].coverUrl,
                      ), // Book cover
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
