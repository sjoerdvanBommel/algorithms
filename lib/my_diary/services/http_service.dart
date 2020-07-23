import 'package:http/http.dart' as http;

class HttpService {
  String _baseUrl = 'https://my-diary-app.glitch.me';

  Future<http.Response> get(String url) {
    return http.get(_baseUrl + url);
  }

  Future<http.Response> post(String url, Map<String, String> body) {
    return http.post(_baseUrl + url, body: body);
  }
}
