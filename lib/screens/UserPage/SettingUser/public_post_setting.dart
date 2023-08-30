import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_public_post_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_tag_settings.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:provider/provider.dart' as pv;

class PublicPostSetting extends ConsumerStatefulWidget {
  final dynamic data;
  const PublicPostSetting({super.key, this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublicPostSettingState();
}

class _PublicPostSettingState extends ConsumerState<PublicPostSetting> {
  dynamic settings = {};
  Map<String, Map<String, dynamic>> listSelected1 = {
    "public": {
      "icon": "assets/groups/publish.png",
      "title": "Công khai",
    },
    "friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn bè",
    }
  };
  Map<String, Map<String, dynamic>> listSelected2 = {
    "public": {
      "icon": "assets/groups/publish.png",
      "title": "Công khai",
    },
    "friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn bè",
    },
    "friend_of_friend": {
      "icon": "assets/groups/groupActivity.png",
      "title": "Bạn của bạn bè",
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
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await ref
        .read(userPublicPostControllerProvider.notifier)
        .getUserPublicPostSetting();
  }

  @override
  Widget build(BuildContext context) {
    settings = ref.watch(userPublicPostControllerProvider);
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Bộ lọc và công cụ của bài viết'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomContainer(
                isDarkMode: theme.isDarkMode,
                children: [
                  sectionTitle(
                    "Ai có thể theo dõi tôi",
                  ),
                  sectionListModalItem(
                      theme,
                      ("Người theo dõi sẽ nhìn thấy bài viết, thước phim và tin của bạn trong Bảng feed. Theo mặc định thì bạn bè sẽ theo dõi bài viết, thước phim và tin của bạn, nhưng bạn cũng có thể để những người không phải là bạn bè theo dõi bài viết, thước phim và tin công khai của mình. Hãy sử dụng cài đặt này để chọn người có thể theo dõi bạn.\n\n"
                          "Mỗi lần đăng bài hoặc tạo tin/thước phim, bạn sẽ chọn đối tượng mình muốn chia sẻ.\n\n"
                          "Cài đặt này không áp dụng cho những người theo dõi bạn trên Marketplace cũng như trong các nhóm mua bán. Bạn có thể quản lý các cài đặt đó trên Marketplace."),
                      true,
                      listSelected1[settings.who_can_follow_me]!["title"],
                      listSelected1[settings.who_can_follow_me]!["icon"],
                      listSelected1,
                      settings.who_can_follow_me,
                      "who_can_follow_me")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomContainer(isDarkMode: theme.isDarkMode, children: [
                sectionTitle(
                  "Bình luận về bài viết công khai",
                ),
                sectionListModalItem(
                    theme,
                    '''
Chọn người được phép nhận xét về bài đăng công khai của bạn. Những người được gắn thẻ trong bài đăng công khai của bạn và bạn bè của họ vẫn có thể bình luận.

Bạn có thể cập nhật cài đặt này cho từng bài viết mà không ảnh hưởng đến tài khoản cài đặt.''',
                    false,
                    listSelected2[settings.public_post_comment]!["title"],
                    listSelected2[settings.public_post_comment]!["icon"],
                    listSelected2,
                    settings.public_post_comment,
                    "public_post_comment"),
                const SizedBox(
                  height: 20,
                ),
                sectionTitle(
                  "Thông báo về bài viết công khai",
                ),
                sectionListModalItem(
                    theme,
                    "Bạn có thể nhận được thông báo khi những người không phải là bạn bè bắt đầu theo dõi bạn và chia sẻ, thích hay bình luận về những bài viết công khai của bạn.",
                    false,
                    listSelected3[settings.public_post_notification]!["title"],
                    listSelected3[settings.public_post_notification]!["icon"],
                    listSelected3,
                    settings.public_post_notification,
                    "public_post_notification"),
                const SizedBox(
                  height: 20,
                ),
                sectionTitle(
                  "Thông báo công khai trên trang cá nhân",
                ),
                sectionListModalItem(
                    theme,
                    "Quản lý xem ai có thể thích hoặc bình luận về những thông tin luôn công khai trên trang cá nhân của bạn, bao gồm ảnh đại diện, video đại diện, ảnh bìa, ảnh đáng chú ý và phần cập nhật tiểu sử ngắn.",
                    true,
                    listSelected2[settings.public_profile_info]!["title"],
                    listSelected2[settings.public_profile_info]!["icon"],
                    listSelected2,
                    settings.public_profile_info,
                    "public_profile_info")
              ]),
              const SizedBox(
                height: 20,
              ),
              CustomContainer(isDarkMode: theme.isDarkMode, children: [
                sectionTitle(
                  "Bình luận về bài viết công khai",
                ),
                sectionListToggleItem(
                    theme,
                    "Hiển thị bản xem trước khi bài viết trong Nhóm công khai của bạn được chia sẻ ra ngoài Emso. Bản xem trước có thể bao gồm tên người dùng, ảnh đại diện và bất kỳ nội dung nào khác trong bài viết gốc của bạn.",
                    true,
                    settings.off_preview,
                    "off_preview")
              ]),
              const SizedBox(
                height: 20,
              ),
              CustomContainer(isDarkMode: theme.isDarkMode, children: [
                sectionTitle(
                  "Hiển thị bình luận phù hợp nhất trước tiên",
                ),
                sectionListToggleItem(
                    theme,
                    "Khi bạn bật tính năng xếp thứ tự bình luận thì bình luận nào liên quan nhất đến bài viết sẽ hiển thị trước tiên.",
                    true,
                    settings.comment_ranking,
                    "comment_ranking")
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget sectionListModalItem(
      theme,
      String title,
      bool isLastItem,
      String selected,
      String icon,
      Map listDataModal,
      String key,
      String type) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  buildFilterUsersSelectionBottomSheet(
                      listDataModal, key, type);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: greyColorOutlined),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Image.asset(
                            icon,
                            width: 20,
                            height: 20,
                            color: blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        selected,
                        style: const TextStyle(color: blackColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void updateModalField(type, key) {
    switch (type) {
      case "who_can_follow_me":
        ref
            .read(userPublicPostControllerProvider.notifier)
            .updateWhoCanFollow(key);
        break;
      case "public_post_comment":
        ref
            .read(userPublicPostControllerProvider.notifier)
            .updatePostComment(key);
        break;
      case "public_post_notification":
        ref
            .read(userPublicPostControllerProvider.notifier)
            .updatePostNotification(key);
        break;
      case "public_profile_info":
        ref
            .read(userPublicPostControllerProvider.notifier)
            .updateProfileInfo(key);
        break;

      default:
        break;
    }
    sendApiUpdateData();
    popToPreviousScreen(context);
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
                if (type == "off_preview") {
                  ref
                      .read(userPublicPostControllerProvider.notifier)
                      .updateOffPreview(value);
                } else {
                  ref
                      .read(userPublicPostControllerProvider.notifier)
                      .updateCommentRanking(value);
                }
                sendApiUpdateData();
              })
        ],
      ),
    );
  }

  buildFilterUsersSelectionBottomSheet(
      listItem, String itemValue, String type) {
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

  void sendApiUpdateData() {
    var data = ref.read(userPublicPostControllerProvider);
    UserPageApi().updateTagSetting({
      "who_can_follow_me": data.who_can_follow_me,
      "public_post_comment": data.public_post_comment,
      "public_post_notification": data.public_post_notification,
      "public_profile_info": data.public_profile_info,
      "off_preview": data.off_preview,
      "comment_ranking": data.comment_ranking,
    });
  }
}
