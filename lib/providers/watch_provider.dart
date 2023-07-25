import 'dart:convert';

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
    int indexFollow = -1;
    int indexSuggest = -1;

    // if (type == 'follow') {
    indexFollow = state.watchFollow
        .indexWhere((element) => element['id'] == newWatch['id']);
    // } else if (type == 'suggest') {
    indexSuggest = state.watchSuggest
        .indexWhere((element) => element['id'] == newWatch['id']);
    // }

    if (mounted && (indexFollow >= 0 || indexSuggest >= 0)) {
      state = state.copyWith(
          mediaSelected: state.mediaSelected,
          position: state.position,
          watchFollow: indexFollow != -1
              ? state.watchFollow.sublist(0, indexFollow) +
                  [newWatch] +
                  state.watchFollow.sublist(indexFollow + 1)
              : state.watchFollow,
          watchSuggest: indexSuggest != -1
              ? state.watchSuggest.sublist(0, indexSuggest) +
                  [newWatch] +
                  state.watchSuggest.sublist(indexSuggest + 1)
              : state.watchSuggest);
    }
    print("newWatch ${jsonEncode(newWatch)}");
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
