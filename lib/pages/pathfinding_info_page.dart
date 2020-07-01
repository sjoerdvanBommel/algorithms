import 'package:algorithms/components/tutorials/DijkstraTutorial.dart';
import 'package:algorithms/pages/pathfinding_try_page.dart';
import 'package:flutter/material.dart';
import 'package:algorithms/components/side_menu.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PathfindingInfoPage extends StatefulWidget {
  static const routeName = '/pathfinding/info';

  @override
  _PathfindingInfoPageState createState() => _PathfindingInfoPageState();
}

class _PathfindingInfoPageState extends State<PathfindingInfoPage> {
  PathfindingAlgorithm algorithm = PathfindingAlgorithm.dijkstra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pathfinding algorithms'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DijkstraTutorial(algorithm),
                          SizedBox(height: 10),
                          // Row(
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: RaisedButton(
                          //         child: Text('Try it yourself!'),
                          //         onPressed: () => Navigator.pushNamed(
                          //             context, PathfindingTryPage.routeName,
                          //             arguments: ScreenArguments(algorithm)),
                          //         color: Theme.of(context).buttonColor,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: SideMenu(
        onTapPathfindingAlgorithm: (index) {
          setState(() {
            algorithm = PathfindingAlgorithm.values[index];
          });
          Navigator.pop(context);
        },
        onTapSortingAlgorithm: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
