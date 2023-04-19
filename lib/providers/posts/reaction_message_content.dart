// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final commentMessageStatusProvider = StateNotifierProvider<
//     CommentMessageStatusController,
//     CommentMessageStatusState>((ref) => CommentMessageStatusController());

// class CommentMessageStatusController
//     extends StateNotifier<CommentMessageStatusState> {
//   CommentMessageStatusController() : super(CommentMessageStatusState());
//   setCommentMessageStatus(bool newStatus) {
//     state = state.copyWith(newStatus);
//   }
// }

// class CommentMessageStatusState {
//   bool status;
//   CommentMessageStatusState({this.status = false});
//   CommentMessageStatusState copyWith(bool newStatus) {
//     return CommentMessageStatusState(status: newStatus);
//   }
// }

// final commentMessageContentProvider = StateNotifierProvider.autoDispose<
//     CommentMessageContentController,
//     CommentMessageContentState>((ref) => CommentMessageContentController());

// class CommentMessageContentController
//     extends StateNotifier<CommentMessageContentState> {
//   CommentMessageContentController() : super(CommentMessageContentState());
//   setCommentMessage(dynamic newContent) {
//     if (newContent != null && mounted) {
//       state = state.copyWithMessage(newContent);
//     }
//   }
// }

// class CommentMessageContentState {
//   dynamic message;
//   CommentMessageContentState({
//     this.message = 0,
//   });
//   CommentMessageContentState copyWithMessage(dynamic newContent) {
//     return CommentMessageContentState(message: newContent);
//   }
// }

// final commentMessageStatusProvider1 = StateNotifierProvider<
//     CommentMessageStatusController1,
//     CommentMessageStatusState1>((ref) => CommentMessageStatusController1());

// class CommentMessageStatusController1
//     extends StateNotifier<CommentMessageStatusState1> {
//   CommentMessageStatusController1() : super(CommentMessageStatusState1());
//   setCommentMessageStatus(int index, bool newStatus) {
//     state = state.copyWith(index, newStatus);
//   }

//   resetCommentMessageStatus() {
//     state = state.copyWith(null, null);
//   }
// }

// class CommentMessageStatusState1 {
//   List<bool> listStatus;
//   CommentMessageStatusState1(
//       {this.listStatus = const [
//         false,
//         false,
//         false,
//         false,
//         false,
//         false,
//         false
//       ]});
//   CommentMessageStatusState1 copyWith(dynamic index, dynamic newStatus) {
//     if (index == null && newStatus == null) {
//       final resetList = [false, false, false, false, false, false, false];
//       return CommentMessageStatusState1(listStatus: resetList);
//     }
//     List<bool> fixList = listStatus;
//     fixList[index] = newStatus;
//     return CommentMessageStatusState1(listStatus: fixList);
//   }
// }
