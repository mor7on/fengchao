import 'package:flutter/material.dart';

import 'theme.dart';

class AppStateModel with ChangeNotifier {
  AppStateModel({ThemeData theme, Locale locale}) {
    this.theme = theme ?? appThemeData[AppTheme.AmberLight];
    this.locale = locale ?? Locale('zh', 'CN');
  }

  ///主题数据
  ThemeData theme;

  ///语言
  Locale locale;

  List<Locale> supportedLocales = [Locale('en', 'US'), Locale('zh', 'CN'), Locale('zh', 'TW')];

  void refreshTheme(ThemeData newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  void refreshLocale(Locale newLocale) {
    locale = newLocale;
    notifyListeners();
  }
}
