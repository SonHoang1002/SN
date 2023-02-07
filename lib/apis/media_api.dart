import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';
import 'package:social_network_app_mobile/apis/config.dart';

class ApiConfig {
  BaseOptions options = BaseOptions(
    baseUrl: baseRoot,
    connectTimeout: 30 * 1000,
    receiveTimeout: 30 * 1000,
    headers: {'authorization': 'Bearer $tokenVideoUpload'},
  );

  Dio getDio() {
    return Dio(options);
  }

  Future uploadMediaPetube(data) async {
    try {
      Dio dio = getDio();
      var response = await dio.post('/api/v1/videos/upload', data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}

class MediaApi {
  Future uploadMediaEmso(data) async {
    return await Api().postRequestBase('/api/v1/media', data);
  }
}
