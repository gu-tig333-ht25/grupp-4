import 'dart:convert'; // For jsonDecode
import 'package:flutter/foundation.dart'; // For ChangeNotifier and kDebugMode
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:firebase_database/firebase_database.dart'; // For Firebase Realtime Database
import '../models/book_model.dart'; //books model

class BookProvider extends ChangeNotifier {
  //Provider class for books, extends ChangeNotifier for state management
  final List<Books> _books = []; // Private list to store books
  List<Books> get books =>
      _books; // Public getter to read access the books list
  bool isLoading = false; // Loading state indicator

  final DatabaseReference _db = FirebaseDatabase.instance
      .ref(); // Firebase Realtime Database reference, to interact with the database

  Future<void> fetchBooks(String query) async {
    // Fetch books from Open Library API based on search query
    if (query.isEmpty) return; //if query is empty, return

    isLoading = true; // Set loading state to true
    notifyListeners(); // Notify listeners about state change

    try {
      final url = Uri.parse(
        'https://openlibrary.org/search.json?q=$query',
      ); // construct URL for Open Library API, with search query
      final response = await http.get(
        // Make HTTP GET request to the constructed
        url,
        headers: {
          // Custom headers for the request so we don't get blocked :)
          'User-Agent': 'SchoolProjectBookApp/1.0 (10benny10ben10@gmail.com)',
        },
      );

      if (response.statusCode == 200) {
        // If the response is successful
        final data = jsonDecode(
          response.body,
        ); // Decode the JSON response into a Dart object
        final docs =
            data['docs']
                as List; // Extract the list of book documents from the response
        _books
          ..clear() // Clear existing books
          ..addAll(
            docs.take(20).map((e) => Books.fromJson(e)).toList(),
          ); // Map each document to a Books object and add to the list (limit to 20 results), e = element
      } else {
        //if status code is not 200
        if (kDebugMode) {
          // Check if in debug mode
          print(
            "Failed to load books: ${response.statusCode}",
          ); // Print error message with status code
        }
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request or JSON parsing
      if (kDebugMode) {
        //if in debug mode
        print("Error fetching books: $e"); // Print error message
      }
    }

    isLoading = false; // Set loading state to false
    notifyListeners(); // Notify listeners about state change
  }

  void clearBooks() {
    // Clear the books list
    _books.clear();
    notifyListeners(); // Notify listeners about state change
  }

  Future<void> saveBookToFirebase(Books book) async {
    // Save or update a book in Firebase Realtime Database
    try {
      final dbRef = _db
          .child("books")
          .child(book.id); //reference to the book's location in Firebase

      final snapshot = await dbRef.get(); // get existing data for the book
      if (snapshot.exists) {
        // If the book already exists in Firebase, convert the existing data to a Books object
        final existingData = Map<String, dynamic>.from(snapshot.value as Map);
        final existingBook = Books.fromJson(existingData);

        if (existingBook.genre.isNotEmpty) {
          // Preserve existing genre if it exists
          book.genre = existingBook.genre;
        }
        if (existingBook.tropes.isNotEmpty) {
          // Preserve existing tropes if they exist
          book.tropes = existingBook.tropes;
        }
      }

      await dbRef.set(book.toJson()); // Save the book data to Firebase

      final localIndex = _books.indexWhere(
        (b) => b.id == book.id,
      ); // Update local list
      if (localIndex != -1) {
        //if book exists in local list
        _books[localIndex] = book; // Update existing book
      } else {
        _books.add(book); // Add new book
      }

      notifyListeners(); // Notify listeners about state change, after saving to Firebase, so UI updates with latest data
    } catch (e) {
      // Catch any exceptions that occur during the Firebase operation
      print("Error in saveBookToFirebase: $e"); // Print error message
    }
  }

  Future<Books?> getBookFromFirebase(String bookId) async {
    // Retrieve a book from Firebase Realtime Database by its ID
    try {
      final snapshot = await _db
          .child("books/works")
          .child(bookId)
          .get(); // Get the book data from Firebase
      if (!snapshot.exists) {
        // If the book does not exist in Firebase
        print(
          "No book found in Firebase for id: $bookId",
        ); // Print message indicating no book found
        return null; // Return null if book not found
      }

      final bookData = Map<String, dynamic>.from(
        snapshot.value as Map,
      ); //convert data into Map
      return Books.fromJson(
        bookData,
      ); // return Books object created from the retrieved data
    } catch (e) {
      // Catch any exceptions that occur during the Firebase operation
      print("Error in getBookFromFirebase: $e"); // Print error message
      return null; // Return null in case of error
    }
  }

  Future<void> updateBookGenreAndTropes(
    // Update a book's genre and tropes in Firebase
    String bookId,
    String newGenre,
    List<String> newTropes,
  ) async {
    try {
      final book = await getBookFromFirebase(bookId); // Get book for firebase
      if (book == null) {
        // If book doesn't exist (null)
        print("Could not find book to update: $bookId");
        return;
      }

      book.genre = newGenre; // Set Book object locally genre to "newGenre"
      book.tropes = newTropes; // Set Book object locally tropes to "newTropes"

      await saveBookToFirebase(
        book,
      ); // Update Book object genre/tropes to firebase
      notifyListeners();
    } catch (e) {
      print("Error in updateBookGenreAndTropes: $e");
    }
  }

  Future<List<Books>> loadAllBooksFromFirebase() async {
    try {
      // Fetch data from the path "/books/works" in Firebase
      final snapshot = await _db.child("books/works").get();

      // If the node doesn't exist or has no data, return an empty list
      if (!snapshot.exists) return [];

      // Convert the snapshot into a dart Map
      final Map<String, dynamic> booksMap = Map<String, dynamic>.from(
        snapshot.value as Map,
      );

      // Convert each entry (key/value pair) in the map into a Books object
      final allBooks = booksMap.entries
          .map(
            (entry) => Books.fromJson(Map<String, dynamic>.from(entry.value)),
          )
          .toList();

      // Return the list of Books objects
      return allBooks;
    } catch (e) {
      print("Error in loadAllBooksFromFirebase: $e");
      return [];
    }
  }

  Books? getBookById(String id) {
    // Get book from local list (_books) by its ID
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      // If no book is found with the given ID return null
      return null;
    }
  }

