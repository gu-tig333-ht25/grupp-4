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
    return Books(
      id: json['key'] ?? '',
      title: json['title'] ?? 'Unknown title',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown author',
      year: (json['first_publish_year'] ?? 0),
      genre: '', // OpenLibrary ger inte detta direkt
      tropes: [],
      coverId: json['cover_i'],
      workKey: json['key'] ?? '',
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
