import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/grow_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class GrowState {
  final List grows;
  final List hosts;
  final List posts;
  final List growsUpcoming;
  final List growsPast;
  final List growsSuggest;
  final dynamic detailGrow;
  final dynamic growTransactions;
  final dynamic updateGrowTransactions;
  final bool isMore;
  final List growsDonated;
  final List growsHostNow;
  final List growsDonatedOver;
  final List growsInvite;
  final List growsInviteHost;
  final List growsOwner;

  const GrowState({
    this.grows = const [],
    this.posts = const [],
    this.hosts = const [],
    this.growsUpcoming = const [],
    this.growsPast = const [],
    this.growsSuggest = const [],
    this.detailGrow = const {},
    this.growTransactions = const {},
    this.updateGrowTransactions = const {},
    this.isMore = true,
    this.growsDonated = const [],
    this.growsHostNow = const [],
    this.growsDonatedOver = const [],
    this.growsInvite = const [],
    this.growsInviteHost = const [],
    this.growsOwner = const [],
  });

  GrowState copyWith({
    List grows = const [],
    List posts = const [],
    List hosts = const [],
    List growsUpcoming = const [],
    List growsPast = const [],
    List growsSuggest = const [],
    dynamic detailGrow = const {},
    dynamic growTransactions = const {},
    dynamic updateGrowTransactions = const {},
    bool isMore = true,
    List growsDonated = const [],
    List growsHostNow = const [],
    List growsDonatedOver = const [],
    List growsInvite = const [],
    List growsInviteHost = const [],
    List growsOwner = const [],
  }) {
    return GrowState(
      grows: grows,
      posts: posts,
      hosts: hosts,
      growsUpcoming: growsUpcoming,
      growsPast: growsPast,
      growsSuggest: growsSuggest,
      detailGrow: detailGrow,
      updateGrowTransactions: updateGrowTransactions,
      growTransactions: growTransactions,
      isMore: isMore,
      growsDonated: growsDonated,
      growsHostNow: growsHostNow,
      growsDonatedOver: growsDonatedOver,
      growsInvite: growsInvite,
      growsInviteHost: growsInviteHost,
      growsOwner: growsOwner,
    );
  }
}

final growControllerProvider =
    StateNotifierProvider<GrowController, GrowState>((ref) {
  ref.read(meControllerProvider);
  return GrowController();
});

class GrowController extends StateNotifier<GrowState> {
  GrowController() : super(const GrowState());

