import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/grow_api.dart';

@immutable
class GrowState {
  final List grows;
  final List growsOwner;
  final List hosts;
  final List growsSuggest;
  final dynamic detailGrow;
  final dynamic growTransactions;
  final dynamic updateGrowTransactions;
  final bool isMore;


  const GrowState({
    this.grows = const [],
    this.growsOwner = const [],
    this.hosts = const [],
    this.growsSuggest = const [],
    this.detailGrow = const {},
    this.growTransactions = const {},
    this.updateGrowTransactions = const {},
    this.isMore = true,
  });

  GrowState copyWith({
    List grows = const [],
    List growsOwner = const [],
    List hosts = const [],
    List growsSuggest = const [],
    dynamic detailGrow = const {},
    dynamic growTransactions = const {},
    dynamic updateGrowTransactions = const {},
    bool isMore = true,

  }) {
    return GrowState(
        grows: grows,
        growsOwner: growsOwner,
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
    StateNotifierProvider<GrowController, GrowState>((ref) => GrowController());

class GrowController extends StateNotifier<GrowState> {
  GrowController() : super(const GrowState());

  getListGrow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      final newGrows = response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
          grows: params.containsKey('max_id') ? [...state.grows, ...newGrows] : newGrows,
          hosts: state.hosts,
          growsOwner: state.growsOwner,
          detailGrow: state.detailGrow,
          growTransactions: state.growTransactions,
          isMore: response.length < params['limit'] ? false : true,
          growsSuggest: state.growsSuggest);
    } else {
      final newGrows = response.where((item) => !state.grows.contains(item)).toList();
      state = state.copyWith(
          hosts: state.hosts,
          grows: params.containsKey('max_id') ? [...state.grows, ...newGrows] : newGrows,
          growsOwner: state.growsOwner,
          detailGrow: state.detailGrow,
          growTransactions: state.growTransactions,
          isMore: false,
          growsSuggest: state.growsSuggest);
    }
  }
  getListOwnerGrow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          growsOwner: [...response],
          grows: state.grows,
          hosts: state.hosts,
          detailGrow: state.detailGrow,
          growTransactions: state.growTransactions,
          isMore: state.isMore,
          growsSuggest: state.growsSuggest);
    }
  }

  getListGrowSuggest(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          growsSuggest: [...response],
          growsOwner: state.growsOwner,
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
          growsOwner: state.growsOwner,
          hosts: state.hosts,
          isMore: state.isMore,
          growTransactions: state.growTransactions,
          growsSuggest: state.growsSuggest);
    }
  }

  updateStatusGrow(id, data) async {
    if (data) {
      var res = await GrowApi().statusGrowApi(id);
    } else {
      var res = await GrowApi().deleteStatusGrowApi(id);
    }
    var indexEventUpdate =
        state.grows.indexWhere((element) => element['id'] == id.toString());
    var eventUpdate = state.grows[indexEventUpdate];
    eventUpdate['project_relationship']['follow_project'] = data;
    state = state.copyWith(
        grows: state.grows.sublist(0, indexEventUpdate) +
            [eventUpdate] +
            state.grows.sublist(indexEventUpdate + 1),
        hosts: state.hosts,
        detailGrow: state.detailGrow,
        growsOwner: state.growsOwner,
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        growsSuggest: state.growsSuggest);
  }
  updateStatusHost(id, data) async {
    if (data) {
      var res = await GrowApi().statusGrowApi(id);
    } else {
      var res = await GrowApi().deleteStatusGrowApi(id);
    }
    var indexEventUpdate =
    state.growsSuggest.indexWhere((element) => element['id'] == id.toString());
    var eventUpdate = state.growsSuggest[indexEventUpdate];
    eventUpdate['project_relationship']['follow_project'] = data;
    state = state.copyWith(
        growsSuggest: state.growsSuggest.sublist(0, indexEventUpdate) +
            [eventUpdate] +
            state.growsSuggest.sublist(indexEventUpdate + 1),
        grows: state.grows,
        detailGrow: state.detailGrow,
        growsOwner: state.growsOwner,
        isMore: state.isMore,
        growTransactions: state.growTransactions,
        hosts: state.hosts);
  }
  getGrowHosts(id) async {
    List response = await GrowApi().getGrowHostApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          hosts: [...response],
          grows: state.grows,
          detailGrow: state.detailGrow,
          growsOwner: state.growsOwner,
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
          growsOwner: state.growsOwner,
          grows: state.grows,
          detailGrow: state.detailGrow,
          isMore: state.isMore,
          growsSuggest: state.growsSuggest);
    }
  }
  updateTransactionDonate(data, id) async {
    var response = await GrowApi().transactionDonateApi(id, data);
    if (response.isNotEmpty) {
      state = state.copyWith(
          updateGrowTransactions: response,
          growTransactions: state.growTransactions,
          hosts: state.hosts,
          grows: state.grows,
          growsOwner: state.growsOwner,
          detailGrow: state.detailGrow,
          isMore: state.isMore,
          growsSuggest: state.growsSuggest);
    }
  }
}
