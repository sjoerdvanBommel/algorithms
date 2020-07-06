import 'dart:math';

import 'package:algorithms/components/tutorials/node.dart';
import 'package:algorithms/components/tutorials/node_connection.dart';
import 'package:algorithms/components/tutorials/tutorial_step.dart';

class DijkstraTutorialSteps {
  Set<Node> visitedNodes = Set<Node>();
  Set<NodeConnection> currentNodeConnections = Set<NodeConnection>();
  List<NodeConnection> nodeConnections;
  List<Node> nodes = List<Node>();
  Node currentNode;
  List<TutorialStep> steps;

  DijkstraTutorialSteps(
      List<NodeConnection> nodeConnections, List<Node> nodes) {
    this.nodeConnections = nodeConnections;
    this.nodes = clonedNodes(nodes: nodes);
  }

  TutorialStep getFirstStep() {
    return TutorialStep(explanation: 'Pick a starting node by pressing it');
  }

  List<Node> clonedNodes({List<Node> nodes}) {
    return (nodes != null ? nodes : this.nodes)
        .map((e) => Node.clone(e))
        .toList();
  }

  List<Node> updateNodeDistance(int newNodeDistance,
      {Node node, List<Node> nodes}) {
    nodes
        .firstWhere((element) => element == (node != null ? node : currentNode))
        .distance = newNodeDistance;
    return clonedNodes(nodes: nodes);
  }

