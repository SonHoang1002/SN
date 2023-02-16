import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/Comment_product_api.dart';

class CommentProductState {
  List<dynamic> commentList;
  CommentProductState({this.commentList = const []});
  CommentProductState copyWith(List<dynamic> list) {
    return CommentProductState(commentList: list);
  }
}

final commentProductProvider =
    StateNotifierProvider<CommentProductController, CommentProductState>(
        (ref) => CommentProductController());

class CommentProductController extends StateNotifier<CommentProductState> {
  CommentProductController() : super(CommentProductState());

  getCommentProduct(String id) async {
    final response = await CommentProductApi().getCommentProductApi(id);
    final data = List.from(response);
    print("data comments: ${data}");
    // state = state.copyWith(response);
  }
}
