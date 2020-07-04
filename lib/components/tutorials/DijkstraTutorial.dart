import 'package:algorithms/components/tutorials/Node.dart';
import 'package:algorithms/components/tutorials/NodeConnection.dart';
import 'package:algorithms/components/tutorials/TutorialStep.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:algorithms/pages/pathfinding_try_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DijkstraTutorial extends StatefulWidget {
  final PathfindingAlgorithm algorithm;

  DijkstraTutorial(this.algorithm);

  @override
  _DijkstraTutorialState createState() => _DijkstraTutorialState();
}

class _DijkstraTutorialState extends State<DijkstraTutorial> {
  Node start;
  Node currentNode;
  List<NodeConnection> currentNodeConnections;
  Set<Node> visitedNodes = Set<Node>();
  Set<Node> nodes;
  Set<NodeConnection> nodeConnections;
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
    nodes = Set.from([a, b, c, d, e, f]);

    nodeConnections = Set.from([
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

    super.initState();
  }

  setStart(Node node) {
    if (codeStep == 0) {
      setState(() {
        start = node;
        codeStep++;
        shownStep++;
      });
    }
  }

  resetNodes() {
    nodes.forEach((element) => element.distance = 1 << 32);
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: widget.algorithm.tutorial,
      flags: YoutubePlayerFlags(autoPlay: true),
    );

    TutorialStep tutorialStep = getTutorialStep();
    int stepsCount = start == null
        ? 1 << 32
        : 17 + nodes.length * 5 + (['A', 'B', 'F'].contains(start.id) ? 1 : 0);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.algorithm.label +
                  ' (step $shownStep' +
                  (start != null ? '/${stepsCount.toString()}' : '') +
                  ')',
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
        Container(
          height: 250,
          child: new Stack(
            children: [
              ...getNodeConnectionWidgets(tutorialStep),
              ...getNodeWidgets(tutorialStep),
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
                  children: nodes.map((node) {
                    return Container(
                      height: 40,
                      width: 40,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Center(
                          child:
                              Text(visitedNodes.contains(node) ? node.id : '')),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).backgroundColor,
                          border: tutorialStep.visitedNodeSelected == null
                              ? visitedNodes.contains(node)
                                  ? Border.all(width: 3, color: Colors.green)
                                  : null
                              : tutorialStep.visitedNodeSelected(node)
                                  ? Border.all(width: 3, color: Colors.red)
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
                        if (tutorialStep.goBack != null) tutorialStep.goBack();
                      });
                    },
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  shownStep == stepsCount
                      ? RaisedButton(
                          child: Text('Try it yourself!'),
                          onPressed: () => Navigator.pushNamed(
                              context, PathfindingTryPage.routeName,
                              arguments: ScreenArguments(widget.algorithm)),
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
              onPressed: shownStep == stepsCount || start == null
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
        )
      ],
    );
  }

  String getPrettifiedNodeIds(List<Node> nodes) {
    return nodes.length == 1
        ? nodes[0].id
        : nodes
                .map((e) => e.id)
                .toList()
                .sublist(0, nodes.length - 1)
                .join(', ') +
            ' and ' +
            nodes[nodes.length - 1].id;
  }

  bool isConnectedToNode(NodeConnection connection, Node node) {
    return connection.nodes.where((e) => e.id == node.id).isNotEmpty;
  }

  bool haveConnection(Node a, Node b) {
    return getNodeConnection(a, b) != null;
  }

  NodeConnection getNodeConnection(Node a, Node b) {
    return nodeConnections.firstWhere(
        (element) => element.nodes.contains(a) && element.nodes.contains(b),
        orElse: () => null);
  }

  List<Node> getNodes(Node a, {unvisited: false}) {
    return getNodeConnections(a)
        .map((nc) => nc.nodes.firstWhere((e) => e != a, orElse: () => null))
        .where((node) => unvisited ? !visitedNodes.contains(node) : true)
        .toList();
  }

  Node getOtherNode(Node node, NodeConnection nodeConnection) {
    return nodeConnection.nodes
        .firstWhere((e) => e != node, orElse: () => null);
  }

  Node getLowestDistanceNode() {
    return nodes
        .where((node) => !visitedNodes.contains(node))
        .reduce((curr, next) => curr.distance < next.distance ? curr : next);
  }

  List<NodeConnection> getNodeConnections(Node node, {unvisited: false}) {
    if (node == null) return [];
    return nodeConnections
        .where((nodeConnection) =>
            nodeConnection.nodes.contains(node) &&
            (unvisited
                ? !visitedNodes.contains(getOtherNode(node, nodeConnection))
                : true))
        .toList();
  }

