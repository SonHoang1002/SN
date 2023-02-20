import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';

@immutable
class GroupListState {
  final List groupAdmin;
  final List groupMember;
  final bool isMoreGroupAdmin;
  final bool isMoreGroupMember;

  const GroupListState(
      {this.groupAdmin = const [],
      this.groupMember = const [],
      this.isMoreGroupAdmin = true,
      this.isMoreGroupMember = true});

  GroupListState copyWith(
      {List groupAdmin = const [],
      List groupMember = const [],
      bool isMoreGroupAdmin = true,
      bool isMoreGroupMember = true}) {
    return GroupListState(
      groupAdmin: groupAdmin,
      groupMember: groupMember,
      isMoreGroupAdmin: isMoreGroupAdmin,
      isMoreGroupMember: isMoreGroupMember,
    );
  }
}

final groupListControllerProvider =
    StateNotifierProvider<GroupListController, GroupListState>(
        (ref) => GroupListController());

class GroupListController extends StateNotifier<GroupListState> {
  GroupListController() : super(const GroupListState());

  getListGroupAdminMember(params) async {
    String tab = params['tab'];
    int limit = params['limit'];

    dynamic response = await GroupApi().fetchListGroupAdminMember(params);
    if (response != null) {
      state = state.copyWith(
          groupAdmin:
              tab == 'admin' ? state.groupAdmin + response : state.groupAdmin,
          groupMember: tab == 'member'
              ? state.groupMember + response
              : state.groupMember,
          isMoreGroupAdmin: tab == 'admin' && response.length < limit
              ? false
              : state.isMoreGroupAdmin,
          isMoreGroupMember: tab == 'member' && response.length < limit
              ? false
              : state.isMoreGroupMember);
    }
  }
}
