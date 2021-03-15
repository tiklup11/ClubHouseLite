import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubHouseLite/ChatGroups/chat_groups.dart';
import 'package:clubHouseLite/Feed/feed.dart';
import 'package:clubHouseLite/Profile/profile.dart';
import 'package:clubHouseLite/SearchFiles/message_page_view.dart';
import 'package:clubHouseLite/SearchFiles/search_page.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection("users");
final CollectionReference postRef =
    FirebaseFirestore.instance.collection("posts");
final Reference storageRef = FirebaseStorage.instance.ref();

class HomePage extends StatefulWidget {
  HomePage({this.user});
  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homePageController = new PageController();
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => toggleSwipeToMessage());
  }

  toggleSwipeToMessage(int pageIndex) {
    if (pageIndex == 0) {
      Provider.of<FNMPageViewController>(context, listen: false)
          .setIsSwipeAblePage(true);
    } else {
      Provider.of<FNMPageViewController>(context, listen: false)
          .setIsSwipeAblePage(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
        backgroundColor: appTheme.backgroundColor,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          allowImplicitScrolling: true,
          pageSnapping: true,
          controller: homePageController,
          children: [
            UserFeed(
              currentUser: widget.user,
            ),
            // MessagePageView(),
            SearchPage(),
            // ChatGroups(),
            Profile(
              currentUser: widget.user,
            ),
          ],
          onPageChanged: (index) {
            setState(() {
              homePageController.jumpToPage(index);
              toggleSwipeToMessage(index);
              // homePageController.animateToPage(index,curve: Curves.bounceIn,duration: Duration(milliseconds: 500));
              pageIndex = index;
            });
          },
        ),
        bottomNavigationBar: Container(
          height: 65,
          color: appTheme.bottomNavBar,
          padding: EdgeInsets.only(top: 10),
          child: CustomNavigationBar(
            elevation: 0,
            currentIndex: pageIndex,
            bubbleCurve: Curves.bounceInOut,
            scaleCurve: Curves.decelerate,
            selectedColor: appTheme.selectedIcon,
            // selectedColor: ,
            unSelectedColor: appTheme.unSelectedIcon,
            strokeColor: appTheme.selectedIcon,
            scaleFactor: 0.5,
            iconSize: 34.0,
            onTap: (index) {
              setState(() {
                homePageController.jumpToPage(index);
                pageIndex = index;
              });
            },
            backgroundColor: appTheme.bottomNavBar,
            // backgroundColor: Color(0xFF040307),
            items: [
              CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
              CustomNavigationBarItem(
                  icon: Icon(
                FontAwesomeIcons.search,
                size: 27,
              )),
              // CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
              CustomNavigationBarItem(icon: Icon(EvaIcons.person)),
            ],
          ),
        ),
      ),
    );
  }
}
