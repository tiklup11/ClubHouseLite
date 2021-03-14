import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:clubHouseLite/services/size_config.dart';

//MediaQuery r2d

///Working on new sign in functionality in this page
// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

// keytool -genkey -v -keystore c:\Users\tiklu\kirketKey\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

class _SignInPageState extends State<SignInPage> {
  final _firebaseAuth = FirebaseAuth.instance;

  ///this is the same user who logged in, but also contains
  ///some more properties
  User user;
  bool isLoading = false;

  ///Implementation of SignInWithGoogle
  ///

  _signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken),
          );
          // print(authResult.user.email);
          user = authResult.user;
          _uploadUserData(user);
          return user;
        } else {
          PlatformException(
              code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
              message: 'Missing Google Auth Token');
        }
      } else {
        PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by User');
      }
    } catch (e) {
      // print('QWERTY:: $e');
    }
  }

  _uploadUserData(User user) async {
    print('qwerty:: called');
    final _firestore = FirebaseFirestore.instance;
    final userDoc =
        await _firestore.collection('users').doc(user.uid.toString()).get();

    if (!userDoc.exists) {
      _firestore.collection('users').doc(user.uid.toString()).set({
        'userEmail': user.email,
        'usedId': user.uid,
        'userImageUrl': user.photoURL,
        'userDisplayName': user.displayName,
      });
    }

    print('qwerty:: ${user.email}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.darkColor,
      body: Padding(
        padding: EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
            ),
            SizedBox(
                height: 200,
                width: 200,
                child: Image.network('https://i.gifer.com/4AIB.gif')),
            SizedBox(
              height: 160,
            ),
            Bounce(
              onPressed: () {
                _signInWithGoogle();
                setState(() {
                  isLoading = true;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                // width: 200,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      EvaIcons.googleOutline,
                      color: Colors.blue,
                    ),
                    Text(
                      !isLoading ? "Continue with Google" : "Signing in..",
                      style:
                          TextStyle(color: Colors.blue, fontFamily: "Poppins"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "By continuing you agree Okays terms and conditions",
              style: TextStyle(color: ConstantColors.whiteColor, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  Container loadingScreen() {
    return Container(
      height: (SizeConfig.oneH * 30).roundToDouble(),
      child: Center(
        child: Text(
          "signing in...",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
