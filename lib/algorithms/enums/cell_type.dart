import 'package:flutter/material.dart';

enum CellType {
  start, end, wall, shortestPath, visited, normal
}

extension CellTypeColor on CellType {
  Color get color {
    switch (this) {
      case CellType.start:
        return Colors.green[700];
      case CellType.end:
        return Colors.red[700];
      case CellType.wall:
        return Colors.black;
      case CellType.shortestPath:
        return Colors.green[200];
      case CellType.visited:
        return Colors.blue[50];
      default:
        return null;
    }
  }
}