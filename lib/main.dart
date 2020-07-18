import 'package:algorithms/algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/home_page.dart';
import 'package:algorithms/algorithms/pages/pathfinding_try_page.dart';
import 'package:algorithms/my_diary/pages/my_diary_page.dart';
import 'package:algorithms/theme.dart';
import 'package:flutter/material.dart';
import 'package:algorithms/algorithms/pages/info_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (BuildContext context) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Algorithms',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),

        // Algorithms
        InfoPage.routeName: (context) => InfoPage(),
        PathfindingTryPage.routeName: (context) =>
            PathfindingTryPage(PathfindingAlgorithm.dijkstra),

        // My Diary
        MyDiaryPage.routeName: (context) => MyDiaryPage(),
      },
    );
  }
}
