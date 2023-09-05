import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/type_constant.dart';

class DisableWatchState {
  final bool isDisableWatchHome;
  final bool isDisableWatchFollow;
  final bool isDisableWatchLive;
  final bool isDisableWatchProgram;
  final bool isDisableWatchSaved;
  const DisableWatchState(
      {this.isDisableWatchHome = true,
      this.isDisableWatchFollow = true,
      this.isDisableWatchLive = true,
      this.isDisableWatchProgram = true,
      this.isDisableWatchSaved = true});

  DisableWatchState copyWith(
      {bool isDisableWatchHome = true,
      bool isDisableWatchFollow = true,
      bool isDisableWatchLive = true,
      bool isDisableWatchProgram = true,
      bool isDisableWatchSaved = true}) {
    return DisableWatchState(
        isDisableWatchHome: isDisableWatchHome,
        isDisableWatchFollow: isDisableWatchFollow,
        isDisableWatchLive: isDisableWatchLive,
        isDisableWatchProgram: isDisableWatchProgram,
        isDisableWatchSaved: isDisableWatchSaved);
  }
}

final disableVideoController =
    StateNotifierProvider<DisableVideoController, DisableWatchState>((ref) {
  return DisableVideoController();
});

class DisableVideoController extends StateNotifier<DisableWatchState> {
  DisableVideoController() : super(const DisableWatchState());
  setDisableVideo(String type, bool newStatus, {bool? disableBefore = true}) {
    if (disableBefore == true) {
      disableAllVideo();
    }
    state = state.copyWith(
      isDisableWatchHome:
          type == watchHome ? newStatus : state.isDisableWatchHome,
      isDisableWatchFollow:
          type == watchFollow ? newStatus : state.isDisableWatchFollow,
      isDisableWatchLive:
          type == watchLive ? newStatus : state.isDisableWatchLive,
      isDisableWatchProgram:
          type == watchProgram ? newStatus : state.isDisableWatchProgram,
      isDisableWatchSaved:
          type == watchSaved ? newStatus : state.isDisableWatchSaved,
    );
  }

  disableAllVideo() {
    state = state.copyWith(
      isDisableWatchHome:true,
      isDisableWatchFollow:
         true,
      isDisableWatchLive:
          true,
      isDisableWatchProgram:
         true,
      isDisableWatchSaved:
          true,
    );
  }

  String getProperties() {
    return "Home:${state.isDisableWatchHome},Follow: ${state.isDisableWatchFollow}, Live: ${state.isDisableWatchLive},Program:  ${state.isDisableWatchProgram},Saved:  ${state.isDisableWatchSaved}";
  }
}

final videoCurrentTabController =
    StateNotifierProvider<VideoCurrentTabController, VideoCurrentTabState>(
        (ref) => VideoCurrentTabController());

class VideoCurrentTabState {
  final String videoCurrentTab;
  const VideoCurrentTabState({this.videoCurrentTab = ""});
  VideoCurrentTabState copyWith({String videoCurrentTab = ""}) {
    return VideoCurrentTabState(videoCurrentTab: videoCurrentTab);
  }
}

class VideoCurrentTabController extends StateNotifier<VideoCurrentTabState> {
  VideoCurrentTabController() : super(const VideoCurrentTabState());

  setVideoCurrentTab(String newValue) {
    state = state.copyWith(videoCurrentTab: newValue);
  }
}
