import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final int selectedIndex = 1; // används för att baka in provider senare

  @override
  Widget build(BuildContext context) {
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
          bookGenreSection("Romance", 5),
          SizedBox(height: 20),
          bookGenreSection("Action", 7),
          SizedBox(height: 20),
          bookGenreSection("Sci-fi", 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(83, 255, 255, 255),
        currentIndex: selectedIndex,
        onTap: (index) {
          // Hanteras av Provider senare
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
                width: 120,
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
