import 'package:algorithms/my_diary/components/date_weather.dart';
import 'package:flutter/material.dart';
import '../components/diary_pages.dart';
import '../components/my_diary_navigation_bar.dart';
import 'package:algorithms/my_diary/components/flip_drawer.dart';

class HistoryPage extends StatefulWidget {
  final Function onTapBottomButton;

  HistoryPage({Key key, this.onTapBottomButton}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlipDrawer(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  DateWeather(),
                  BottomButtons(),
                  DiaryPages(),
                ],
              ),
            ),
            bottomNavigationBar: MyDiaryNavigationBar(
              selected: 0,
              onTap: widget.onTapBottomButton,
            ),
          ),
        ),
      ],
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 0,
      right: 0,
      child: Center(
        child: OutlineButton(
          onPressed: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(Duration(days: 365))),
          child: Text('Pick a date', style: TextStyle(color: Colors.grey[500])),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
