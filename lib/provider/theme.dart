import 'package:flutter/material.dart';

enum AppTheme {
  AmberLight,
  AmberDark,
  BlueLight,
  BlueDark,
}


final appThemeData = {
  AppTheme.AmberLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.amber
  ),
  AppTheme.AmberDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.amber[700]
  ),
  AppTheme.BlueLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue
  ),
  AppTheme.BlueDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700]
  ),
};

final appThemeTitle = {
  AppTheme.AmberLight: '亮银湖泊',
  AppTheme.AmberDark: '暗夜琥珀',
  AppTheme.BlueLight: '幻昼明蓝',
  AppTheme.BlueDark: '极夜深蓝',
};