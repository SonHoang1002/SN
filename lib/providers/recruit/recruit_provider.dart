import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/recruit_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class RecruitState {
  final List recruits;
  final bool isMore;
  final dynamic detailRecruit;

  const RecruitState(
      {this.recruits = const [],
      this.isMore = true,
      this.detailRecruit = const {}});

  RecruitState copyWith({
    List recruits = const [],
    bool isMore = true,
    dynamic detailRecruit = const {},
  }) {
    return RecruitState(
        recruits: recruits, isMore: isMore, detailRecruit: detailRecruit);
  }
}

final recruitControllerProvider =
    StateNotifierProvider.autoDispose<RecruitController, RecruitState>((ref) {
  ref.read(meControllerProvider);
  return RecruitController();
});

class RecruitController extends StateNotifier<RecruitState> {
  RecruitController() : super(const RecruitState());

  getListRecruit(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.recruits.contains(item)).toList();
      state = state.copyWith(
        recruits: params.containsKey('max_id')
            ? [...state.recruits, ...newGrows]
            : newGrows,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
      );
    } else {
      final newGrows =
          response.where((item) => !state.recruits.contains(item)).toList();
      state = state.copyWith(
          recruits: params.containsKey('max_id')
              ? [...state.recruits, ...newGrows]
              : newGrows,
          isMore: false);
    }
  }
  getDetailRecruit(id) async {
    var response = await RecruitApi().getDetailRecruitApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          detailRecruit: response,
          recruits: state.recruits,
          isMore: state.isMore,
      );
    }
  }
}
