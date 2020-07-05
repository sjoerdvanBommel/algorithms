import 'package:algorithms/components/my_chip.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/enums/chip_label.dart';
import 'package:flutter/material.dart';

class AlgorithmChips extends StatelessWidget {
  final PathfindingAlgorithm algorithm;

  AlgorithmChips(this.algorithm);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 6,
        runSpacing: -9,
        children: algorithm.chips.map((chip) => MyChip(chip.label)).toList(),
      ),
    );
  }
}
