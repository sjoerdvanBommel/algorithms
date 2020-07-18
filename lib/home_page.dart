import 'package:algorithms/algorithms/pages/info_page.dart';
import 'package:algorithms/my_diary/pages/my_diary_page.dart';
import 'package:algorithms/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChangeThemeButton(
              text: 'Algorithms',
              themeType: ThemeType.Algorithms,
              routeName: InfoPage.routeName,
            ),
            ChangeThemeButton(
              text: 'My Diary',
              themeType: ThemeType.MyDiary,
              routeName: MyDiaryPage.routeName,
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeThemeButton extends StatelessWidget {
  final String text, routeName;
  final ThemeType themeType;

  const ChangeThemeButton({
    Key key,
    this.text,
    this.routeName,
    this.themeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text(text),
        onPressed: () {
          Provider.of<ThemeModel>(context, listen: false).setTheme(themeType);
          Navigator.pushReplacementNamed(context, routeName);
        },
      ),
    );
  }
}
