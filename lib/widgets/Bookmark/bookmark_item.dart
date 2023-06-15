import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;

class BookmarkItem extends ConsumerStatefulWidget {
  final dynamic item;

  const BookmarkItem({super.key, this.item});

  @override
  BookmarkItemState createState() => BookmarkItemState();
}

class BookmarkItemState extends ConsumerState<BookmarkItem> {
  void handleUnBookmark(bookmark, BuildContext context) async {
    var response = await BookmarkApi()
        .unBookmarkApi({"bookmark_id": bookmark['bookmark_id']});
    if (response != null && mounted) {
      ref
          .read(savedControllerProvider.notifier)
          .updateAfterUnBookmard(bookmark['id']);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bỏ lưu thành công"),
        ),
      );
    }
  }

  String defaultCollectionImage =
      "https://snapi.emso.asia/system/media_attachments/files/108/927/296/811/310/650/small/6d639898340c58e6.jpg";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);

    return Container(
      height: height / 8,
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.item['imageUrl'] ?? defaultCollectionImage,
                fit: BoxFit.cover,
                height: height / 10,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    width: double.infinity,
                    child: Text(
                      widget.item['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: widget.item['type'] == 'status'
                          ? "Bài viết của "
                          : "Trang",
                      style: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.item['author'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 100.0,
                        padding: const EdgeInsets.only(left: 10.0),
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            showCupertinoDialog(
                                context: context,
                                builder: ((context) {
                                  return CupertinoAlertDialog(
                                    content: Container(
                                      margin: EdgeInsets.only(top: 8.0),
                                      child: const Text(
                                        "Bạn có chắc chắn muốn bỏ lưu mục đã chọn không?",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hủy'),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          handleUnBookmark(
                                              widget.item, context);
                                        },
                                        child: const Text('Gỡ, xóa'),
                                      ),
                                    ],
                                  );
                                }));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.0,
                                backgroundColor: greyColor[350],
                                child: const Icon(
                                  FontAwesomeIcons.circleXmark,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Bỏ lưu",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Icon(
                Icons.more_horiz_rounded,
                size: 25.0,
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
