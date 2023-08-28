import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_block_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/custom_pop_up.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/Posts/opaque_cupertino_route.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

class DetailBlockList extends ConsumerStatefulWidget {
  final String type;
  final String title;
  final String description;
  const DetailBlockList(
      {super.key,
      required this.title,
      required this.type,
      required this.description});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailBlockListState();
}

class _DetailBlockListState extends ConsumerState<DetailBlockList> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<dynamic> listBlock = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (widget.type == "user") {
      await ref.read(userBlockControllerProvider.notifier).getUserBlockList();
    } else if (widget.type == "message") {
      await ref
          .read(userBlockControllerProvider.notifier)
          .getUserMessageBlockList();
    } else {
      await ref
          .read(userBlockControllerProvider.notifier)
          .getUserPageBlockList();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    listBlock = ref.watch(userBlockControllerProvider).data;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(title: widget.title),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.description,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {
                  buildSearchPageUserBottomSheet(widget.type);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                  child: TextFormField(
                    controller: _searchController,
                    enabled: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: widget.type == "page"
                          ? 'Nhập để tìm kiếm trang'
                          : 'Nhập để tìm kiếm bạn bè',
                    ),
                  ),
                ),
              ),
              const Text(
                "Danh sách chặn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Expanded(
                  child: _isLoading
                      ? buildCircularProgressIndicator()
                      : listBlock.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: listBlock.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.type == "page"
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                AvatarSocial(
                                                    width: 40,
                                                    height: 40,
                                                    object: listBlock[index]
                                                        ["page"],
                                                    path: listBlock[index] !=
                                                                null &&
                                                            listBlock[index]
                                                                        ["page"]
                                                                    [
                                                                    "avatar_media"] !=
                                                                null
                                                        ? listBlock[index]
                                                                    ["page"]
                                                                ["avatar_media"]
                                                            ['preview_url']
                                                        : linkAvatarDefault),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      200,
                                                  child: Text(
                                                    listBlock[index]?["page"]
                                                            ["title"] ??
                                                        'Không xác định',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                AvatarSocial(
                                                    width: 40,
                                                    height: 40,
                                                    object: listBlock[index]
                                                        ["target_account"],
                                                    path: listBlock[index][
                                                                    "target_account"]
                                                                [
                                                                'avatar_media'] !=
                                                            null
                                                        ? listBlock[index][
                                                                    "target_account"]
                                                                ['avatar_media']
                                                            ['preview_url']
                                                        : linkAvatarDefault),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              200,
                                                      child: Text(
                                                        listBlock[index][
                                                                    "target_account"]
                                                                ?[
                                                                'display_name'] ??
                                                            'Không xác định',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      ButtonPrimary(
                                        label: 'Huỷ chặn',
                                        isGrey: true,
                                        handlePress: () async {
                                          await showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomCupertinoAlertDialog(
                                              title: 'Hủy chặn',
                                              content: widget.type == "page"
                                                  ? 'Bạn có chắc chắn muốn hủy chặn trang này.'
                                                  : 'Bạn có chắc chắn muốn hủy chặn người này.',
                                              cancelText: 'Huỷ',
                                              confirmText: 'Xác nhận',
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                              onConfirm: () async {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                if (widget.type == "user") {
                                                  await UserPageApi()
                                                      .unblockUser(listBlock[
                                                                  index]
                                                              ["target_account"]
                                                          ["id"]);
                                                } else if (widget.type ==
                                                    "message") {
                                                  await UserPageApi()
                                                      .unblockUserMessage(
                                                          listBlock[index][
                                                                  "target_account"]
                                                              ["id"]);
                                                } else {
                                                  await PageApi().unblockPage(
                                                      listBlock[index]["page"]
                                                          ["id"]);
                                                }
                                                await getData();
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                widget.type == "page"
                                    ? "Không có trang bị chặn"
                                    : "Không có người dùng bị chặn",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ))
            ])));
  }

  buildSearchPageUserBottomSheet(String type) {
    showCustomBottomSheet(context, MediaQuery.of(context).size.height,
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

        fetchPages(search) async {
          Map<String, dynamic> params = {
            "q": search,
            "type": "pages",
          };
          var response = await SearchApi().getListSearchApi(params);
          if (response != null) {
            setStatefull(() {
              searchResults = response["pages"];
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
                  setStatefull(() {
                    EasyDebounce.debounce(
                        'my-debouncer', const Duration(milliseconds: 500), () {
                      if (type == "page") {
                        fetchPages(value);
                      } else {
                        fetchFriends(value);
                      }
                    });
                  });
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: searchResults.isEmpty
                    ? const Center(
                        child: Text("Không có kết quả nào"),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomCupertinoAlertDialog(
                                  title: 'Xác nhận chặn',
                                  content: type == "page"
                                      ? "Bạn có chắc chắn muốn chặn trang này?"
                                      : 'Bạn có chắc chắn muốn chặn người này?',
                                  cancelText: 'Huỷ',
                                  confirmText: 'Xác nhận',
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                  onConfirm: () async {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (type == "user") {
                                      await UserPageApi().blockUser({
                                        "account_id": searchResults[index]["id"]
                                      });
                                    } else if (type == "message") {
                                      await UserPageApi().blockUserMessage({
                                        "target_account_id":
                                            searchResults[index]["id"]
                                      });
                                    } else {
                                      await PageApi().blockPage({
                                        "page_id": searchResults[index]["id"]
                                      });
                                    }
                                    await getData();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: type == "page"
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AvatarSocial(
                                            width: 40,
                                            height: 40,
                                            object: searchResults[index],
                                            path: searchResults[index] !=
                                                        null &&
                                                    searchResults[index]
                                                            ['avatar_media'] !=
                                                        null
                                                ? searchResults[index]
                                                        ['avatar_media']
                                                    ['preview_url']
                                                : linkAvatarDefault),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            searchResults[index]?['title'] ??
                                                'Không xác định',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AvatarSocial(
                                            width: 40,
                                            height: 40,
                                            object: searchResults[index],
                                            path: searchResults[index] !=
                                                        null &&
                                                    searchResults[index]
                                                            ['avatar_media'] !=
                                                        null
                                                ? searchResults[index]
                                                        ['avatar_media']
                                                    ['preview_url']
                                                : linkAvatarDefault),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            searchResults[index]
                                                    ?['display_name'] ??
                                                'Không xác định',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                overflow:
                                                    TextOverflow.ellipsis),
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
}
