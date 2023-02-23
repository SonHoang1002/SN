import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

@immutable
class PageListState {
  final List pageAdmin;
  final bool isMorePageAdmin;

  final List pageLiked;
  final bool isMorePageLiked;

  const PageListState(
      {this.pageAdmin = const [],
      this.pageLiked = const [],
      this.isMorePageAdmin = true,
      this.isMorePageLiked = true});

  PageListState copyWith(
      {List pageAdmin = const [],
      List pageLiked = const [],
      bool isMorePageAdmin = true,
      bool isMorePageLiked = true}) {
    return PageListState(
      pageAdmin: pageAdmin,
      pageLiked: pageLiked,
      isMorePageAdmin: isMorePageAdmin,
      isMorePageLiked: isMorePageLiked,
    );
  }
}

final pageListControllerProvider =
    StateNotifierProvider<PageListController, PageListState>(
        (ref) => PageListController());

class PageListController extends StateNotifier<PageListState> {
  PageListController() : super(const PageListState());

  getListPageAdmin(params) async {
    var response = await PageApi().fetchListPageAdmin(params);

    if (response != null) {
      state = state.copyWith(
        pageAdmin: state.pageAdmin + response,
        pageLiked: state.pageLiked,
        isMorePageAdmin:
            response.length < params['limit'] ? false : state.isMorePageAdmin,
        isMorePageLiked: state.isMorePageLiked,
      );
    }
  }
}
