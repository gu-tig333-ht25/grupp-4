import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'api_getbooks.dart';

/// Logga in automatiskt med testkonto
Future<User?> loginTestUser() async {
  try {
    const email = "wilma@example.com"; // ersätt med ert testkonto
    const password = "test1234"; // ersätt med lösenord

    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("Inloggad som ${cred.user?.email} (UID: ${cred.user?.uid})");
    return cred.user;
  } catch (e) {
    print("Inloggning misslyckades: $e");
    return null;
  }
}

/// Testar att skriva och läsa användardata i Realtime Database
Future<void> testUserData(User user) async {
  try {
    final db = FirebaseDatabase.instance.ref("users/${user.uid}");

    await db.set({
      "name": "Wilma Test",
      "email": user.email,
      "wantToRead": [],
      "haveRead": [],
    });

    final snapshot = await db.get();
    if (snapshot.exists) {
      print("Hämtad användardata:");
      print(snapshot.value);
    } else {
      print("Ingen data hittades!");
    }
  } catch (e) {
    print("Fel vid testUserData: $e");
  }
}

//förslag

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
    List currentList = [];
    if (snapshot.exists) {
      currentList = List.from(snapshot.value as List);
    }
    if (!currentList.contains(book)) {
      currentList.add(book);
      await dbRef.set(currentList);
      // Uppdatera lokalt
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
    List currentList = [];
    if (snapshot.exists) {
      currentList = List.from(snapshot.value as List);
    }
    if (!currentList.contains(book)) {
      currentList.add(book);
      await dbRef.set(currentList);
      // Uppdatera lokalt
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

        final wantIds = List<String>.from(data['wantToRead'] ?? []);
        final haveIds = List<String>.from(data['haveRead'] ?? []);

        // Vi mappar ID:n till Books med placeholder title (du kan senare hämta full info från API)
        wantToRead = wantIds.map((id) => Books(id: id, title: id)).toList();
        haveRead = haveIds.map((id) => Books(id: id, title: id)).toList();
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading user data: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
