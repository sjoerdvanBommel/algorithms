import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Node extends StatelessWidget {
  final String id;
  final double left, top;
  final int distance;
  final List<NodeConnection> connectedTo;
  final Function onPress;
  final bool isSelected;
  final bool isDistanceSelected;

  Node(
      {this.id,
      this.distance,
      this.left,
      this.top,
      this.connectedTo,
      this.onPress,
      this.isSelected,
      this.isDistanceSelected});

  @override
  Widget build(BuildContext context) {
    final connections = connectedTo.map((NodeConnection e) {
      return CustomPaint(
        painter: MyPainter(
            text: e.weight.toString(),
            left: left,
            top: top,
            destLeft: e.node.left,
            destTop: e.node.top),
      );
    }).toList();

    return Container(
      child: Positioned(
        left: left,
        top: top,
        child: Stack(
          children: <Widget>[
            ...connections,
            ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () => onPress(id),
                color: Theme.of(context).backgroundColor,
                child: Text(id),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(
                  side: isSelected == true ? BorderSide(color: Colors.red, width: 3) : BorderSide.none,
                ),
              ),
            ),
            Positioned(
              left: 50,
              child: Container(
                width: 25,
                height: 25,
                child: Center(
                    child: distance == 1 << 32
                        ? Icon(
                            FontAwesomeIcons.infinity,
                            size: 10,
                          )
                        : Text(distance.toString())),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isDistanceSelected ? Border.all(color: Colors.red, width: 3) : null,
                    color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NodeConnection {
  final Node node;
  final int weight;

  NodeConnection(this.node, this.weight);
}

class MyPainter extends CustomPainter {
  final String text;
  final double left, top, destLeft, destTop;

  MyPainter(
      {@required this.text, this.left, this.top, this.destLeft, this.destTop});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(45, 25);
    final p2 = Offset(destLeft - left + 45, destTop - top + 25);
    final paint = Paint()
      ..color = Colors.grey[300]
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
    final textpainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: Colors.black)),
      textDirection: TextDirection.ltr,
    );
    textpainter.layout(minWidth: 0, maxWidth: 300);
    textpainter.paint(
        canvas,
        Offset((destLeft == left ? 50 : 40) + (destLeft - left) / 2,
            5 + (destTop - top) / 2));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
