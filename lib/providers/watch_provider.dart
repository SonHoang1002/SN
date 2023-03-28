import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/watch_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class WatchState {
  final List watchSuggest;
  final List watchFollow;

  const WatchState({
    this.watchSuggest = const [],
    this.watchFollow = const [],
  });

  WatchState copyWith({
    List watchSuggest = const [],
    List watchFollow = const [],
  }) {
    return WatchState(
      watchSuggest: watchSuggest,
      watchFollow: watchFollow,
    );
  }
}

final watchControllerProvider =
    StateNotifierProvider.autoDispose<WatchController, WatchState>((ref) {
  ref.read(meControllerProvider);
  return WatchController();
});

class WatchController extends StateNotifier<WatchState> {
  WatchController() : super(const WatchState());

  getListWatchFollow(params) async {
    List response = await WatchApi().getListWatchFollow(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          watchFollow: state.watchFollow + response,
          watchSuggest: state.watchSuggest);
    }
  }

  getListWatchSuggest(params) async {
    List response = await WatchApi().getListWatchSuggest(params) ?? [];
    if (mounted) {
      final newWatch =
          response.where((item) => !state.watchSuggest.contains(item)).toList();
      state = state.copyWith(
          watchFollow: state.watchFollow,
          watchSuggest: params.containsKey('max_id')
              ? [...state.watchSuggest, ...newWatch]
              : newWatch);
    }
  }

  updateWatchDetail(type, newWatch) {
    int index = -1;

    if (type == 'follow') {
      index = state.watchFollow
          .indexWhere((element) => element['id'] == newWatch['id']);
    } else if (type == 'suggest') {
      index = state.watchSuggest
          .indexWhere((element) => element['id'] == newWatch['id']);
    }

    if (mounted && index >= 0) {
      state = state.copyWith(
          watchFollow: type == 'follow'
              ? state.watchFollow.sublist(0, index) +
                  [newWatch] +
                  state.watchFollow.sublist(index + 1)
              : state.watchFollow,
          watchSuggest: type == 'forget'
              ? state.watchSuggest.sublist(0, index) +
                  [newWatch] +
                  state.watchSuggest.sublist(index + 1)
              : state.watchSuggest);
    }
  }
}
