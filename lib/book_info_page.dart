import 'package:flutter/material.dart';
import 'package:template/sample_books.dart';
import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'api_getbooks.dart';

class BookPage extends StatefulWidget {
  final Books book;

  const BookPage({super.key, required this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Books? detailedBook;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookInfo();
  }

  Future<void> _loadBookInfo() async {
    final bookProvider = context.read<BookProvider>();
    final book = await bookProvider.fetchBookById(widget.book.id);

    setState(() {
      detailedBook = book ?? widget.book;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = detailedBook ?? widget.book;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/Orange-Book-Logo-scaled.jpg'),
              height: AppBar().preferredSize.height,
            ),
            const SizedBox(width: 8),
            const Text('Bookapp'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                            image: NetworkImage(book.coverUrl),
                          ),
                        ),
                      ),
                      Container(
                        height: 122,
                        width: 200,
                        margin: const EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Title: ${book.title}'),
                              Text('Author: ${book.author}'),
                              Text('Published: ${book.year}'),
                              Text('Test: ${book.workKey}'),
                              Text('Test: ${book.coverId}'),
                              if (book.genre.isNotEmpty)
                                Text('Genre: ${book.genre}'),
                              TextButton(
                                onPressed: () {
                                  updateBookGenre(book, globalGenres[1]);
                                },
                                child: const Text('testgenre'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '"${book.title}" added to Want to Read',
                                          ),
                                        ),
                                      );
                                    },
                                    label: const Text('Want to read'),
                                    heroTag: "wantToRead",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  child: FloatingActionButton.extended(
                                    onPressed: () async {
                                      final userProvider = context
                                          .read<UserProvider>();
                                      await userProvider.addBookToHaveRead(
                                        book,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '"${book.title}" added to Have Read',
                                          ),
                                        ),
                                      );
                                    },
                                    label: const Text('Have read'),
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
                  const SizedBox(height: 20),
                  if (book.tropes.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.tropes
                          .map(
                            (t) => ElevatedButton(
                              onPressed: () {},
                              child: Text(t),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: SingleChildScrollView(
                        child: FutureBuilder<String>(
                          future: fetchDescription(book.workKey),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Text("Error loading description");
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
  }

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
}
