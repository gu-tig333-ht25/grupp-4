import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class UserProvider extends ChangeNotifier {
  //Provides the selected user data throughout the app
  String username = '';
  String email = '';
  List<Books> wantToRead = []; // List of type 'Books'
  List<Books> haveRead = [];
  bool isLoading = true;

  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase authentication instance
  final DatabaseReference _db = FirebaseDatabase.instance
      .ref(); // Firebase real-time database reference

  UserProvider() {
    loadUserData(); // When the userprovider is created, load the user data from firebase (with loadUserData function)
  }

  // --- Add book to WantToRead ---
  Future<void> addBookToWantToRead(Books book) async {
    final user =
        _auth.currentUser; // Get the current (authenticated) user from Firebase
    if (user == null) return;

    final dbRef = _db.child(
      "users/${user.uid}/wantToRead",
    ); // A reference to the user's "wantToRead" list in the Realtime Database
    final snapshot = await dbRef
        .get(); //Fetch the current "wantToRead" list from the database
    List<Map<String, dynamic>> currentList =
        []; // Store the current book data (in JSON/map form) in a list
    if (snapshot.exists) {
      final listFromDb = snapshot.value as List;
      currentList = listFromDb
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(); //Cast the snapshot value to a List and convert each item to a Map
    }

    if (!currentList.any((b) => b['id'] == book.id)) {
      // Check if the book is already in the list (to avoid duplicates)
      currentList.add(book.toJson()); // Add new book to the local list
      await dbRef.set(currentList); // and upload the updated list to Firebase
      wantToRead.add(book);
      notifyListeners();
    }
  }

  // --- Add book to HaveRead ---
  Future<void> addBookToHaveRead(Books book) async {
    final user = _auth.currentUser; // Get current user
    if (user == null) return;

    final dbRef = _db.child("users/${user.uid}/haveRead");
    final snapshot = await dbRef
        .get(); // Fetch current "haveRead" list with reference above
    List<Map<String, dynamic>> currentList =
        []; // Local list to store current book data in JSON/map form
    if (snapshot.exists) {
      final listFromDb = snapshot.value as List;
      currentList = listFromDb
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(); // Convert each item to a Map
    }
    if (!currentList.any((b) => b['id'] == book.id)) {
      // Check for duplicates
      currentList.add(book.toJson()); // Add new book to local list
      await dbRef.set(currentList); // Upload updated list to Firebase
      haveRead.add(book);
      notifyListeners();
    }
  }

  // --- Load user data from Firebase ---
  Future<void> loadUserData() async {
    final user = _auth.currentUser; // Get the current user via FirebaseAuth
    if (user == null) return; // If no user is logged in, exit

    try {
      isLoading = true;
      notifyListeners(); // The UI can show a loading indicator while data is being fetched

      final snapshot = await _db
          .child("users/${user.uid}")
          .get(); // Get the user data from the Realtime database (one time)
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(
          snapshot.value as Map,
        ); // Convert the Firebase data (Object type) to a Dart-Map

        // Get user info (if 'name' or 'email' is null, set to empty string)
        username = data['name'] ?? '';
        email = data['email'] ?? '';

        final wantList = // Get wantToRead list
            data['wantToRead'] !=
                null //if there is data in wantToRead -> make each object to a Map<String, dynamic>
            ? (data['wantToRead'] as List)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : []; // if no data, set to empty list

        wantToRead = wantList
            .map((b) => Books.fromJson(b))
            .toList(); // Convert each Map to a Book object (using fromJson method)
        // and assign to wantToRead list

        final haveReadList =
            data['haveRead'] !=
                null // Get haveRead list
            ? (data['haveRead'] as List)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : [];

        haveRead = haveReadList
            .map((b) => Books.fromJson(b))
            .toList(); // Convert each Map to a Book object
      }

      isLoading = false; // Loading is complete, update UI
      notifyListeners();
    } catch (e) {
      print("Error loading user data: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear local user data and notify listeners (call this on logout)
  void clearUserData() {
    username = '';
    email = '';
    wantToRead.clear();
    haveRead.clear();
    isLoading = false;
    notifyListeners();
  }

  Future<void> removeBook(Books book, int selectedList) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 0 = wantToRead, 1 = haveRead
      final listName = selectedList == 0 ? "wantToRead" : "haveRead";
      final dbRef = _db.child(
        "users/${user.uid}/$listName",
      ); // A reference to the user's selected list in the Realtime Database

      final snapshot = await dbRef
          .get(); // Fetch the current data for selected list
      if (!snapshot.exists) return;

      final listFromDb =
          snapshot.value
              as List; // Convert the raw Firebase snapshot into a List of Maps
      final currentList = listFromDb
          .whereType<Map>() // Ensure that only Maps are handled
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Filter out the book with the same id, creating a new list excluding it
      final updatedList = currentList.where((b) => b['id'] != book.id).toList();

      // Update the datbase with the new list
      await dbRef.set(updatedList);

      // Update the local list, UI updates immediately
      if (selectedList == 0) {
        wantToRead.removeWhere((b) => b.id == book.id);
      } else {
        haveRead.removeWhere((b) => b.id == book.id);
      }

      notifyListeners();
    } catch (e) {
      print("Error with removeBook: $e");
    }
  }
}
