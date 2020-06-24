import 'package:pathfinder/pathfinders/astar_algorithm.dart';
import 'package:pathfinder/pathfinders/depth_first_search_algorithm.dart';
import 'package:pathfinder/pathfinders/dijkstra_algorithm.dart';
import 'package:pathfinder/pathfinders/breadth_first_search_algorithm.dart';
import 'package:pathfinder/pathfinders/weighted_algorithm.dart';

enum Algorithm {
  dijkstra, astar, breadthFirstSearch, depthFirstSearch
}

extension AlgorithmLabel on Algorithm {
  String get label {
    switch (this) {
      case Algorithm.dijkstra: return 'Dijkstra';
      case Algorithm.astar: return 'A* search';
      case Algorithm.breadthFirstSearch: return 'Breadth-first search';
      case Algorithm.depthFirstSearch: return 'Depth-first search';
      default: return 'Unknown';
    }
  }
  
  String get description {
    switch (this) {
      case Algorithm.dijkstra: return 'Dijkstra\'s Algorithm guarantees you the shortest path between the start node (you pick which one) and every other node in a graph.';
      case Algorithm.astar: return 'A* Search algorithm won\'t guarantee the shortest path, but the calculation time is very short because it knows where the end node is.';
      case Algorithm.breadthFirstSearch: return 'Breadth-first search (BFS) starts at the root node and explores all of the neighbor nodes prior to moving on to the next depth level.';
      case Algorithm.depthFirstSearch: return 'Depth-first search (DFS) starts at the root node and explores as far as possible along each branch before backtracking.';
      default: return 'No description';
    }
  }

  bool get weighted {
    switch (this) {
      case Algorithm.dijkstra: return true;
      case Algorithm.astar: return true;
      case Algorithm.breadthFirstSearch: return false;
      case Algorithm.depthFirstSearch: return false;
      default: return true;
    }
  }

  WeightedAlgorithm run(List<int> weights, Set<int> walls, int nColumns, int start, int end) {
    switch (this) {
      case Algorithm.dijkstra: return new DijkstraAlgorithm(weights, walls, nColumns, start, end);
      case Algorithm.astar: return new AstarAlgorithm(weights, walls, nColumns, start, end);
      case Algorithm.breadthFirstSearch: return new BreadthFirstSearchAlgorithm(walls, nColumns, (weights.length / nColumns).truncate(), start, end);
      case Algorithm.depthFirstSearch: return new DepthFirstSearchAlgorithm(walls, nColumns, (weights.length / nColumns).truncate(), start, end);
      default: return null;
    }
  }
}