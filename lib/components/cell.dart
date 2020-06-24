import 'package:flutter/material.dart';
import 'package:pathfinder/enums/cell_type.dart';

class Cell extends StatefulWidget {
  final bool isSelected;
  final CellType type;
  final int weight, index;

  Cell(
      {@required this.isSelected,
      @required this.type,
      @required this.weight,
      @required this.index});

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: widget.type.color,
        border: Border.all(
          width: widget.isSelected ? 2.0 : 0.25,
          color: Theme.of(context).accentColor,
        ),
      ),
      child: widget.type == CellType.start || widget.type == CellType.end
          ? Center(
              child: Text(
                widget.type == CellType.start ? 'Start' : 'End',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            )
          : widget.type != CellType.wall && widget.weight != -1
              ? Center(
                  child: Text(
                    '${widget.weight}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
    );
  }
}
