import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  bool isLightTheme = true;

  Color backgroundColor = ConstantColors.whiteColor;
  Color selectedIcon = ConstantColors.darkColor;
  Color unSelectedIcon = ConstantColors.greyColor.withOpacity(0.8);
  Color bottomNavBar = ConstantColors.whiteColor;
  Color primaryColor = ConstantColors.whiteColor;
  Color msgIconColor = ConstantColors.blueColor;
  Color darkOnLight = ConstantColors
      .darkColor; //dark color on light-theme && blue color on darkTheme
  Color bnw = ConstantColors.darkColor;
  // Color greyBackground = ConstantColors.
  // blueGreyColor.withOpacity(0.6);

  void toggleTheme() {
    if (isLightTheme) {
      backgroundColor = ConstantColors.darkColor;
      bottomNavBar = Color(0xFF040307);
      primaryColor = ConstantColors.blueColor;
      selectedIcon = ConstantColors.blueColor;
      unSelectedIcon = ConstantColors.blueGreyColor;
      bnw = ConstantColors.whiteColor;
      darkOnLight = ConstantColors.blueColor;
      msgIconColor = ConstantColors.whiteColor;

      isLightTheme = false;
      notifyListeners();
      return;
    } else {
      selectedIcon = ConstantColors.darkColor;
      bnw = ConstantColors.darkColor;
      unSelectedIcon = ConstantColors.greyColor.withOpacity(0.8);
      backgroundColor = ConstantColors.whiteColor;
      bottomNavBar = ConstantColors.whiteColor;
      primaryColor = ConstantColors.whiteColor;
      darkOnLight = ConstantColors.darkColor;
      msgIconColor = ConstantColors.blueColor;

      isLightTheme = true;
      notifyListeners();
    }
  }
}
