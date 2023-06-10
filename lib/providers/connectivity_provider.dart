
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class ConnectivityState {
  final bool connectWifi;

  const ConnectivityState({this.connectWifi = true});

  ConnectivityState copyWith({bool connectWifi = true}) {
    return ConnectivityState(connectWifi: connectWifi);
  }
}

final connectivityControllerProvider =
    StateNotifierProvider.autoDispose<ConnectivityProvider, ConnectivityState>(
        (ref) {
  ref.read(meControllerProvider);
  return ConnectivityProvider();
});

class ConnectivityProvider extends StateNotifier<ConnectivityState> {
  ConnectivityProvider() : super(const ConnectivityState());
  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      state = state.copyWith(connectWifi: true);
    } else {
      state = state.copyWith(connectWifi: false);
    }
  }
}
