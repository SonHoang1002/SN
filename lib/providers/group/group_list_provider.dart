import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';

@immutable
class GroupListState {
  final List groupAdmin;
  final List groupMember;
  final bool isMoreGroupAdmin;
  final bool isMoreGroupMember;
  final List memberQuestionList;

  const GroupListState(
      {this.groupAdmin = const [],
      this.groupMember = const [],
      this.isMoreGroupAdmin = true,
      this.isMoreGroupMember = true,
      this.memberQuestionList = const []});

  GroupListState copyWith(
      {List groupAdmin = const [],
      List groupMember = const [],
      bool isMoreGroupAdmin = true,
      bool isMoreGroupMember = true,
      List memberQuestionList = const []}) {
    return GroupListState(
        groupAdmin: groupAdmin,
        groupMember: groupMember,
        isMoreGroupAdmin: isMoreGroupAdmin,
        isMoreGroupMember: isMoreGroupMember,
        memberQuestionList: memberQuestionList);
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
              : state.isMoreGroupMember,
          memberQuestionList: state.memberQuestionList);
    }
  }

  getMemberQuestion(dynamic groupId) async {
    final response = await GroupApi().getMemberQuestion(groupId);
    if (response != null) {
      state = state.copyWith(
          groupAdmin: state.groupAdmin,
          groupMember: state.groupMember,
          isMoreGroupAdmin: state.isMoreGroupAdmin,
          isMoreGroupMember: state.isMoreGroupMember,
          memberQuestionList: response);
    }
  }

  removeGroupAdmin(dynamic group) async {
    if (mounted) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin
            .where((admin) => admin['id'] != group['id'])
            .toList(),
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
      );
    }
  }

  removeGroupMember(dynamic groupMemberId) async {
    state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember
            .where((element) => element['id'] != groupMemberId)
            .toList(),
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList);
  }
}
