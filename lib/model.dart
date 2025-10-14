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

class Books {
  String id;
  String title;
  String author;
  int year;
  String genre;
  List<String> tropes;

  Books({
    this.id = "",
    this.title = "",
    this.author = "",
    this.year = 0,
    this.genre = "",
    this.tropes = const [],
  });
}
