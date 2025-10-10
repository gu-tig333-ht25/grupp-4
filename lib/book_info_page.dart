import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
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
                  //margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text('Book cover'),
                ),
                Container(
                  height: 122,
                  width: 200,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title'),
                        Text('Author'),
                        Text('Published'),
                      ],
                    ),
                  ),
                ),

                Expanded(child: Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text('Want to read'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text('Have read'),
                      ),
                    ),
                  ],
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
                  child: Text('Book description ...' * 70),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 2,
      ),
    );
  }
}
