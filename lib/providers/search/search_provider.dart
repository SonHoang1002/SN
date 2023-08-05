import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';

@immutable
class SearchState {
  final List searchHistory;
  final dynamic search;
  final dynamic searchDetail;
  final bool isLoading;

  const SearchState({
    this.searchHistory = const [],
    this.search = const {},
    this.searchDetail = const {},
    this.isLoading = true,
  });

  SearchState copyWith({
    List searchHistory = const [],
    dynamic search = const {},
    dynamic searchDetail = const {},
    bool isLoading = true,
  }) {
    return SearchState(
      searchHistory: searchHistory,
      search: search,
      searchDetail: searchDetail,
      isLoading: isLoading,
    );
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>(
        (ref) => SearchController());

class SearchController extends StateNotifier<SearchState> {
  SearchController() : super(const SearchState());

  getSearchHistory(params) async {
    List response = await SearchApi().getListSearchHistoriesApi(params);
    if (response.isNotEmpty && mounted) {
      state = state.copyWith(
        searchHistory: response,
        search: state.search,
        searchDetail: state.searchDetail,
        isLoading: true,
      );
    }
  }

  void changeLoadingBackIcon() {
    state = state.copyWith(
      searchHistory: state.searchHistory,
      search: state.search,
      searchDetail: state.searchDetail,
      isLoading: true,
    );
  }

  getSearchDetail(params) async {
    var response = await SearchApi().getListSearchApi(params);
    if (response != null && mounted) {
      state = state.copyWith(
        searchHistory: state.searchHistory,
        search: state.search,
        searchDetail: response['accounts'].isNotEmpty ||
                response['groups'].isNotEmpty ||
                response['pages'].isNotEmpty ||
                response['statuses'].isNotEmpty
            ? response
            : {},
        isLoading: false,
      );
    }
  }

  getSearch(params) async {
    var response = await SearchApi().getListSearchApi(params);
    if (response != null && mounted) {
      state = state.copyWith(
        searchHistory: state.searchHistory,
        search: response,
        searchDetail: state.searchDetail,
      );
    }
  }

  deleteSearchHistory(id) async {
    var response = await SearchApi().deleteSearchHistoriesApi(id);
    if (response.isNotEmpty && mounted) {
      state = state.copyWith(
        searchHistory:
            state.searchHistory.where((item) => item['id'] != id).toList(),
        search: state.search,
        searchDetail: state.searchDetail,
      );
    }
  }
}
