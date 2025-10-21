import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TagProvider extends ChangeNotifier {
  final _db = FirebaseDatabase.instance.ref();

  List<String> genres = [];
  List<String> tropes = [];
  List<String> popularTags = [];
  bool isLoading = true;

  TagProvider() {
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final snapshot = await _db.child('globalTags').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        genres =
            (data['genres'] as Map?)?.keys.map((e) => e.toString()).toList() ??
            [];
        tropes =
            (data['tropes'] as Map?)?.keys.map((e) => e.toString()).toList() ??
            [];
        popularTags =
            (data['popular'] as Map?)?.keys.map((e) => e.toString()).toList() ??
            [];
      }
    } catch (e) {
      debugPrint("Fel vid laddning av globalTags: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGenre(String genre) async {
    await _db.child('globalTags/genres/$genre').set(true);
    genres.add(genre);
    notifyListeners();
  }

  Future<void> addTrope(String trope) async {
    await _db.child('globalTags/tropes/$trope').set(true);
    tropes.add(trope);
    notifyListeners();
  }

  Future<void> addPopularTag(String tag) async {
    await _db.child('globalTags/popular/$tag').set(true);
    popularTags.add(tag);
    notifyListeners();
  }
}
