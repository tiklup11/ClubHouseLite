import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.darkColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gifs/camm.gif',
              height: 50,
              width: 50,
            ),
            RichText(
              text: TextSpan(
                  text: "Club",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: ConstantColors.whiteColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: "House",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: ConstantColors.blueColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
