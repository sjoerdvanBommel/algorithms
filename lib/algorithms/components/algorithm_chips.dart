import 'package:algorithms/algorithms/components/my_chip.dart';
import 'package:algorithms/algorithms/enums/chip_label.dart';
import 'package:flutter/material.dart';

class AlgorithmChips extends StatelessWidget {
  final List<ChipLabel> chips;

  AlgorithmChips(this.chips);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 6,
        runSpacing: -9,
        children: chips.map((chip) => MyChip(chip.label)).toList(),
      ),
    );
  }
}
