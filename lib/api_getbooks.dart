import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'model.dart';


class BookProvider extends ChangeNotifier {
  final List<Books> _books = [];
  List<Books> get books => _books;
  bool isLoading = false;

  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final docs = data['docs'] as List;
        _books
          ..clear()
          ..addAll(docs.take(20).map((e) => Books.fromJson(e)).toList());
      } else {
        if (kDebugMode) {
          print("Failed to load books: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching books: $e");
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void clearBooks() {
    _books.clear();
    notifyListeners();
  }
}
