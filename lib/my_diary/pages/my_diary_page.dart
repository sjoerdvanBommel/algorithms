import 'package:algorithms/my_diary/pages/add_page.dart';
import 'package:algorithms/my_diary/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyDiaryPage extends StatefulWidget {
  static final routeName = '/my_diary';

  const MyDiaryPage({Key key}) : super(key: key);

  static _MyDiaryPageState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyDiaryPageState>();

  @override
  _MyDiaryPageState createState() => _MyDiaryPageState();
}

class _MyDiaryPageState extends State<MyDiaryPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() {
    animationController.animateTo(currentScreen / 2);
    currentScreen = (currentScreen + 1) % 3;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      builder: (context, _) => Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(-screenWidth * animationController.value, 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(math.pi * animationController.value / 2),
              alignment: Alignment.centerRight,
              child: HistoryPage(),
            ),
          ),
          Transform.translate(
            offset: Offset(
                screenWidth - (animationController.value * screenWidth), 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((animationController.value - .5) * math.pi),
              alignment: Alignment.centerLeft,
              child: AddPage(),
            ),
          ),
          Transform.translate(
            offset: Offset(
                screenWidth - (animationController.value * screenWidth), 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(((animationController.value - 1) * math.pi) / 2),
              alignment: Alignment.centerLeft,
              child: AddPage(),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: toggle,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      animation: animationController,
    );
  }
}
