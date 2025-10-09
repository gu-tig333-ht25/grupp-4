import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookSearchScreen(),
    );
  }
}

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;

  Future<void> _searchBooks(String query) async {
    setState(() => _isLoading = true);

    final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _books = data['docs'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Search (Open Library)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Sök efter bok',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchBooks(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        final title = book['title'] ?? 'Ingen titel';
                        final author = (book['author_name'] != null)
                            ? book['author_name'][0]
                            : 'Okänd författare';
                        final coverId = book['cover_i'];
                        final coverUrl = coverId != null
                            ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                            : null;

                        return ListTile(
                          leading: coverUrl != null
                              ? Image.network(coverUrl, width: 50, fit: BoxFit.cover)
                              : const Icon(Icons.book),
                          title: Text(title),
                          subtitle: Text(author),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

