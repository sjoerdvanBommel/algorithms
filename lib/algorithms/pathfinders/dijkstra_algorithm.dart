import 'package:algorithms/algorithms/pathfinders/weighted_algorithm.dart';

class DijkstraAlgorithm extends WeightedAlgorithm {
  DijkstraAlgorithm(
      List<int> weights, Set<int> walls, int nColumns, int start, int end)
      : super(weights, walls, nColumns, start, end) {
    super.run(getLowestDistanceIndex, calculateMinimumDistance);
  }

  void calculateMinimumDistance(int connectedIndex, int currentIndex) {
    int currentDistance = distances[currentIndex];
    int connectedWeight = weights[connectedIndex];
    if (currentDistance + connectedWeight < distances[connectedIndex]) {
      distances[connectedIndex] = currentDistance + connectedWeight;
      List<int> shortestPath = [...shortestPaths[currentIndex]];
      shortestPath.add(currentIndex);
      shortestPaths[connectedIndex] = shortestPath;
    }
  }

  int getLowestDistanceIndex() {
    int lowestDistance = 1 << 32;
    int lowestDistanceIndex = -1;
    unsettledIndexes.forEach((unsettledIndex) {
      int currentDistance = distances[unsettledIndex];
      if (currentDistance < lowestDistance) {
        lowestDistance = currentDistance;
        lowestDistanceIndex = unsettledIndex;
      }
    });
    return lowestDistanceIndex;
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
