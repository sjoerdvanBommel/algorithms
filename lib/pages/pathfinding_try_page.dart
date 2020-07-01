import 'dart:async';

import 'package:algorithms/components/grid.dart';
import 'package:algorithms/enums/cell_action.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/pathfinders/weighted_algorithm.dart';
import 'package:flutter/material.dart';

class PathfindingTryPage extends StatefulWidget {
  static const routeName = '/pathfinding/try';

  @override
  _PathfindingTryPageState createState() => _PathfindingTryPageState();
}

class _PathfindingTryPageState extends State<PathfindingTryPage> {
  final List<CellAction> cellActions = CellAction.values;
  double speed = 5;
  List<int> shortestPath, visitedIndexes, grid;
  bool clickedCalculate = false;
  int timeElapsed, shortestDistance, start = 17, end = 87, nColumns = 10, nRows = 10;
  List<StreamSubscription> subscriptions = List<StreamSubscription>();
  bool unsolvable = false;
  List<bool> isSelected = List.filled(CellAction.values.length, false);
  Set<int> selectedIndexes = Set<int>();
  Set<int> walls = Set<int>();

  @override
  void initState() {
    isSelected[CellAction.add.index] = true;
    resetGrid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Try it yourself'),
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
                          Text(
                            args.algorithm.label,
                            style: Theme.of(context).textTheme.headline5,
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
                                  onPressed: () => calculate(args.algorithm),
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
                  grid: args.algorithm.weighted
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
                      if (clickedCalculate) calculate(args.algorithm, animated: false);
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
    );
  }

  void calculate(PathfindingAlgorithm algorithm, {animated: true}) {
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

  void resetGrid() {
    grid = List.generate(nRows * nColumns, (i) => 1, growable: false);
    selectedIndexes = Set<int>();
    walls = Set<int>();
    resetOnCalculate();
  }

  void resetOnCalculate() {
    subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    setState(() {
      shortestPath = new List<int>();
      clickedCalculate = false;
      visitedIndexes = List<int>();
      shortestDistance = null;
      unsolvable = false;
      timeElapsed = null;
    });
  }

  void resetSelectedIndexes() {
    setState(() {
      selectedIndexes = new Set<int>();
    });
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
}

class ScreenArguments {
  PathfindingAlgorithm algorithm;

  ScreenArguments(this.algorithm);
}
