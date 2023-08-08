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
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
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
  var filterUserList = [
    "Quản trị viên",
    "Người kiểm duyệt",
  ];
  dynamic _filterSelection;
  List<dynamic> searchResults = [];
  List<dynamic> listAdmin = [];
  addToList(data) {
    data["role"] = _controller.text;
    if (listAdmin.contains(data) == false) {
      setState(() {
        listAdmin.add(data);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filterSelection = filterUserList[0];
    _controller.text = filterUserList[0];
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                      "Có thể quản lý tất cả khía cạnh của Trang. Họ có thể đăng và gửi tin nhắn với tư cách Trang, trả lời và xóa bình luận trên Trang, tạo quảng cáo, xem những ai tạo bài viết hoặc bình luận, xem thông tin chi tiết và chỉ định vai trò trên Trang."),
                ),
                Text(
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
                              buildAdminRoleActionBottomSheet(index);
                            },
                            child: Padding(
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
                                          object: listAdmin[index],
                                          path: listAdmin[index]['avatar_media']
                                              ['preview_url']),
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
                                            listAdmin[index]?['display_name'] ??
                                                'Không xác định',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(listAdmin[index]["role"])
                                        ],
                                      ),
                                    ],
                                  ),
                                  ButtonPrimary(
                                    label: 'Huỷ lời mời',
                                    isGrey: true,
                                    handlePress: () {
                                      //Navigator.pop(context);
                                      setState(() {
                                        listAdmin.remove(listAdmin[index]);
                                      });
                                    },
                                  ),
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
              final data = filterUserList[index];
              return InkWell(
                child: Column(
                  children: [
                    GeneralComponent(
                      [
                        buildTextContent(data, true),
                      ],
                      changeBackground: transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixWidget: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: _filterSelection,
                        value: data,
                        onChanged: (value) async {
                          setState(() {
                            _filterSelection = data;
                          });
                          popToPreviousScreen(context);
                        },
                      ),
                      function: () async {
                        setState(() {
                          _filterSelection = data;
                          _controller.text = data;
                        });
                        popToPreviousScreen(context);
                      },
                    ),
                    buildSpacer(height: 10)
                  ],
                ),
              );
            });
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
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          addToList(searchResults[index]);
                          Navigator.pop(context);
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
