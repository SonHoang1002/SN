import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionPost {
  dynamic positionScroll;

  PositionPost({
    this.positionScroll = "",
  });

  PositionPost copyWith({
    dynamic newPosition = "",
  }) {
    return PositionPost(
      positionScroll: newPosition,
    );
  }
}

final positionPostProvider =
    StateNotifierProvider<PositionPostController, PositionPost>(
        (ref) => PositionPostController());

class PositionPostController extends StateNotifier<PositionPost> {
  PositionPostController() : super(PositionPost());

  setPostionPost(dynamic newPosition) {
    state = state.copyWith(newPosition: newPosition);
  }
}
