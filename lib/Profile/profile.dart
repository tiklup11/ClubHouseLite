import 'package:clubHouseLite/Profile/profile_widgets.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final User currentUser;
  Profile({this.currentUser});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
          backgroundColor: appTheme.backgroundColor,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.settings, color: ConstantColors.whiteColor),
            ),
            actions: [
              IconButton(
                icon: Icon(EvaIcons.logOut),
                onPressed: () {
                  logOutDialog(context);
                },
              ),
            ],
            centerTitle: true,
            backgroundColor: appTheme.bottomNavBar,
            title: RichText(
              text: TextSpan(
                  text: "My",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: appTheme.darkOnLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Profile",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: appTheme.darkOnLight.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ]),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: ConstantColors.blueColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ProfileWidget.profileDataWidget(context, widget.currentUser),
                  ProfileWidget.divider(),
                  ProfileWidget.noPostWidget(),
                ],
              ),
            ),
          )),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors.darkColor,
            title: Text(
              "Log out ?",
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            actions: [
              MaterialButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.whiteColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: ConstantColors.redColor,
                child: Text(
                  "LogOut",
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.whiteColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _signOut();
                },
              )
            ],
          );
        });
  }
}
