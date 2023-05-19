import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/data/suggest.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class MomentState {
  final List momentSuggest;
  final List momentFollow;

  const MomentState({
    this.momentSuggest = const [],
    this.momentFollow = const [],
  });

  MomentState copyWith({
    List momentSuggest = const [],
    List momentFollow = const [],
  }) {
    return MomentState(
      momentSuggest: momentSuggest,
      momentFollow: momentFollow,
    );
  }
}

final momentControllerProvider =
    StateNotifierProvider.autoDispose<MomentController, MomentState>((ref) {
  ref.read(meControllerProvider);
  return MomentController();
});

class MomentController extends StateNotifier<MomentState> {
  MomentController() : super(const MomentState());

  getListMomentFollow(params) async {
    List response = await MomentApi().getListMomentFollow(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          momentFollow: state.momentFollow + response,
          momentSuggest: state.momentSuggest);
    }
  }

  updateReaction(reaction, id) async {
    var response;
    if (reaction == 'love') {
      response = await MomentApi().favoriteReactionMoment(id);
    } else if (reaction == null) {
      response = await MomentApi().unfavoriteReactionMoment(id);
    }
    if (response['id'] == id) {
      if (mounted) {
        var tempDataFollow = state.momentFollow
            .map((e) => e['id'] == id
                ? {
                    ...e,
                    'viewer_reaction': reaction,
                    'favourites_count': reaction == 'love'
                        ? e['favourites_count'] + 1
                        : e['favourites_count'] - 1
                  }
                : e)
            .toList();
        var tempDataSuggest = state.momentSuggest
            .map((e) => e['id'] == id
                ? {
                    ...e,
                    'viewer_reaction': reaction,
                    'favourites_count': reaction == 'love'
                        ? e['favourites_count'] + 1
                        : e['favourites_count'] - 1
                  }
                : e)
            .toList();

        state = state.copyWith(
            momentFollow: tempDataFollow, momentSuggest: tempDataSuggest);
      }
    }
  }

  getListMomentSuggest(params) async {
    List response = await MomentApi().getListMomentSuggest(params) ?? [];
    if (mounted) {
      final newMoment = response
          .where((item) => !state.momentSuggest.contains(item))
          .toList();
      state = state.copyWith(
          momentFollow: state.momentFollow,
          momentSuggest: params.containsKey('max_id')
              ? [...state.momentSuggest, ...newMoment]
              : newMoment);
    }
  }

  updateMomentDetail(type, newMoment) {
    int index = -1;

    if (type == 'follow') {
      index = state.momentFollow
          .indexWhere((element) => element['id'] == newMoment['id']);
    } else if (type == 'suggest') {
      index = state.momentSuggest
          .indexWhere((element) => element['id'] == newMoment['id']);
    }

    if (mounted && index >= 0) {
      state = state.copyWith(
          momentFollow: type == 'follow'
              ? state.momentFollow.sublist(0, index) +
                  [newMoment] +
                  state.momentFollow.sublist(index + 1)
              : state.momentFollow,
          momentSuggest: type == 'forget'
              ? state.momentSuggest.sublist(0, index) +
                  [newMoment] +
                  state.momentSuggest.sublist(index + 1)
              : state.momentSuggest);
    }
  }
}
