import 'dart:convert';

import 'package:algorithms/my_diary/controllers/controller.dart';
import 'package:algorithms/my_diary/controllers/controller_response.dart';
import 'package:algorithms/my_diary/models/diary_day.dart';
import 'package:algorithms/my_diary/services/diary_day_service.dart';
import 'package:http/http.dart' as http;

class DiaryDayController implements Controller<DiaryDay> {
  final DiaryDayService diaryDayService = DiaryDayService();

  @override
  Future<ControllerResponse> add(DiaryDay diaryDay) async {
    http.Response res = await diaryDayService.add(diaryDay);
    return ControllerResponse(
        statusCode: res.statusCode, message: 'Succesvol opgeslagen.');
  }

  @override
  Future<ControllerResponse<List<DiaryDay>>> getAll() async {
    http.Response res = await diaryDayService.getAll();
    List<dynamic> resBody = json.decode(res.body);
    List<DiaryDay> body = resBody.map((e) => DiaryDay.fromJSON(e)).toList();
    return ControllerResponse(statusCode: res.statusCode, body: body);
  }
}
