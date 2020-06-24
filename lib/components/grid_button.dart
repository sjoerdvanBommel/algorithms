import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  GridButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 30,
      minWidth: 30,
      child: OutlineButton(
        padding: EdgeInsets.all(12),
        borderSide: BorderSide(
          color: Theme.of(context).backgroundColor,
          width: 1,
        ),
        child: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
