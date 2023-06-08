import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:helpers/helpers.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_feed_status_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';
import 'package:social_network_app_mobile/widgets/page_item.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

class ScreenShare extends ConsumerStatefulWidget {
  final dynamic entityShare;
  final String type;
  final String entityType;
  final dynamic pageShared;
  const ScreenShare({
    Key? key,
    this.entityShare,
    required this.type,
    required this.entityType,
    this.pageShared,
  }) : super(key: key);

  @override
  ConsumerState<ScreenShare> createState() => _ScreenShareState();
}

class _ScreenShareState extends ConsumerState<ScreenShare> {
  dynamic visibility = typeVisibility[0];
  String content = '';
  dynamic groupShareSelected;
  dynamic pageShareSelected;
  String renderType = 'root';
  List groupsRender = [];
  List pagesRender = [];
  bool isSearch = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (ref.read(pageListControllerProvider).pageAdmin.isEmpty) {
        ref
            .read(pageListControllerProvider.notifier)
            .getListPageAdmin({'limit': 20});
      }

      if (ref.read(groupListControllerProvider).groupMember.isEmpty) {
        ref
            .read(groupListControllerProvider.notifier)
            .getListGroupAdminMember({'tab': 'member', 'limit': 20});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handlePress(key) {
      if (key == "share_group") {
        setState(() {
          renderType = 'groups';
        });
        setState(() {
          groupsRender = ref.read(groupListControllerProvider).groupMember;
        });
      } else if (key == "share_page") {
        setState(() {
          renderType = 'pages';
        });
        setState(() {
          pagesRender = ref.read(pageListControllerProvider).pageAdmin;
        });
      }
    }

    handleUpdateData(key, value) {
      if (key == 'update_visibility') {
        setState(
          () => visibility = value,
        );
      } else if (key == 'update_content') {
        setState(() {
          content = value;
        });
      }
    }

    handleSearch(value) {
      if (value == '') {
        setState(() {
          groupsRender = ref.read(groupListControllerProvider).groupMember;
          pagesRender = ref.read(pageListControllerProvider).pageAdmin;
        });
      }
      setState(() {
        isSearch = true;
      });
      EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
          () async {
        var response = await SearchApi()
            .getListSearchApi({'q': value, 'type': renderType, 'offset': 1});
        if (response != null) {
          List resGroups = response['groups'] ?? [];
          List resPages = response['pages'] ?? [];

          setState(() {
            isSearch = false;
            groupsRender = resGroups.isNotEmpty ? resGroups : groupsRender;
            pagesRender = resPages.isNotEmpty ? resPages : pagesRender;
          });
        }
      });
    }

    handleChooseEntity(entity) {
      if (renderType == 'groups') {
        setState(() {
          groupShareSelected = {...entity, 'entityType': 'group'};
          pageShareSelected = null;
        });
      } else {
        setState(() {
          pageShareSelected = {...entity, 'entityType': 'page'};
          groupShareSelected = null;
        });
      }

      setState(() {
        renderType = 'root';
      });
    }

    List menuShare = [
      {
        "key": "share_now",
        "icon": "assets/icons/chia_se_qua_chat_black.png",
        "label": "Gửi qua EmsoChat"
      },
      {
        "key": "share_group",
        "icon": "assets/icons/chia_se_len_nhom_black.png",
        "label": "Chia sẻ lên một nhóm"
      },
      {
        "key": "share_page",
        "icon": "assets/icons/chia_se_ngay_black.png",
        "label": "Chia sẻ lên trang của bạn"
      },
      {
        "key": "share_user_page_other",
        "icon": "assets/icons/chia_se_len_nhom_black.png",
        "label": "Chia sẻ lên trang cá nhân của bạn bè"
      }
    ];

