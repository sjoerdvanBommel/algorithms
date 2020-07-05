import 'package:algorithms/components/tutorials/node.dart';
import 'package:algorithms/components/tutorials/node_connection.dart';

class TutorialStep {
  String explanation;
  int forwardSteps, backSteps;
  bool Function(Node node) selected;
  bool Function(Node node) distanceSelected;
  bool Function(Node node) visitedNodeSelected;
  bool Function(NodeConnection connection) connectionSelected;
  void Function() goBack;

  TutorialStep(
      {this.explanation,
      this.selected,
      this.visitedNodeSelected,
      this.distanceSelected,
      this.connectionSelected,
      this.goBack,
      this.forwardSteps: 1,
      this.backSteps: 1});
}
