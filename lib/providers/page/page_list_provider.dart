import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

@immutable
class PageListState {
  final List pageAdmin;
  final bool isMorePageAdmin;

  final List pageLiked;
  final bool isMorePageLiked;

  final List pageInvitedLike;
  final bool isMorePageInvitedLike;

  final List pageInvitedManage;
  final bool isMorePageInvitedManage;

  final List pageSuggestions;
  final bool isMorePageSuggestions;

  const PageListState({
    this.pageAdmin = const [],
    this.pageLiked = const [],
    this.pageInvitedLike = const [],
    this.pageInvitedManage = const [],
    this.pageSuggestions = const [],
    this.isMorePageAdmin = true,
    this.isMorePageLiked = true,
    this.isMorePageInvitedLike = true,
    this.isMorePageInvitedManage = true,
    this.isMorePageSuggestions = true,
  });

  PageListState copyWith({
    List pageAdmin = const [],
    List pageLiked = const [],
    List pageInvitedLike = const [],
    List pageInvitedManage = const [],
    List pageSuggestions = const [],
    bool isMorePageAdmin = true,
    bool isMorePageLiked = true,
    bool isMorePageInvitedLike = true,
    bool isMorePageInvitedManage = true,
    bool isMorePageSuggestions = true,
  }) {
    return PageListState(
      pageAdmin: pageAdmin,
      pageLiked: pageLiked,
      isMorePageAdmin: isMorePageAdmin,
      isMorePageLiked: isMorePageLiked,
      pageInvitedLike: pageInvitedLike,
      isMorePageInvitedLike: isMorePageInvitedLike,
      pageInvitedManage: pageInvitedManage,
      isMorePageInvitedManage: isMorePageInvitedManage,
      pageSuggestions: pageSuggestions,
      isMorePageSuggestions: isMorePageSuggestions,
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
    final newListPage =
        response.where((item) => !state.pageAdmin.contains(item)).toList();
    if (response != null) {
      state = state.copyWith(
        pageAdmin: params.containsKey('max_id')
            ? [...state.pageAdmin, ...newListPage]
            : newListPage,
        pageLiked: state.pageLiked,
        isMorePageAdmin:
            response.length < params['limit'] ? false : state.isMorePageAdmin,
        isMorePageLiked: state.isMorePageLiked,
        pageInvitedLike: state.pageInvitedLike,
        isMorePageInvitedLike: state.isMorePageInvitedLike,
        pageInvitedManage: state.pageInvitedManage,
        isMorePageInvitedManage: state.isMorePageInvitedManage,
        pageSuggestions: state.pageSuggestions,
        isMorePageSuggestions: state.isMorePageSuggestions,
      );
    }
  }

  getListPageLiked(params) async {
    var id = await SecureStorage().getKeyStorage('userId');
    var response = await PageApi().fetchListPageLiked(params, id);

    if (response != null) {
      state = state.copyWith(
        pageLiked: state.pageLiked + response['data'],
        pageAdmin: state.pageAdmin,
        isMorePageLiked:
            response['data'].length < 10 ? false : state.isMorePageLiked,
        isMorePageAdmin: state.isMorePageAdmin,
        pageInvitedLike: state.pageInvitedLike,
        isMorePageInvitedLike: state.isMorePageInvitedLike,
        pageInvitedManage: state.pageInvitedManage,
        isMorePageInvitedManage: state.isMorePageInvitedManage,
        pageSuggestions: state.pageSuggestions,
        isMorePageSuggestions: state.isMorePageSuggestions,
      );
    }
  }

  getListPageSuggest(params) async {
    List response = await PageApi().fetchListPageSuggest(params);
    if (response.isNotEmpty) {
      final newList = response
          .where((item) => !state.pageSuggestions
              .any((suggestion) => suggestion['id'] == item['id']))
          .toList();
      state = state.copyWith(
        pageLiked: state.pageLiked,
        pageAdmin: state.pageAdmin,
        isMorePageLiked: state.isMorePageLiked,
        isMorePageAdmin: state.isMorePageAdmin,
        pageInvitedLike: state.pageInvitedLike,
        isMorePageInvitedLike: state.isMorePageInvitedLike,
        pageInvitedManage: state.pageInvitedManage,
        isMorePageInvitedManage: state.isMorePageInvitedManage,
        pageSuggestions: params.containsKey('max_id')
            ? [...state.pageSuggestions, ...newList]
            : newList,
        isMorePageSuggestions:
            response.length < params['limit'] ? false : state.isMorePageAdmin,
      );
    } else {
      state = state.copyWith(
        pageLiked: state.pageLiked,
        pageAdmin: state.pageAdmin,
        isMorePageLiked: state.isMorePageLiked,
        isMorePageAdmin: state.isMorePageAdmin,
        pageInvitedLike: state.pageInvitedLike,
        isMorePageInvitedLike: state.isMorePageInvitedLike,
        pageInvitedManage: state.pageInvitedManage,
        isMorePageInvitedManage: state.isMorePageInvitedManage,
        pageSuggestions: response,
        isMorePageSuggestions: false,
      );
    }
  }

  getListPageInvited(String type) async {
    if (type == 'like') {
      var response = await PageApi().fetchListPageInvitedLike();

      if (response != null) {
        state = state.copyWith(
          pageLiked: state.pageLiked,
          pageAdmin: state.pageAdmin,
          isMorePageLiked: state.isMorePageLiked,
          isMorePageAdmin: state.isMorePageAdmin,
          pageInvitedLike: state.pageInvitedLike + response['data'],
          isMorePageInvitedLike: state.isMorePageInvitedLike,
          pageInvitedManage: state.pageInvitedManage,
          isMorePageInvitedManage: state.isMorePageInvitedManage,
          pageSuggestions: state.pageSuggestions,
          isMorePageSuggestions: state.isMorePageSuggestions,
        );
      }
    } else if (type == 'manage') {
      var response = await PageApi().fetchListPageInvitedManage();
      if (response != null) {
        state = state.copyWith(
          pageLiked: state.pageLiked,
          pageAdmin: state.pageAdmin,
          isMorePageLiked: state.isMorePageLiked,
          isMorePageAdmin: state.isMorePageAdmin,
          pageInvitedLike: state.pageInvitedLike,
          isMorePageInvitedLike: state.isMorePageInvitedLike,
          pageInvitedManage: state.pageInvitedManage + response['data'],
          isMorePageInvitedManage: state.isMorePageInvitedManage,
          pageSuggestions: state.pageSuggestions,
          isMorePageSuggestions: state.isMorePageSuggestions,
        );
      }
    }
  }

  updateListPageLiked(id, updateLike, updateFollow) {
    state = state.copyWith(
      pageLiked: updateLike != null || updateFollow != null
          ? state.pageLiked.map((e) {
              return e['page']['id'] == id
                  ? {
                      ...e,
                      'page': {
                        ...e['page'],
                        'page_relationship': {
                          ...e['page']['page_relationship'],
                          'like': updateLike == 'likes'
                              ? true
                              : updateLike == 'unlikes'
                                  ? false
                                  : e['page']['page_relationship']['like'],
                          'following': updateFollow == 'follows'
                              ? true
                              : updateFollow == 'unfollows'
                                  ? false
                                  : e['page']['page_relationship']['following']
                        }
                      }
                    }
                  : e;
            }).toList()
          : state.pageLiked
              .where((element) => element['page']['id'] != id)
              .toList(),
      pageAdmin: state.pageAdmin,
      isMorePageLiked: state.isMorePageLiked,
      isMorePageAdmin: state.isMorePageAdmin,
      pageInvitedLike: state.pageInvitedLike,
      isMorePageInvitedLike: state.isMorePageInvitedLike,
      pageInvitedManage: state.pageInvitedManage,
      isMorePageInvitedManage: state.isMorePageInvitedManage,
      pageSuggestions: state.pageSuggestions,
      isMorePageSuggestions: state.isMorePageSuggestions,
    );
  }

  deleteListPageLike() async {
    state = state.copyWith(
      pageLiked: [],
      pageAdmin: state.pageAdmin,
      isMorePageLiked: true,
      isMorePageAdmin: state.isMorePageAdmin,
      pageInvitedLike: state.pageInvitedLike,
      isMorePageInvitedLike: state.isMorePageInvitedLike,
      pageInvitedManage: state.pageInvitedManage,
      isMorePageInvitedManage: state.isMorePageInvitedManage,
      pageSuggestions: state.pageSuggestions,
      isMorePageSuggestions: state.isMorePageSuggestions,
    );
  }

  likePageSuggestion(id, type) async {
    switch (type) {
      case "like":
        final index = state.pageSuggestions
            .indexWhere((element) => element['id'] == id.toString());
        final dataPageSuggest = state.pageSuggestions[index];
        var updatedPageSuggestions = {
          ...dataPageSuggest,
          'page_relationship': {
            ...(dataPageSuggest['page_relationship'] ?? {}),
            'like': type == 'like' ? true : false,
          },
        };
        state = state.copyWith(
          pageLiked: state.pageLiked,
          pageAdmin: state.pageAdmin,
          isMorePageLiked: state.isMorePageLiked,
          isMorePageAdmin: state.isMorePageAdmin,
          pageInvitedLike: state.pageInvitedLike,
          isMorePageInvitedLike: state.isMorePageInvitedLike,
          pageInvitedManage: state.pageInvitedManage,
          isMorePageInvitedManage: state.isMorePageInvitedManage,
          pageSuggestions: [
            ...state.pageSuggestions.sublist(0, index),
            updatedPageSuggestions,
            ...state.pageSuggestions.sublist(index + 1),
          ],
          isMorePageSuggestions: state.isMorePageSuggestions,
        );
        break;
      case "filter":
        state = state.copyWith(
          pageLiked: state.pageLiked,
          pageAdmin: state.pageAdmin,
          isMorePageLiked: state.isMorePageLiked,
          isMorePageAdmin: state.isMorePageAdmin,
          pageInvitedLike: state.pageInvitedLike,
          isMorePageInvitedLike: state.isMorePageInvitedLike,
          pageInvitedManage: state.pageInvitedManage,
          isMorePageInvitedManage: state.isMorePageInvitedManage,
          pageSuggestions: state.pageSuggestions
              .where((element) => element['id'] != id.toString())
              .toList(),
          isMorePageSuggestions: state.isMorePageSuggestions,
        );
        break;
      default:
        break;
    }
    type == "like"
        ? await PageApi().likePageSuggestion(id)
        : await PageApi().unLikePageSuggestion(id);
  }
}
