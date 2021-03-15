import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatGroups extends StatefulWidget {
  @override
  _ChatGroupsState createState() => _ChatGroupsState();
}

class _ChatGroupsState extends State<ChatGroups> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
        appBar: AppBar(
          leading: Consumer<FNMPageViewController>(
            builder: (context, fnm, _) => IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: appTheme.msgIconColor,
                ),
                onPressed: () {
                  fnm.jumpToPage(0);
                }),
          ),
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: appTheme.bottomNavBar,
          title: RichText(
            text: TextSpan(
                text: "Chat",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: appTheme.darkOnLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: "Hub",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: appTheme.darkOnLight.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ]),
          ),
        ),
        backgroundColor: appTheme.backgroundColor,
      ),
    );
  }
}
