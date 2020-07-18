import 'package:algorithms/algorithms/enums/chip_label.dart';

enum SortingAlgorithm { bubbleSort }

extension AlgorithmExtension on SortingAlgorithm {
  List<ChipLabel> get chips {
    switch (this) {
      case SortingAlgorithm.bubbleSort:
        return [ChipLabel.sorting];
    }
    return [];
  }

  String get label {
    switch (this) {
      case SortingAlgorithm.bubbleSort:
        return 'Bubble sort';
      default:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case SortingAlgorithm.bubbleSort:
        return 'Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in wrong order.';
      default:
        return 'No description';
    }
  }

  String get tutorial {
    switch (this) {
      case SortingAlgorithm.bubbleSort:
        return 'xli_FI7CuzA';
      default:
        return 'xli_FI7CuzA';
    }
  }
}
