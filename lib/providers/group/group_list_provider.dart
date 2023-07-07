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
  final List groupFeed;
  final List yourGroup;
  final List groupDiscover;
  final List groupInvitedRequest;
  final dynamic groupDetail;
  final List contentReported;
  final List waitingApproval;
  final List requestMember;
  final List notiApproval;
  final List groupPost;
  final List groupPins;
  final List groupRoleMember;
  final List groupRoleFriend;
  final List groupRoleAdmin;
  final List groupRoleMorderator;
  final List groupImage;
  final List groupAlbum;
  final List groupDetailAlbum;

  const GroupListState({
    this.groupAdmin = const [],
    this.groupMember = const [],
    this.isMoreGroupAdmin = true,
    this.isMoreGroupMember = true,
    this.memberQuestionList = const [],
    this.groupFeed = const [],
    this.yourGroup = const [],
    this.groupDiscover = const [],
    this.groupInvitedRequest = const [],
    this.groupDetail = const {},
    this.contentReported = const [],
    this.waitingApproval = const [],
    this.requestMember = const [],
    this.notiApproval = const [],
    this.groupPost = const [],
    this.groupPins = const [],
    this.groupRoleMember = const [],
    this.groupRoleFriend = const [],
    this.groupRoleAdmin = const [],
    this.groupRoleMorderator = const [],
    this.groupImage = const [],
    this.groupAlbum = const [],
    this.groupDetailAlbum = const [],
  });

  GroupListState copyWith({
    List groupAdmin = const [],
    List groupMember = const [],
    bool isMoreGroupAdmin = true,
    bool isMoreGroupMember = true,
    List memberQuestionList = const [],
    List groupFeed = const [],
    List yourGroup = const [],
    List groupDiscover = const [],
    List groupInvitedRequest = const [],
    dynamic groupDetail = const {},
    List contentReported = const [],
    List waitingApproval = const [],
    List requestMember = const [],
    List notiApproval = const [],
    List groupPost = const [],
    List groupPins = const [],
    List groupRoleMember = const [],
    List groupRoleFriend = const [],
    List groupRoleAdmin = const [],
    List groupRoleMorderator = const [],
    List groupImage = const [],
    List groupAlbum = const [],
    List groupDetailAlbum = const [],
  }) {
    return GroupListState(
      groupAdmin: groupAdmin,
      groupMember: groupMember,
      isMoreGroupAdmin: isMoreGroupAdmin,
      isMoreGroupMember: isMoreGroupMember,
      memberQuestionList: memberQuestionList,
      groupFeed: groupFeed,
      yourGroup: yourGroup,
      groupDiscover: groupDiscover,
      groupInvitedRequest: groupInvitedRequest,
      groupDetail: groupDetail,
      contentReported: contentReported,
      waitingApproval: waitingApproval,
      requestMember: requestMember,
      notiApproval: notiApproval,
      groupPost: groupPost,
      groupPins: groupPins,
      groupRoleMember: groupRoleMember,
      groupRoleFriend: groupRoleFriend,
      groupRoleAdmin: groupRoleAdmin,
      groupRoleMorderator: groupRoleMorderator,
      groupImage: groupImage,
      groupAlbum: groupAlbum,
      groupDetailAlbum: groupDetailAlbum,
    );
  }
}

final groupListControllerProvider =
    StateNotifierProvider<GroupListController, GroupListState>(
        (ref) => GroupListController());

class GroupListController extends StateNotifier<GroupListState> {
  GroupListController() : super(const GroupListState());
  getListGroupFeed(params) async {
    List response = await GroupApi().fetchListGroupFeed(params);
    final newGroup = response
        .where((item) =>
            !state.groupFeed.map((el) => el['id']).contains(item['id']))
        .toList();
    state = state.copyWith(
      groupAdmin: state.groupAdmin,
      groupMember: state.groupMember,
      isMoreGroupAdmin: state.isMoreGroupAdmin,
      isMoreGroupMember: state.isMoreGroupMember,
      memberQuestionList: state.memberQuestionList,
      groupFeed: params.containsKey('max_id')
          ? [...state.groupFeed, ...newGroup]
          : newGroup,
      yourGroup: state.yourGroup,
      groupDiscover: state.groupDiscover,
      groupInvitedRequest: state.groupInvitedRequest,
      groupDetail: state.groupDetail,
      contentReported: state.contentReported,
      waitingApproval: state.waitingApproval,
      requestMember: state.requestMember,
      notiApproval: state.notiApproval,
      groupPost: state.groupPost,
      groupPins: state.groupPins,
      groupRoleMember: state.groupRoleMember,
      groupRoleFriend: state.groupRoleFriend,
      groupRoleAdmin: state.groupRoleAdmin,
      groupRoleMorderator: state.groupRoleMorderator,
      groupImage: state.groupImage,
      groupAlbum: state.groupAlbum,
      groupDetailAlbum: state.groupDetailAlbum,
    );
  }

