import 'package:flutter/foundation.dart';
import 'model.dart';
import 'book_list.dart';

class NavigationBottomBar extends ChangeNotifier {
  int _selectedIndex = 1; // 0 = Search, 1 = Home, 2 = Profile

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}

class BookProvider extends ChangeNotifier {
  final List<Books> _books = [];
  List<Books> get books => _books;

  void loadBooks() {
    _books.clear();
    _books.addAll(demoBooks);
    notifyListeners();
  }
}
