import 'package:clubHouseLite/SearchFiles/searchedUser.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchedUserCard extends StatelessWidget {
  SearchedUserCard({this.searchedUser});
  final SearchedUser searchedUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ConstantColors.lightBlueColor),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/batman.png'),
          ),
          Text(searchedUser.userName),
        ],
      ),
    );
  }
}
