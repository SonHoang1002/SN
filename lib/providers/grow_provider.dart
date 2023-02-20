import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/grow_api.dart';

@immutable
class GrowState {
  final List grows;
  // final dynamic detailGrow;

  const GrowState({
    this.grows = const [],
    // this.detailGrow = const {},
  });

  GrowState copyWith({
    List grows = const [],
    // dynamic detailGrow = const {},
  }) {
    return GrowState(
      grows: grows,
      // detailGrow: detailGrow,
    );
  }
}

final growControllerProvider =
    StateNotifierProvider<GrowController, GrowState>((ref) => GrowController());

class GrowController extends StateNotifier<GrowState> {
  GrowController() : super(const GrowState());

  getListGrow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        grows: [...response],
      );
    }
  }

  // getDetailGrow(id) async {
  //   var response = await GrowApi().getDetailGrowApi(id);
  //   if (response.isNotEmpty) {
  //     state = state.copyWith(grows: state.grows, detailGrow: response);
  //   }
  // }
  // updateStatusEvent(id, data) async {
  //   var res = await EventApi().statusEventApi(id, data);
  //   var indexEventUpdate =
  //       state.events.indexWhere((element) => element['id'] == id.toString());
  //   var eventUpdate = state.events[indexEventUpdate];
  //   eventUpdate['event_relationship']['status'] = res['status'] ?? '';
  //   state = state.copyWith(
  //       events: state.events.sublist(0, indexEventUpdate) +
  //           [eventUpdate] +
  //           state.events.sublist(indexEventUpdate + 1),
  //       hosts: state.hosts,
  //       eventsSuggested: state.eventsSuggested);
  // }
}
