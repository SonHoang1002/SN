import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';

class PageLiked extends ConsumerStatefulWidget {
  const PageLiked({super.key});

  @override
  ConsumerState<PageLiked> createState() => _PageLikedState();
}

class _PageLikedState extends ConsumerState<PageLiked> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (ref.read(pageListControllerProvider).pageLiked.isNotEmpty &&
            ref.read(pageListControllerProvider).isMorePageLiked) {
          ref.read(pageListControllerProvider.notifier).getListPageLiked({
            'page':
                ref.read(pageListControllerProvider).pageLiked.length ~/ 10 + 1,
            'sort_direction': 'asc'
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List pagesLike = ref.watch(pageListControllerProvider).pageLiked;
    bool isMorePageLike = ref.watch(pageListControllerProvider).isMorePageLiked;

    final size = MediaQuery.of(context).size;

    handlePress(page) {
      List actionsPage = [
        {
          "icon": FontAwesomeIcons.solidThumbsUp,
          "label":
              page['page_relationship']['like'] == true ? "Bỏ thích" : 'Thích',
        },
        {
          "icon": FontAwesomeIcons.calendar,
          "label": page['page_relationship']['following'] == true
              ? "Bỏ theo dõi"
              : 'Theo dõi',
        },
        {
          "icon": FontAwesomeIcons.message,
          "label": "Nhắn tin",
        },
        {
          "icon": FontAwesomeIcons.userPlus,
          "label": "Mời bạn bè",
        },
        {
          "icon": FontAwesomeIcons.solidThumbsUp,
          "label": "Chia sẻ",
        },
        {
          "icon": FontAwesomeIcons.solidThumbsUp,
          "label": "Chặn Trang",
        }
      ];

      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          builder: (context) => SizedBox(
                height: 430,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(8.0),
                      child: PageItem(page: page),
                    ),
                    Container(
                      height: 1,
                      width: size.width,
                      color: greyColor,
                    ),
                    Column(
                      children: List.generate(
                          actionsPage.length,
                          (index) => InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).canvasColor),
                                        child:
                                            actionsPage[index]['image'] != null
                                                ? SvgPicture.asset(
                                                    actionsPage[index]['image'],
                                                    width: 26,
                                                    color: greyColor,
                                                  )
                                                : Icon(
                                                    actionsPage[index]['icon'],
                                                    color: greyColor,
                                                    size: 20,
                                                  ),
                                      ),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        actionsPage[index]['label'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                    )
                  ],
                ),
              ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Tất cả các Trang bạn đã thích hoặc theo dõi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pagesLike.length,
                itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(top: 12.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: greyColor.withOpacity(0.15)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PageItem(
                                  page: pagesLike[index]['page'],
                                  sizeAvatar: 50,
                                  sizeTitle: 16,
                                  maxLinesTitle: 3,
                                  sizeDesription: 14),
                              InkWell(
                                  onTap: () {
                                    handlePress(pagesLike[index]['page']);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      FontAwesomeIcons.ellipsisVertical,
                                      size: 16,
                                    ),
                                  ))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 58),
                            child: ButtonPrimary(
                              isPrimary: false,
                              label: "Gửi tin nhắn",
                              handlePress: () {},
                            ),
                          ),
                        ],
                      ),
                    )),
            if (isMorePageLike)
              Center(
                child: SkeletonCustom().postSkeleton(context),
              )
          ],
        ),
      ),
    );
  }
}
