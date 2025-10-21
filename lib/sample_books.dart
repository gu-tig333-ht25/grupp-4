import 'model.dart';
import 'package:firebase_database/firebase_database.dart';

final _db = FirebaseDatabase.instance.ref();

/// --- Uppdatera genre ---
Future<void> updateBookGenre(Books book, String genre) async {
  try {
    final bookRef = _db.child('books/$book.workKey');
    await bookRef.update({'genre': genre});
    print("Genre uppdaterad för bok $book.titke: $genre");
  } catch (e) {
    print("Fel vid uppdatering av genre: $e");
  }
}

/// --- Uppdatera tropes ---
Future<void> updateBookTropes(String bookKey, List<String> tropes) async {
  try {
    final bookRef = _db.child('books/$bookKey');
    await bookRef.update({'tropes': tropes});
    print("Tropes uppdaterade för bok $bookKey: $tropes");
  } catch (e) {
    print("Fel vid uppdatering av tropes: $e");
  }
}

/// --- Hitta bookKey via workKey ---
Future<String?> findBookKeyByWorkKey(String workKey) async {
  final snapshot = await _db.child('books').get();
  if (!snapshot.exists) return null;

  final data = snapshot.value as Map;
  for (var entry in data.entries) {
    final key = entry.key;
    final value = Map<String, dynamic>.from(entry.value);
    if (value['workKey'] == workKey) {
      return key;
    }
  }
  return null;
}
