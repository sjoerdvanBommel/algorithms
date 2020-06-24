abstract class WeightedAlgorithm {
  int getDistance();
  List<int> getShortestPath();
  List<int> getVisitedIndexes();

  Map<int, List<int>> shortestPaths = new Map<int, List<int>>();
  List<int> weights;
  Set<int> unsettledIndexes, settledIndexes, walls, indexesForAnimation;
  int start, end, nColumns;
  List<int> distances;

  WeightedAlgorithm(this.weights, this.walls, this.nColumns, this.start, this.end) {
    distances = List.generate(weights.length, (i) => 1 << 32);
    unsettledIndexes = new Set<int>();
    settledIndexes = new Set<int>();
    indexesForAnimation = new Set<int>();
    shortestPaths[start] = new List<int>();
    distances[start] = 0;
    unsettledIndexes.add(start);
  }

  void run(lowestIndexFunction, minimumDistanceFunction) {
    while (unsettledIndexes.isNotEmpty && !endFound()) {
      int lowestDistanceIndex = lowestIndexFunction();
      if (lowestDistanceIndex == -1 ||
          distances[lowestDistanceIndex] >= distances[end]) break;
      unsettledIndexes.remove(lowestDistanceIndex);
      List<int> connectedIndexes = getConnectedIndexes(lowestDistanceIndex);
      for (int i = 0; i < connectedIndexes.length; i++) {
        if (!settledIndexes.contains(connectedIndexes[i])) {
          minimumDistanceFunction(connectedIndexes[i], lowestDistanceIndex);
          unsettledIndexes.add(connectedIndexes[i]);
          indexesForAnimation.add(connectedIndexes[i]);
        }
      }
      settledIndexes.add(lowestDistanceIndex);
      indexesForAnimation.add(lowestDistanceIndex);
    }
  }

  bool endFound() {
    return settledIndexes.containsAll(getConnectedIndexes(end));
  }

  List<int> getConnectedIndexes(int index) {
    List<int> connectedIndexes = new List<int>();
    int indexAbove = index - nColumns,
        indexRight = index + 1,
        indexBelow = index + nColumns,
        indexLeft = index - 1;
    if (indexAbove >= 0 && !walls.contains(indexAbove))
      connectedIndexes.add(indexAbove);
    if (indexRight % nColumns != 0 && !walls.contains(indexRight))
      connectedIndexes.add(indexRight);
    if (indexBelow < weights.length && !walls.contains(indexBelow))
      connectedIndexes.add(indexBelow);
    if (index % nColumns != 0 && !walls.contains(indexLeft))
      connectedIndexes.add(indexLeft);
    return connectedIndexes;
  }

  int getY(int i) {
    return (i / nColumns).floor();
  }

  int getX(int i) {
    return i % nColumns;
  }
}