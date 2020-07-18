import 'package:algorithms/algorithms/components/algorithm_chips.dart';
import 'package:algorithms/algorithms/enums/chip_label.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final String title, description;
  final Function onTapRealExample;
  final List<ChipLabel> chips;

  CardHeader(
      {@required this.title,
      this.onTapRealExample,
      this.chips: const [],
      this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            GestureDetector(
              child: Text(
                'Real example',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: onTapRealExample,
            ),
          ],
        ),
        SizedBox(height: 2),
        AlgorithmChips(chips),
        SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.grey),
          textAlign: TextAlign.justify,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
