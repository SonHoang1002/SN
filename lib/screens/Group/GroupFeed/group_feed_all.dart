import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import '../../../constant/post_type.dart';
import '../../../widgets/skeleton.dart';

class GroupFeedAll extends ConsumerStatefulWidget {
  const GroupFeedAll({super.key});

  @override
  ConsumerState<GroupFeedAll> createState() => _GroupFeedAllState();
}

class _GroupFeedAllState extends ConsumerState<GroupFeedAll> {
  var paramsGroupFeed = {
    "exclude_replies": true,
    "limit": 3,
  };
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(groupListControllerProvider).groupFeed.last['id'];
        ref
            .read(groupListControllerProvider.notifier)
            .getListGroupFeed({"max_id": maxId, ...paramsGroupFeed});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupFeed = ref.watch(groupListControllerProvider).groupFeed;
    final groupMember = ref.watch(groupListControllerProvider).groupMember;
    return Expanded(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: groupMember.length,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) {
                              return GroupDetail(
                                id: groupMember[index]['id'],
                              );
                            },
                          ));
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: ExtendedImage.network(
                                      groupMember[index]['banner'] != null
                                          ? groupMember[index]['banner']
                                              ['preview_url']
                                          : linkBannerDefault,
                                      width: 70.0,
                                      height: 70.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 2,
                                      left: 2,
                                      child: SizedBox(
                                          width: 64,
                                          child: Text(
                                            groupMember[index]['title'],
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ))),
          const CrossBar(),
          groupFeed.isEmpty
              ? Center(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return Center(
                        child: SkeletonCustom().postSkeleton(context),
                      );
                    })
                )
              : SizedBox(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: groupFeed.length,
                      itemBuilder: ((context, index) => Post(
                            post: groupFeed[index],
                            type: postGroup,
                          ))),
                )
        ],
      ),
    ));
  }
}