  TutorialStep getStepAfterSelectingStartNode() {
    steps = List.generate(100, (i) => TutorialStep());
    steps.asMap().forEach((i, step) {
      step.previousStep = i > 0 ? steps[i - 1] : null;
      step.nextStep = i < steps.length - 1 ? steps[i + 1] : null;
    });
    List<Node> curNodes = clonedNodes();

    steps[0]
      ..explanation = 'Pick a starting node by pressing it'
      ..nodes = (() {
        curNodes.forEach((element) => element.distance = 1 << 32);
        return curNodes;
      });
    steps[1]
      ..explanation = 'From now on, ${currentNode.id} will be the starting node'
      ..selected = (node) => currentNode == node;

    currentNode.distance = 0;
    steps[2]
      ..explanation =
          'The tentative distance to ${currentNode.id} will be set to 0, since we\'re already there'
      ..nodes = (() => updateNodeDistance(0, nodes: curNodes))
      ..previousNodes = (() => updateNodeDistance(1 << 32, nodes: curNodes))
      ..distanceSelected = ((node) => currentNode == node);
    steps[3]
      ..explanation =
          'The other nodes will have a tentative distance of infinity'
      ..distanceSelected = (node) => currentNode != node;
    steps[4]
      ..explanation =
          'On the bottom we keep track of the visited nodes. This will also be visible during the tutorial with a green border'
      ..visitedNodeSelected = ((id) => true);
    steps[5]
      ..explanation =
          'The first step will be comparing the tentative distance between the start node (${currentNode.id}) and the connected nodes'
      ..connectionSelected = ((nc) => isConnectedToNode(nc, currentNode))
      ..distanceSelected = ((node) => haveConnection(node, currentNode));

    currentNodeConnections = getNodeConnections(currentNode, unvisited: true);
    for (int i = 6; i < 14; i++) {
      bool intro = i % 2 == 0;
      int otherNodeIndex = ((i - 6) / 2).floor();
      int ncCount = currentNodeConnections.length;

      if (ncCount <= otherNodeIndex) {
        steps[i] = null;
        continue;
      }

      NodeConnection nc = currentNodeConnections.elementAt(otherNodeIndex);
      Node otherNode = getOtherNode(currentNode, nc);
      int newOtherNodeDistance =
          min(currentNode.distance + nc.weight, otherNode.distance);
      otherNode.distance = newOtherNodeDistance;

      if (intro) {
        steps[i]
          ..explanation = otherNodeIndex > 0
              ? 'Next we will check ${otherNode.id}, the ${otherNodeIndex == 1 ? 'second' : otherNodeIndex == 2 ? 'third' : 'fourth'} connected node'
              : 'We start with checking ${otherNode.id}, the first connected node'
          ..connectionSelected = (e) => e == nc;
      } else {
        steps[i]
          ..explanation = currentNode.distance + nc.weight < otherNode.distance
              ? 'Since (${currentNode.distance} + ${nc.weight}) is smaller than ${otherNode.distance == 1 << 32 ? 'infinity' : otherNode.distance}, the distance to ${otherNode.id} will be set to ${currentNode.distance + nc.weight}'
              : 'Because the calculated distance (${currentNode.distance} + ${nc.weight}) isn\'t smaller than the current lowest distance (${otherNode.distance}), it doesn\'t need to be updated'
          ..connectionSelected = ((e) => e == nc)
          ..distanceSelected = ((e) => [currentNode, otherNode].contains(e))
          ..nextStep = steps[i +
              (ncCount > otherNodeIndex + 1 || otherNodeIndex == 3
                  ? 1
                  : ncCount == 3 ? 3 : ncCount == 2 ? 5 : 7)]
          ..nodes = (() => updateNodeDistance(newOtherNodeDistance,
              node: otherNode, nodes: curNodes))
          ..previousNodes = (() {
            curNodes
                .firstWhere((element) => element == otherNode)
                .distances
                .removeLast();
            return curNodes;
          });
      }
    }

    visitedNodes.add(currentNode);
    steps[14]
      ..explanation =
          'Now that we checked every connected node, we can mark the start node as visited'
      ..visitedNodes = (() => Set.from([currentNode]))
      ..previousVisitedNodes = (() => Set<Node>())
      ..previousStep = steps[5 + 2 * currentNodeConnections.length];
    steps[15]..explanation = 'A visited node will never be checked again';
    steps[16]
      ..explanation =
          'The next step is to perform the same steps again for all other unvisited nodes'
      ..selected = ((e) => e != currentNode && haveConnection(currentNode, e))
      ..connectionSelected = ((e) => currentNodeConnections.contains(e));

    Node closest = getLowestDistanceNode();
    steps[17]
      ..explanation =
          'It is important to always choose the connected node with the smallest tentative distance. ${closest.id} in this case'
      ..nodes = (() {
        currentNode = getLowestDistanceNode();
        return clonedNodes();
      })
      ..selected = ((e) => e == currentNode)
      ..distanceSelected = ((e) => e == currentNode)
      ..connectionSelected =
          ((e) => e == getNodeConnection(visitedNodes.last, currentNode));
    // ..previousNodes = (() => currentNode = visitedNodes.last);

    return steps[1];

    // } else if (codeStep == 17) {
    //   currentNode = getLowestDistanceNode();
    //   return TutorialStep(
    //     explanation:
    //         ,
    //     selected: ,
    //     distanceSelected: ,
    //     connectionSelected: ,
    //     goBackFunction: ,
    //   );
    // } else if (codeStep >= 18 && codeStep <= 76) {
    //   int repeatingStep = (codeStep - 18) % 12;
    //   if (repeatingStep == 0) {
    //     currentNodeConnections =
    //         getNodeConnections(currentNode, unvisited: true);
    //     List<Node> nodes = getNodes(currentNode, unvisited: true);
    //     String unvisitedNodes = getPrettifiedNodeIds(nodes);

    //     return TutorialStep(
    //       explanation:
    //           '${currentNode.id} has ${currentNodeConnections.length} connected node${nodes.length == 1 ? ' that hasn\'t' : 's that haven\'t'} been visited yet: $unvisitedNodes',
    //       distanceSelected: (e) => e == currentNode,
    //       selected: (e) => e == currentNode,
    //       connectionSelected: (e) => currentNodeConnections.contains(e),
    //       goBackFunction: () =>
    //           currentNodeConnections = getNodeConnections(start),
    //     );
    //   } else if (repeatingStep == 1) {
    //     NodeConnection nc = currentNodeConnections.elementAt(0);
    //     Node node2 = getOtherNode(currentNode, nc);
    //     return TutorialStep(
    //       explanation: currentNodeConnections.length == 1
    //           ? 'Every unvisited connected node needs to be checked again. In this case there is only 1, so let\'s check ${node2.id}'
    //           : 'Every unvisited connected node needs to be checked again. The order doesn\'t matter. Let\'s start with ${node2.id}',
    //       distanceSelected: (e) => e == currentNode,
    //       selected: (e) => e == currentNode,
    //       connectionSelected: (e) => e == nc,
    //     );
    //   } else if (repeatingStep >= 2 && repeatingStep <= 8) {
    //     Function f = repeatingStep % 2 == 0
    //         ? getCompareTutorialStep
    //         : getIntroCompareTutorialStep;
    //     return f(currentNode, ((repeatingStep - 2) / 2).ceil());
    //   } else if (repeatingStep == 9) {
    //     return getAllCheckedTutorialStep(forwardSteps: 2);
    //   } else if (repeatingStep == 10) {
    //     visitedNodes.add(currentNode);
    //     return TutorialStep(
    //       explanation:
    //           'Because all connected nodes have been visited already, there is nothing to do. This node can be marked as visited',
    //       goBackFunction: () => visitedNodes.remove(currentNode),
    //       backSteps: 11,
    //     );
    //   } else if (repeatingStep == 11) {
    //     currentNode = getLowestDistanceNode();
    //     currentNodeConnections =
    //         getNodeConnections(currentNode, unvisited: true);
    //     return TutorialStep(
    //       explanation:
    //           'Now we take the next unvisited node with the smallest tentative distance, which is ${currentNode.id}',
    //       goBackFunction: () {
    //         currentNode = visitedNodes.last;
    //         currentNodeConnections =
    //             getNodeConnections(currentNode, unvisited: true);
    //       },
    //       selected: (node) => node == currentNode,
    //       distanceSelected: (node) => node == currentNode,
    //       forwardSteps: currentNodeConnections.length == 0 ? 11 : 1,
    //       backSteps:
    //           getNodeConnections(visitedNodes.last, unvisited: true).length == 0
    //               ? 1
    //               : 2,
    //     );
    //   }
    // } else if (codeStep == 77) {
    //   return TutorialStep(
    //       explanation: 'The algorithm ends when all elements are visited');
    // } else if (codeStep == 78) {
    //   return TutorialStep(
    //       explanation:
    //           'It is also possible that the algorithm can\'t reach certain nodes');
    // } else if (codeStep == 79) {
    //   return TutorialStep(
    //       explanation:
    //           'In this case it will stop as soon as all remaining nodes have a tentative distance of infinity');
    // } else if (codeStep == 80) {
    //   return TutorialStep(
    //       explanation:
    //           'If you want, you can let it stop as soon as it found a finish node, for example');
    // } else if (codeStep == 81) {
    //   return TutorialStep(
    //       explanation:
    //           'If you want to save the shortest path for every node, you can set a parent node for every node which will be updated when you update the node distance');
    // } else if (codeStep == 82) {
    //   return TutorialStep(
    //       explanation:
    //           'Now you know how Dijkstra\'s algorithm works. Congrats!');
    // } else if (codeStep == 83) {
    //   return TutorialStep();
    // }
    // return null;
  }