  List<NodeConnectionWidget> getNodeConnectionWidgets(TutorialStep step) {
    return nodeConnections
        .map((nodeConnection) => NodeConnectionWidget(
              nodeConnection: nodeConnection,
              step: step,
            ))
        .toList();
  }

  List<NodeWidget> getNodeWidgets(TutorialStep step) {
    return nodes
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

  TutorialStep getTutorialStep() {
    if (codeStep == 0) {
      start = null;
      return TutorialStep(
        explanation: 'Pick a starting node by pressing it',
      );
    } else if (codeStep == 1) {
      return TutorialStep(
        explanation: 'From now on, {startId} will be the starting node',
        selected: (node) => start == node,
      );
    } else if (codeStep == 2) {
      start.distance = 0;
      return TutorialStep(
        explanation:
            'The tentative distance to {startId} will be set to 0, since we\'re already there',
        distanceSelected: (node) => start == node,
        goBack: () => resetNodes(),
      );
    } else if (codeStep == 3) {
      return TutorialStep(
        explanation:
            'The other nodes will have a tentative distance of infinity',
        distanceSelected: (node) => start != node,
      );
    } else if (codeStep == 4) {
      return TutorialStep(
        explanation:
            'On the bottom we keep track of the visited nodes. This will also be visible during the tutorial with a green border',
        visitedNodeSelected: (id) => true,
      );
    } else if (codeStep == 5) {
      return TutorialStep(
        explanation:
            'The first step will be comparing the tentative distance between the start node ({startId}) and the connected nodes',
        connectionSelected: (nc) => isConnectedToNode(nc, start),
        distanceSelected: (node) => haveConnection(node, start),
      );
    } else if (codeStep == 6) {
      return getIntroCompareTutorialStep(start, 0);
    } else if (codeStep >= 7 && codeStep <= 13) {
      Function f = codeStep % 2 == 1
          ? getCompareTutorialStep
          : getIntroCompareTutorialStep;
      return f(start, ((codeStep - 7) / 2).ceil());
    } else if (codeStep == 14) {
      visitedNodes.add(start);
      return TutorialStep(
        explanation:
            'Now that we checked every connected node, we can mark the start node as visited',
        goBack: () => visitedNodes = Set<Node>(),
        backSteps: 9 - 2 * currentNodeConnections.length,
      );
    } else if (codeStep == 15) {
      return TutorialStep(
        explanation: 'A visited node will never be checked again',
      );
    } else if (codeStep == 16) {
      return TutorialStep(
        explanation:
            'The next step is to perform the same steps again for all other unvisited nodes',
        selected: (e) => e != start && haveConnection(start, e),
        connectionSelected: (e) => currentNodeConnections.contains(e),
      );
    } else if (codeStep == 17) {
      currentNode = getLowestDistanceNode();
      return TutorialStep(
        explanation:
            'It is important to always choose the connected node with the smallest tentative distance. ${currentNode.id} in this case',
        selected: (e) => e == currentNode,
        distanceSelected: (e) => e == currentNode,
        connectionSelected: (e) => e == getNodeConnection(start, currentNode),
        goBack: () => currentNode = start,
      );
    } else if (codeStep >= 18 && codeStep <= 76) {
      int repeatingStep = (codeStep - 18) % 12;
      if (repeatingStep == 0) {
        currentNodeConnections =
            getNodeConnections(currentNode, unvisited: true);
        List<Node> nodes = getNodes(currentNode, unvisited: true);
        String unvisitedNodes = getPrettifiedNodeIds(nodes);

        return TutorialStep(
          explanation:
              '${currentNode.id} has ${currentNodeConnections.length} connected node${nodes.length == 1 ? ' that hasn\'t' : 's that haven\'t'} been visited yet: $unvisitedNodes',
          distanceSelected: (e) => e == currentNode,
          selected: (e) => e == currentNode,
          connectionSelected: (e) => currentNodeConnections.contains(e),
          goBack: () => currentNodeConnections = getNodeConnections(start),
        );
      } else if (repeatingStep == 1) {
        NodeConnection nc = currentNodeConnections[0];
        Node node2 = getOtherNode(currentNode, nc);
        return TutorialStep(
          explanation: currentNodeConnections.length == 1
              ? 'Every unvisited connected node needs to be checked again. In this case there is only 1, so let\'s check ${node2.id}'
              : 'Every unvisited connected node needs to be checked again. The order doesn\'t matter. Let\'s start with ${node2.id}',
          distanceSelected: (e) => e == currentNode,
          selected: (e) => e == currentNode,
          connectionSelected: (e) => e == nc,
        );
      } else if (repeatingStep >= 2 && repeatingStep <= 8) {
        Function f = repeatingStep % 2 == 0
            ? getCompareTutorialStep
            : getIntroCompareTutorialStep;
        return f(currentNode, ((repeatingStep - 2) / 2).ceil());
      } else if (repeatingStep == 9) {
        return getAllCheckedTutorialStep(forwardSteps: 2);
      } else if (repeatingStep == 10) {
        visitedNodes.add(currentNode);
        return TutorialStep(
          explanation:
              'Because all connected nodes have been visited already, there is nothing to do. This node can be marked as visited',
          goBack: () => visitedNodes.remove(currentNode),
          backSteps: 11,
        );
      } else if (repeatingStep == 11) {
        currentNode = getLowestDistanceNode();
        currentNodeConnections =
            getNodeConnections(currentNode, unvisited: true);
        return TutorialStep(
          explanation:
              'Now we take the next unvisited node with the smallest tentative distance, which is ${currentNode.id}',
          goBack: () {
            currentNode = visitedNodes.last;
            currentNodeConnections =
                getNodeConnections(currentNode, unvisited: true);
          },
          selected: (node) => node == currentNode,
          distanceSelected: (node) => node == currentNode,
          forwardSteps: currentNodeConnections.length == 0 ? 11 : 1,
          backSteps:
              getNodeConnections(visitedNodes.last, unvisited: true).length == 0
                  ? 1
                  : 2,
        );
      }
    } else if (codeStep == 77) {
      return TutorialStep(
          explanation: 'The algorithm ends when all elements are visited');
    } else if (codeStep == 78) {
      return TutorialStep(
          explanation:
              'It is also possible that the algorithm can\'t reach certain nodes');
    } else if (codeStep == 79) {
      return TutorialStep(
          explanation:
              'In this case it will stop as soon as all remaining nodes have a tentative distance of infinity');
    } else if (codeStep == 80) {
      return TutorialStep(
          explanation:
              'If you want, you can let it stop as soon as it found a finish node, for example');
    } else if (codeStep == 81) {
      return TutorialStep(
          explanation:
              'If you want to save the shortest path for every node, you can set a parent node for every node which will be updated when you update the node distance');
    } else if (codeStep == 82) {
      return TutorialStep(
          explanation:
              'Now you know how Dijkstra\'s algorithm works. Congrats!');
    } else if (codeStep == 83) {
      return TutorialStep();
    }
    return null;
  }

