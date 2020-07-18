import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:algorithms/algorithms/components/cell.dart';
import 'package:algorithms/algorithms/enums/cell_type.dart';

class Grid extends StatefulWidget {
  final List<int> grid, shortestPath, visitedIndexes;
  final Set<int> selectedIndexes, walls;
  final int start, end, nColumns;
  final Function onSelectCell;

  Grid({
    @required this.grid,
    @required this.start,
    @required this.end,
    @required this.nColumns,
    @required this.onSelectCell,
    this.shortestPath,
    this.visitedIndexes,
    this.selectedIndexes,
    this.walls,
  });

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  final key = GlobalKey();
  int selectedIndex;

  onPointerEvent(PointerEvent event) {
    final RenderBox box = key.currentContext.findRenderObject();
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is CellIndex) {
          if (target.index != selectedIndex ||
              event is PointerDownEvent ||
              event is LongPressGestureRecognizer) {
            widget.onSelectCell(target.index);
          }
          setState(() {
            selectedIndex = target.index;
          });
        }
      }
    }
  }

  CellType getCellType(int i) {
    return i == widget.start
        ? CellType.start
        : i == widget.end
            ? CellType.end
            : widget.walls.contains(i)
                ? CellType.wall
                : widget.shortestPath.contains(i)
                    ? CellType.shortestPath
                    : widget.visitedIndexes.contains(i)
                        ? CellType.visited
                        : CellType.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: onPointerEvent,
      onPointerMove: onPointerEvent,
      child: GridView.builder(
        key: key,
        shrinkWrap: true,
        itemCount: widget.grid.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.nColumns,
          childAspectRatio:
              (widget.grid.length / widget.nColumns) / widget.nColumns,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemBuilder: (context, i) {
          return CellHelper(
            index: i,
            child: Cell(
                isSelected: false, //widget.selectedIndexes.contains(i),
                type: getCellType(i),
                weight: widget.grid[i],
                index: i),
          );
        },
      ),
    );
  }
}

class CellHelper extends SingleChildRenderObjectWidget {
  final int index;

  CellHelper({Widget child, this.index, Key key})
      : super(child: child, key: key);

  @override
  CellIndex createRenderObject(BuildContext context) {
    return CellIndex()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, CellIndex renderObject) {
    renderObject..index = index;
  }
}

class CellIndex extends RenderProxyBox {
  int index;
}
