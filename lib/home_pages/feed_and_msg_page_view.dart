import 'package:clubHouseLite/ChatGroups/chat_groups.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:clubHouseLite/home_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedAndMessagePageView extends StatelessWidget {
  final User user;
  FeedAndMessagePageView({
    this.user,
  });
  PageController pageViewController;
  @override
  Widget build(BuildContext context) {
    FNMPageViewController fnM = Provider.of<FNMPageViewController>(context);
    // pageViewController = new PageController(initialPage: 0);
    return Consumer<FNMPageViewController>(
      builder: (context, fnm, _) => PageView(
        controller:fnm.pageViewController,
        children: [
          HomePage(
            user: user,
          ),
          ChatGroups(),
        ],
      ),
    );
  }
}
