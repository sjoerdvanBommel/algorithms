import 'package:pathfinder/pathfinders/weighted_algorithm.dart';

class DepthFirstSearchAlgorithm extends WeightedAlgorithm {
  bool visitedEnd = false;

  DepthFirstSearchAlgorithm(
      Set<int> walls, int nColumns, int nRows, int start, int end)
      : super(List.generate(nColumns * nRows, (index) => 1), walls, nColumns,
            start, end) {
    dfs(start, getConnectedIndexes(start));
  }

  void dfs(int parent, List<int> connectedIndexes) {
    for (int i = 0; i < connectedIndexes.length; i++) {
      int connectedIndex = connectedIndexes[i];
      if (distances[parent] + 1 < distances[connectedIndex]) {
        distances[connectedIndex] = distances[parent] + 1;
        shortestPaths[connectedIndex] = [...shortestPaths[parent], parent];
        indexesForAnimation.add(connectedIndex);
        dfs(connectedIndex, getConnectedIndexes(connectedIndex));
      }
      settledIndexes.add(connectedIndex);
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
