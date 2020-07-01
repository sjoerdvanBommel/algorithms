import 'package:algorithms/pathfinders/astar_algorithm.dart';
import 'package:algorithms/pathfinders/depth_first_search_algorithm.dart';
import 'package:algorithms/pathfinders/dijkstra_algorithm.dart';
import 'package:algorithms/pathfinders/breadth_first_search_algorithm.dart';
import 'package:algorithms/pathfinders/weighted_algorithm.dart';

enum PathfindingAlgorithm {
  dijkstra, astar, breadthFirstSearch, depthFirstSearch
}

extension AlgorithmExtension on PathfindingAlgorithm {
  String get label {
    switch (this) {
      case PathfindingAlgorithm.dijkstra: return 'Dijkstra';
      case PathfindingAlgorithm.astar: return 'A* search';
      case PathfindingAlgorithm.breadthFirstSearch: return 'Breadth-first search';
      case PathfindingAlgorithm.depthFirstSearch: return 'Depth-first search';
      default: return 'Unknown';
    }
  }
  
  String get description {
    switch (this) {
      case PathfindingAlgorithm.dijkstra: return 'Dijkstra\'s Algorithm guarantees you the shortest path between the start node (you pick which one by clicking a node) and every other node in a graph.';
      case PathfindingAlgorithm.astar: return 'A* Search algorithm won\'t guarantee the shortest path, but the calculation time is very short because it knows where the end node is.';
      case PathfindingAlgorithm.breadthFirstSearch: return 'Breadth-first search (BFS) starts at the root node and explores all of the neighbor nodes prior to moving on to the next depth level.';
      case PathfindingAlgorithm.depthFirstSearch: return 'Depth-first search (DFS) starts at the root node and explores as far as possible along each branch before backtracking.';
      default: return 'No description';
    }
  }

  String get tutorial {
    switch (this) {
      case PathfindingAlgorithm.dijkstra: return '_lHSawdgXpI';
      case PathfindingAlgorithm.astar: return '6TsL96NAZCo';
      case PathfindingAlgorithm.breadthFirstSearch: return 'oDqjPvD54Ss';
      case PathfindingAlgorithm.depthFirstSearch: return '7fujbpJ0LB4';
      default: return 'No description';
    }
  }

  bool get weighted {
    switch (this) {
      case PathfindingAlgorithm.dijkstra: return true;
      case PathfindingAlgorithm.astar: return true;
      case PathfindingAlgorithm.breadthFirstSearch: return false;
      case PathfindingAlgorithm.depthFirstSearch: return false;
      default: return true;
    }
  }

  WeightedAlgorithm run(List<int> weights, Set<int> walls, int nColumns, int start, int end) {
    switch (this) {
      case PathfindingAlgorithm.dijkstra: return new DijkstraAlgorithm(weights, walls, nColumns, start, end);
      case PathfindingAlgorithm.astar: return new AstarAlgorithm(weights, walls, nColumns, start, end);
      case PathfindingAlgorithm.breadthFirstSearch: return new BreadthFirstSearchAlgorithm(walls, nColumns, (weights.length / nColumns).truncate(), start, end);
      case PathfindingAlgorithm.depthFirstSearch: return new DepthFirstSearchAlgorithm(walls, nColumns, (weights.length / nColumns).truncate(), start, end);
      default: return null;
    }
  }
}