import 'dart:collection';

import 'package:algorithms/algorithms/pathfinders/weighted_algorithm.dart';

class BreadthFirstSearchAlgorithm extends WeightedAlgorithm {
  BreadthFirstSearchAlgorithm(
      Set<int> walls, int nColumns, int nRows, int start, int end)
      : super(List.generate(nColumns * nRows, (index) => 1), walls, nColumns,
            start, end) {
    Queue<int> queue = new Queue<int>();
    distances[start] = 0;
    queue.addFirst(start);
    while (queue.isNotEmpty) {
      int i = queue.removeLast();
      List<int> connectedIndexes = getConnectedIndexes(i);
      for (int j = 0; j < connectedIndexes.length; j++) {
        if (distances[connectedIndexes[j]] == 1 << 32) {
          distances[connectedIndexes[j]] = distances[i] + 1;
          shortestPaths[connectedIndexes[j]] = [...shortestPaths[i], i];
          queue.addFirst(connectedIndexes[j]);
          indexesForAnimation.add(connectedIndexes[j]);
          if (connectedIndexes[j] == end) return;
        }
      }
      indexesForAnimation.add(i);
    }
  }

  @override
  int getDistance() {
    return distances[end] == 1 << 32 ? -1 : distances[end];
  }

  @override
  List<int> getShortestPath() {
    return shortestPaths[end];
  }

  @override
  List<int> getVisitedIndexes() {
    return indexesForAnimation.toList();
  }
}
