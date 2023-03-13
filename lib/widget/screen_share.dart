import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/group_item.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class ScreenShare extends ConsumerStatefulWidget {
  final dynamic entityShare;
  final String type;
  final String entityType;
  const ScreenShare(
      {Key? key,
      this.entityShare,
      required this.type,
      required this.entityType})
      : super(key: key);

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
          () => content = value;
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
        "icon": FontAwesomeIcons.solidComment,
        "label": "Gửi qua EmsoChat"
      },
      {
        "key": "share_group",
        "icon": FontAwesomeIcons.userGroup,
        "label": "Chia sẻ lên một nhóm"
      },
      {
        "key": "share_page",
        "icon": FontAwesomeIcons.solidFlag,
        "label": "Chia sẻ lên trang của bạn"
      },
      {
        "key": "share_user_page_other",
        "icon": FontAwesomeIcons.solidUser,
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
    }

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const AppBarTitle(title: "Chia sẻ"),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
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
                                                ),
                                        ),
                                      )),
                            )
                    ],
                  )
                : Column(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          ButtonPrimary(
                            label: "Chia sẻ",
                            handlePress: handleShare,
                          )
                        ],
                      ),
                      const CrossBar(
                        height: 0.5,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: menuShare.length,
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
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: secondaryColorSelected),
                                          child: Icon(
                                            menuShare[index]['icon'],
                                            size: 16,
                                            color: secondaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          menuShare[index]['label'],
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
          ),
        ));
  }
}
