import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(ref: ref, postApi: ref.watch(postApiProvider));
});

final getPostsProvider = FutureProvider.autoDispose.family((ref, params) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts(params);
});

class PostController extends StateNotifier<bool> {
  final PostApi postApi;

  PostController({required this.postApi, required Ref ref}) : super(false);

  List listPost = [];

  Future getPosts(params) async {
    final newList = await postApi.getListPostApi(params);
    listPost = newList;
    return listPost;
  }
}
