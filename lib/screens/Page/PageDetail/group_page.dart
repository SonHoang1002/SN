import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class GroupPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  const GroupPage(this.pageData, {Key? key}) : super(key: key);

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage> {
  @override
  void initState() {
    if (!mounted) return;
    Map<String, dynamic> paramsGroupPage = {"limit": 10};
    if (ref.read(pageControllerProvider).pageGroup.isEmpty) {
      ref.read(pageControllerProvider.notifier).getListPageGroup({
        ...paramsGroupPage,
      }, widget.pageData['id']);
    }
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
                onTap: () {},
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AvatarSocial(
                          width: 65,
                          height: 65,
                          isGroup: true,
                          object: groupPage[index],
                          path: groupPage[index]['banner'] != null
                              ? groupPage[index]['banner']['url']
                              : groupPage[index]['cover_image_url']),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width - 100,
                            margin: const EdgeInsets.only(left: 8),
                            child: Text(
                              groupPage[index]['title'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: ButtonPrimary(
                              label: 'Hủy liên kết',
                              isGrey: true,
                            ),
                          )
                        ],
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
