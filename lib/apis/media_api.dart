import 'package:dio/dio.dart';
import 'package:market_place/constant/config.dart';
import 'package:market_place/apis/api_root.dart';

class ApiMediaPetube {
  BaseOptions options = BaseOptions(
    baseUrl: baseRootPtube,
    connectTimeout: 30 * 1000,
    receiveTimeout: 30 * 1000,
    headers: {
      "Content-Type": "multipart/form-data",
      'authorization': 'Bearer $tokenVideoUpload'
    },
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
