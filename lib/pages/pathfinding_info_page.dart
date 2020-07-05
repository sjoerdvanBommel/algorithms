import 'package:algorithms/components/algorithm_chips.dart';
import 'package:algorithms/components/my_chip.dart';
import 'package:algorithms/components/tutorials/AlgorithmTutorial.dart';
import 'package:algorithms/enums/chip_label.dart';
import 'package:flutter/material.dart';
import 'package:algorithms/components/side_menu.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';

class PathfindingInfoPage extends StatefulWidget {
  static const routeName = '/pathfinding/info';

  @override
  _PathfindingInfoPageState createState() => _PathfindingInfoPageState();
}

class _PathfindingInfoPageState extends State<PathfindingInfoPage> {
  final List<GlobalKey> keys =
      List.generate(PathfindingAlgorithm.values.length, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algorithms'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: PathfindingAlgorithm.values
                    .asMap()
                    .entries
                    .map(
                      (e) => Container(
                        width: double.infinity,
                        child: Card(
                          key: keys[e.key],
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: AlgorithmTutorial(e.value),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      drawer: SideMenu(
        onTapPathfindingAlgorithm: (index) {
          Scrollable.ensureVisible(keys[index].currentContext);
          Navigator.pop(context);
        },
        onTapSortingAlgorithm: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
