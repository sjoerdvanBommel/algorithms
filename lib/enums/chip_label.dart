enum ChipLabel {
  pathfinding, weighted, unweighted, directed, undirected, sorting
}

extension ChipLabelExtension on ChipLabel {
  String get label {
    switch (this) {
      case ChipLabel.pathfinding: return 'Pathfinding';
      case ChipLabel.weighted: return 'Weighted';
      case ChipLabel.unweighted: return 'Unweighted';
      case ChipLabel.directed: return 'Directed';
      case ChipLabel.undirected: return 'Undirected';
      case ChipLabel.sorting: return 'Sorting';
    }
    return '';
  }
}