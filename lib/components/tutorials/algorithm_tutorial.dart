import 'package:algorithms/components/algorithm_chips.dart';
import 'package:algorithms/components/tutorials/dijkstra_tutorial_steps.dart';
import 'package:algorithms/components/tutorials/node.dart';
import 'package:algorithms/components/tutorials/node_connection.dart';
import 'package:algorithms/components/tutorials/tutorial_step.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/pages/animations/enter_exit_route.dart';
import 'package:algorithms/pages/pathfinding_try_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlgorithmTutorial extends StatefulWidget {
  final PathfindingAlgorithm algorithm;

  AlgorithmTutorial(this.algorithm);

  @override
  _AlgorithmTutorialState createState() => _AlgorithmTutorialState();
}

class _AlgorithmTutorialState extends State<AlgorithmTutorial> {
  DijkstraTutorialSteps tutorialSteps;
  int codeStep = 0, shownStep = 1;
  bool isGoingBack = false;

  @override
  void initState() {
    Node a = Node(id: 'A', left: 0, top: 100, distance: 1 << 32);
    Node b = Node(id: 'B', left: 90, top: 20, distance: 1 << 32);
    Node c = Node(id: 'C', left: 90, top: 180, distance: 1 << 32);
    Node d = Node(id: 'D', left: 180, top: 20, distance: 1 << 32);
    Node e = Node(id: 'E', left: 180, top: 180, distance: 1 << 32);
    Node f = Node(id: 'F', left: 270, top: 100, distance: 1 << 32);
    Set<Node> nodes = Set.from([a, b, c, d, e, f]);

    Set<NodeConnection> nodeConnections = Set.from([
      NodeConnection([a, b], 1),
      NodeConnection([a, c], 4),
      NodeConnection([b, c], 2),
      NodeConnection([b, d], 4),
      NodeConnection([b, e], 5),
      NodeConnection([c, e], 3),
      NodeConnection([d, e], 1),
      NodeConnection([d, f], 2),
      NodeConnection([e, f], 4),
    ]);
    tutorialSteps = DijkstraTutorialSteps(nodeConnections, nodes);

    super.initState();
  }

  setStart(Node node) {
    if (codeStep == 0) {
      setState(() {
        tutorialSteps.start = node;
        tutorialSteps.currentNode = node;
        codeStep++;
        shownStep++;
      });
    }
  }

  goToTryPage() {
    Navigator.push(
      context,
      SlideRightRoute(page: PathfindingTryPage(widget.algorithm)),
    );
  }

  @override
  Widget build(BuildContext context) {
    TutorialStep tutorialStep = tutorialSteps.getTutorialStep(codeStep);
    //TODO improve ugly inaccurate calculation
    int stepsCount = tutorialSteps.start == null
        ? 1 << 32
        : 17 + tutorialSteps.nodes.length * 5 + (['A', 'B', 'F'].contains(tutorialSteps.start.id) ? 1 : 0);
    bool implemented = widget.algorithm == PathfindingAlgorithm.dijkstra;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.algorithm.label +
                  (implemented
                      ? ' (step $shownStep' +
                          (tutorialSteps.start != null ? '/${stepsCount.toString()}' : '') +
                          ')'
                      : ''),
              style: Theme.of(context).textTheme.headline5,
            ),
            GestureDetector(
              child: Text(
                'Real example',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: goToTryPage,
            ),
          ],
        ),
        SizedBox(height: 2),
        AlgorithmChips(widget.algorithm),
        SizedBox(height: 10),
        Text(
          widget.algorithm.description,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.grey),
          textAlign: TextAlign.justify,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        implemented
            ? Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: new Stack(
                      children: [
                        ...getNodeConnectionWidgets(tutorialStep),
                        ...getNodeWidgets(tutorialSteps.visitedNodes, tutorialStep),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        Text('Visited nodes', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: tutorialSteps.nodes.map((node) {
                              return Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Center(
                                    child: Text(tutorialSteps.visitedNodes.contains(node)
                                        ? node.id
                                        : '')),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).backgroundColor,
                                    border: tutorialStep.visitedNodeSelected ==
                                            null
                                        ? tutorialSteps.visitedNodes.contains(node)
                                            ? Border.all(
                                                width: 3, color: Colors.green)
                                            : null
                                        : tutorialStep.visitedNodeSelected(node)
                                            ? Border.all(
                                                width: 3, color: Colors.red)
                                            : null),
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      IconButton(
                        iconSize: 36,
                        icon: Icon(Icons.arrow_left),
                        onPressed: codeStep == 0
                            ? null
                            : () {
                                setState(() {
                                  if (codeStep > 0) {
                                    codeStep -= tutorialStep.backSteps;
                                    shownStep--;
                                    isGoingBack = true;
                                  }
                                  if (tutorialStep.goBack != null)
                                    tutorialStep.goBack();
                                });
                              },
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            shownStep == stepsCount
                                ? RaisedButton(
                                    child: Text('Try out a real example!'),
                                    onPressed: goToTryPage,
                                    color: Theme.of(context).buttonColor,
                                  )
                                : Text(
                                    tutorialStep.explanation,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        iconSize: 36,
                        icon: Icon(Icons.arrow_right),
                        onPressed: shownStep == stepsCount || tutorialSteps.start == null
                            ? null
                            : () {
                                setState(() {
                                  codeStep += tutorialStep.forwardSteps;
                                  shownStep++;
                                  isGoingBack = false;
                                });
                              },
                      ),
                    ],
                  ),
                ],
              )
            : Text(
                'Currently there is no tutorial implemented for this algorithm',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  List<NodeConnectionWidget> getNodeConnectionWidgets(TutorialStep step) {
    return tutorialSteps.nodeConnections
        .map((nodeConnection) => NodeConnectionWidget(
              nodeConnection: nodeConnection,
              step: step,
            ))
        .toList();
  }

  List<NodeWidget> getNodeWidgets(Set<Node> visitedNodes, TutorialStep step) {
    return tutorialSteps.nodes
        .map((node) => NodeWidget(
            node: node,
            onPress: (node) => setStart(node),
            isSelected: step != null && step.selected != null
                ? step.selected(node)
                : false,
            isVisited: visitedNodes.contains(node),
            isDistanceSelected: step != null && step.distanceSelected != null
                ? step.distanceSelected(node)
                : false))
        .toList();
  }
}
