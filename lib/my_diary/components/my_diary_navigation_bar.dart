import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyDiaryNavigationBar extends StatelessWidget {
  const MyDiaryNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_carousel,
              size: 30, color: Theme.of(context).primaryIconTheme.color),
          title: Text('Diary'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 35),
          title: Text('Add'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.user_fea, size: 25),
          title: Text('Account'),
        ),
      ],
    );
  }
}
