import 'package:flutter/material.dart';

onHorizontalDragEnd(AnimationController _controller, DragEndDetails details,
    BuildContext context, bool forward, double maxValueReverse) {
  double _kMinFlingVelocity = 365.0;
  if (_controller.isDismissed || _controller.isCompleted) {
    return;
  }
  if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
    double visualVelocity =
        details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;

    _controller.fling(velocity: visualVelocity * (forward == true ? 1 : -1));
  } else if (_controller.value < maxValueReverse) {
    _controller.reverse();
  } else {
    _controller.forward();
  }
}
