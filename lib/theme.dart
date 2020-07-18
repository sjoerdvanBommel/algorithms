import 'package:flutter/material.dart';

enum ThemeType { Algorithms, MyDiary }

extension ThemeTypeData on ThemeType {
  get themeData {
    switch (this) {
      case ThemeType.Algorithms:
        return ThemeData.light().copyWith(
          primaryColor: Colors.blue[700],
          buttonColor: Colors.blue[700],
          accentColor: Colors.blue[200],
          backgroundColor: Colors.blue[50],
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
          textTheme: TextTheme(
            headline4: TextStyle(fontSize: 30, color: Colors.black),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
      case ThemeType.MyDiary:
        return ThemeData.light().copyWith(
          backgroundColor: Color(0xFFFCFCFC),
          primaryIconTheme: IconThemeData(color: Colors.grey[800]),
          textTheme: TextTheme(
              bodyText1: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[800],
              ),
              button: TextStyle(
                color: Colors.grey[500],
              )),
        );
    }
  }
}

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = ThemeType.Algorithms.themeData;

  setTheme(ThemeType type) {
    currentTheme = type.themeData;
    return notifyListeners();
  }
}
