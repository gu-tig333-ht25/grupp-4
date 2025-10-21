import 'package:flutter/material.dart';
import 'package:template/sample_books.dart';
import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_provider.dart';
import 'package:provider/provider.dart';

class BookPage extends StatelessWidget {
  final Books book;

  const BookPage({super.key, required this.book});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/Orange-Book-Logo-scaled.jpg'),
              height: AppBar().preferredSize.height,
            ),
            Text('Bookapp'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 122,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(book.coverUrl),
                    ),
                  ),
                ),
                Container(
                  height: 122,
                  width: 200,
                  margin: EdgeInsets.only(left: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${book.title}'),
                        Text('Author: ${book.author}'),
                        Text('Published: ${book.year}'),
                        TextButton(
                          onPressed: () {
                            updateBookGenre(book, globalGenres[1]);
                          },
                          child: Text('testgenre'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                final userProvider = context
                                    .read<UserProvider>();
                                await userProvider.addBookToWantToRead(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '"${book.title}" added to Want to Read',
                                    ),
                                  ),
                                );
                              },
                              label: Text('Want to read'),
                              heroTag: "wantToRead",
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: constraints.maxWidth,
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                final userProvider = context
                                    .read<UserProvider>();
                                await userProvider.addBookToHaveRead(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '"${book.title}" added to Have Read',
                                    ),
                                  ),
                                );
                              },
                              label: Text('Have read'),
                              heroTag: "haveRead",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30, child: Text('Tags:')),
            Wrap(
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Fantasy')),
                ElevatedButton(onPressed: () {}, child: Text('Romance')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
                ElevatedButton(onPressed: () {}, child: Text('Space')),
              ],
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: SingleChildScrollView(
                  child: FutureBuilder<String>(
                    future: fetchDescription(book.workKey),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error loading description");
                      } else {
                        return Text(
                          snapshot.data ?? "No description available",
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchDescription(String workKey) async {
    if (workKey.isEmpty) return "No description available";
    final url = Uri.parse("https://openlibrary.org$workKey.json");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['description'] is String) {
          return data['description'];
        } else if (data['description']?['value'] != null) {
          return data['description']['value'];
        }
      }
    } catch (e) {
      print("Error fetching description: $e");
    }
    return "No description available";
  }
}
