// ignore_for_file: non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_tag_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_notification_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class UserTagSetting extends ConsumerStatefulWidget {
  final dynamic data;
  const UserTagSetting({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserTagsSettingState();
}

class _UserTagsSettingState extends ConsumerState<UserTagSetting> {
  PageNotificationState data = PageNotificationState();
  FocusNode focus = FocusNode();
  final TextEditingController _categoryController = TextEditingController();
  List monitored_keywords = [];
  Map<String, Map<String, dynamic>> listSelected = {
    "friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn bè",
    },
    "private": {
      "icon": "assets/groups/privacy.png",
      "title": "Riêng tư",
    }
  };
  Map<String, Map<String, dynamic>> listSelectedWithPublic = {
    "public": {
      "icon": "assets/groups/publish.png",
      "title": "Công khai",
    },
    "friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn bè",
    },
    "private": {
      "icon": "assets/groups/privacy.png",
      "title": "Riêng tư",
    }
  };
  Map<String, Map<String, dynamic>> listSelected3 = {
    "public": {
      "icon": "assets/groups/publish.png",
      "title": "Công khai",
    },
    "friend_of_friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn của bạn bè",
    },
    "private": {
      "icon": "assets/groups/privacy.png",
      "title": "Riêng tư",
    }
  };
  Map<String, Map<String, dynamic>> listSelected4 = {
    "friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn bè",
    },
    "private": {
      "icon": "assets/groups/privacy.png",
      "title": "Riêng tư",
    }
  };
  dynamic settings = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await ref.read(userTagControllerProvider.notifier).getUserTagSetting();
    setState(() {
      monitored_keywords =
          ref.read(userTagControllerProvider).monitored_keywords;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    _categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    settings = ref.watch(userTagControllerProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Trang cá nhân và gắn thẻ'),
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomContainer(
                isDarkMode: theme.isDarkMode,
                children: [
                  sectionTitle(
                    "Trang cá nhân",
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterUsersSelectionBottomSheet(listSelected,
                          "allow_post_status", settings.allow_post_status);
                    },
                    child: sectionListModalItem(
                        theme,
                        "Ai có thể đăng lên trang cá nhân của bạn?",
                        false,
                        listSelected[settings.allow_post_status ?? "friend"]![
                            "title"],
                        listSelected[settings.allow_post_status ?? "friend"]![
                            "icon"]),
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterUsersSelectionBottomSheet(
                          listSelectedWithPublic,
                          "allow_view_status",
                          settings.allow_view_status);
                    },
                    child: sectionListModalItem(
                        theme,
                        "Ai có thể xem những gì người khác đăng lên trang cá nhân của bạn?",
                        false,
                        listSelectedWithPublic[
                            settings.allow_view_status ?? "friend"]!["title"],
                        listSelectedWithPublic[
                            settings.allow_view_status ?? "friend"]!["icon"]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        const Text(
                          "Ẩn bình luận chứa một số từ nhất định khỏi trang của bạn",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 6),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: focus.hasFocus
                                      ? secondaryColor
                                      : greyColor,
                                  width: focus.hasFocus ? 2 : 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Wrap(
                                    children: List.generate(
                                        monitored_keywords.length,
                                        (index) =>
                                            selectedArea(context, index))),
                              ),
                              TextFormField(
                                focusNode: focus,
                                controller: _categoryController,
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  monitored_keywords = [
                                    ...monitored_keywords,
                                    _categoryController.text
                                  ];
                                  setState(() {
                                    _categoryController.text = "";
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.search),
                                    labelText: "Thêm từ, cụm từ cần kiểm duyệt",
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 12, 0, 0)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonPrimary(
                                        label: 'Lưu thay đổi',
                                        handlePress: () async {
                                          saveKeywords();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonPrimary(
                                        label: 'Xoá tất cả',
                                        isGrey: true,
                                        handlePress: () {
                                          setState(() {
                                            monitored_keywords = [];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomContainer(
                isDarkMode: theme.isDarkMode,
                children: [
                  sectionTitle(
                    "Gắn thẻ",
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterUsersSelectionBottomSheet(listSelected3,
                          "allow_tagging", settings.allow_tagging);
                    },
                    child: sectionListModalItem(
                        theme,
                        "Ai có thể xem bài viết có gắn thẻ bạn trên trang cá nhân của bạn?",
                        false,
                        listSelected3[settings.allow_tagging ?? "public"]![
                            "title"],
                        listSelected3[settings.allow_tagging ?? "public"]![
                            "icon"]),
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterUsersSelectionBottomSheet(listSelected4,
                          "allow_view_tagging", settings.allow_view_tagging);
                    },
                    child: sectionListModalItem(
                        theme,
                        "Khi bạn được gắn thẻ trong một bài viết, bạn muốn thêm ai vào đối tượng của bài viết nếu họ chưa thể nhìn thấy bài viết?",
                        true,
                        listSelected4[settings.allow_view_tagging ?? "friend"]![
                            "title"],
                        listSelected4[settings.allow_view_tagging ?? "friend"]![
                            "icon"]),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomContainer(
                isDarkMode: theme.isDarkMode,
                children: [
                  sectionTitle(
                    "Xem lại",
                  ),
                  sectionListToggleItem(
                      theme,
                      "Xét duyệt bài viết có gắn thẻ bạn trước khi bài viết đó xuất hiện trên trang cá nhân của bạn",
                      false,
                      settings.review_tag_on_profile,
                      "review_tag_on_profile"),
                  sectionListToggleItem(
                      theme,
                      "Xem lại thẻ mọi người thêm vào bài viết của bạn trước khi thẻ xuất hiện trên EMSO?",
                      true,
                      settings.review_tag_on_feed,
                      "review_tag_on_feed"),
                ],
              )
            ],
          ),
        )));
  }

  buildFilterUsersSelectionBottomSheet(
      listItem, String type, String itemValue) {
    showCustomBottomSheet(context, 250,
        title: "Chọn đối tượng",
        isShowCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              String key = listItem.keys.elementAt(index);
              String title = listItem[key]!["title"];
              return InkWell(
                child: Column(
                  children: [
                    GeneralComponent(
                      [
                        buildTextContent(title, true),
                      ],
                      changeBackground: transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixWidget: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: itemValue,
                        value: key,
                        onChanged: (value) async {
                          updateModalField(type, key);
                        },
                      ),
                      function: () async {
                        updateModalField(type, key);
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

  void updateModalField(type, key) {
    switch (type) {
      case "allow_post_status":
        ref.read(userTagControllerProvider.notifier).updateAllowPostStatus(key);
        break;
      case "allow_view_status":
        ref.read(userTagControllerProvider.notifier).updateAllowViewStatus(key);
        break;
      case "allow_tagging":
        ref
            .read(userTagControllerProvider.notifier)
            .updateAllowTaggingStatus(key);
        break;
      case "allow_view_tagging":
        ref
            .read(userTagControllerProvider.notifier)
            .updateAllowViewTaggingStatus(key);
        break;

      default:
        break;
    }
    sendApiUpdateData();
    popToPreviousScreen(context);
  }

  void sendApiUpdateData() {
    var data = ref.read(userTagControllerProvider);
    UserPageApi().updateTagSetting({
      "allow_post_status": data.allow_post_status,
      "allow_view_status": data.allow_view_status,
      "allow_tagging": data.allow_tagging,
      "allow_view_tagging": data.allow_view_tagging,
      "review_tag_on_profile": data.review_tag_on_profile,
      "review_tag_on_feed": data.review_tag_on_feed,
    });
  }

  void saveKeywords() async {
    var res = await UserPageApi()
        .updateTagSetting({"monitored_keywords": monitored_keywords});
    if (res != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
    }
  }

  Widget selectedArea(BuildContext context, dynamic value) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey),
      child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            InkWell(
              onTap: (() {}),
              child: Text(
                monitored_keywords[value],
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  monitored_keywords.remove(monitored_keywords[value]);
                });
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8, 3, 5, 3),
                child: Icon(
                  FontAwesomeIcons.solidCircleXmark,
                  size: 16,
                  color: white,
                ),
              ),
            )
          ]),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget sectionListToggleItem(
      theme, String title, bool isFirstItem, bool checked, String type) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: !isFirstItem
            ? const Border(
                bottom: BorderSide(
                  color: greyColor,
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CupertinoSwitch(
              value: checked,
              onChanged: (value) async {
                if (type == "review_tag_on_profile") {
                  ref
                      .read(userTagControllerProvider.notifier)
                      .updateReviewProfile(value);
                } else {
                  ref
                      .read(userTagControllerProvider.notifier)
                      .updateReviewFeed(value);
                }
                sendApiUpdateData();
              })
        ],
      ),
    );
  }

  Widget sectionListModalItem(
      theme, String title, bool isLastItem, String selected, String icon) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: !isLastItem
            ? const Border(
                bottom: BorderSide(
                  color: greyColor,
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: blueColor),
            child: Row(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      icon,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  selected,
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final bool isDarkMode;
  final List<Widget> children;

  const CustomContainer({
    super.key,
    required this.isDarkMode,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.transparent : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
