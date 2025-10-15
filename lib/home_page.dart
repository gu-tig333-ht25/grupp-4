import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/book_info_page.dart';
import 'book_list.dart';
import 'model.dart';
import 'api_getbooks.dart';
import 'book_info_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> categories = [
    "Colleen Hoover",
    "Katarina Wennstam",
    "Brandon Sanderson",
  ];

  @override
  Widget build(BuildContext context) {
    /*final bookList = demoBooks;
    final romanceBooks = bookList.where((b) => b.genre == 'Romance').toList();
    final dystopianBooks = bookList
        .where((b) => b.genre == 'Dystopian')
        .toList();
    final historicalFictionBooks = bookList
        .where((b) => b.genre == 'Historical Fiction')
        .toList();*/
    final bookProvider = context.watch<BookProvider>();

    // Filtrera böcker per vald författare
    Map<String, List<Books>> booksByAuthor = {};
    for (var author in categories) {
      booksByAuthor[author] = bookProvider.books
          .where((b) => b.author.toLowerCase().contains(author.toLowerCase()))
          .toList();
    }
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
          bookGenreListHorizontal(booksByAuthor["Colleen Hoover"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Katarina Wennstam"] ?? []),
          SizedBox(height: 20),
          bookGenreListHorizontal(booksByAuthor["Brandon Sanderson"] ?? []),
        ],
      ),
    );
  }
}

Widget bookGenreListHorizontal(List<Books> bookInfo) {
  // Ska ta emot en sorterad genre lista av böcker
  String bookAuthor = bookInfo.isNotEmpty
      ? bookInfo.first.author
      : "Okänd author";
  //String bookGenre = bookInfo.isNotEmpty ? bookInfo.first.genre : "Okänd genre";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Titel
      Container(
        margin: EdgeInsets.only(bottom: 4),
        child: Text(
          bookAuthor,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Horisontell scrolllista
      SizedBox(
        height: 180, // viktigt! annars får ListView ingen höjd
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bookInfo.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookPage(book: bookInfo[index]),
                    ),
                  );
                },
                child: Container(
                  width: 135,
                  height: 155,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(bookInfo[index].coverUrl),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      bookInfo[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
