import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessingPost {
  double heightOfProcessingPost;

  ProcessingPost({
    this.heightOfProcessingPost =0,
  });

  ProcessingPost copyWith({
    double heightOfProcessingPost = 0,
  }) {
    return ProcessingPost(
      heightOfProcessingPost: heightOfProcessingPost,
    );
  }
}

final processingPostController =
    StateNotifierProvider<ProcessingPostController, ProcessingPost>(
        (ref) => ProcessingPostController());

class ProcessingPostController extends StateNotifier<ProcessingPost> {
  ProcessingPostController() : super(ProcessingPost());

  setPostionPost(double  newHeight) {
    state = state.copyWith(heightOfProcessingPost: newHeight);
  }
}
