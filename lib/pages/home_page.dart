import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pathfinder/components/grid.dart';
import 'package:pathfinder/components/side_menu.dart';
import 'package:pathfinder/enums/pathfinding_algorithm.dart';
import 'package:pathfinder/enums/cell_action.dart';
import 'package:pathfinder/pathfinders/weighted_algorithm.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int nColumns = 10, nRows = 10;
  final List<CellAction> cellActions = CellAction.values;
  List<bool> isSelected = List.filled(CellAction.values.length, false);
  int start = 17, end = 87;
  Set<int> selectedIndexes = Set<int>();
  Set<int> walls = Set<int>();
  PathfindingAlgorithm algorithm = PathfindingAlgorithm.dijkstra;
  List<int> shortestPath;
  List<int> visitedIndexes;
  List<int> grid;
  bool clickedCalculate = false;
  int timeElapsed;
  int shortestDistance;
  List<StreamSubscription> subscriptions = List<StreamSubscription>();
  double speed = 5;
  bool unsolvable = false;

  void initState() {
    super.initState();
    isSelected[CellAction.add.index] = true;
    resetGrid();
  }

  void resetSelectedIndexes() {
    setState(() {
      selectedIndexes = new Set<int>();
    });
  }

  void resetGrid() {
    grid = List.generate(nRows * nColumns, (i) => 1, growable: false);
    selectedIndexes = Set<int>();
    walls = Set<int>();
    resetOnCalculate();
  }

  void resetOnCalculate() {
    setState(() {
      shortestPath = new List<int>();
      clickedCalculate = false;
      visitedIndexes = List<int>();
      shortestDistance = null;
      unsolvable = false;
      timeElapsed = null;
    });
    subscriptions.forEach((subscription) {
      subscription.cancel();
    });
  }

  void increaseSelectedIndexes(int amount) {
    setState(() {
      selectedIndexes.forEach((index) {
        grid[index] += amount;
        if (grid[index] < 0) {
          grid[index] = 0;
        }
      });
    });
    if (clickedCalculate) calculate();
  }

  void toggleWalls(bool add) {
    setState(() {
      selectedIndexes.forEach((index) {
        add ? walls.add(index) : walls.remove(index);
      });
      selectedIndexes = new Set<int>();
    });
    if (clickedCalculate) calculate();
  }

  void calculate({animated: true}) {
    resetOnCalculate();
    final stopwatch = Stopwatch()..start();
    WeightedAlgorithm algorithmResult =
        algorithm.run(grid, walls, nColumns, start, end);
    setState(() {
      clickedCalculate = true;
      shortestDistance = 0;
      timeElapsed = stopwatch.elapsedMicroseconds;
    });
    List<int> steps = algorithmResult.getVisitedIndexes();
    List<int> shortestPathIndexes = algorithmResult.getShortestPath();
    for (int i = 0; i < steps.length; i++) {
      addSubscription(((500 * i) / speed).round(), () {
        visitedIndexes.add(steps[i]);
        if (shortestPathIndexes != null &&
            shortestPathIndexes.contains(steps[i])) {
          shortestDistance += algorithm.weighted ? grid[steps[i]] : 1;
        }
      }, animated);
    }
    if (algorithmResult.getDistance() != -1) {
      if (shortestPathIndexes != null) {
        shortestPath.length = shortestPathIndexes.length;
        for (int i = 0; i < shortestPathIndexes.length; i++) {
          addSubscription(((500 * steps.length + 500 * i) / speed).round(), () {
            shortestPath[i] = shortestPathIndexes[i];
          }, animated);
        }
      }
    } else {
      addSubscription(((500 * steps.length) / speed).round(),
          () => unsolvable = true, animated);
    }
  }

  void addSubscription(int milliseconds, Function stateCallback, animated) {
    animated
        ? subscriptions.add(Future.delayed(Duration(milliseconds: milliseconds))
            .asStream()
            .listen((e) {
            setState(stateCallback);
          }))
        : stateCallback();
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: algorithm.tutorial,
      flags: YoutubePlayerFlags(
        autoPlay: true
      ),
    );

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                algorithm.label,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              GestureDetector(
                                child: Text(
                                  'Tutorial',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    child: SimpleDialog(
                                      contentPadding: EdgeInsets.zero,
                                      titlePadding: EdgeInsets.zero,
                                      children: <Widget>[
                                        YoutubePlayer(
                                          controller: _controller,
                                          onEnded: (e) {
                                            _controller.reset();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            algorithm.description,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.grey),
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Animation speed',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Expanded(
                                child: Slider(
                                  value: speed,
                                  onChanged: (value) {
                                    setState(() {
                                      speed = value;
                                    });
                                  },
                                  min: 1,
                                  max: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text('Calculate'),
                                  onPressed: calculate,
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: RaisedButton(
                                  child: Text('Reset'),
                                  onPressed: resetGrid,
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          unsolvable
                              ? Text(
                                  'There is no valid path',
                                  style: TextStyle(
                                    color: Theme.of(context).errorColor,
                                  ),
                                )
                              : Visibility(
                                  visible: timeElapsed != null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: 'Calculated path in \n'),
                                            TextSpan(
                                              text: timeElapsed.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            TextSpan(text: '\nmicroseconds'),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: 'Shortest path takes\n'),
                                            TextSpan(
                                              text: shortestDistance.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            TextSpan(text: '\nsteps'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ToggleButtons(
                  color: Theme.of(context).buttonColor,
                  borderColor: Theme.of(context).accentColor,
                  selectedBorderColor: Theme.of(context).accentColor,
                  fillColor: Theme.of(context).backgroundColor,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                  children: cellActions.map((e) => e.icon).toList(),
                ),
                SizedBox(height: 10.0),
                Grid(
                  grid: algorithm.weighted
                      ? grid
                      : List.generate(grid.length, (i) => -1),
                  start: start,
                  end: end,
                  nColumns: nColumns,
                  shortestPath: shortestPath,
                  onSelectCell: (i) {
                    setState(() {
                      switch (cellActions[isSelected.indexWhere((e) => e)]) {
                        case CellAction.start:
                          start = i;
                          break;
                        case CellAction.end:
                          end = i;
                          break;
                        case CellAction.add:
                          if (!walls.contains(i)) grid[i]++;
                          break;
                        case CellAction.remove:
                          if (!walls.contains(i) && grid[i] > 0) grid[i]--;
                          break;
                        case CellAction.wall:
                          walls.add(i);
                          break;
                        case CellAction.unwall:
                          walls.remove(i);
                          break;
                      }
                      if (clickedCalculate) calculate(animated: false);
                    });
                  },
                  visitedIndexes: visitedIndexes,
                  walls: walls,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: SideMenu(
        onTapMenuItem: (index) {
          setState(() {
            algorithm = PathfindingAlgorithm.values[index];
          });
          resetOnCalculate();
          Navigator.pop(context);
        }
      ),
    );
  }
}
