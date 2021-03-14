import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWidget {
  static Widget profileDataWidget(BuildContext context, User currrentuser) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Container(
        decoration: BoxDecoration(
            // color: ConstantColors.lightColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: ConstantColors.darkColor,
                  radius: 36,
                  backgroundImage: NetworkImage(currrentuser.photoURL),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(currrentuser.displayName,
                    style: TextStyle(color: appTheme.bnw)),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Icon(
                      EvaIcons.emailOutline,
                      color: ConstantColors.lightBlueColor,
                    ),
                    Text(currrentuser.email,
                        style: TextStyle(fontSize: 12, color: appTheme.bnw)),
                  ],
                )
              ],
            ),
            generalNumberData()
          ],
        ),
      ),
    );
  }

  static Widget generalNumberData() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _customBox(boxTitle: "Posts", data: 12),
              _customBox(boxTitle: "Stars", data: 23),
            ],
          ),
          Row(
            children: [
              _customBox(boxTitle: "Achivements", data: 2),
            ],
          )
        ],
      ),
    );
  }

  static Widget _customBox({String boxTitle, int data}) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: appTheme.darkOnLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(data.toString(),
                style:
                    TextStyle(fontSize: 26, color: ConstantColors.whiteColor)),
            Text(
              boxTitle,
              style: TextStyle(color: ConstantColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  static Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: ConstantColors.whiteColor,
          borderRadius: BorderRadius.circular(14)),
      height: 0.5,
    );
  }

  static Widget noPostWidget() {
    return Container(
      child: Column(
        children: [
          Image.network(
            'https://i.gifer.com/4hsh.gif',
            height: 200,
            width: 200,
          ),
          Text(
            "No post posted",
            style: TextStyle(
                color: ConstantColors.yellowColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
