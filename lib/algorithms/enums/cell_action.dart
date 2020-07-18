import 'package:flutter/material.dart';

enum CellAction {
  start, end, wall, unwall, add, remove
}

extension CellActionIcon on CellAction {
  Widget get icon {
    switch(this) {
      case CellAction.start:
        return Icon(Icons.play_arrow);
      case CellAction.end:
        return Icon(Icons.stop);
      case CellAction.wall:
        return Icon(Icons.lock);
      case CellAction.unwall:
        return Icon(Icons.lock_open);
      case CellAction.add:
        return Icon(Icons.add);
      case CellAction.remove:
        return Icon(Icons.remove);
      default:
        return Icon(Icons.not_interested);
    }
  }
}