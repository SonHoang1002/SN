import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/watch_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class WatchState {
  final List watchSuggest;
  final List watchFollow;
  //Position video is playing
  final int position;
  final dynamic mediaSelected;

  const WatchState(
      {this.watchSuggest = const [],
      this.watchFollow = const [],
      this.position = 0,
      this.mediaSelected});

  WatchState copyWith(
      {List watchSuggest = const [],
      List watchFollow = const [],
      int position = 0,
      dynamic mediaSelected}) {
    return WatchState(
        watchSuggest: watchSuggest,
        watchFollow: watchFollow,
        position: position,
        mediaSelected: mediaSelected);
  }
}

final watchControllerProvider =
    StateNotifierProvider.autoDispose<WatchController, WatchState>((ref) {
  ref.read(meControllerProvider);
  return WatchController();
});

class WatchController extends StateNotifier<WatchState> {
  WatchController() : super(const WatchState());

  reset() {
    state = const WatchState();
  }

  getListWatchFollow(params) async {
    List response = await WatchApi().getListWatchFollow(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          mediaSelected: state.mediaSelected,
          position: state.position,
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
          mediaSelected: state.mediaSelected,
          position: state.position,
          watchFollow: state.watchFollow,
          watchSuggest: params.containsKey('max_id')
              ? checkObjectUniqueInList(
                  [...state.watchSuggest, ...newWatch], 'id')
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
          mediaSelected: state.mediaSelected,
          position: state.position,
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

  updatePositionPlaying(position) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        state = state.copyWith(
            watchSuggest: state.watchSuggest,
            watchFollow: state.watchFollow,
            position: position);
      }
    });
  }

  updateMediaPlaying(media) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        state = state.copyWith(
            mediaSelected: media,
            watchSuggest: state.watchSuggest,
            watchFollow: state.watchFollow,
            position: state.position);
      }
    });
  }
}
