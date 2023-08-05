import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../widgets/GeneralWidget/divider_widget.dart';

class GroupApproval extends ConsumerStatefulWidget {
  final dynamic groupID;

  const GroupApproval({Key? key, required this.groupID}) : super(key: key);
  @override
  ConsumerState<GroupApproval> createState() => _GroupApproval();
}

class _GroupApproval extends ConsumerState<GroupApproval> {
  List? listWaitingApproval;
  var groupDetail = {};
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () async {
        await ref
            .read(groupListControllerProvider.notifier)
            .getGroupDetail(widget.groupID)
            .then(
          (value) {
            setState(
              () {
                groupDetail = ref.read(groupListControllerProvider).groupDetail;
              },
            );
          },
        );
        ref
            .read(groupListControllerProvider.notifier)
            .getGroupRole({'role': 'admin'}, widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getGroupRole({'role': 'moderator'}, widget.groupID);
        ref.read(groupListControllerProvider.notifier).getGroupRole(
            {'role': 'member', 'include_friend': true}, widget.groupID);
        ref.read(groupListControllerProvider.notifier).getGroupRole(
            {'role': 'member', 'exclude_friend': true}, widget.groupID);
        ref.read(groupListControllerProvider.notifier).getMediaImage(
            {'media_type': 'image', 'limit': '10'}, widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getAlbum({'limit': '10'}, widget.groupID);
        ref.read(groupListControllerProvider.notifier).getPostGroup(
            {"sort_by": "new_post", "exclude_replies": true, "limit": 3},
            widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getGroupPins(widget.groupID);

        ref
            .read(groupListControllerProvider.notifier)
            .getJoinRequest(widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getPendingStatus(widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getReportedStatus(widget.groupID);
        ref
            .read(groupListControllerProvider.notifier)
            .getStatusAlert(widget.groupID);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    listWaitingApproval ??=
        ref.watch(groupListControllerProvider).waitingApproval;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Center(
            child: Text(
              "Bài viết đang chờ",
              style: TextStyle(color: colorWord(context)),
            ),
          ),
        ),
        body: listWaitingApproval != null
            ? Column(
                children: [
                  buildDivider(
                    color: colorWord(context),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height - 98,
                    child: listWaitingApproval!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: listWaitingApproval!.length,
                            itemBuilder: (context, index) =>
                                // Kiểm tra điều kiện nếu type bằng "group_pending_status"
                                Post(
                                  waitingForApproval: true,
                                  post: listWaitingApproval![index],
                                  groupId: widget.groupID,
                                  data: listWaitingApproval,
                                  approvalFunction: () {
                                    if (listWaitingApproval!.length >= 0) {
                                      ref
                                          .read(groupListControllerProvider
                                              .notifier)
                                          .removeApproval(
                                              listWaitingApproval![index]
                                                  ["id"]);
                                      removeItem(index);
                                    }
                                  },
                                ))
                        : Container(
                            alignment: Alignment.center,
                            child:
                                Text("Hiện không có bài viết nào chờ phê duyệt",
                                    style: TextStyle(
                                      color: colorWord(context),
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                  )
                ],
              )
            : buildCircularProgressIndicator());
  }

  void removeItem(int index) {
    setState(() {
      listWaitingApproval!.removeAt(index);
    });
  }
}
