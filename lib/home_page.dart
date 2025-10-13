import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationBottomBar>();
    final selectedIndex = navigationProvider.selectedIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text('Name'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          bookGenreListHorizontal("Romance", 5),
          SizedBox(height: 20),
          bookGenreListHorizontal("Action", 7),
          SizedBox(height: 20),
          bookGenreListHorizontal("Sci-fi", 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(83, 255, 255, 255),
        currentIndex: selectedIndex,
        onTap: (index) {
          context.read<NavigationBottomBar>().setIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

Widget bookGenreListHorizontal(String genreTitle, int itemCount) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Titel
      Container(
        margin: EdgeInsets.only(bottom: 4),
        child: Text(
          genreTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Horisontell scrolllista
      SizedBox(
        height: 180, // viktigt! annars får ListView ingen höjd
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
              child: Container(
                width: 135,
                height: 155,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            );
          },
        ),
      ),
    ],
  );
}
