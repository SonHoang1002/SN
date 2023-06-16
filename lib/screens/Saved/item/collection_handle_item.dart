import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../apis/bookmark_api.dart';
import '../../../providers/saved/saved_menu_item_provider.dart';
import '../../../widgets/show_modal_message.dart';
import '../../../widgets/text_description.dart';

class HandleItem {
  IconData iconData;
  String title;
  String actionType;

  HandleItem({
    required this.iconData,
    required this.title,
    required this.actionType,
  });
}

class CollectionHandleItem extends ConsumerStatefulWidget {
  HandleItem item;
  String collectionId;
  String collectionName;
  CollectionHandleItem({
    super.key,
    required this.item,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  CollectionHandleItemState createState() => CollectionHandleItemState();
}

class CollectionHandleItemState extends ConsumerState<CollectionHandleItem> {
  TextEditingController _controller = TextEditingController();

  void handleDelete(collectionId) async {
    var response = await BookmarkApi().deleteBookmarkCollection(collectionId);
    if (response != null && mounted) {
      ref
          .read(savedControllerProvider.notifier)
          .deleteOneCollection(collectionId);
    }
  }

  void handleRename(collectionId, String newName, BuildContext context) async {
    // print("handle: $collectionId");
    // print("newName: $newName");
    final res = await BookmarkApi().renameCollection(collectionId, newName);
    // print("handle: $res");
    // print("mounted: $mounted");
    if (res != null && mounted) {
      // print("run: run");
      ref
          .read(savedControllerProvider.notifier)
          .renameOneCollection(collectionId, newName);
      Navigator.pop(context);
      showSnackbar(context, "Đổi tên thành công");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller.text = widget.collectionName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        if (widget.item.actionType == 'rename') {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Column(
                  children: const [
                    Text('Đổi tên bộ sưu tập'),
                    TextDescription(
                      description: "Nhập tên mới cho bộ sưu tập này",
                    ),
                  ],
                ),
                content: Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: CupertinoTextField(
                    controller: _controller,
                    autofocus: true,
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
                    onPressed: _controller.text.split('').isNotEmpty
                        ? () {
                            handleRename(
                              widget.collectionId,
                              _controller.text,
                              context,
                            );
                          }
                        : null,
                    child: const Text('Đổi tên'),
                  ),
                ],
              );
            },
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: ((context) {
              return CupertinoAlertDialog(
                content: Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: const Text(
                    "Bạn có chắc chắn muốn xóa bộ sưu tập không?",
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
                      handleDelete(widget.collectionId);
                      Navigator.pop(context);
                      showSnackbar(context, "Xóa bộ sưu tập thành công");
                    },
                    child: const Text('Gỡ, xóa'),
                  ),
                ],
              );
            }),
          );
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.0,
            backgroundColor: greyColor[350],
            child: Icon(
              widget.item.iconData,
              size: 18.0,
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(
              widget.item.title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
