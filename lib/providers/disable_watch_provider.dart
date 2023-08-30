import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/type_constant.dart';

class DisableWatchState {
  final bool isDisableWatchHome;
  final bool isDisableWatchFollow;
  final bool isDisableWatchLive;
  final bool isDisableWatchProgram;
  final bool isDisableWatchSaved;
  const DisableWatchState(
      {this.isDisableWatchHome = false,
      this.isDisableWatchFollow = false,
      this.isDisableWatchLive = false,
      this.isDisableWatchProgram = false,
      this.isDisableWatchSaved = false});

  DisableWatchState copyWith(
      {bool isDisableWatchHome = false,
      bool isDisableWatchFollow = false,
      bool isDisableWatchLive = false,
      bool isDisableWatchProgram = false,
      bool isDisableWatchSaved = false}) {
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
  setDisableVideo(String type, bool newStatus) {
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
    state = const DisableWatchState();
  }
}
