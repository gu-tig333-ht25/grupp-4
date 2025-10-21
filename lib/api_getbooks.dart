import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'model.dart';

class BookProvider extends ChangeNotifier {
  final List<Books> _books = [];
  List<Books> get books => _books;
  bool isLoading = false;

  /// Hämta böcker från Open Library + mergea med metadata från Firebase
  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      // Hämta från Open Library API
      final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
        },
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print("Failed to load books: ${response.statusCode}");
        }
        isLoading = false;
        notifyListeners();
        return;
      }

      final data = jsonDecode(response.body);
      final docs = data['docs'] as List;
      final apiBooks = docs.take(20).map((e) => Books.fromJson(e)).toList();

      //Hämta extra metadata från Firebase
      final db = FirebaseDatabase.instance.ref("books");
      final snapshot = await db.get();

      Map<String, dynamic> firebaseBooks = {};
      if (snapshot.exists) {
        firebaseBooks = Map<String, dynamic>.from(snapshot.value as Map);
      }

      // Slå ihop Open Library + Firebase-data
      final mergedBooks = apiBooks.map((b) {
        if (firebaseBooks.containsKey(b.id)) {
          final extra = firebaseBooks[b.id] as Map;
          return b.copyWith(
            genre: extra['genre'],
            tropes: extra['tropes'] != null
                ? List<String>.from(extra['tropes'])
                : [],
          );
        }
        return b;
      }).toList();

      //Uppdatera lokala listan
      _books
        ..clear()
        ..addAll(mergedBooks);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching books: $e");
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //Rensa listan
  void clearBooks() {
    _books.clear();
    notifyListeners();
  }

  /// Hämta en specifik bok (för t.ex. BookPage)
  ///
  /// - Försöker först hitta i Firebase (om den finns där)
  /// - Annars hämtar från Open Library direkt
  Future<Books?> fetchBookById(String bookId) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref("books/$bookId");
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        if (kDebugMode) print("Found $bookId in Firebase!");
        return Books(
          id: bookId,
          title: data['title'] ?? 'Unknown Title',
          author: data['author'] ?? 'Unknown Author',
          year: data['year'] ?? 0,
          genre: data['genre'] ?? '',
          tropes: data['tropes'] != null
              ? List<String>.from(data['tropes'])
              : [],
          coverId:
              data['coverId'] ??
              (data['covers'] != null && data['covers'].isNotEmpty
                  ? data['covers'][0]
                  : null),
          workKey: data['workKey'] ?? "",
        );
      }

      // Om den inte finns i Firebase, hämta från Open Library
      if (kDebugMode) print("Fetching $bookId from Open Library instead...");
      final url = Uri.parse('https://openlibrary.org/works/$bookId.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Books(
          id: bookId,
          title: data['title'] ?? 'Unknown Title',
          author: data['authors'] != null && data['authors'].isNotEmpty
              ? data['authors'][0]['name'] ?? 'Unknown Author'
              : 'Unknown Author',
          year: data['created'] != null
              ? DateTime.tryParse(data['created']['value'] ?? '')?.year ?? 0
              : 0,
          genre: '',
          tropes: [],
          coverId:
              data['coverId'] ??
              (data['covers'] != null && data['covers'].isNotEmpty
                  ? data['covers'][0]
                  : null),
          workKey: "/works/$bookId",
        );
      } else {
        if (kDebugMode)
          print("Failed to fetch $bookId: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching book by id: $e");
    }

    return null;
  }
}
