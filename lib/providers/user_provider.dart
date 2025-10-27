import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class UserProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  List<Books> wantToRead = [];
  List<Books> haveRead = [];
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  UserProvider() {
    loadUserData();
  }

  // --- Lägg till bok i WantToRead ---
  Future<void> addBookToWantToRead(Books book) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final dbRef = _db.child("users/${user.uid}/wantToRead");
    final snapshot = await dbRef.get();
    List<Map<String, dynamic>> currentList = [];
    if (snapshot.exists) {
      final listFromDb = snapshot.value as List;
      currentList = listFromDb
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    if (!currentList.any((b) => b['id'] == book.id)) {
      currentList.add(book.toJson());
      await dbRef.set(currentList);
      wantToRead.add(book);
      notifyListeners();
    }
  }

  // --- Lägg till bok i HaveRead ---
  Future<void> addBookToHaveRead(Books book) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final dbRef = _db.child("users/${user.uid}/haveRead");
    final snapshot = await dbRef.get();
    List<Map<String, dynamic>> currentList = [];
    if (snapshot.exists) {
      final listFromDb = snapshot.value as List;
      currentList = listFromDb
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    if (!currentList.any((b) => b['id'] == book.id)) {
      currentList.add(book.toJson());
      await dbRef.set(currentList);
      haveRead.add(book);
      notifyListeners();
    }
  }

  // --- Ladda användardata från Firebase ---
  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _db.child("users/${user.uid}").get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        username = data['name'] ?? '';
        email = data['email'] ?? '';

        final wantList = data['wantToRead'] != null
            ? (data['wantToRead'] as List)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : [];

        wantToRead = wantList.map((b) => Books.fromJson(b)).toList();

        final haveReadList = data['haveRead'] != null
            ? (data['haveRead'] as List)
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList()
            : [];

        haveRead = haveReadList.map((b) => Books.fromJson(b)).toList();
      }

      isLoading = false;
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
      final dbRef = _db.child("users/${user.uid}/$listName");

      final snapshot = await dbRef.get();
      if (!snapshot.exists) return;

      final listFromDb = snapshot.value as List;
      final currentList = listFromDb
          .whereType<Map>() // säkerställ att bara Maps hanteras
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Filtrera bort boken med samma id
      final updatedList = currentList.where((b) => b['id'] != book.id).toList();

      // Uppdatera databasen
      await dbRef.set(updatedList);

      // Uppdatera den lokala listan
      if (selectedList == 0) {
        wantToRead.removeWhere((b) => b.id == book.id);
      } else {
        haveRead.removeWhere((b) => b.id == book.id);
      }

      notifyListeners();
    } catch (e) {
      print("Fel vid removeBook: $e");
    }
  }
}
