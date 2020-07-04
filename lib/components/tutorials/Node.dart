import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Node {
  final String id;
  final double left, top;
  Queue<int> distances = Queue<int>();

  Node({this.id, @required this.left, this.top, distance}) {
    this.distance = distance;
  }

  int get distance {
    return distances.last;
  }

  set distance(int value) {
    distances.addLast(value);
    distances.forEach((element) {print(element);});
  }

  bool operator ==(node) =>
      node is Node && node.id == id && node.distance == distance;

  int get hashCode => id.hashCode * distance.hashCode;
}

class NodeWidget extends StatelessWidget {
  final Node node;
  final Function onPress;
  final bool isSelected;
  final bool isDistanceSelected;
  final bool isVisited;

  NodeWidget(
      {this.node,
      this.onPress,
      this.isSelected,
      this.isDistanceSelected,
      this.isVisited});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: node.left,
        top: node.top,
        child: Stack(
          children: <Widget>[
            ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () => onPress(node),
                color: Theme.of(context).backgroundColor,
                child: Text(node.id),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(
                  side: isSelected || isVisited ? BorderSide(color: isSelected ? Colors.red : Colors.green, width: 3) : BorderSide.none,
                ),
              ),
            ),
            Positioned(
              left: 50,
              child: Container(
                width: 25,
                height: 25,
                child: Center(
                    child: node.distance == 1 << 32
                        ? Icon(
                            FontAwesomeIcons.infinity,
                            size: 10,
                          )
                        : Text(node.distance.toString())),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDistanceSelected ? Colors.red : isVisited ? Colors.green : Theme.of(context).accentColor, width: 3),
                    color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