  Future<Books> getOrCreateBook(Books book) async {
    // GetOrCreateBook method
    final existing = await getBookFromFirebase(
      book.id,
    ); // Try to get the book from Firebase
    if (existing != null) return existing; // If it exists, return it
    await saveBookToFirebase(
      book,
    ); // If it doesn't exist, save the new book to Firebase
    return book; // Return the newly created book
  }

  Future<List<Books>> searchBooksByTags(Set<String> selectedTags) async {
    if (selectedTags.isEmpty)
      return []; //If no tags are selected, return an empty list

    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _db
          .child("books/works")
          .get(); // Fetch all books stored under "books/works" from Firebase
      if (!snapshot.exists) {
        // If no books exist in the database, stop and return an empty list
        isLoading = false;
        notifyListeners();
        return [];
      }

      final booksMap = Map<String, dynamic>.from(
        snapshot.value as Map,
      ); //Convert the raw Firebase snapshot into a Map for easier processing

      final matchingBooks = booksMap.entries
          .map(
            (entry) => Books.fromJson(
              Map<String, dynamic>.from(entry.value),
            ), // Convert each entry from the database into a Books object
          )
          .where((book) {
            // Create a combined list (bookTags) of tags for each book: includes its genre and tropes
            final bookTags = <String>[
              if (book.genre.isNotEmpty) book.genre,
              ...book.tropes,
            ];
            return selectedTags.every(
              (tag) => bookTags.contains(tag),
            ); //Filter only those that match all selected tags
          })
          .toList();

      _books // Replace the provider’s current book list with the filtered matching books
        ..clear()
        ..addAll(
          matchingBooks,
        ); //('..' is a consice way to clear and add all in one statement)

      print(
        "Found ${matchingBooks.length} books that matched all tags ${selectedTags.join(', ')}",
      );

      isLoading =
          false; // Turn off loading state and update listeners to refresh the UI
      notifyListeners();
      return matchingBooks;
    } catch (e) {
      print("Error in search in Firebase: $e");
      isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
