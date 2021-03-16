import 'package:clubHouseLite/services/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EventView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          isExtended: true,
          label: Text(
            "Event",
            style:
                TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
          ),
          icon: Icon(
            Icons.add,
            size: 26,
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.question,
                color: appTheme.msgIconColor,
              ),
            ),
          ],
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: appTheme.bottomNavBar,
          title: RichText(
            text: TextSpan(
                text: "Event",
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
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
