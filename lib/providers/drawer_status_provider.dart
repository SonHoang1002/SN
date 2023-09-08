import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerStatusState {
  final bool drawerStatus;

  DrawerStatusState({this.drawerStatus = false});

  DrawerStatusState copyWith({drawerStatus = false}) {
    return DrawerStatusState(drawerStatus: drawerStatus);
  }
}

final drawerStatusProviderController =
    StateNotifierProvider<DrawerStatusController, DrawerStatusState>(
        (ref) => DrawerStatusController());

class DrawerStatusController extends StateNotifier<DrawerStatusState> {
  DrawerStatusController() : super(DrawerStatusState());
  setDrawerStatus(bool newValue) {
    state = state.copyWith(drawerStatus: newValue);
  }
}
