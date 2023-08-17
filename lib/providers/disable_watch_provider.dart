import 'package:flutter_riverpod/flutter_riverpod.dart';


class DisableVideoState {
  final bool isDisable;
  const DisableVideoState({this.isDisable =  false});
  DisableVideoState copyWith({bool isDisable = false}) {
    return DisableVideoState(isDisable: isDisable);
  }
}

final disableVideoController =
    StateNotifierProvider<DisableVideoController, DisableVideoState>((ref) {
  return DisableVideoController();
});

class DisableVideoController extends StateNotifier<DisableVideoState> {
  DisableVideoController() : super(const DisableVideoState());
  setDisableVideo(bool newStatus) {
    state = state.copyWith(isDisable: newStatus);
  }
}
