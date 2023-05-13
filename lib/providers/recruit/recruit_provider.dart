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
  final List recruitsInterest;
  final List recruitsPast;
  final List recruitsNew;
  final List recruitsNewPast;

  const RecruitState({
    this.recruits = const [],
    this.isMore = true,
    this.recruitsCV = const [],
    this.recruitsSimilar = const [],
    this.recruitsPropose = const [],
    this.detailRecruit = const {},
    this.recruitsInvite = const [],
    this.recruitsChipMenu = const [],
    this.recruitsNew = const [],
    this.recruitsPast = const [],
    this.recruitsInterest = const [],
    this.recruitsNewPast = const [],
  });

  RecruitState copyWith({
    List recruits = const [],
    List recruitsSimilar = const [],
    List recruitsCV = const [],
    List recruitsPropose = const [],
    bool isMore = true,
    dynamic detailRecruit = const {},
    List recruitsInvite = const [],
    List recruitsChipMenu = const [],
    List recruitsNew = const [],
    List recruitsPast = const [],
    List recruitsInterest = const [],
    List recruitsNewPast = const [],
  }) {
    return RecruitState(
      recruits: recruits,
      isMore: isMore,
      recruitsCV: recruitsCV,
      detailRecruit: detailRecruit,
      recruitsSimilar: recruitsSimilar,
      recruitsPropose: recruitsPropose,
      recruitsInvite: recruitsInvite,
      recruitsChipMenu: recruitsChipMenu,
      recruitsNew: recruitsNew,
      recruitsPast: recruitsPast,
      recruitsInterest: recruitsInterest,
      recruitsNewPast: recruitsNewPast,
    );
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
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
        recruitsChipMenu: state.recruitsChipMenu,
        isMore: false,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    }
  }

  getListRecruitInterest(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows = response
          .where((item) => !state.recruitsInterest.contains(item))
          .toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: params.containsKey('max_id')
            ? [...state.recruitsInterest, ...newGrows]
            : newGrows,
        recruitsNewPast: state.recruitsNewPast,
      );
    } else {
      final newGrows = response
          .where((item) => !state.recruitsInterest.contains(item))
          .toList();
      state = state.copyWith(
        recruits: state.recruits,
        detailRecruit: state.detailRecruit,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        recruitsCV: state.recruitsCV,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsInvite: state.recruitsInvite,
        isMore: false,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: params.containsKey('max_id')
            ? [...state.recruitsInterest, ...newGrows]
            : newGrows,
        recruitsNewPast: state.recruitsNewPast,
      );
    }
  }

  getListRecruitPast(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.recruitsPast.contains(item)).toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: params.containsKey('max_id')
            ? [...state.recruitsPast, ...newGrows]
            : newGrows,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    } else {
      final newGrows =
          response.where((item) => !state.recruitsPast.contains(item)).toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: params.containsKey('max_id')
            ? [...state.recruitsPast, ...newGrows]
            : newGrows,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    }
  }

  getListRecruitNewPast(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.recruitsPast.contains(item)).toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        recruitsChipMenu: state.recruitsChipMenu,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: params.containsKey('max_id')
            ? [...state.recruitsNewPast, ...newGrows]
            : newGrows,
      );
    } else {
      final newGrows = response
          .where((item) => !state.recruitsNewPast.contains(item))
          .toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: params.containsKey('max_id')
            ? [...state.recruitsNewPast, ...newGrows]
            : newGrows,
      );
    }
  }

  getListRecruitNew(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.recruitsNew.contains(item)).toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: params.containsKey('max_id')
            ? [...state.recruitsNew, ...newGrows]
            : newGrows,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    } else {
      final newGrows =
          response.where((item) => !state.recruitsNew.contains(item)).toList();
      state = state.copyWith(
        recruits: state.recruits,
        isMore: false,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsNew: params.containsKey('max_id')
            ? [...state.recruitsNew, ...newGrows]
            : newGrows,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
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
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
        isMore: false,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    }
  }

  getListRecruitPropose(params) async {
    List response = await RecruitApi().getListRecruitApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        recruitsPropose: response,
        recruitsSimilar: state.recruitsSimilar,
        recruits: state.recruits,
        recruitsChipMenu: state.recruitsChipMenu,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
        recruitsChipMenu: state.recruitsChipMenu,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
        recruitsChipMenu: state.recruitsChipMenu,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        detailRecruit: state.detailRecruit,
        recruitsCV: state.recruitsCV,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
        recruitsChipMenu: state.recruitsChipMenu,
        isMore: state.isMore,
        detailRecruit: state.detailRecruit,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
      );
    }
  }

  getDetailRecruit(id) async {
    var response = await RecruitApi().getDetailRecruitApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        detailRecruit: response,
        recruits: state.recruits,
        recruitsChipMenu: state.recruitsChipMenu,
        recruitsCV: state.recruitsCV,
        isMore: state.isMore,
        recruitsSimilar: state.recruitsSimilar,
        recruitsPropose: state.recruitsPropose,
        recruitsInvite: state.recruitsInvite,
        recruitsNew: state.recruitsNew,
        recruitsPast: state.recruitsPast,
        recruitsInterest: state.recruitsInterest,
        recruitsNewPast: state.recruitsNewPast,
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
          isMore: response.length < params['limit'] ? false : true,
          recruitsChipMenu: state.recruitsChipMenu,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
        );
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
          recruitsChipMenu: state.recruitsChipMenu,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
        );
      }
    }
  }

  updateStatusRecruit(params, id, {String name = 'recruits'}) async {
    params == true
        ? await RecruitApi().recruitUpdateStatusApi(id)
        : await RecruitApi().recruitDeleteStatusApi(id);
    List recruitsList;
    switch (name) {
      case 'recruitsNew':
        recruitsList = state.recruitsNew;
        break;
      case 'recruitsInterest':
        recruitsList = state.recruitsInterest;
        break;
      case 'recruitsInvite':
        recruitsList = state.recruitsInvite;
        break;
      case 'recruitsNewPast':
        recruitsList = state.recruitsNewPast;
        break;
      case 'recruitsPast':
        recruitsList = state.recruitsPast;
        break;
      case 'detailRecruit':
        recruitsList = state.recruitsPast;
        break;
      default:
        recruitsList = state.recruits;
        break;
    }

    final indexRecruitUpdate = name != 'detailRecruit'
        ? recruitsList.indexWhere((element) => element['id'] == id.toString())
        : null;

    final eventUpdate = name != 'detailRecruit'
        ? {
            ...recruitsList[indexRecruitUpdate!],
            'recruit_relationships': {
              ...recruitsList[indexRecruitUpdate]['recruit_relationships'],
              'follow_recruit': params
            }
          }
        : null;

    switch (name) {
      case 'recruitsNew':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: [...state.recruitsNew]..[indexRecruitUpdate!] =
              eventUpdate,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      case 'detailRecruit':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: {
            ...state.detailRecruit,
            "recruit_relationships": {
              ...state.detailRecruit["recruit_relationships"],
              "follow_recruit": params
            }
          },
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      case 'recruitsInterest':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: [...state.recruitsInterest]..[indexRecruitUpdate!] =
              eventUpdate,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      case 'recruitsInvite':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: [...state.recruitsInvite]..[indexRecruitUpdate!] =
              eventUpdate,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      case 'recruitsNewPast':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: [...state.recruitsNewPast]..[indexRecruitUpdate!] =
              eventUpdate,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      case 'recruitsPast':
        state = state.copyWith(
          recruits: state.recruits,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: [...state.recruitsPast]..[indexRecruitUpdate!] =
              eventUpdate,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
      default:
        state = state.copyWith(
          recruits: [...state.recruits]..[indexRecruitUpdate!] = eventUpdate,
          detailRecruit: state.detailRecruit,
          recruitsCV: state.recruitsCV,
          recruitsSimilar: state.recruitsSimilar,
          recruitsPropose: state.recruitsPropose,
          recruitsInvite: state.recruitsInvite,
          isMore: state.isMore,
          recruitsNew: state.recruitsNew,
          recruitsPast: state.recruitsPast,
          recruitsInterest: state.recruitsInterest,
          recruitsNewPast: state.recruitsNewPast,
          recruitsChipMenu: state.recruitsChipMenu,
        );
        break;
    }
  }
}