    handleShare() async {
      context.loaderOverlay.show();
      dynamic data = {
        "visibility": visibility['key'],
        "status": content,
      };

      if (groupShareSelected != null) {
        data['shared_group_id'] = groupShareSelected['id'];
      }

      if (pageShareSelected != null) {
        data['page_id'] = pageShareSelected['id'];
      }

      if (widget.entityType == 'post') {
        data['reblog_of_id'] = widget.entityShare['id'];
        var response = await PostApi().createStatus(data);

        if (response != null) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chia sẻ bài viết thành công")));
          }

          if (groupShareSelected == null && pageShareSelected == null) {
            ref
                .read(postControllerProvider.notifier)
                .createUpdatePost(widget.type, response);
          }
        }
      }
      if (widget.entityType == 'share_page') {
        data['shared_page_id'] = widget.pageShared['id'];
        var response = await PostApi().createStatus(data);
        if (response != null) {
          // if (context.mounted) {
          // ignore: use_build_context_synchronously
          context.loaderOverlay.hide();
          // ignore: use_build_context_synchronously
          Navigator.of(context)
            ..pop()
            ..pop();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chia sẻ Trang thành công")));
          // }
        } else {
          // ignore: use_build_context_synchronously
          context.loaderOverlay.hide();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chia sẻ bài viết thất bại.")));
        }
      }
    }

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: GestureDetector(
          onTap: () {
            hiddenKeyboard(context);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const AppBarTitle(title: "Chia sẻ"),
              actions: [
                if (!['groups', 'pages'].contains(renderType))
                  ButtonPrimary(
                    label: "Chia sẻ",
                    handlePress: handleShare,
                    colorButton: Theme.of(context).scaffoldBackgroundColor,
                    colorText: secondaryColor,
                  )
              ],
            ),
            body: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              child: ['groups', 'pages'].contains(renderType)
                  ? Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  renderType = 'root';
                                });
                              },
                              child: Icon(
                                FontAwesomeIcons.chevronLeft,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                                child: SearchInput(
                              handleSearch: handleSearch,
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        isSearch
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: (renderType == 'groups'
                                            ? groupsRender
                                            : pagesRender)
                                        .length,
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            handleChooseEntity(
                                                (renderType == 'groups'
                                                    ? groupsRender
                                                    : pagesRender)[index]);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Container(
                                            margin: const EdgeInsets.all(6.0),
                                            child: renderType == 'groups'
                                                ? GroupItem(
                                                    group: groupsRender[index],
                                                  )
                                                : PageItem(
                                                    page: pagesRender[index],
                                                    isActiveNewScreen: false,
                                                  ),
                                          ),
                                        )),
                              )
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CreateFeedStatusHeader(
                            entity: groupShareSelected ?? pageShareSelected,
                            visibility: visibility,
                            handleUpdateData: handleUpdateData,
                            friendSelected: const [],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              autofocus: true,
                              onChanged: (value) {
                                handleUpdateData('update_content', value);
                              },
                              textAlign: TextAlign.left,
                              maxLines: 4,
                              minLines: 1,
                              enabled: true,
                              decoration: const InputDecoration(
                                hintText: "Nói gì đó về nội dung này...",
                                hintStyle: TextStyle(fontSize: 15),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          pageShareSelected != null
                              ? SizedBox(
                                  child: PageGroupShared(
                                    page: pageShareSelected,
                                  ),
                                )
                              : groupShareSelected != null
                                  ? SizedBox(
                                      child: PageGroupShared(
                                        page: groupShareSelected,
                                      ),
                                    )
                                  : const SizedBox(),
                          const CrossBar(
                            height: 0.5,
                          ),
                          ListView.builder(
                              itemCount: menuShare.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      handlePress(menuShare[index]['key']);
                                    },
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            // decoration: BoxDecoration(
                                            //     shape: BoxShape.circle,
                                            //     color: secondaryColorSelected),
                                            child: Image.asset(
                                              menuShare[index]['icon'],
                                              height: 15,
                                              color: blackColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            menuShare[index]['label'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                        ],
                      ),
                    ),
            ),
          ),
        ));
  }
}

class PageGroupShared extends StatelessWidget {
  final dynamic page;
  const PageGroupShared({super.key, this.page});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 226),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: NetworkImage(page['banner']['url']),
                onError: (exception, stackTrace) => const SizedBox(),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12)),
            color: Colors.grey.shade100,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Row(
              children: [
                PageItem(
                  page: page,
                  sizeAvatar: 42,
                  sizeTitle: 14,
                  maxLinesTitle: 1,
                  sizeDesription: 12,
                  maxLinesDescription: 1,
                  marginContent: 2,
                  widthTitle: size.width - 212,
                ),
                ButtonPrimary(
                  icon: Icon(
                    FontAwesomeIcons.solidThumbsUp,
                    size: 18,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  colorButton: greyColorOutlined,
                  colorText: Theme.of(context).textTheme.bodyMedium?.color,
                  label: page['page_relationship'] != null &&
                          page['page_relationship']['like']
                      ? 'Đã thích'
                      : 'Thích',
                  handlePress: () {},
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
