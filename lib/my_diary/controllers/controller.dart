import 'package:algorithms/my_diary/models/model.dart';

import 'controller_response.dart';

abstract class Controller<T extends Model> {
  Future<ControllerResponse> add(T model);
  Future<ControllerResponse<List<T>>> getAll();
}
