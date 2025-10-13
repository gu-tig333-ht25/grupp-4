import 'package:flutter/foundation.dart';

class NavigationBottomBar extends ChangeNotifier {
  int _selectedIndex = 1; // 0 = Search, 1 = Home, 2 = Profile

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      print("$_selectedIndex");
      notifyListeners();
    }
  }
}
