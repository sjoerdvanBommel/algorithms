import 'package:flutter/material.dart';

class ControllerResponse<T> {
  final int statusCode;
  final String message;
  final T body;

  ControllerResponse({@required this.statusCode, this.message, this.body});
}
