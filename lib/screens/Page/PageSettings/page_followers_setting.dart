import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
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
  List users = [
    User(name: "Nguyễn Thanh Bình", date: "27/08/2000", isChecked: false),
    User(name: "John Doe", date: "27/08/2000", isChecked: false),
    User(name: "Jane Smith", date: "27/08/2000", isChecked: false),
    User(name: "Bob Johnson", date: "27/08/2000", isChecked: false),
  ];
  List users_follow = [
    User(name: "John Doe", date: "27/08/2000", isChecked: false),
    User(name: "Jane Smith", date: "27/08/2000", isChecked: false),
    User(name: "Bob Johnson", date: "27/08/2000", isChecked: false),
  ];
  List users_blocked = [
    User(name: "Bob Johnson", date: "27/08/2000", isChecked: false),
  ];
  List filteredUserList = [];
  @override
  void initState() {
    super.initState();
    filteredUserList = List.from(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
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
                          setState(() {
                            filteredUserList = users_blocked;
                          });
                        }
                      }
                    },
                    listTabs: pageUsersType,
                    tabCurrent: menuSelected)),
            Expanded(child: renderTab(widget.data)),
            showButton
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonPrimary(
                      label: 'Cấm trên trang',
                      handlePress: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void onClickToggleChecked(value) {
    setState(() {
      for (int i = 0; i < filteredUserList.length; i++) {
        filteredUserList[i].isChecked = value;
      }
    });
  }

  bool checkAvailableButton() {
    int count = 0;
    for (int i = 0; i < filteredUserList.length; i++) {
      if (filteredUserList[i].isChecked) {
        count++;
      }
    }
    if (count == filteredUserList.length) {
      selectAll = true;
    } else {
      selectAll = false;
    }
    if (count > 0)
      return true;
    else
      return false;
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
        filteredUserList = searchList
            .where((user) => user.name
                .trim()
                .toLowerCase()
                .contains(searchText.trim().toLowerCase()))
            .toList();
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
                        filteredUserList[index].isChecked =
                            !filteredUserList[index].isChecked;
                        showButton = checkAvailableButton();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Checkbox(
                            value: filteredUserList[index].isChecked,
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                filteredUserList[index].isChecked = value;
                                showButton = checkAvailableButton();
                              });
                            },
                          ),
                        ),
                        Container(
                            width: width * 0.6,
                            child: Text(filteredUserList[index].name)),
                        Container(
                            width: width * 0.3,
                            child: Text(filteredUserList[index].date)),
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
                        filteredUserList[index].isChecked =
                            !filteredUserList[index].isChecked;
                        showButton = checkAvailableButton();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Checkbox(
                            value: filteredUserList[index].isChecked,
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                filteredUserList[index].isChecked = value;
                                showButton = checkAvailableButton();
                              });
                            },
                          ),
                        ),
                        Container(
                            width: width * 0.4,
                            child: Text(filteredUserList[index].name)),
                        Container(
                            width: width * 0.3,
                            child: Text(filteredUserList[index].date)),
                        Container(
                          width: width * 0.2,
                          child: Text("Nguyễn Đình Đạt"),
                        )
                      ],
                    ),
                  )),
        )
      ],
    );
  }
}

class User {
  String name;
  String date;
  bool isChecked;

  User({required this.name, required this.date, this.isChecked = false});
}
