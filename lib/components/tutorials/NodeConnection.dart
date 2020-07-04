import 'package:algorithms/components/tutorials/Node.dart';
import 'package:algorithms/components/tutorials/TutorialStep.dart';
import 'package:flutter/material.dart';

class NodeConnection {
  final List<Node> nodes;
  final int weight;

  NodeConnection(this.nodes, this.weight);

  bool operator ==(nodeConnection) =>
      nodeConnection is NodeConnection &&
      this.nodes[0].id == nodeConnection.nodes[0].id &&
      this.nodes[1].id == nodeConnection.nodes[1].id &&
      this.weight == nodeConnection.weight;

  int get hashCode => this.nodes[0].hashCode * this.nodes[1].hashCode;
}

class NodeConnectionWidget extends StatelessWidget {
  final NodeConnection nodeConnection;
  final TutorialStep step;

  NodeConnectionWidget({this.nodeConnection, this.step});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(400, 250),
      painter: MyPainter(
          start: nodeConnection.nodes[0],
          end: nodeConnection.nodes[1],
          weight: nodeConnection.weight,
          selected: step.connectionSelected != null
              ? step.connectionSelected(nodeConnection)
              : false),
    );
  }
}

class MyPainter extends CustomPainter {
  final Node start;
  final Node end;
  final int weight;
  final bool selected;

  MyPainter(
      {@required this.start, @required this.end, this.weight, this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(start.left + 45, start.top + 25);
    final p2 = Offset(end.left + 45, end.top + 25);
    final paint = Paint()
      ..color = selected ? Colors.red : Colors.grey[300]
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
    final textpainter = TextPainter(
      text: TextSpan(
          text: ' ${weight.toString()} ',
          style: TextStyle(
              color: Colors.black,
              backgroundColor: Colors.white,
              fontSize: 14)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textpainter.layout(minWidth: 0, maxWidth: 400);
    textpainter.paint(
        canvas,
        Offset(
            45 +
                start.left +
                (end.left - start.left) / 2 -
                (textpainter.width / 2) -
                1,
            (25 + start.top + (end.top - start.top) / 2) -
                (textpainter.height / 2)));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