  getAllCheckedTutorialStep({forwardSteps: 1}) {
    visitedNodes.add(currentNode);
    return TutorialStep(
      explanation:
          'Now all connected nodes of ${currentNode.id} are checked as well, which means it can be marked as visited',
      goBack: () => visitedNodes.remove(currentNode),
      backSteps: 9 - 2 * currentNodeConnections.length,
      forwardSteps: forwardSteps,
    );
  }

  getIntroCompareTutorialStep(Node a, int otherNodeIndex) {
    NodeConnection nc = getNodeConnections(a, unvisited: true)[otherNodeIndex];
    Node b = getOtherNode(a, nc);
    return TutorialStep(
      explanation: otherNodeIndex > 0
          ? 'Next we will check ${b.id}, the ${otherNodeIndex == 1 ? 'second' : otherNodeIndex == 2 ? 'third' : 'fourth'} connected node'
          : 'We start with checking ${b.id}, the first connected node',
      connectionSelected: (e) => e == getNodeConnection(a, b),
    );
  }

  getCompareTutorialStep(Node a, int otherNodeIndex) {
    currentNodeConnections = getNodeConnections(a, unvisited: true);
    NodeConnection nc = currentNodeConnections[otherNodeIndex];
    Node b = getOtherNode(a, nc);
    int l = currentNodeConnections.length;
    TutorialStep step = TutorialStep(
      explanation: a.distance + nc.weight < b.distance
          ? 'Since (${a.distance} + ${nc.weight}) is smaller than ${b.distance == 1 << 32 ? 'infinity' : b.distance}, the distance to ${b.id} will be set to ${a.distance + nc.weight}'
          : 'Because the calculated distance (${a.distance} + ${nc.weight}) isn\'t smaller than the current lowest distance (${b.distance}), it doesn\'t need to be updated',
      connectionSelected: (e) => e == nc,
      distanceSelected: (e) => [a, b].contains(e),
      goBack: () => b.distances.removeLast(),
      // Calculates amount of steps to skip based on amount of connections to node
      forwardSteps: l > otherNodeIndex + 1 || otherNodeIndex == 3
          ? 1
          : l == 3 ? 3 : l == 2 ? 5 : 7,
    );
    b.distance = (a.distance + nc.weight < b.distance)
        ? a.distance + nc.weight
        : b.distance;
    return step;
  }
}