  getListGroupAdminMember(params) async {
    String tab = params['tab'];
    int limit = params['limit'];

    dynamic response = await GroupApi().fetchListGroupAdminMember(params);
    if (response != null) {
      state = state.copyWith(
        groupAdmin:
            tab == 'admin' ? state.groupAdmin + response : state.groupAdmin,
        groupMember:
            tab == 'member' ? state.groupMember + response : state.groupMember,
        isMoreGroupAdmin: tab == 'admin' && response.length < limit
            ? false
            : state.isMoreGroupAdmin,
        isMoreGroupMember: tab == 'member' && response.length < limit
            ? false
            : state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
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
        memberQuestionList: response,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
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
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
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
      memberQuestionList: state.memberQuestionList,
      groupFeed: state.groupFeed,
      yourGroup: state.yourGroup,
      groupDiscover: state.groupDiscover,
      groupInvitedRequest: state.groupInvitedRequest,
      groupDetail: state.groupDetail,
      contentReported: state.contentReported,
      waitingApproval: state.waitingApproval,
      requestMember: state.requestMember,
      notiApproval: state.notiApproval,
      groupPost: state.groupPost,
      groupPins: state.groupPins,
      groupRoleMember: state.groupRoleMember,
      groupRoleFriend: state.groupRoleFriend,
      groupRoleAdmin: state.groupRoleAdmin,
      groupRoleMorderator: state.groupRoleMorderator,
      groupImage: state.groupImage,
      groupAlbum: state.groupAlbum,
      groupDetailAlbum: state.groupDetailAlbum,
    );
  }

  groupDiscover(params) async {
    List response = await GroupApi().fetchListGroupAdminMember(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: response,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getGroupDetail(id) async {
    resetGroupDetail();
    var response = await GroupApi().fetchGroupDetail(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: response,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getJoinRequest(id) async {
    List response = await GroupApi().fetchJoinRequest(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: response,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    } else {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: [],
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getPendingStatus(id) async {
    var response = await GroupApi().fetchPendingStatus(id);
    if (response['data'] != null) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: response['data'],
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    } else {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: [],
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getReportedStatus(id) async {
    List response = await GroupApi().fetchReportedStatus(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: response,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    } else {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: [],
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getStatusAlert(id) async {
    List response = await GroupApi().fetchStatusAlert(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: response,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    } else {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: [],
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getPostGroup(params, id) async {
    List response = await GroupApi().fetchGroupFeed(params, id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: params.containsKey('max_id')
            ? state.groupPost + response
            : response,
        groupPins: state.groupPins,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getGroupPins(id) async {
    List response = await GroupApi().fetchListGroupPins(id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: response,
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    } else {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: [],
        groupRoleMember: state.groupRoleMember,
        groupRoleFriend: state.groupRoleFriend,
        groupRoleAdmin: state.groupRoleAdmin,
        groupRoleMorderator: state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  getGroupRole(params, id) async {
    String role = params['role'];

    List response = await GroupApi().fetchGroupRole(params, id);
    if (response.isNotEmpty) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupMember,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: state.groupDetail,
        contentReported: state.contentReported,
        waitingApproval: state.waitingApproval,
        requestMember: state.requestMember,
        notiApproval: state.notiApproval,
        groupPost: state.groupPost,
        groupPins: state.groupPins,
        groupRoleMember:
            params['exclude_friend'] == true ? response : state.groupRoleMember,
        groupRoleFriend:
            params['include_friend'] == true ? response : state.groupRoleFriend,
        groupRoleAdmin: role == 'admin' ? response : state.groupRoleAdmin,
        groupRoleMorderator:
            role == 'moderator' ? response : state.groupRoleMorderator,
        groupImage: state.groupImage,
        groupAlbum: state.groupAlbum,
        groupDetailAlbum: state.groupDetailAlbum,
      );
    }
  }

  resetGroupDetail() {
    if (mounted) {
      state = state.copyWith(
        groupAdmin: state.groupAdmin,
        groupMember: state.groupAdmin,
        isMoreGroupAdmin: state.isMoreGroupAdmin,
        isMoreGroupMember: state.isMoreGroupMember,
        memberQuestionList: state.memberQuestionList,
        groupFeed: state.groupFeed,
        yourGroup: state.yourGroup,
        groupDiscover: state.groupDiscover,
        groupInvitedRequest: state.groupInvitedRequest,
        groupDetail: [],
        contentReported: [],
        waitingApproval: [],
        requestMember: [],
        notiApproval: [],
        groupPost: [],
        groupPins: [],
        groupRoleMember: [],
        groupRoleFriend: [],
        groupRoleAdmin: [],
        groupRoleMorderator: [],
        groupImage: [],
        groupAlbum: [],
        groupDetailAlbum: [],
      );
    }
  }
}
