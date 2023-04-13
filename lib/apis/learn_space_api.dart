import 'package:social_network_app_mobile/apis/api_root.dart';

class LearnSpaceApi {
  getListCoursesApi(params) async {
    return await Api().getRequestBase('/api/v1/courses', params);
  }

  getDetailCoursesApi(id) async {
    return await Api().getRequestBase('/api/v1/courses/$id', null);
  }
}
