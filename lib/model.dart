import 'package:flutter/material.dart';
import 'profile_page.dart';
import "search_page.dart";
import 'package:template/home_page.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});
  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationBottomBar>();

    return Scaffold(
      body: IndexedStack(
        index: nav.selectedIndex,
        children: [SearchPage(), HomePage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: nav.selectedIndex,
        onTap: (index) => context.read<NavigationBottomBar>().setIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

//bokmodell
class Books {
  String id;
  String title;
  String author;
  int year;
  String genre;
  List<String> tropes;
  int? coverId;
  String workKey;
  String? description;

  Books({
    this.id = "",
    this.title = "",
    this.author = "",
    this.year = 0,
    this.genre = "",
    this.tropes = const [],
    this.coverId,
    this.workKey = "",
    this.description,
  });

  String get coverUrl => coverId != null
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : 'https://via.placeholder.com/60x100';

  factory Books.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    final bool isOpenLibrary =
        json.containsKey('author_name') ||
        json.containsKey('cover_i') ||
        json.containsKey('first_publish_year') ||
        (json['key'] != null && (json['key'] as String).startsWith('/works/'));

    if (isOpenLibrary) {
      return Books(
        id: json['key'] ?? '',
        title: json['title'] ?? 'Unknown title',
        author:
            (json['author_name'] is List &&
                (json['author_name'] as List).isNotEmpty)
            ? (json['author_name'][0]?.toString() ?? 'Unknown author')
            : 'Unknown author',
        year: parseInt(json['first_publish_year']) ?? 0,
        genre: '',
        tropes: [],
        coverId: parseInt(json['cover_i']),
        workKey: json['key'] ?? '',
        description: json['description'] is String
            ? json['description']
            : (json['description'] is Map
                  ? (json['description']['value'] as String?)
                  : null),
      );
    }

    return Books(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? 'Unknown author',
      year: parseInt(json['year']) ?? 0,
      genre: json['genre'] ?? '',
      tropes:
          (json['tropes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      coverId: parseInt(json['coverId']),
      workKey: json['workKey'] ?? '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'tropes': tropes,
      'coverId': coverId,
      'workKey': workKey,
      'description': description,
    };
  }
}

List<String> globalGenres = [
  "Fantasy",
  "Romance",
  "Science Fiction",
  "Mystery",
  "Historical Fiction",
];

List<String> globalTropes = [
  "Enemies to Lovers",
  "Found Family",
  "Chosen One",
  "Secret Identity",
  "Redemption Arc",
  "Forbidden Love",
];

List<String> globalPopular = [
  "Fantasy",
  "Enemies to Lovers",
  "Science Fiction",
  "Secret Identity",
  "Romance",
];