  getListGrow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
        grows: params.containsKey('max_id')
            ? [...state.grows, ...newGrows]
            : newGrows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      final newGrows =
          response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
        hosts: state.hosts,
        grows: params.containsKey('max_id')
            ? [...state.grows, ...newGrows]
            : newGrows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowsOwner(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.growsOwner.contains(item)).toList();
      state = state.copyWith(
        grows: state.grows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: params.containsKey('max_id')
            ? [...state.growsOwner, ...newGrows]
            : newGrows,
      );
    } else {
      final newGrows =
          response.where((item) => !state.growsOwner.contains(item)).toList();
      state = state.copyWith(
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: params.containsKey('max_id')
            ? [...state.growsOwner, ...newGrows]
            : newGrows,
      );
    }
  }

  getListGrowsInvite(params) async {
    var response = await GrowApi().getListGrowInviteApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        grows: state.grows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: [...response['data']],
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      state = state.copyWith(
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: [],
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowsInviteHost(params) async {
    var response = await GrowApi().getListGrowInviteHostApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        grows: state.grows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: [...response['data']],
        growsOwner: state.growsOwner,
      );
    } else {
      state = state.copyWith(
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: [...response['data']],
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowsDonatedOver(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows = response
          .where((item) => !state.growsDonatedOver.contains(item))
          .toList();
      state = state.copyWith(
        grows: state.grows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: params.containsKey('max_id')
            ? [...state.grows, ...newGrows]
            : newGrows,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      final newGrows = response
          .where((item) => !state.growsDonatedOver.contains(item))
          .toList();
      state = state.copyWith(
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: params.containsKey('max_id')
            ? [...state.grows, ...newGrows]
            : newGrows,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowHostNow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.growsHostNow.contains(item)).toList();
      state = state.copyWith(
        grows: state.grows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: params.containsKey('max_id')
            ? [...state.growsHostNow, ...newGrows]
            : newGrows,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      final newGrows =
          response.where((item) => !state.growsHostNow.contains(item)).toList();
      state = state.copyWith(
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: params.containsKey('max_id')
            ? [...state.growsHostNow, ...newGrows]
            : newGrows,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowDonated(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows =
          response.where((item) => !state.growsDonated.contains(item)).toList();
      state = state.copyWith(
        growsDonated: params.containsKey('max_id')
            ? [...state.growsDonated, ...newGrows]
            : newGrows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        grows: state.grows,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      final newGrows =
          response.where((item) => !state.growsDonated.contains(item)).toList();
      state = state.copyWith(
        hosts: state.hosts,
        growsDonated: params.containsKey('max_id')
            ? [...state.growsDonated, ...newGrows]
            : newGrows,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        grows: state.grows,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowUpcoming(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows = response
          .where((item) => !state.growsUpcoming.contains(item))
          .toList();
      state = state.copyWith(
        growsUpcoming: params.containsKey('max_id')
            ? [...state.growsUpcoming, ...newGrows]
            : newGrows,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        grows: state.grows,
        growsPast: state.growsPast,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      final newGrows =
          response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
        hosts: state.hosts,
        growsUpcoming: params.containsKey('max_id')
            ? [...state.growsUpcoming, ...newGrows]
            : newGrows,
        posts: state.posts,
        grows: state.grows,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowPast(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        growsPast: response,
        hosts: state.hosts,
        posts: state.posts,
        detailGrow: state.detailGrow,
        grows: state.grows,
        growsUpcoming: state.growsUpcoming,
        growTransactions: state.growTransactions,
        isMore: params['limit'] != null
            ? response.length < params['limit']
                ? false
                : true
            : false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    } else {
      state = state.copyWith(
        growsPast: response,
        posts: state.posts,
        grows: state.grows,
        growsUpcoming: state.growsUpcoming,
        detailGrow: state.detailGrow,
        growTransactions: state.growTransactions,
        isMore: false,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getListGrowSuggest(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        growsSuggest: [...response],
        posts: state.posts,
        grows: state.grows,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        hosts: state.hosts,
        growTransactions: state.growTransactions,
        isMore: state.isMore,
        detailGrow: state.detailGrow,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getDetailGrow(id) async {
    var response = await GrowApi().getDetailGrowApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        grows: state.grows,
        detailGrow: response,
        posts: state.posts,
        hosts: state.hosts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  void updateStatusGrow(id, data) {
    final growApi = GrowApi();
    data ? growApi.statusGrowApi(id) : growApi.deleteStatusGrowApi(id);
    final indexEventUpdate =
        state.grows.indexWhere((element) => element['id'] == id.toString());
    final eventUpdate = {
      ...state.grows[indexEventUpdate],
      'project_relationship': {
        ...state.grows[indexEventUpdate]['project_relationship'],
        'follow_project': data
      }
    };

    state = state.copyWith(
      grows: [...state.grows]..[indexEventUpdate] = eventUpdate,
      hosts: state.hosts,
      detailGrow: state.detailGrow,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      isMore: state.isMore,
      growTransactions: state.growTransactions,
      growsSuggest: state.growsSuggest,
      growsDonated: state.growsDonated,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsInvite: state.growsInvite,
      growsInviteHost: state.growsInviteHost,
      growsOwner: state.growsOwner,
    );
  }

  void updateStatusGrowDetail(id, data) {
    final growApi = GrowApi();
    data ? growApi.statusGrowApi(id) : growApi.deleteStatusGrowApi(id);

    final eventUpdate = {
      ...state.detailGrow,
      'project_relationship': {
        ...state.detailGrow['project_relationship'],
        'follow_project': data
      }
    };
    state = state.copyWith(
      grows: state.grows,
      hosts: state.hosts,
      detailGrow: eventUpdate,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      isMore: state.isMore,
      growTransactions: state.growTransactions,
      growsSuggest: state.growsSuggest,
      growsDonated: state.growsDonated,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsInvite: state.growsInvite,
      growsInviteHost: state.growsInviteHost,
      growsOwner: state.growsOwner,
    );
  }

  void updateStatusGrowDonated(id, data) {
    final growApi = GrowApi();
    data ? growApi.statusGrowApi(id) : growApi.deleteStatusGrowApi(id);
    final indexEventUpdate = state.growsDonated
        .indexWhere((element) => element['id'] == id.toString());
    final eventUpdate = {
      ...state.growsDonated[indexEventUpdate],
      'project_relationship': {
        ...state.growsDonated[indexEventUpdate]['project_relationship'],
        'follow_project': data
      }
    };

    state = state.copyWith(
      growsDonated: [...state.growsDonated]..[indexEventUpdate] = eventUpdate,
      hosts: state.hosts,
      detailGrow: state.detailGrow,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      isMore: state.isMore,
      growTransactions: state.growTransactions,
      growsSuggest: state.growsSuggest,
      grows: state.grows,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsInvite: state.growsInvite,
      growsInviteHost: state.growsInviteHost,
      growsOwner: state.growsOwner,
    );
  }

  void updateStatusGrowInvite(id, data) {
    final growApi = GrowApi();
    data ? growApi.statusGrowApi(id) : growApi.deleteStatusGrowApi(id);
    final indexEventUpdate = state.growsInvite
        .indexWhere((element) => element['project']['id'] == id.toString());

    var growInviteUpdate = {
      ...state.growsInvite[indexEventUpdate],
      'project': {
        ...state.growsInvite[indexEventUpdate]['project'],
        'project_relationship': {
          ...(state.growsInvite[indexEventUpdate]['project']
                  ['project_relationship'] ??
              {}),
          'follow_project': data,
        },
      },
    };
    state = state.copyWith(
      growsInvite: [...state.growsInvite]..[indexEventUpdate] =
          growInviteUpdate,
      hosts: state.hosts,
      detailGrow: state.detailGrow,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      isMore: state.isMore,
      growTransactions: state.growTransactions,
      growsSuggest: state.growsSuggest,
      grows: state.grows,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsDonated: state.growsDonated,
      growsInviteHost: state.growsInviteHost,
      growsOwner: state.growsOwner,
    );
  }

  updateStatusHost(id, data) async {
    if (data) {
      await GrowApi().statusGrowApi(id);
    } else {
      await GrowApi().deleteStatusGrowApi(id);
    }
    var indexEventUpdate = state.growsSuggest
        .indexWhere((element) => element['id'] == id.toString());
    var eventUpdate = state.growsSuggest[indexEventUpdate];
    eventUpdate['project_relationship']['follow_project'] = data;
    state = state.copyWith(
      growsSuggest: state.growsSuggest.sublist(0, indexEventUpdate) +
          [eventUpdate] +
          state.growsSuggest.sublist(indexEventUpdate + 1),
      grows: state.grows,
      detailGrow: state.detailGrow,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      isMore: state.isMore,
      growTransactions: state.growTransactions,
      hosts: state.hosts,
      growsDonated: state.growsDonated,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsInvite: state.growsInvite,
      growsInviteHost: state.growsInviteHost,
      growsOwner: state.growsOwner,
    );
  }

  getGrowHosts(id) async {
    List response = await GrowApi().getGrowHostApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        hosts: [...response],
        posts: state.posts,
        grows: state.grows,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  void updateStatusInviteHost(id, data) {
    GrowApi().statusInviteHost(id, data);
    final index = state.growsInviteHost
        .indexWhere((element) => element['project']['id'] == id.toString());
    final eventsInviteHost = state.growsInviteHost[index];
    final updatedEvent = {
      ...eventsInviteHost,
      'status': data['status'] ?? '',
    };
    state = state.copyWith(
      growTransactions: state.growTransactions,
      hosts: state.hosts,
      posts: state.posts,
      growsUpcoming: state.growsUpcoming,
      growsPast: state.growsPast,
      grows: state.grows,
      detailGrow: state.detailGrow,
      isMore: state.isMore,
      growsSuggest: state.growsSuggest,
      growsDonated: state.growsDonated,
      growsHostNow: state.growsHostNow,
      growsDonatedOver: state.growsDonatedOver,
      growsInvite: state.growsInvite,
      growsInviteHost: [...state.growsInviteHost]..[index] = updatedEvent,
      growsOwner: state.growsOwner,
    );
  }

  getGrowTransactions(params) async {
    var response = await GrowApi().getGrowTransactionsApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        growTransactions: response,
        hosts: state.hosts,
        posts: state.posts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        grows: state.grows,
        detailGrow: state.detailGrow,
        isMore: state.isMore,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  getGrowPost(id, params) async {
    var response = await GrowApi().getGrowPostApi(id, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        posts: [...response],
        growTransactions: response,
        hosts: state.hosts,
        grows: state.grows,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        detailGrow: state.detailGrow,
        isMore: state.isMore,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }

  updateTransactionDonate(data, id) async {
    var response = await GrowApi().transactionDonateApi(id, data);
    if (response != null) {
      state = state.copyWith(
        updateGrowTransactions: response,
        growTransactions: state.growTransactions,
        hosts: state.hosts,
        growsUpcoming: state.growsUpcoming,
        growsPast: state.growsPast,
        grows: state.grows,
        posts: state.posts,
        detailGrow: state.detailGrow,
        isMore: state.isMore,
        growsSuggest: state.growsSuggest,
        growsDonated: state.growsDonated,
        growsHostNow: state.growsHostNow,
        growsDonatedOver: state.growsDonatedOver,
        growsInvite: state.growsInvite,
        growsInviteHost: state.growsInviteHost,
        growsOwner: state.growsOwner,
      );
    }
  }
}
