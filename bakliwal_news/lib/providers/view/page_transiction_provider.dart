import 'package:flutter/widgets.dart';

class PageTransictionIndex with ChangeNotifier {
  int _index = 1;

  int get index {
    return _index;
  }

  void changeIndex(int i) {
    if (i == 0 || i == 7) {
      _index = 1;
    } else {
      _index = i;
    }
    notifyListeners();
  }
}
