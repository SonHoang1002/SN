import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/moment_api.dart';
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

  getListMomentSuggest(params) async {
    List response = await MomentApi().getListMomentSuggest(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          momentFollow: state.momentFollow,
          momentSuggest: state.momentSuggest + response);
    }
  }
}
