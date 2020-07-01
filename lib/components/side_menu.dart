import 'package:flutter/material.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/enums/sorting_algorithm.dart';

class SideMenu extends StatelessWidget {
  final Function onTapPathfindingAlgorithm;
  final Function onTapSortingAlgorithm;

  SideMenu({@required this.onTapPathfindingAlgorithm, @required this.onTapSortingAlgorithm});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Pathfinding algorithms',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: PathfindingAlgorithm.values.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(PathfindingAlgorithm.values[index].label),
                    onTap: () => onTapPathfindingAlgorithm(index),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                'Sorting algorithms',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: SortingAlgorithm.values.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(SortingAlgorithm.values[index].label),
                    onTap: () => onTapSortingAlgorithm(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
