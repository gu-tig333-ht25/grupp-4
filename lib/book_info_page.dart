import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Namn + logga')),
      bottomNavigationBar: BottomAppBar(child: Text('BottomBar')),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 80,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text('Book cover'),
              ),
              Container(
                height: 100,
                width: 200,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
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
                  FloatingActionButton.extended(
                    onPressed: () {},
                    label: Text('Want to read'),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton.extended(
                    onPressed: () {},
                    label: Text('Have read'),
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

          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Text('Book description ....'),
          ),
        ],
      ),
    );
  }
}
