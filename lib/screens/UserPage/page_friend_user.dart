import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

class PageFriendUser extends ConsumerStatefulWidget {
  final dynamic user;
  const PageFriendUser({Key? key, this.user}) : super(key: key);

  @override
  ConsumerState<PageFriendUser> createState() => _PageFriendUserState();
}

class _PageFriendUserState extends ConsumerState<PageFriendUser> {
  String menuSelected = 'all';
  bool isSearch = false;
  List friendsAll = [];
  late ScrollController scrollController;
  bool isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await ref
        .read(userInformationProvider.notifier)
        .getUserFriend(widget.user['id'], {"limit": 20});
    if (mounted) {
      setState(() {
        friendsAll = ref.watch(userInformationProvider).friends;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    if (ref.read(userInformationProvider).friends.isNotEmpty && mounted) {
      if (mounted && ref.read(userInformationProvider).friendsNear.isEmpty) {
        ref.read(userInformationProvider.notifier).getUserFriend(
            widget.user['id'], {"limit": 20, "order_by_column": "created_at"});
      }
    }

    scrollController.addListener(() async{
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !isLoading) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        if (friendsAll != []) {
      await ref
            .read(userInformationProvider.notifier)
            .getUserFriend(widget.user['id'], {
          "limit": 10,
          "max_id": ref.watch(userInformationProvider).friends.last['id'],
        });
        }
        if (mounted) {
          setState(() {
            if (ref.watch(userInformationProvider).friends != []) {
              friendsAll = ref.watch(userInformationProvider).friends;
               isLoading = false; // Kết thúc quá trình tải dữ liệu
            }
          });
        }
      }
    });
  }

  handleSearch(text) {
    setState(() {
      isSearch = true;
    });
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () async {
      if (text.isEmpty) {
        setState(() {
          friendsAll = ref.watch(userInformationProvider).friends;
        });
      } else {
        var response = await UserPageApi()
            .getUserFriend(widget.user['id'], {'keyword': text});
        setState(() => friendsAll = response);
      }
      setState(() {
        isSearch = false;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    List listMenu = [
      {"key": 'all', "label": "Tất cả"},
      {"key": 'new', "label": "Gần đây"}
    ];

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: const BackIconAppbar(),
          centerTitle: true,
          title: const AppBarTitle(title: "Danh sách bạn bè"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.plus,
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            )
          ]),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: List.generate(
                  listMenu.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            menuSelected = listMenu[index]['key'];
                            friendsAll =
                                ref.read(userInformationProvider).friendsNear;
                          });
                        },
                        child: ChipMenu(
                            isSelected: menuSelected == listMenu[index]['key'],
                            label: listMenu[index]['label']),
                      )),
            ),
            const SizedBox(height: 8.0),
            SearchInput(handleSearch: (value) {
              handleSearch(value);
            }),
            const SizedBox(height: 8.0),
            isSearch
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : friendsAll.isEmpty
                    ? const Center(
                        child: Text("Không có bạn bè để hiển thị"),
                      )
                    : Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: friendsAll.length,
                            itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserPageHome(),
                                                settings: RouteSettings(
                                                  arguments: {
                                                    'id': friendsAll[index]
                                                        ['id']
                                                  },
                                                ),
                                              ));
                                        },
                                        child: SizedBox(
                                          width: size.width - 20,
                                          child: UserItem(
                                            user: friendsAll[index],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModal(context, friendsAll[index]);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.ellipsis,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                      ),
                      isLoading? const Center(
                                                  child: CupertinoActivityIndicator(),
                                                )
                                              : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<dynamic> showModal(BuildContext context, user) {
    String displayName = user['display_name'];

    List listMenu = [
      {
        "key": "friend",
        "label": "Xem bạn bè của $displayName",
        "icon": FontAwesomeIcons.solidUser,
      },
      {
        "key": "chat",
        "label": "Nhắn tin cho $displayName",
        "icon": FontAwesomeIcons.solidComment,
      },
      {
        "key": "unfollow",
        "label": "Bỏ theo dõi $displayName",
        "icon": FontAwesomeIcons.solidRectangleXmark,
        "sublabel": "Dừng xem bài viết nhưng vẫn là bạn bè"
        //Bài viết của $displayName sẽ hiển thị trên bảng tin của bạn
        // FontAwesomeIcons.squarePlus
      },
      {
        "key": "block",
        "label": "Chặn $displayName",
        "icon": FontAwesomeIcons.userXmark,
        "sublabel":
            "$displayName sẽ không thể nhìn thấy bạn hoặc liên hệ với bạn trên Emso"
        //Bài viết của $displayName sẽ hiển thị trên bảng tin của bạn
        // FontAwesomeIcons.squarePlus
      },
      {
        "key": "unfriend",
        "label": "Hủy kết bạn với $displayName",
        "icon": FontAwesomeIcons.userMinus,
        // FontAwesomeIcons.userPlus
      },
    ];

    handleActionMenu(key) {
      Navigator.pop(context);
    }

    return showBarModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => Container(
              margin: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      listMenu.length,
                      (index) => InkWell(
                            onTap: () {
                              handleActionMenu(listMenu[index]['key']);
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      listMenu[index]['icon'],
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                90,
                                        child: Text(listMenu[index]['label'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      listMenu[index]['sublabel'] != null
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  90,
                                              child: Text(
                                                listMenu[index]['sublabel'],
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: greyColor),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
              ),
            ));
  }
}
