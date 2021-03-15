//feed N Message Page View Controller
import 'package:flutter/material.dart';

class FNMPageViewController extends ChangeNotifier {
  //search and profile can't swipe to chat
  bool isSwipeAblePage = true;
  PageController pageViewController = PageController(initialPage: 0);

  jumpToPage(int value) {
    pageViewController.animateToPage(value,
        duration: Duration(
          milliseconds: 800,
        ),
        curve: Curves.slowMiddle);
    notifyListeners();
  }

  setIsSwipeAblePage(bool to) {
    isSwipeAblePage = to;
    notifyListeners();
  }
}
