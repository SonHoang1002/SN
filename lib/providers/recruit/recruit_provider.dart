import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/recruit_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class RecruitState {
  final List recruits;
  final List recruitsPropose;
  final List recruitsSimilar;
  final bool isMore;
  final dynamic detailRecruit;

  const RecruitState(
      {this.recruits = const [],
      this.isMore = true,
      this.recruitsSimilar = const [],
      this.recruitsPropose = const [],
      this.detailRecruit = const {}});

  RecruitState copyWith({
    List recruits = const [],
    List recruitsSimilar = const [],
    List recruitsPropose = const [],
    bool isMore = true,
    dynamic detailRecruit = const {},
  }) {
    return RecruitState(
        recruits: recruits,
        isMore: isMore,
        detailRecruit: detailRecruit,
        recruitsSimilar: recruitsSimilar,
        recruitsPropose: recruitsPropose);
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
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
      );
    } else {
      final newGrows =
          response.where((item) => !state.recruits.contains(item)).toList();
      state = state.copyWith(
          recruits: params.containsKey('max_id')
              ? [...state.recruits, ...newGrows]
              : newGrows,
          detailRecruit: state.detailRecruit,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          isMore: false);
    }
  }

  getListRecruitPropose(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        recruitsPropose: response,
        recruitsSimilar: state.recruitsSimilar,
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
      );
    }
  }

  getListRecruitSimilar(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        recruitsSimilar: response,
        recruitsPropose: state.recruitsPropose,
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
      );
    }
  }

  getDetailRecruit(id) async {
    var response = await RecruitApi().getDetailRecruitApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        detailRecruit: response,
        recruits: state.recruits,
        isMore: state.isMore,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
      );
    }
  }

  refreshListRecruit(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        state = state.copyWith(
            recruits: response,
            detailRecruit: state.detailRecruit,
            recruitsSimilar: state.recruitsSimilar,
            recruitsPropose: state.recruitsPropose,
            isMore: response.length < params['limit'] ? false : true);
      }
    } else {
      if (mounted) {
        state = state.copyWith(
          isMore: false,
          recruits: response,
          detailRecruit: state.detailRecruit,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
        );
      }
    }
  }

  updateStatusRecruit(params, id) async {
    params == true
        ? await RecruitApi().recruitUpdateStatusApi(id)
        : await RecruitApi().recruitDeleteStatusApi(id);
    final indexRecruitUpdate =
        state.recruits.indexWhere((element) => element['id'] == id.toString());
    final eventUpdate = {
      ...state.recruits[indexRecruitUpdate],
      'recruit_relationships': {
        ...state.recruits[indexRecruitUpdate]['recruit_relationships'],
        'follow_recruit': params
      }
    };
    state = state.copyWith(
        recruits: [...state.recruits]..[indexRecruitUpdate] = eventUpdate,
        detailRecruit: state.detailRecruit,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        isMore: state.isMore);
  }
}
