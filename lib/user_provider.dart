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
      "wantToRead": ["book_001", "book_002"],
      "haveRead": ["book_003"],
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

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _db.child("users/${user.uid}").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        username = data['name'] ?? '';
        email = data['email'] ?? '';

        // Böcker: använd ID:n direkt som placeholder
        final wantIds = List<String>.from(data['wantToRead'] ?? []);
        final haveIds = List<String>.from(data['haveRead'] ?? []);

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
