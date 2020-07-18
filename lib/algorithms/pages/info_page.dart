import 'package:algorithms/algorithms/components/card_header.dart';
import 'package:algorithms/algorithms/components/tutorials/pathfinding_algorithm_tutorial.dart';
import 'package:algorithms/algorithms/components/tutorials/sorting_algorithm_tutorial.dart';
import 'package:algorithms/algorithms/enums/sorting_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:algorithms/algorithms/components/side_menu.dart';
import 'package:algorithms/algorithms/enums/pathfinding_algorithm.dart';

class InfoPage extends StatefulWidget {
  static const routeName = '/pathfinding/info';

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
                children: <Widget>[
                  ...PathfindingAlgorithm.values
                      .asMap()
                      .entries
                      .map(
                        (e) => Card(
                          key: keys[e.key],
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: double.infinity,
                            child: PathfindingAlgorithmTutorial(e.value),
                          ),
                        ),
                      )
                      .toList(),
                  SizedBox(
                    height: 20,
                  ),
                  ...SortingAlgorithm.values
                      .asMap()
                      .entries
                      .map(
                        (e) => Card(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                CardHeader(
                                  title: e.value.label,
                                  onTapRealExample: () {},
                                  chips: e.value.chips,
                                  description: e.value.description,
                                ),
                                SizedBox(height: 20),
                                SortingAlgorithmTutorial(),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
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
