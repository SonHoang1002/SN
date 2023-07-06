
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ConnectivityState {
  final bool connectInternet;

  const ConnectivityState({this.connectInternet = true});

  ConnectivityState copyWith({bool connectInternet = true}) {
    return ConnectivityState(connectInternet: connectInternet);
  }
}

final connectivityControllerProvider =
    StateNotifierProvider<ConnectivityProvider, ConnectivityState>(
        (ref) { 
  return ConnectivityProvider();
});

class ConnectivityProvider extends StateNotifier<ConnectivityState> {
  ConnectivityProvider() : super(const ConnectivityState());
  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      state = state.copyWith(connectInternet: true);
    } else {
      state = state.copyWith(connectInternet: false);
    }
  }
}
