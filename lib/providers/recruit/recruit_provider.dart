import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/recruit_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class RecruitState {
  final List recruits;
  final List recruitsCV;
  final List recruitsPropose;
  final List recruitsSimilar;
  final List recruitsInvite;
  final bool isMore;
  final dynamic detailRecruit;
  final List recruitsChipMenu;

  const RecruitState({
    this.recruits = const [],
    this.isMore = true,
    this.recruitsCV = const [],
    this.recruitsSimilar = const [],
    this.recruitsPropose = const [],
    this.detailRecruit = const {},
    this.recruitsInvite = const [],
    this.recruitsChipMenu = const [],
  });

  RecruitState copyWith(
      {List recruits = const [],
      List recruitsSimilar = const [],
      List recruitsCV = const [],
      List recruitsPropose = const [],
      bool isMore = true,
      dynamic detailRecruit = const {},
      List recruitsInvite = const [],
      List recruitsChipMenu = const []}) {
    return RecruitState(
        recruits: recruits,
        isMore: isMore,
        recruitsCV: recruitsCV,
        detailRecruit: detailRecruit,
        recruitsSimilar: recruitsSimilar,
        recruitsPropose: recruitsPropose,
        recruitsInvite: recruitsInvite,
        recruitsChipMenu: recruitsChipMenu);
  }
}

final recruitControllerProvider =
    StateNotifierProvider.autoDispose<RecruitController, RecruitState>((ref) {
  ref.read(meControllerProvider);
  return RecruitController(ref.watch(meControllerProvider));
});

class RecruitController extends StateNotifier<RecruitState> {
  final List meData;
  RecruitController(this.meData) : super(const RecruitState());
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
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
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
          recruitsCV: state.recruitsCV,
          recruitsInvite: state.recruitsInvite,
          isMore: false);
    }
  }

  getListRecruitChipMenu(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows = response
          .where((item) => !state.recruitsChipMenu.contains(item))
          .toList();
      state = state.copyWith(
        recruits: state.recruits,
        recruitsChipMenu: params.containsKey('max_id')
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
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
      );
    } else {
      final newGrows = response
          .where((item) => !state.recruitsChipMenu.contains(item))
          .toList();
      state = state.copyWith(
          recruits: state.recruits,
          recruitsChipMenu: params.containsKey('max_id')
              ? [...state.recruits, ...newGrows]
              : newGrows,
          detailRecruit: state.detailRecruit,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsCV: state.recruitsCV,
          recruitsInvite: state.recruitsInvite,
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
        recruitsCV: state.recruitsCV,
      );
    }
  }

  getListRecruitInvite(params) async {
    var response = await RecruitApi().getListRecruitInviteApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        recruitsInvite: response['data'],
        recruitsPropose: state.recruitsPropose,
        recruitsSimilar: state.recruitsSimilar,
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
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
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
      );
    }
  }

  getListRecruitCV() async {
    List response = await RecruitApi().getListRecruitCVApi(meData[0]['id']);
    if (response.isNotEmpty) {
      state = state.copyWith(
        recruitsCV: response,
        recruitsSimilar: response,
        recruitsPropose: state.recruitsPropose,
        recruits: state.recruits,
        isMore: state.isMore,
        detailRecruit: state.detailRecruit,
        recruitsInvite: state.recruitsInvite,
      );
    }
  }

  getDetailRecruit(id) async {
    var response = await RecruitApi().getDetailRecruitApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        detailRecruit: response,
        recruits: state.recruits,
        recruitsCV: state.recruitsCV,
        isMore: state.isMore,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        recruitsInvite: state.recruitsInvite,
      );
    }
  }

  refreshListRecruit(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        state = state.copyWith(
            recruits: response,
            recruitsCV: state.recruitsCV,
            detailRecruit: state.detailRecruit,
            recruitsSimilar: state.recruitsSimilar,
            recruitsPropose: state.recruitsPropose,
            recruitsInvite: state.recruitsInvite,
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
          recruitsInvite: state.recruitsInvite,
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
        recruitsCV: state.recruitsCV,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        recruitsInvite: state.recruitsInvite,
        isMore: state.isMore);
  }
}
