/*import 'dart:convert';
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
      final response = await http.get(
      url,
      headers: {
        'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
      },
    );

  

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
}*/

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'model.dart';

class BookProvider extends ChangeNotifier {
  final List<Books> _books = [];
  List<Books> get books => _books;
  bool isLoading = false;

  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
        },
      );

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

  Future<void> saveBookToFirebase(Books book) async {
    try {
      final dbRef = _db.child("books").child(book.id); // egen nod per bok
      await dbRef.set(book.toJson());

      // Uppdatera lokalt
      final localIndex = _books.indexWhere((b) => b.id == book.id);
      if (localIndex != -1) {
        _books[localIndex] = book;
      } else {
        _books.add(book);
      }

      notifyListeners();
      print("Bok sparad till Firebase: ${book.title}");
    } catch (e) {
      print("Fel vid saveBookToFirebase: $e");
    }
  }

  Future<Books?> getBookFromFirebase(String bookId) async {
    try {
      final snapshot = await _db.child("books").child(bookId).get();
      if (!snapshot.exists) {
        print("Ingen bok hittades i Firebase för id: $bookId");
        return null;
      }

      final bookData = Map<String, dynamic>.from(snapshot.value as Map);
      return Books.fromJson(bookData);
    } catch (e) {
      print("Fel vid getBookFromFirebase: $e");
      return null;
    }
  }

  Future<void> updateBookGenreAndTropes(
    String bookId,
    String newGenre,
    List<String> newTropes,
  ) async {
    try {
      final book = await getBookFromFirebase(bookId);
      if (book == null) {
        print("Kunde inte hitta bok att uppdatera: $bookId");
        return;
      }

      book.genre = newGenre;
      book.tropes = newTropes;

      await saveBookToFirebase(book);
      notifyListeners();

      print("Uppdaterade genre/tropes för ${book.title}");
    } catch (e) {
      print("Fel vid updateBookGenreAndTropes: $e");
    }
  }

  Future<List<Books>> loadAllBooksFromFirebase() async {
    try {
      final snapshot = await _db.child("books").get();
      if (!snapshot.exists) return [];

      final Map<String, dynamic> booksMap = Map<String, dynamic>.from(
        snapshot.value as Map,
      );

      final allBooks = booksMap.entries
          .map(
            (entry) => Books.fromJson(Map<String, dynamic>.from(entry.value)),
          )
          .toList();

      print("Hämtade ${allBooks.length} böcker från Firebase");
      return allBooks;
    } catch (e) {
      print("Fel vid loadAllBooksFromFirebase: $e");
      return [];
    }
  }

  Books? getBookById(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
