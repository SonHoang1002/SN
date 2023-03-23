import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/grow_api.dart';

@immutable
class GrowState {
  final List grows;
  final List hosts;
  final List growsSuggest;
  final dynamic detailGrow;
  final dynamic growTransactions;
  final dynamic updateGrowTransactions;

  const GrowState({
    this.grows = const [],
    this.hosts = const [],
    this.growsSuggest = const [],
    this.detailGrow = const {},
    this.growTransactions = const {},
    this.updateGrowTransactions = const {}
  });

  GrowState copyWith({
    List grows = const [],
    List hosts = const [],
    List growsSuggest = const [],
    dynamic detailGrow = const {},
    dynamic growTransactions = const {},
    dynamic updateGrowTransactions = const {},

  }) {
    return GrowState(
        grows: grows,
        hosts: hosts,
        growsSuggest: growsSuggest,
        detailGrow: detailGrow,
        updateGrowTransactions: updateGrowTransactions,
        growTransactions: growTransactions);
  }
}

final growControllerProvider =
    StateNotifierProvider<GrowController, GrowState>((ref) => GrowController());

class GrowController extends StateNotifier<GrowState> {
  GrowController() : super(const GrowState());

  getListGrow(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          grows: [...response],
          hosts: state.hosts,
          detailGrow: state.detailGrow,
          growTransactions: state.growTransactions,
          growsSuggest: state.growsSuggest);
    }
  }

  getListGrowSuggest(params) async {
    List response = await GrowApi().getListGrowApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          growsSuggest: [...response],
          grows: state.grows,
          hosts: state.hosts,
          growTransactions: state.growTransactions,
          detailGrow: state.detailGrow);
    }
  }

  getDetailGrow(id) async {
    var response = await GrowApi().getDetailGrowApi(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
          grows: state.grows,
          detailGrow: response,
          hosts: state.hosts,
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
          grows: state.grows,
          detailGrow: state.detailGrow,
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
          detailGrow: state.detailGrow,
          growsSuggest: state.growsSuggest);
    }
  }
}
