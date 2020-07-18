import 'dart:math';

import 'package:algorithms/algorithms/components/tutorials/node.dart';
import 'package:algorithms/algorithms/components/tutorials/node_connection.dart';
import 'package:algorithms/algorithms/components/tutorials/pathfinding_tutorial_step.dart';

class DijkstraTutorialSteps {
  Set<Node> visitedNodes = Set<Node>();
  Set<NodeConnection> currentNodeConnections = Set<NodeConnection>();
  Set<NodeConnection> nodeConnections;
  Set<Node> nodes;
  Node start;
  Node currentNode;

  DijkstraTutorialSteps(this.nodeConnections, this.nodes);

  PathfindingTutorialStep getTutorialStep(int codeStep) {
    if (codeStep == 0) {
      start = null;
      return PathfindingTutorialStep(
        explanation: 'Pick a starting node by pressing it',
      );
    } else if (codeStep == 1) {
      return PathfindingTutorialStep(
        explanation: 'From now on, ${start.id} will be the starting node',
        selected: (node) => start == node,
      );
    } else if (codeStep == 2) {
      start.distance = 0;
      return PathfindingTutorialStep(
        explanation:
            'The tentative distance to ${start.id} will be set to 0, since we\'re already there',
        distanceSelected: (node) => start == node,
        goBack: () {
          start.distances.removeLast();
          if (start.distances.length > 1) start.distances.removeLast();
        },
      );
    } else if (codeStep == 3) {
      return PathfindingTutorialStep(
        explanation:
            'The other nodes will have a tentative distance of infinity',
        distanceSelected: (node) => start != node,
      );
    } else if (codeStep == 4) {
      return PathfindingTutorialStep(
        explanation:
            'On the bottom we keep track of the visited nodes. This will also be visible during the tutorial with a green border',
        visitedNodeSelected: (id) => true,
      );
    } else if (codeStep == 5) {
      return PathfindingTutorialStep(
        explanation:
            'The first step will be comparing the tentative distance between the start node (${start.id}) and the connected nodes',
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
      return PathfindingTutorialStep(
        explanation:
            'Now that we checked every connected node, we can mark the start node as visited',
        goBack: () => visitedNodes = Set<Node>(),
        backSteps: 9 - 2 * currentNodeConnections.length,
      );
    } else if (codeStep == 15) {
      return PathfindingTutorialStep(
        explanation: 'A visited node will never be checked again',
      );
    } else if (codeStep == 16) {
      return PathfindingTutorialStep(
        explanation:
            'The next step is to perform the same steps again for all other unvisited nodes',
        selected: (e) => e != start && haveConnection(start, e),
        connectionSelected: (e) => currentNodeConnections.contains(e),
      );
    } else if (codeStep == 17) {
      currentNode = getLowestDistanceNode();
      return PathfindingTutorialStep(
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

        return PathfindingTutorialStep(
          explanation:
              '${currentNode.id} has ${currentNodeConnections.length} connected node${nodes.length == 1 ? ' that hasn\'t' : 's that haven\'t'} been visited yet: $unvisitedNodes',
          distanceSelected: (e) => e == currentNode,
          selected: (e) => e == currentNode,
          connectionSelected: (e) => currentNodeConnections.contains(e),
          goBack: () => currentNodeConnections = getNodeConnections(start),
        );
      } else if (repeatingStep == 1) {
        NodeConnection nc = currentNodeConnections.elementAt(0);
        Node node2 = getOtherNode(currentNode, nc);
        return PathfindingTutorialStep(
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
        return PathfindingTutorialStep(
          explanation:
              'Because all connected nodes have been visited already, there is nothing to do. This node can be marked as visited',
          goBack: () => visitedNodes.remove(currentNode),
          backSteps: 11,
        );
      } else if (repeatingStep == 11) {
        currentNode = getLowestDistanceNode();
        currentNodeConnections =
            getNodeConnections(currentNode, unvisited: true);
        return PathfindingTutorialStep(
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
      return PathfindingTutorialStep(
          explanation: 'The algorithm ends when all elements are visited');
    } else if (codeStep == 78) {
      return PathfindingTutorialStep(
          explanation:
              'It is also possible that the algorithm can\'t reach certain nodes');
    } else if (codeStep == 79) {
      return PathfindingTutorialStep(
          explanation:
              'In this case it will stop as soon as all remaining nodes have a tentative distance of infinity');
    } else if (codeStep == 80) {
      return PathfindingTutorialStep(
          explanation:
              'If you want, you can let it stop as soon as it found a finish node, for example');
    } else if (codeStep == 81) {
      return PathfindingTutorialStep(
          explanation:
              'If you want to save the shortest path for every node, you can set a parent node for every node which will be updated when you update the node distance');
    } else if (codeStep == 82) {
      return PathfindingTutorialStep(
          explanation:
              'Now you know how Dijkstra\'s algorithm works. Congrats!');
    } else if (codeStep == 83) {
      return PathfindingTutorialStep();
    }
    return null;
  }

  getAllCheckedTutorialStep({forwardSteps: 1}) {
    visitedNodes.add(currentNode);
    return PathfindingTutorialStep(
      explanation:
          'Now all connected nodes of ${currentNode.id} are checked as well, which means it can be marked as visited',
      goBack: () => visitedNodes.remove(currentNode),
      backSteps: 9 - 2 * currentNodeConnections.length,
      forwardSteps: forwardSteps,
    );
  }

  getIntroCompareTutorialStep(Node a, int otherNodeIndex) {
    NodeConnection nc =
        getNodeConnections(a, unvisited: true).elementAt(otherNodeIndex);
    Node b = getOtherNode(a, nc);
    return PathfindingTutorialStep(
      explanation: otherNodeIndex > 0
          ? 'Next we will check ${b.id}, the ${otherNodeIndex == 1 ? 'second' : otherNodeIndex == 2 ? 'third' : 'fourth'} connected node'
          : 'We start with checking ${b.id}, the first connected node',
      connectionSelected: (e) => e == getNodeConnection(a, b),
    );
  }

  getCompareTutorialStep(Node a, int otherNodeIndex) {
    currentNodeConnections = getNodeConnections(a, unvisited: true);
    NodeConnection nc = currentNodeConnections.elementAt(otherNodeIndex);
    Node b = getOtherNode(a, nc);
    int l = currentNodeConnections.length;
    PathfindingTutorialStep step = PathfindingTutorialStep(
      explanation: a.distance + nc.weight < b.distance
          ? 'Since (${a.distance} + ${nc.weight}) is smaller than ${b.distance == 1 << 32 ? 'infinity' : b.distance}, the distance to ${b.id} will be set to ${a.distance + nc.weight}'
          : 'Because the calculated distance (${a.distance} + ${nc.weight}) isn\'t smaller than the current lowest distance (${b.distance}), it doesn\'t need to be updated',
      connectionSelected: (e) => e == nc,
      distanceSelected: (e) => [a, b].contains(e),
      goBack: () {
        b.distances.removeLast();
        if (b.distances.length > 1) b.distances.removeLast();
      },
      // Calculates amount of steps to skip based on amount of connections to node
      forwardSteps: l > otherNodeIndex + 1 || otherNodeIndex == 3
          ? 1
          : l == 3 ? 3 : l == 2 ? 5 : 7,
    );
    b.distance = min(a.distance + nc.weight, b.distance);
    return step;
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
}
