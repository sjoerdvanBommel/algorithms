import 'package:algorithms/my_diary/enums/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DateDropdowns extends StatelessWidget {
  final years = List.generate(5, (i) => 2020 - i);

  DateDropdowns({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            radius: 16,
            icon: Icon(FlutterIcons.keyboard_arrow_down_mdi),
            underline: Container(width: 0.0),
            iconEnabledColor: Theme.of(context).primaryIconTheme.color,
            onChanged: (_) {},
            items: years
                .map(
                  (year) => DropdownMenuItem(
                    child: Text(
                      year.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(width: 30),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            icon: Icon(FlutterIcons.keyboard_arrow_down_mdi),
            underline: Container(width: 0.0),
            iconEnabledColor: Theme.of(context).primaryIconTheme.color,
            onChanged: (_) {},
            items: Month.values
                .map(
                  (month) => DropdownMenuItem(
                    child: Text(
                      month.fullName,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
