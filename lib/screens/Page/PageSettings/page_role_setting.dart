import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_role_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/custom_pop_up.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Posts/opaque_cupertino_route.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

class PageRoleSettings extends ConsumerStatefulWidget {
  final dynamic data;
  const PageRoleSettings({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageRoleSettingsState();
}

class _PageRoleSettingsState extends ConsumerState<PageRoleSettings> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  Map<String, String> filterUserList = {
    'moderator': 'Người kiểm duyệt',
    'admin': 'Quản trị viên',
  };
  dynamic _filterSelection;
  List<dynamic> searchResults = [];
  List<dynamic> listAdmin = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filterSelection = 'admin';
    _controller.text = filterUserList['admin']!;
  }

  bool haveInList(data) {
    for (var i = 0; i < listAdmin.length; i++) {
      if (listAdmin[i]["target_account"]["id"] == data["id"]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    listAdmin = ref.watch(pageRoleControllerProvider).accounts;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Vai trò trên trang'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chỉ định một vai trò mới trên Trang",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    buildSearchPageAdminBottomSheet();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: TextFormField(
                      controller: _searchController,
                      enabled: false,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nhập để tìm kiếm bạn bè',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    buildFilterRoleSelectionBottomSheet();
                  },
                  child: TextFormField(
                    controller: _controller,
                    enabled: false,
                    autofocus: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vai trò',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                      "Có thể quản lý tất cả khía cạnh của Trang. Họ có thể đăng và gửi tin nhắn với tư cách Trang, trả lời và xóa bình luận trên Trang, tạo quảng cáo, xem những ai tạo bài viết hoặc bình luận, xem thông tin chi tiết và chỉ định vai trò trên Trang."),
                ),
                const Text(
                  "Quản trị viên và người kiểm duyệt",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: listAdmin.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (listAdmin[index]["status"] != "pending") {
                                buildAdminRoleActionBottomSheet(index);
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AvatarSocial(
                                          width: 40,
                                          height: 40,
                                          object: listAdmin[index]
                                              ["target_account"],
                                          path: listAdmin[index]
                                                  ["target_account"]
                                              ['avatar_media']['preview_url']),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            listAdmin[index]["target_account"]
                                                    ?['display_name'] ??
                                                'Không xác định',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                filterUserList[listAdmin[index]
                                                    ["role"]]!,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              listAdmin[index]["status"] ==
                                                      "pending"
                                                  ? const Text(
                                                      "Đang chờ",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12),
                                                    )
                                                  : Container()
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  listAdmin[index]["status"] == "pending"
                                      ? ButtonPrimary(
                                          label: 'Huỷ lời mời',
                                          isGrey: true,
                                          handlePress: () async {
                                            //Navigator.pop(context);

                                            await showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomCupertinoAlertDialog(
                                                title: 'Hủy yêu cầu',
                                                content:
                                                    'Bạn có chắc chắn muốn hủy người này làm quản lý Trang.',
                                                cancelText: 'Huỷ',
                                                confirmText: 'Xác nhận',
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                                onConfirm: () async {
                                                  Navigator.pop(context);
                                                  await PageApi()
                                                      .removeInviteManagePage(
                                                          widget.data["id"],
                                                          listAdmin[index][
                                                                  "target_account"]
                                                              ["id"]);
                                                  ref
                                                      .read(
                                                          pageRoleControllerProvider
                                                              .notifier)
                                                      .getInviteListPage(
                                                          widget.data['id']);
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            )));
  }

  buildFilterRoleSelectionBottomSheet() {
    showCustomBottomSheet(context, 200,
        isNoHeader: true,
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: filterUserList.length,
          itemBuilder: (context, index) {
            final key = filterUserList.keys.elementAt(index);
            final value = filterUserList[key]!;
            return Column(
              children: [
                GeneralComponent(
                  [
                    buildTextContent(value, true),
                  ],
                  changeBackground: transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixWidget: Radio(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => secondaryColor),
                    groupValue: _filterSelection,
                    value: key,
                    onChanged: (value) async {
                      setState(() {
                        _filterSelection = key;
                        _controller.text = filterUserList[_filterSelection]!;
                      });
                      popToPreviousScreen(context);
                    },
                  ),
                ),
                buildSpacer(height: 10)
              ],
            );
          },
        );
      },
    ));
  }

  buildSearchPageAdminBottomSheet() {
    showCustomBottomSheet(context, MediaQuery.of(context).size.height * 0.8,
        isNoHeader: true,
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        fetchFriends(search) async {
          Map<String, dynamic> params = {
            "keyword": search,
          };
          var response = await FriendsApi().getListFriendApi(
              ref.watch(meControllerProvider)[0]['id'], params);
          if (response != null) {
            setStatefull(() {
              searchResults = response;
            });
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SearchInput(handleSearch: (value) async {
                  //searchFriendInvite(value);

                  setStatefull(() {
                    EasyDebounce.debounce(
                        'my-debouncer', const Duration(milliseconds: 500), () {
                      fetchFriends(value);
                    });
                  });
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomCupertinoAlertDialog(
                              title: 'Xác nhận lời mời',
                              content:
                                  'Bạn có chắc chắn muốn mời người này làm quản lý Trang.',
                              cancelText: 'Huỷ',
                              confirmText: 'Xác nhận',
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () async {
                                Navigator.pop(context);
                                var check = haveInList(searchResults[index]);
                                if (check == false) {
                                  await PageApi().sendInviteManagePage(
                                      widget.data["id"], {
                                    "target_account_id": searchResults[index]
                                        ["id"],
                                    "role": _filterSelection
                                  });
                                  ref
                                      .read(pageRoleControllerProvider.notifier)
                                      .getInviteListPage(widget.data['id']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Tài khoản đã được thêm")));
                                }
                              },
                            ),
                          );
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AvatarSocial(
                                  width: 40,
                                  height: 40,
                                  object: searchResults[index],
                                  path: searchResults[index] != null &&
                                          searchResults[index]
                                                  ['avatar_media'] !=
                                              null
                                      ? searchResults[index]['avatar_media']
                                          ['preview_url']
                                      : linkAvatarDefault),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                searchResults[index]?['display_name'] ??
                                    'Không xác định',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    ));
  }

  buildAdminRoleActionBottomSheet(index) {
    showCustomBottomSheet(context, 100,
        isNoHeader: true,
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        print(index);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonPrimary(
                    label: 'Chỉnh sửa vai trò',
                    handlePress: () {
                      Navigator.pop(context);
                      //buildFilterRoleSelectionBottomSheet();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonPrimary(
                    label: 'Gỡ',
                    isGrey: true,
                    handlePress: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
