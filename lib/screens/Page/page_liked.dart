import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widgets/page_item.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

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

  handleLikeFollow(String type, String id) async {
    var response = await PageApi().handleLikeFollowPage(id, type);
    if (response != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      ref.read(pageListControllerProvider.notifier).updateListPageLiked(
          id,
          type == 'likes' || type == 'unlikes' ? type : null,
          type == 'follows' || type == 'unfollows' ? type : null);
    }
  }

  handleInvite(page) async {
    showBarModalBottomSheet(
        context: context,
        builder: (context) => InviteFriend(
              id: page['id'],
              type: 'page',
            ));
  }

  handleShare(page) async {
    showBarModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ScreenShare(
            pageShared: page, type: 'share_page', entityType: 'share_page'));
  }

  handleBlock(id) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: buildTextContent("Xác nhận chặn Trang này", false,
                fontSize: 18, isCenterLeft: false),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildTextContent("Bạn có chắc chắn muốn chặn Trang này.", false,
                    fontSize: 14, isCenterLeft: false),
                buildTextContent(
                    "Trang sẽ không thể tương tác, thích hoặc phản hồi với bài viết của bạn",
                    false,
                    fontSize: 14,
                    isCenterLeft: false),
                buildTextContent(
                    "Bạn sẽ không thể nhắn tin hoặc đăng lên dòng thời gian của Trang",
                    false,
                    fontSize: 14,
                    isCenterLeft: false),
                buildTextContent("Bỏ thích và theo dõi Trang", false,
                    fontSize: 14, isCenterLeft: false)
              ],
            ),
            actions: [
              ButtonPrimary(
                isGrey: true,
                label: 'Chặn',
                handlePress: () async {
                  var response =
                      await PageApi().handleBlockPage({'page_id': id});
                  if (response != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    ref
                        .read(pageListControllerProvider.notifier)
                        .updateListPageLiked(id, null, null);
                  }
                },
              ),
              ButtonPrimary(
                isGrey: true,
                label: 'Hủy',
                handlePress: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
              )
            ],
          );
        });
  }

  void handleAction(type, pageCurrent) {
    switch (type) {
      case 'like':
        handleLikeFollow(
            pageCurrent['page_relationship']['like'] == true
                ? 'unlikes'
                : 'likes',
            pageCurrent['id']);
        break;
      case 'follow':
        handleLikeFollow(
            pageCurrent['page_relationship']['follow'] == true
                ? 'unfollows'
                : 'follows',
            pageCurrent['id']);
        break;
      case 'invite':
        handleInvite(pageCurrent);
        break;
      case 'share':
        handleShare(pageCurrent);
        break;
      case 'block':
        handleBlock(pageCurrent['id']);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List pagesLike = ref.watch(pageListControllerProvider).pageLiked;
    bool isMorePageLike = ref.watch(pageListControllerProvider).isMorePageLiked;

    handlePress(page) {
      List actionsPage = [
        {
          "key": 'like',
          "icon": FontAwesomeIcons.solidThumbsUp,
          "label":
              page['page_relationship']['like'] == true ? "Bỏ thích" : 'Thích',
        },
        {
          "key": 'follow',
          "icon": FontAwesomeIcons.calendar,
          "label": page['page_relationship']['following'] == true
              ? "Bỏ theo dõi"
              : 'Theo dõi',
        },
        {
          "key": 'invite',
          "icon": FontAwesomeIcons.userPlus,
          "label": "Mời bạn bè",
        },
        {
          "key": 'share',
          "icon": FontAwesomeIcons.solidThumbsUp,
          "label": "Chia sẻ",
        },
        {
          "key": 'block',
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
                height: 390,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      padding: const EdgeInsets.all(8.0),
                      child: PageItem(page: page),
                    ),
                    Divider(
                      thickness: 1.1,
                      color: greyColor.shade200,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Column(
                      children: List.generate(
                          actionsPage.length,
                          (index) => InkWell(
                                onTap: () {
                                  handleAction(actionsPage[index]['key'], page);
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
      child: RefreshIndicator(
        color: secondaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () async {
              await ref
                  .read(pageListControllerProvider.notifier)
                  .deleteListPageLike();
              await ref
                  .read(pageListControllerProvider.notifier)
                  .getListPageLiked({'page': 1, 'sort_direction': 'asc'});
            },
          );
        },
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
      ),
    );
  }
}
