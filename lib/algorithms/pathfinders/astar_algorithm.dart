import 'package:algorithms/algorithms/pathfinders/weighted_algorithm.dart';

class AstarAlgorithm extends WeightedAlgorithm {
  List<int> expectedDistances = new List<int>();

  AstarAlgorithm(
      List<int> weights, Set<int> walls, int nColumns, int start, int end)
      : super(weights, walls, nColumns, start, end) {
    expectedDistances = List.generate(weights.length, (i) => 0);
    super.run(getLowestExpectedDistanceIndex, calculateMinimumDistance);
  }

  int getLowestExpectedDistanceIndex() {
    int lowestExpectedDistance = 1 << 32;
    int lowestExpectedDistanceIndex = -1;
    unsettledIndexes.forEach((unsettledIndex) {
      int expectedDistance = expectedDistances[unsettledIndex];
      if (expectedDistance < lowestExpectedDistance) {
        lowestExpectedDistance = expectedDistance;
        lowestExpectedDistanceIndex = unsettledIndex;
      }
    });
    return lowestExpectedDistanceIndex;
  }

  void calculateMinimumDistance(int connectedIndex, int currentIndex) {
    int currentDistance = distances[currentIndex];
    int connectedWeight = weights[connectedIndex];
    if (currentDistance + connectedWeight < distances[connectedIndex]) {
      distances[connectedIndex] = currentDistance + connectedWeight;
      List<int> shortestPath = [...shortestPaths[currentIndex]];
      shortestPath.add(currentIndex);
      shortestPaths[connectedIndex] = shortestPath;
      int h = (((getX(connectedIndex) - getX(end)).abs() +
                  (getY(connectedIndex) - getY(end)).abs()) *
              getAverageWeight())
          .toInt();
      expectedDistances[connectedIndex] = h + distances[connectedIndex];
    }
  }

  double getAverageWeight() {
    int totalWeight = 0;
    for (int i = 0; i < weights.length; i++) {
      totalWeight += weights[i];
    }
    return totalWeight / weights.length;
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
