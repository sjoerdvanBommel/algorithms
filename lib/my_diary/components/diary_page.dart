import 'dart:convert';

import 'package:algorithms/my_diary/controllers/weather_controller.dart';
import 'package:algorithms/my_diary/models/diary_day.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class DiaryPage extends StatefulWidget {
  final bool boxShadow;
  final DiaryDay diaryDay;
  final Widget child;
  final WeatherController weatherController = WeatherController();

  DiaryPage({
    Key key,
    this.diaryDay,
    this.boxShadow,
    this.child,
  }) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool editting = false;

  _toggleEditMode() => setState(() => editting = !editting);

  _getZefyrController() {
    return ZefyrController(
        NotusDocument.fromJson(jsonDecode(widget.diaryDay.content)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform(
          transform: Matrix4.diagonal3Values(1.016, 1.015, 1.0)
            ..translate(-4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(4),
                topLeft: Radius.circular(18),
                topRight: Radius.circular(4),
              ),
              image: DecorationImage(
                image: AssetImage('assets/book-page.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: widget.boxShadow == true
                  ? [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 10,
                        color: Color(0xFFb8b1a4),
                      )
                    ]
                  : null,
            ),
          ),
        ),
        if (widget.diaryDay != null)
          Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.diaryDay.title,
                            style: Theme.of(context).textTheme.headline5,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-15, -5),
                          child: Icon(
                            widget.weatherController
                                .getIconData(widget.diaryDay.weatherIcon),
                            color: Theme.of(context).accentIconTheme.color,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ZefyrEditor(
                        controller: _getZefyrController(),
                        focusNode: FocusNode(),
                        mode: editting ? ZefyrMode.edit : ZefyrMode.select,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${widget.diaryDay.dayDate.day.toString().padLeft(2, '0')}-${widget.diaryDay.dayDate.month.toString().padLeft(2, '0')}-${widget.diaryDay.dayDate.year.toString()}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 23,
                      width: 35,
                      child: IconButton(
                        padding: EdgeInsets.only(bottom: 10),
                        icon: Icon(
                          editting ? Icons.save : Icons.edit,
                          color: Theme.of(context).accentIconTheme.color,
                        ),
                        onPressed: _toggleEditMode,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        else if (widget.child != null)
          widget.child
      ],
    );
  }
}
