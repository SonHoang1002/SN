import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/common.api.dart';

@immutable
class MapState {
  final List checkin;

  const MapState({
    this.checkin = const [],
  });

  MapState copyWith({
    List checkin = const [],
  }) {
    return MapState(
      checkin: checkin,
    );
  }
}

final mapControllerProvider =
    StateNotifierProvider<MapController, MapState>((ref) => MapController());

class MapController extends StateNotifier<MapState> {
  MapController() : super(const MapState());

  getListMapCheckin(params) async {
    var response = await CommonApi().fetchDataLocation(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        checkin: [...response],
      );
    }
  }
}
