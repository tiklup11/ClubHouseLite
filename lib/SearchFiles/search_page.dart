import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubHouseLite/ChatGroups/chat_groups.dart';
import 'package:clubHouseLite/Profile/profile.dart';
import 'package:clubHouseLite/SearchFiles/searchedUser.dart';
import 'package:clubHouseLite/SearchFiles/searched_user_card.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:clubHouseLite/home_pages/home_page.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> searchedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => toggleSwipeToMessage());
  }

  toggleSwipeToMessage() {
    print("searchPage");
    // Provider.of<FNMPageViewController>(context, listen: false)
    // .setIsSwipeAblePage(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
        appBar: AppBar(
          // actions: [IconButton(icon: Icon(EvaIcons.search), onPressed: () {})],
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: appTheme.bottomNavBar,

          title: RichText(
            text: TextSpan(
                text: "Search",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: ConstantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: "er",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: appTheme.darkOnLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ]),
          ),
        ),
        backgroundColor: appTheme.backgroundColor,
        body: Column(
          children: [
            searchBar(context),
            searchedUser == null ? normalSearchImage() : buildUserList(context),
          ],
        ),
      ),
    );
  }

  TextEditingController seachEditingController;

  searchBar(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ConstantColors.lightBlueColor.withOpacity(0.1)),
        child: Center(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            onChanged: checkInCloud,
            cursorWidth: 5,
            cursorColor: ConstantColors.whiteColor,
            cursorHeight: 28,
            decoration: InputDecoration(
                prefixIcon: Icon(
              EvaIcons.search,
              color: appTheme.darkOnLight,
            )),
            controller: seachEditingController,
          ),
        ),
      ),
    );
  }

  normalSearchImage() {
    return Expanded(
      child: Center(
        child: Image.asset(
          "assets/gifs/looking.gif",
          height: 200,
          width: 400,
        ),
      ),
    );
  }

  void checkInCloud(String query) async {
    if (query.trim().isNotEmpty) {
      Future<QuerySnapshot> users = usersRef
          .where("userDisplayName", isGreaterThanOrEqualTo: query)
          .get();

      setState(() {
        searchedUser = users;
      });
    }
  }

  buildUserList(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: searchedUser,
      builder: (context, snaphot) {
        if (!snaphot.hasData) {
          return CircularProgressIndicator(
            backgroundColor: ConstantColors.blueColor,
          );
        }
        List<SearchedUserCard> searchedUserList = [];
        snaphot.data.docs.forEach((userDoc) {
          SearchedUser newUser = new SearchedUser(
              imageUrl: userDoc.data()['userImageUrl'],
              userName: userDoc.data()['userDisplayName']);
          searchedUserList.add(SearchedUserCard(
            searchedUser: newUser,
          ));
        });
        print(searchedUserList);

        return Expanded(
          child: ListView(
            shrinkWrap: true,
            children: searchedUserList,
          ),
        );
      },
    );
  }
}
