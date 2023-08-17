import 'package:flutter_riverpod/flutter_riverpod.dart';


class DisableMomentState {
  final bool isDisable;
  const DisableMomentState({this.isDisable =  false});
  DisableMomentState copyWith({bool isDisable = false}) {
    return DisableMomentState(isDisable: isDisable);
  }
}

final disableMomentController =
    StateNotifierProvider<DisableMomentController, DisableMomentState>((ref) {
  return DisableMomentController();
});

class DisableMomentController extends StateNotifier<DisableMomentState> {
  DisableMomentController() : super(const DisableMomentState());
  setDisableMoment(bool newStatus) {
    state = state.copyWith(isDisable: newStatus);
  }
}
