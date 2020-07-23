import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyDiaryNavigationBar extends StatelessWidget {
  final int selected;
  final Function onTap;

  const MyDiaryNavigationBar({
    Key key,
    this.selected,
    this.onTap,
  }) : super(key: key);

  getIconColor(int icon, BuildContext context) {
    return selected == icon
        ? Theme.of(context).accentIconTheme.color
        : Colors.grey[400];
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTap,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_carousel,
              size: 30, color: getIconColor(0, context)),
          title: Text('Diary'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outline,
            size: 35,
            color: getIconColor(1, context),
          ),
          title: Text('Add'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FlutterIcons.user_fea,
            size: 25,
            color: getIconColor(2, context),
          ),
          title: Text('Account'),
        ),
      ],
    );
  }
}
