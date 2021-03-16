import 'dart:io';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import "package:clubHouseLite/constants/Constantcolors.dart";

class FeedWidgets {
  static finalImagePreviewToUser({File file}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Column(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.image_aspect_ratio,
                    color: ConstantColors.greenColor,
                  ),
                  onPressed: () {
                    //TODO:
                  }),
              IconButton(
                  icon: Icon(
                    Icons.fit_screen,
                    color: ConstantColors.whiteColor,
                  ),
                  onPressed: () {}),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: ConstantColors.darkColor),
                borderRadius: BorderRadius.circular(10),
                color: ConstantColors.transperant),
            child: Center(
              child: Image(
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  return Center(child: child);
                },
                image: FileImage(
                  file,
                ),
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget customDrawer(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 100,
        child: Drawer(
          elevation: 0,
          child: Container(
              color: appTheme.bottomNavBar,
              child: ListView(
                children: [
                  iconBox(
                    bgColor: ConstantColors.blueColor,
                    icon: appTheme.isLightTheme
                        ? Icon(
                            FontAwesomeIcons.sun,
                            color: Colors.deepOrangeAccent,
                            size: 30,
                          )
                        : Icon(
                            FontAwesomeIcons.moon,
                            color: ConstantColors.darkColor,
                            size: 30,
                          ),
                    onTab: () {
                      appTheme.toggleTheme();
                      // Navigator.pop(context);
                    },
                  ),
                  iconBox(
                    bgColor: ConstantColors.blueColor.withOpacity(0.6),
                    icon: Icon(
                      FontAwesomeIcons.userLock,
                      color: ConstantColors.darkColor,
                      size: 28,
                    ),
                  ),
                  iconBox(
                    bgColor: Colors.blueAccent,
                    icon: Icon(
                      FontAwesomeIcons.shareAlt,
                      color: ConstantColors.darkColor,
                      size: 30,
                    ),
                  ),
                  iconBox(
                    bgColor: ConstantColors.blueColor,
                    icon: Icon(
                      FontAwesomeIcons.upload,
                      color: ConstantColors.darkColor,
                      size: 30,
                    ),
                  ),
                  iconBox(
                    bgColor: ConstantColors.blueColor.withOpacity(0.6),
                    icon: Icon(
                      FontAwesomeIcons.bug,
                      color: ConstantColors.darkColor,
                      size: 28,
                    ),
                  ),
                  iconBox(
                    bgColor: Colors.blueAccent,
                    icon: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: ConstantColors.darkColor,
                      size: 30,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  static Widget iconBox({Icon icon, Function onTab, Color bgColor}) {
    return Container(
      width: 100,
      height: 100,
      color: bgColor,
      child: IconButton(
        icon: icon,
        onPressed: onTab,
      ),
    );
  }
}
