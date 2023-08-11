import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/page/page_follower_management_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/header_tabs.dart';

class PageFollowersSettings extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? rolePage;
  final Function? handleChangeDependencies;
  const PageFollowersSettings(
      {Key? key, this.data, this.rolePage, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<PageFollowersSettings> createState() =>
      _PageFollowersSettingsState();
}

class _PageFollowersSettingsState extends ConsumerState<PageFollowersSettings> {
  List<Map<String, dynamic>> pageEllipsis = [];
  String menuSelected = 'like';
  String typeMedia = 'image';
  bool selectAll = false;
  bool showButton = false;
  List menuFriend = [
    {
      "key": "suggest-friend",
      "label": "Gợi ý",
    },
    {
      "key": "your-frieend",
      "label": "Bạn bè",
    },
  ];
  List users = [];
  List users_follow = [];
  List users_blocked = [];
  List filteredUserList = [];
  List checkIndex = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    users = ref.read(pageFollowControllerProvider).like;
    filteredUserList = List.from(users);
    checkboxList();
  }

  void checkboxList() {
    checkIndex = [];
    for (int i = 0; i < filteredUserList.length; i++) {
      checkIndex.add(false);
    }
  }

  List<String> arrayToStringList() {
    List<String> saved = [];
    for (var i = 0; i < filteredUserList.length; i++) {
      if (checkIndex[i] == true) {
        if (menuSelected == "blocked") {
          saved.add(filteredUserList[i]["target_account"]["id"]);
        } else {
          saved.add(filteredUserList[i]["id"]);
        }
      }
    }
    return saved;
  }

  @override
  Widget build(BuildContext context) {
    users = ref.watch(pageFollowControllerProvider).like;
    users_follow = ref.watch(pageFollowControllerProvider).follower;
    users_blocked = ref.watch(pageFollowControllerProvider).block;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Người và trang khác'),
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
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Người và trang khác",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const Text(
                "Đây là nơi hiển thị những người và Trang khác đã thích tam hon trong sang. Từ danh sách người thích Trang, hãy nhấp vào để xóa hoặc cấm ai đó khỏi danh sách này. Người bị cấm không thể đăng, bình luận, gửi tin nhắn hoặc thực hiện các hành động khác trên Trang.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  onSearchTextChanged(value);
                },
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HeaderTabs(
                      chooseTab: (tab) {
                        showButton = false;
                        if (mounted) {
                          setState(() {
                            selectAll = false;
                            menuSelected = tab;
                          });
                          onClickToggleChecked(false);
                        }
                        if (tab == 'like') {
                          if (mounted) {
                            setState(() {
                              filteredUserList = users;
                            });
                          }
                        } else if (tab == 'follower') {
                          if (mounted) {
                            setState(() {
                              filteredUserList = users_follow;
                            });
                          }
                        } else if (tab == 'blocked') {
                          if (mounted) {
                            filteredUserList = users_blocked;
                          }
                        }
                        checkboxList();
                      },
                      listTabs: pageUsersType,
                      tabCurrent: menuSelected)),
              Expanded(child: renderTab(widget.data)),
              showButton
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonPrimary(
                        label: menuSelected == "blocked"
                            ? "Bỏ cấm trên trang"
                            : 'Cấm trên trang',
                        handlePress: () async {
                          context.loaderOverlay.show();
                          var res;
                          if (menuSelected != "blocked") {
                            res = await PageApi().pageBlockAccount(
                                widget.data["id"],
                                {"target_account_ids": arrayToStringList()});
                          } else {
                            res = await PageApi().pageUnblockAccount(
                                widget.data["id"],
                                {"target_account_ids": arrayToStringList()});
                          }
                          await ref
                              .read(pageFollowControllerProvider.notifier)
                              .getDataFollowPage(widget.data['id']);
                          if (mounted) {
                            context.loaderOverlay.hide();
                            if (res != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Cập nhật thành công")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Cập nhật thất bại")));
                            }
                          }
                          //Navigator.pop(context);
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void onClickToggleChecked(value) {
    setState(() {
      for (int i = 0; i < filteredUserList.length; i++) {
        checkIndex[i] = value;
      }
    });
  }

  bool checkAvailableButton() {
    int count = 0;
    for (int i = 0; i < checkIndex.length; i++) {
      if (checkIndex[i] == true) {
        count++;
      }
    }
    if (count == filteredUserList.length) {
      selectAll = true;
    } else {
      selectAll = false;
    }
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        switch (menuSelected) {
          case 'like':
            filteredUserList = List.from(users);
          case 'follower':
            filteredUserList = List.from(users_follow);
          case 'blocked':
            filteredUserList = List.from(users_blocked);
          default:
            filteredUserList = List.from(users);
        }
      } else {
        List searchList;
        switch (menuSelected) {
          case 'like':
            searchList = List.from(users);
          case 'follower':
            searchList = List.from(users_follow);
          case 'blocked':
            searchList = List.from(users_blocked);
          default:
            searchList = List.from(users);
        }
        if (menuSelected != "blocked") {
          filteredUserList = searchList
              .where((user) => user["display_name"]
                  .trim()
                  .toLowerCase()
                  .contains(searchText.trim().toLowerCase()))
              .toList();
        } else {
          filteredUserList = searchList
              .where((user) => user["target_account"]["display_name"]
                  .trim()
                  .toLowerCase()
                  .contains(searchText.trim().toLowerCase()))
              .toList();
        }
      }
    });
  }

  Widget renderTab(data) {
    if (data != null) {
      switch (menuSelected) {
        case 'like':
          return ListItems(data);
        case 'follower':
          return ListItems(data);
        case 'blocked':
          return ListItemsBlocked(data);
        default:
          return const SizedBox();
      }
    }
    return const SizedBox();
  }

  Widget ListItems(data) {
    var width = (MediaQuery.of(context).size.width - 32);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectAll = !selectAll;
              onClickToggleChecked(selectAll);
              showButton = checkAvailableButton();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width * 0.1,
                child: Checkbox(
                  value: selectAll,
                  activeColor: secondaryColor,
                  onChanged: (value) {
                    selectAll = value!;
                    onClickToggleChecked(value);
                    showButton = checkAvailableButton();
                  },
                ),
              ),
              Container(width: width * 0.6, child: Text("Họ tên")),
              Container(width: width * 0.3, child: Text("Ngày đăng ký")),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: filteredUserList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        checkIndex[index] = !checkIndex[index];
                        showButton = checkAvailableButton();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Checkbox(
                            value: checkIndex[index],
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                checkIndex[index] = value;
                                showButton = checkAvailableButton();
                              });
                            },
                          ),
                        ),
                        Container(
                            width: width * 0.6,
                            child:
                                Text(filteredUserList[index]["display_name"])),
                        Container(
                            width: width * 0.3,
                            child: Text(
                                filteredUserList[index]["last_status_at"])),
                      ],
                    ),
                  )),
        )
      ],
    );
  }

  Widget ListItemsBlocked(data) {
    var width = (MediaQuery.of(context).size.width - 32);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectAll = !selectAll;
              onClickToggleChecked(selectAll);
              showButton = checkAvailableButton();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width * 0.1,
                child: Checkbox(
                  value: selectAll,
                  activeColor: secondaryColor,
                  onChanged: (value) {
                    selectAll = value!;
                    onClickToggleChecked(value);
                    showButton = checkAvailableButton();
                  },
                ),
              ),
              Container(width: width * 0.4, child: Text("Họ tên")),
              Container(width: width * 0.3, child: Text("Ngày đăng ký")),
              Container(width: width * 0.2, child: Text("Người chặn")),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: filteredUserList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        checkIndex[index] = !checkIndex[index];
                        showButton = checkAvailableButton();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Checkbox(
                            value: checkIndex[index],
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                checkIndex[index] = value;
                                showButton = checkAvailableButton();
                              });
                            },
                          ),
                        ),
                        Container(
                            width: width * 0.4,
                            child: Text(filteredUserList[index]
                                ["target_account"]["display_name"])),
                        Container(
                            width: width * 0.3,
                            child: Text(filteredUserList[index]
                                ["target_account"]["last_status_at"])),
                        Container(
                          width: width * 0.2,
                          child: Text(filteredUserList[index]["account"]
                              ["display_name"]),
                        )
                      ],
                    ),
                  )),
        )
      ],
    );
  }
}
