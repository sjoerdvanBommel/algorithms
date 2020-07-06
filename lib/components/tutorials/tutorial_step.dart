import 'package:algorithms/components/tutorials/node.dart';
import 'package:algorithms/components/tutorials/node_connection.dart';

class TutorialStep {
  String explanation;
  TutorialStep previousStep, nextStep;
  int backSteps, forwardSteps;
  bool Function(Node node) selected;
  bool Function(Node node) distanceSelected;
  bool Function(Node node) visitedNodeSelected;
  bool Function(NodeConnection connection) connectionSelected;
  List<Node> Function() nodes;
  List<Node> Function() previousNodes;
  Set<Node> Function() visitedNodes;
  Set<Node> Function() previousVisitedNodes;

  TutorialStep(
      {this.explanation,
      this.selected,
      this.visitedNodeSelected,
      this.distanceSelected,
      this.connectionSelected,
      this.nodes,
      this.previousNodes,
      this.previousStep,
      this.nextStep,
      this.backSteps: 1,
      this.forwardSteps: 1});

  bool operator ==(step) => step is TutorialStep && step.explanation == explanation;

  int get hashCode => explanation.hashCode;
}