  getAllCheckedTutorialStep({forwardSteps: 1}) {
    visitedNodes.add(currentNode);
    return TutorialStep(
      explanation:
          'Now all connected nodes of ${currentNode.id} are checked as well, which means it can be marked as visited',
      // goBackFunction: () => visitedNodes.remove(currentNode),
      backSteps: 9 - 2 * currentNodeConnections.length,
      forwardSteps: forwardSteps,
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

  NodeConnection getNodeConnection(Node a, Node b) {
    return nodeConnections.firstWhere(
        (element) => element.nodes.contains(a) && element.nodes.contains(b),
        orElse: () => null);
  }

  bool haveConnection(Node a, Node b) {
    return getNodeConnection(a, b) != null;
  }

  Node getOtherNode(Node node, NodeConnection nodeConnection, {List<Node> nodes}) {
    return (nodes != null ? nodes : this.nodes).firstWhere(
        (n) => nodeConnection.nodes.firstWhere((e) => e != node) == n);
  }

  Node getLowestDistanceNode() {
    return nodes
        .where((node) => !visitedNodes.contains(node))
        .reduce((curr, next) => curr.distance < next.distance ? curr : next);
  }

  Set<NodeConnection> getNodeConnections(Node node, {unvisited: false}) {
    if (node == null) return Set();
    return nodeConnections
        .where((nodeConnection) =>
            nodeConnection.nodes.contains(node) &&
            (unvisited
                ? !visitedNodes.contains(getOtherNode(node, nodeConnection))
                : true))
        .toSet();
  }

  List<Node> getNodes(Node a, {unvisited: false}) {
    return getNodeConnections(a)
        .map((nc) => nc.nodes.firstWhere((e) => e != a, orElse: () => null))
        .where((node) => unvisited ? !visitedNodes.contains(node) : true)
        .toList();
  }
}
