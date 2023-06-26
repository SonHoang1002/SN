import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

import '../../../constant/common.dart';
import '../../../providers/group/group_list_provider.dart';

class GroupPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  const GroupPage(this.pageData, {Key? key}) : super(key: key);

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    Map<String, dynamic> paramsGroupPage = {"limit": 10};
    if (ref.read(pageControllerProvider).pageGroup.isEmpty) {
      ref.read(pageControllerProvider.notifier).getListPageGroup({
        ...paramsGroupPage,
      }, widget.pageData['id']);
      ref.read(groupListControllerProvider.notifier).getListGroupAdminMember(
          {'tab': 'admin', 'limit': 20, 'page_id': widget.pageData['id']});
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(groupListControllerProvider).groupAdmin.last['id'];
        ref.read(groupListControllerProvider.notifier).getListGroupAdminMember({
          'tab': 'admin',
          'limit': 20,
          'page_id': widget.pageData['id'],
          'max_id': maxId
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List groupPage = ref.watch(pageControllerProvider).pageGroup;
    List groupAdmin = ref.watch(groupListControllerProvider).groupAdmin;
    bool isMoreAdmin = ref.watch(groupListControllerProvider).isMoreGroupAdmin;
    bool isMoreGroup = ref.watch(pageControllerProvider).isMoreGroup;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nhóm của Trang này',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  showBarModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setStateful) {
                            return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: groupAdmin.length + 1,
                                itemBuilder: (context, indexGroupAdmin) {
                                  if (indexGroupAdmin < groupAdmin.length) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8),
                                      margin: const EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              AvatarSocial(
                                                width: 65,
                                                height: 65,
                                                isGroup: true,
                                                object:
                                                    groupAdmin[indexGroupAdmin],
                                                path:
                                                    groupAdmin[indexGroupAdmin]
                                                                ['banner'] !=
                                                            null
                                                        ? groupAdmin[
                                                                indexGroupAdmin]
                                                            ['banner']['url']
                                                        : linkBannerDefault,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8),
                                                width: size.width * 0.5,
                                                child: Text(
                                                  groupAdmin[indexGroupAdmin]
                                                      ['title'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .color),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ButtonPrimary(
                                            label: 'Liên kết',
                                            colorText: Colors.black,
                                            handlePress: () async {
                                              await ref
                                                  .read(pageControllerProvider
                                                      .notifier)
                                                  .updateLinkedGroup(
                                                      groupAdmin[
                                                          indexGroupAdmin],
                                                      widget.pageData['id'],
                                                      {
                                                    'group_id': groupAdmin[
                                                        indexGroupAdmin]['id']
                                                  });
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              await ref
                                                  .read(
                                                      groupListControllerProvider
                                                          .notifier)
                                                  .removeGroupAdmin(groupAdmin[
                                                      indexGroupAdmin]);
                                            },
                                            isGrey: true,
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: isMoreAdmin
                                          ? const CupertinoActivityIndicator()
                                          : const SizedBox(),
                                    );
                                  }
                                });
                          }));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Thêm nhóm liên kết',
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: groupPage.length + 1,
            itemBuilder: (context, index) {
              if (index < groupPage.length) {
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AvatarSocial(
                            width: 65,
                            height: 65,
                            isGroup: true,
                            object: groupPage[index],
                            path: groupPage[index]['banner'] != null
                                ? groupPage[index]['banner']['url']
                                : linkBannerDefault,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            width: size.width * 0.5,
                            child: Text(
                              groupPage[index]['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                        ],
                      ),
                      ButtonPrimary(
                        label: 'Hủy liên kết',
                        colorText: Colors.black,
                        handlePress: () async {
                          await ref
                              .read(pageControllerProvider.notifier)
                              .removeLinkedGroup(widget.pageData['id'],
                                  {'group_id': groupPage[index]['id']});
                        },
                        isGrey: true,
                      )
                    ],
                  ),
                );
              } else {
                return isMoreGroup == true
                    ? Center(
                        child: SkeletonCustom().postSkeleton(context),
                      )
                    : const SizedBox();
              }
            }),
        isMoreGroup
            ? Center(
                child: SkeletonCustom().postSkeleton(context),
              )
            : const Center(child: TextDescription(description: ""))
      ],
    );
  }
}
