import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';

@immutable
class GroupScheduleState {
  final List post;

  const GroupScheduleState({
    this.post = const [],
  });

  GroupScheduleState copyWith({
    List post = const [],
  }) {
    return GroupScheduleState(
      post: post,
    );
  }
}

final groupScheduleControllerProvider =
    StateNotifierProvider<GroupScheduleController, GroupScheduleState>(
        (ref) => GroupScheduleController());

class GroupScheduleController extends StateNotifier<GroupScheduleState> {
  GroupScheduleController() : super(const GroupScheduleState());

  getListMapCheckin(params) async {
    var response = await GroupApi().fetchScheduledStatus(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        post: [...response],
      );
    }
  }
}
