import 'package:flutter/material.dart';
import '../views/profile_page.dart';
import "../views/search_page.dart";
import 'package:template/views/home_page.dart';
import 'package:provider/provider.dart';
import '../providers/bottombar_nav.dart';

// App's bottom navigation and page controller
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watches for changes in NavigationBottomBar
    final navProvider = context.watch<NavigationBottomBar>();

    return Scaffold(
      // Displays one page at a time, but keeps the state of all pages alive
      body: IndexedStack(
        index: navProvider.selectedIndex, // Shows the currently selected page
        children: [SearchPage(), HomePage(), ProfilePage()],
      ),
      // Bottom navigation bar for switching between pages
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.selectedIndex, // Highlights the active tab
        onTap: (index) => context.read<NavigationBottomBar>().setIndex(
          index,
        ), // Updates selected tab in provider
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
