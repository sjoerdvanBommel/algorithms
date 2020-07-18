import 'package:flutter/material.dart';

class StepsWidget extends StatelessWidget {
  final Function onBack, onNext;
  final Widget child;

  StepsWidget({this.onBack, this.onNext, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          iconSize: 36,
          icon: Icon(Icons.arrow_left),
          onPressed: onBack,
        ),
        Expanded(child: child),
        IconButton(
          iconSize: 36,
          icon: Icon(Icons.arrow_right),
          onPressed: onNext,
        ),
      ],
    );
  }
}
