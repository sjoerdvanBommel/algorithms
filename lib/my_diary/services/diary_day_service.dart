import 'package:algorithms/my_diary/models/diary_day.dart';
import 'package:http/http.dart' as http;
import 'http_service.dart';

class DiaryDayService extends HttpService {
  Future<http.Response> add(DiaryDay diaryDay) {
    return post('/diary-day', {
      'title': diaryDay.title,
      'content': diaryDay.content,
      'dayDate': diaryDay.dayDate.toUtc().toIso8601String(),
      'weatherIcon': diaryDay.weatherIcon,
    });
  }

  Future<http.Response> getAll() {
    return get('/diary-day');
  }
}
