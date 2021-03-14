import 'package:clubHouseLite/ChatGroups/chat_groups.dart';
import 'package:clubHouseLite/SearchFiles/search_page.dart';
import 'package:flutter/material.dart';

class MessagePageView extends StatelessWidget {
  PageController pageViewController = new PageController(
    initialPage: 0
    );
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageViewController,
      children: [
        SearchPage(),
        ChatGroups(),
      ],
    );
  }
}
