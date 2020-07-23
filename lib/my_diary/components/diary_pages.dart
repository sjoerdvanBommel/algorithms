import 'dart:math' as math;
import 'package:algorithms/my_diary/components/book.dart';
import 'package:algorithms/my_diary/controllers/diary_day_controller.dart';
import 'package:algorithms/my_diary/functions/drag_functions.dart';
import 'package:algorithms/my_diary/models/diary_day.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

import 'diary_page.dart';

class DiaryPages extends StatefulWidget {
  final DiaryDayController diaryDayController = DiaryDayController();

  DiaryPages({Key key}) : super(key: key);

  @override
  _DiaryPagesState createState() => _DiaryPagesState();
}

class _DiaryPagesState extends State<DiaryPages>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<DiaryDay> diaryDays;
  Future<List<DiaryDay>> diaryDaysFuture;

  int currentDay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        if (currentDay < diaryDays.length - 1 &&
            status == AnimationStatus.completed) {
          setState(() {
            currentDay++;
            _controller.value = 0.000001;
          });
        } else if (currentDay > 0 && status == AnimationStatus.dismissed) {
          setState(() {
            currentDay--;
            _controller.value = 0.999999;
          });
        }
      });
    _updateDiaryDays();
  }

  _updateDiaryDays() async {
    diaryDaysFuture = _getAllDiaryDays();
    List<DiaryDay> days = await diaryDaysFuture;
    setState(() {
      diaryDays = days;
      currentDay = days.length - 1;
    });
  }

  Future<List<DiaryDay>> _getAllDiaryDays() async {
    return (await widget.diaryDayController.getAll()).body;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _controller.value -= details.primaryDelta / 300;
      },
      onHorizontalDragEnd: (details) =>
          onHorizontalDragEnd(_controller, details, context, false, .7),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          width: double.infinity,
          height: double.infinity,
          child: ZefyrScaffold(
            child: Book(
              top: 150,
              child: Stack(
                children: <Widget>[
                  DiaryPage(boxShadow: true),
                  FutureBuilder(
                    future: diaryDaysFuture,
                    builder: (context, AsyncSnapshot<List<DiaryDay>> snapshot) {
                      if (snapshot.hasData) {
                        return Stack(
                          children: <Widget>[
                            currentDay >= snapshot.data.length - 1
                                ? DiaryPage(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'This was your diary...\n\nWant to add a new day to it?\n',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Colors.grey[600]),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Text(
                                              'Click here',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Transform(
                                    transform: Matrix4.identity(),
                                    child: DiaryPage(
                                      diaryDay: snapshot.data[currentDay + 1],
                                    ),
                                  ),
                            Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(math.pi / 2 * _controller.value),
                              child: DiaryPage(
                                diaryDay: snapshot.data[currentDay],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('Loading');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Expanded(
    //   child: CarouselSlider.builder(
    //     carouselController: carouselController,
    //     options: CarouselOptions(
    //       height: double.infinity,
    //       enableInfiniteScroll: false,
    //       initialPage: days.length - 1,
    //     ),
    //     itemCount: days.length,
    //     itemBuilder: (context, i) => Builder(
    //       builder: (BuildContext context) {
    //         return Container(
    //           width: MediaQuery.of(context).size.width,
    //           margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
    //           child: DiaryPage(day: i),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
