import 'package:algorithms/pages/pathfinding_try_page.dart';
import 'package:flutter/material.dart';
import 'package:algorithms/pages/pathfinding_info_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Algorithms',
      theme: ThemeData(
        primaryColor: Colors.blue[700],
        buttonColor: Colors.blue[700],
        accentColor: Colors.blue[200],
        backgroundColor: Colors.blue[50],
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: PathfindingInfoPage.routeName,
      routes: {
        PathfindingInfoPage.routeName: (context) => PathfindingInfoPage(),
        PathfindingTryPage.routeName: (context) => PathfindingTryPage(),
      },
    );
  }
}