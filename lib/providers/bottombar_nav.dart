import 'package:flutter/foundation.dart';

// Keeps track of the selected index for the navigation bar
class NavigationBottomBar extends ChangeNotifier {
  int _selectedIndex = 1; // default, 0 = Search, 1 = Home, 2 = Profile

  int get selectedIndex => _selectedIndex;

  // Updates the selected index and notifies all listeners
  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
