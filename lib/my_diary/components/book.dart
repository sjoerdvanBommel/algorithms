import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  final double top;
  final Widget child;

  const Book({Key key, @required this.top, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Transform(
        transform: Matrix4.diagonal3Values(1.45, 1.7, 1.0)
          ..translate(0.0, 50.0, 0.0),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/book.png'),
      )
    ];

    if (child != null)
      children.add(
        Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          height: 580,
          child: child,
        ),
      );

    return Transform.translate(
      offset: Offset(0, top - 50),
      child: Stack(
        children: children,
      ),
    );
  }
}
