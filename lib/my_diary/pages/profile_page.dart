import 'package:algorithms/my_diary/components/flip_drawer.dart';
import 'package:algorithms/my_diary/components/my_diary_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Function onTapBottomButton;

  ProfilePage({Key key, this.onTapBottomButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlipDrawer(
          child: Scaffold(
            bottomNavigationBar: MyDiaryNavigationBar(onTap: onTapBottomButton, selected: 2,),
          ),
        ),
      ],
    );
  }
}
