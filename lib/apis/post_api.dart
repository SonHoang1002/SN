import 'api_root.dart';

class PostApi {
  Future getListPostApi(params) async {
    return await Api().getRequestBase('/api/v1/timelines/home', params);
  }

  Future getListCommentPost(String postId, params) async {
    return await Api().getRequestBase('/api/v1/comments/$postId', params);
  }

  Future createStatus(data) async {
    return await Api().postRequestBase('/api/v1/statuses', data);
  }
}
