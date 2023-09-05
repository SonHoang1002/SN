import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/block/user_block_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class UserBlockList extends ConsumerStatefulWidget {
  final dynamic data;
  const UserBlockList({super.key, this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserBlockListState();
}

class _UserBlockListState extends ConsumerState<UserBlockList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Quản lý chặn'),
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
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.isDarkMode ? Colors.transparent : Colors.white,
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
                    children: [
                      sectionTitle(
                        "Chặn người dùng",
                      ),
                      sectionListModalItem(
                          theme,
                          "Ngay khi bạn chặn ai đó, người này không thể xem nội dung đăng trên dòng thời gian của bạn, gắn thẻ bạn, mời bạn tham gia sự kiện hoặc nhóm, bắt đầu cuộc trò chuyện với bạn hay thêm bạn vào danh sách bạn bè nữa. Lưu ý: Không bao gồm các ứng dụng, trò chơi hay nhóm mà cả bạn và người này đều tham gia.",
                          false,
                          "Chặn người dùng",
                          "user"),
                      const SizedBox(
                        height: 20,
                      ),
                      sectionTitle(
                        "Chặn tin nhắn",
                      ),
                      sectionListModalItem(
                          theme,
                          "Nếu bạn chặn trang cá nhân của ai đó trên EMSO, họ cũng sẽ không thể liên hệ với bạn trong EmsoChat. Nếu bạn không chặn trang cá nhân EMSO của ai đó và bất kỳ trang cá nhân nào khác họ có khả năng tạo, họ có thể đăng bài lên dòng thời gian của bạn, gắn thẻ bạn và bình luận về bài viết hoặc bình luận của bạn.",
                          false,
                          "Chặn tin nhắn",
                          "message"),
                      const SizedBox(
                        height: 20,
                      ),
                      sectionTitle(
                        "Chặn trang",
                      ),
                      sectionListModalItem(
                          theme,
                          "Sau khi bạn chặn một Trang, Trang đó không thể tương tác với bài viết của bạn hoặc thích, phản hồi bình luận của bạn nữa. Bạn sẽ không thể đăng lên dòng thời gian của Trang hoặc gửi tin nhắn cho Trang. Nếu bạn đang thích Trang, việc chặn Trang cũng đồng nghĩa với bỏ thích và bỏ theo dõi Trang đó.",
                          true,
                          "Chặn trang",
                          "page")
                    ],
                  ),
                )
              ])),
        ));
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget sectionListModalItem(
      theme, String description, bool isLastItem, String title, String type) {
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
            description,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DetailBlockList(
                            title: title,
                            type: type,
                            description: description,
                          )));
            },
            child: /* Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: greyColorOutlined),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                        color: blackColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ) */
                const ButtonPrimary(
              label: "Chỉnh sửa",
              colorText: white,
            ),
          )
        ],
      ),
    );
  }
}
