import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/grow_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class GrowState {
  final List grows;
  final List hosts;
  final List posts;
  final List growsSuggest;
  final dynamic detailGrow;
  final dynamic growTransactions;
  final dynamic updateGrowTransactions;
  final bool isMore;

  const GrowState({
    this.grows = const [],
    this.posts = const [],
    this.hosts = const [],
    this.growsSuggest = const [],
    this.detailGrow = const {},
    this.growTransactions = const {},
    this.updateGrowTransactions = const {},
    this.isMore = true,
  });

  GrowState copyWith({
    List grows = const [],
    List posts = const [],
    List hosts = const [],
    List growsSuggest = const [],
    dynamic detailGrow = const {},
    dynamic growTransactions = const {},
    dynamic updateGrowTransactions = const {},
    bool isMore = true,
  }) {
    return GrowState(
      grows: grows,
      posts: posts,
      hosts: hosts,
      growsSuggest: growsSuggest,
      detailGrow: detailGrow,
      updateGrowTransactions: updateGrowTransactions,
      growTransactions: growTransactions,
      isMore: isMore,
    );
  }
}

final growControllerProvider =
    StateNotifierProvider.autoDispose<GrowController, GrowState>((ref) {
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
          growTransactions: state.growTransactions,
          isMore: params['limit'] != null
              ? response.length < params['limit']
                  ? false
                  : true
              : false,
          growsSuggest: state.growsSuggest);
    } else {
      final newGrows =
          response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
          hosts: state.hosts,
          grows: params.containsKey('max_id')
              ? [...state.grows, ...newGrows]
              : newGrows,
          posts: state.posts,
          detailGrow: state.detailGrow,
          growTransactions: state.growTransactions,
          isMore: false,
          growsSuggest: state.growsSuggest);
    }
  }

  getListGrowSuggest(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          growsSuggest: [...response],
          posts: state.posts,
          grows: state.grows,
          hosts: state.hosts,
          growTransactions: state.growTransactions,
          isMore: state.isMore,
          detailGrow: state.detailGrow);
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
          isMore: state.isMore,
          growTransactions: state.growTransactions,
          growsSuggest: state.growsSuggest);
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
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        growsSuggest: state.growsSuggest);
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
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        hosts: state.hosts);
  }

  getGrowHosts(id) async {
    List response = await GrowApi().getGrowHostApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          hosts: [...response],
          posts: state.posts,
          grows: state.grows,
          detailGrow: state.detailGrow,
          isMore: state.isMore,
          growTransactions: state.growTransactions,
          growsSuggest: state.growsSuggest);
    }
  }

  getGrowTransactions(params) async {
    var response = await GrowApi().getGrowTransactionsApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          growTransactions: response,
          hosts: state.hosts,
          posts: state.posts,
          grows: state.grows,
          detailGrow: state.detailGrow,
          isMore: state.isMore,
          growsSuggest: state.growsSuggest);
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
          detailGrow: state.detailGrow,
          isMore: state.isMore,
          growsSuggest: state.growsSuggest);
    }
  }

  updateTransactionDonate(data, id) async {
    var response = await GrowApi().transactionDonateApi(id, data);
    if (response != null) {
      // Success
      state = state.copyWith(
        updateGrowTransactions: response,
        growTransactions: state.growTransactions,
        hosts: state.hosts,
        grows: state.grows,
        posts: state.posts,
        detailGrow: state.detailGrow,
        isMore: state.isMore,
        growsSuggest: state.growsSuggest,
      );
    }
  }
}
