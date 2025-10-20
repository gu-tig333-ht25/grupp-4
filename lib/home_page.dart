import 'package:flutter/material.dart';
import 'package:template/book_info_page.dart';
import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> authors = [
    "Colleen Hoover",
    "Ali Hazelwood",
    "Brandon Sanderson",
  ];

  Map<String, List<Books>> booksByAuthor = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooksForAuthors();
  }

  Future<void> fetchBooksForAuthors() async {
    for (var author in authors) {
      final url = Uri.parse(
        'https://openlibrary.org/search.json?author=${Uri.encodeComponent(author)}',
      );
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final docs = data['docs'] as List;

        final books = docs
            .map((e) => Books.fromJson(e))
            .take(5) // max 5 böcker per författare
            .toList();

        booksByAuthor[author] = books;
      } else {
        booksByAuthor[author] = [];
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          bookGenreListHorizontal(booksByAuthor["Colleen Hoover"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Ali Hazelwood"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Brandon Sanderson"] ?? []),
        ],
      ),
    );
  }
}

Widget bookGenreListHorizontal(List<Books> bookInfo) {
  // Ska ta emot en sorterad lista av böcker
  String bookAuthor = bookInfo.isNotEmpty
      ? bookInfo.first.author
      : "Okänd author";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Titel
      Container(
        margin: EdgeInsets.only(bottom: 4),
        child: Text(
          bookAuthor,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Horisontell scrolllista
      SizedBox(
        height: 180, // viktigt! annars får ListView ingen höjd
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bookInfo.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
              child: GestureDetector(
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
                      image: NetworkImage(bookInfo[index].coverUrl),
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
