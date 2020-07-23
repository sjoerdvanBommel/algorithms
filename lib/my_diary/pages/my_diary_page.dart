import 'package:algorithms/my_diary/pages/add_page.dart';
import 'package:algorithms/my_diary/pages/history_page.dart';
import 'package:algorithms/my_diary/pages/profile_page.dart';
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
    with TickerProviderStateMixin {
  AnimationController animationController1, animationController2;
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  void toggleScreen(int screenIndex) {
    if (currentScreen == 0 && screenIndex > 0) {
      animationController1.forward();
      if (screenIndex == 2) animationController2.forward();
    }
    if (currentScreen == 1 && screenIndex == 2) animationController2.forward();

    if (currentScreen == 2 && screenIndex < 2) {
      animationController2.reverse();
      if (screenIndex == 0) animationController1.reverse();
    }
    if (currentScreen == 1 && screenIndex == 0) animationController1.reverse();

    currentScreen = screenIndex;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      builder: (context, _) => AnimatedBuilder(
        builder: (context, _) => Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(
                  2 * screenWidth -
                      ((animationController1.value +
                              animationController2.value) *
                          screenWidth),
                  0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(
                      animationController1.value + animationController2.value <=
                              1
                          ? math.pi / 2
                          : math.pi *
                              (animationController1.value +
                                  animationController2.value -
                                  2) /
                              2),
                alignment: Alignment.centerLeft,
                child: ProfilePage(onTapBottomButton: (i) => toggleScreen(i)),
              ),
            ),
            Transform.translate(
              offset: Offset(
                  animationController2.value == 1
                      ? screenWidth
                      : screenWidth -
                          ((animationController1.value +
                                  animationController2.value) *
                              screenWidth),
                  0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-(math.pi / 2) +
                      math.pi *
                          (animationController1.value +
                              animationController2.value) /
                          2),
                alignment:
                    animationController1.value + animationController2.value <= 1
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                child: AddPage(onTapBottomButton: (i) => toggleScreen(i)),
              ),
            ),
            Transform.translate(
              offset: Offset(
                  animationController1.value + animationController2.value >= 1
                      ? screenWidth
                      : -screenWidth *
                          (animationController1.value +
                              animationController2.value),
                  0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(math.pi *
                      (animationController1.value +
                          animationController2.value) /
                      2),
                alignment: Alignment.centerRight,
                child: HistoryPage(onTapBottomButton: (i) => toggleScreen(i)),
              ),
            ),
          ],
        ),
        animation: animationController1,
      ),
      animation: animationController2,
    );
  }
}
