import 'package:flutter/material.dart';
import '../views/profile_page.dart';
import "../views/search_page.dart";
import 'package:template/views/home_page.dart';
import 'package:provider/provider.dart';
import '../providers/bottombar_nav.dart';

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
