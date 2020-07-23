import 'package:algorithms/my_diary/models/model.dart';
import 'package:flutter/material.dart';

class DiaryDay extends Model {
  final String id, title, content, weatherIcon;
  final DateTime dayDate;

  DiaryDay({
    this.id,
    @required this.title,
    @required this.content,
    @required this.dayDate,
    this.weatherIcon,
  });

  factory DiaryDay.fromJSON(Map<String, dynamic> json) {
    return DiaryDay(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      dayDate: DateTime.parse(json['dayDate']),
      weatherIcon: json['weatherIcon'],
    );
  }
}
