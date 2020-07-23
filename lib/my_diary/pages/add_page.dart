import 'dart:convert';

import 'package:algorithms/my_diary/components/book.dart';
import 'package:algorithms/my_diary/components/my_diary_navigation_bar.dart';
import 'package:algorithms/my_diary/controllers/diary_day_controller.dart';
import 'package:algorithms/my_diary/controllers/weather_controller.dart';
import 'package:algorithms/my_diary/models/diary_day.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class AddPage extends StatefulWidget {
  final DiaryDayController diaryDayController = DiaryDayController();
  final WeatherController weatherController = WeatherController();
  final Function onTapBottomButton;

  AddPage({Key key, this.onTapBottomButton}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        ZefyrController(NotusDocument.fromDelta(Delta()..insert("\n")));
    _focusNode = FocusNode();
  }

  _addDiaryDay() async {
    FocusScope.of(context).unfocus();
    widget.diaryDayController.add(
      DiaryDay(
        title: 'Titel 123',
        content: jsonEncode(_controller.document),
        dayDate: DateTime.now(),
        weatherIcon: await widget.weatherController.getWeatherIconString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ZefyrScaffold(
              child: Book(
                top: 176,
                child: ZefyrEditor(
                  padding: EdgeInsets.only(left: 20, right: 70),
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: false,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: IconButton(
              iconSize: 30,
              color: Theme.of(context).accentIconTheme.color,
              icon: Icon(Icons.save),
              onPressed: _addDiaryDay,
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          MyDiaryNavigationBar(onTap: widget.onTapBottomButton, selected: 1),
    );
  }
}
