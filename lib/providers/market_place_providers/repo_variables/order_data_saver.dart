import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedAddressSaverState {
  dynamic selectedAddressSaver;
  SelectedAddressSaverState({this.selectedAddressSaver = const {}});
  SelectedAddressSaverState copyWith(dynamic newAddress) {
    return SelectedAddressSaverState(selectedAddressSaver: newAddress);
  }
}

final selectedAddressSaverProvider = StateNotifierProvider<
    SelectedAddressSaverController,
    SelectedAddressSaverState>((ref) => SelectedAddressSaverController());

class SelectedAddressSaverController
    extends StateNotifier<SelectedAddressSaverState> {
  SelectedAddressSaverController() : super(SelectedAddressSaverState());

  updateSelectedAddressSaver({dynamic newAddress}) {
    if (newAddress != null || newAddress.isEmpty) {
      state = state.copyWith(newAddress);
    }
  }
}
