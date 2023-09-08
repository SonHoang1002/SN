import 'package:flutter_riverpod/flutter_riverpod.dart';

class DraftFeed {
  final String gifLink;
  final List files;
  final String content;
  final dynamic checkin;
  final dynamic previewUrlData;
  final dynamic poll;
  final dynamic lifeEvent;

  DraftFeed(
      {this.gifLink = "",
      this.files = const [],
      this.content = "",
      this.checkin,
      this.previewUrlData,
      this.poll,
      this.lifeEvent});
  DraftFeed copyWith(
      {String gifLink = "",
      List files = const [],
      String content = "",
      dynamic checkin,
      dynamic previewUrlData,
      dynamic poll,
      dynamic lifeEvent}) {
    return DraftFeed(
        gifLink: gifLink,
        files: files,
        content: content,
        checkin: checkin,
        previewUrlData: previewUrlData,
        poll: poll,
        lifeEvent: lifeEvent);
  }

  String toContentString() {
    return 'DraftFeed{ gifLink: $gifLink, files: $files, content: $content, checkin: $checkin, previewUrlData: $previewUrlData, poll: $poll, lifeEvent $lifeEvent }';
  }
}

final draftFeedController =
    StateNotifierProvider<DraftFeedContentController, DraftFeed>((ref) {
  return DraftFeedContentController();
});

class DraftFeedContentController extends StateNotifier<DraftFeed> {
  DraftFeedContentController() : super(DraftFeed());
  saveDraftFeed(DraftFeed draftFeed) {
    state = state.copyWith(
        gifLink: draftFeed.gifLink,
        files: draftFeed.files,
        content: draftFeed.content,
        checkin: draftFeed.checkin,
        previewUrlData: draftFeed.previewUrlData,
        poll: draftFeed.poll,
        lifeEvent: draftFeed.lifeEvent);
  }

  resetData() {
    state = DraftFeed();
  }
}
