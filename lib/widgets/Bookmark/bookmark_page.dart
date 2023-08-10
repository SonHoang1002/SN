import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  final dynamic entitySave;
  final String entityType;
  final String type;
  const BookmarkPage(
      {Key? key, this.entitySave, required this.entityType, required this.type})
      : super(key: key);

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  List listAlbums = [];

  @override
  void initState() {
    super.initState();

    if (!mounted) return;

    fetchBookmarkCollection();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchBookmarkCollection() async {
    List response = await BookmarkApi().fetchBookmarkCollection();

    if (response.isNotEmpty) {
      if (mounted) {
        setState(() {
          listAlbums = response;
        });
      }
    }
  }

  void showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            isSavedMenuItem: false,
            type: widget.type,
            entitySave: widget.entitySave,
            entityType: widget.entityType,
          );
        });
  }

  handleAction(item) async {
    dynamic data;
    if (item['type'] == 'seen_after') {
      data = {
        "bookmark_id": widget.entitySave['id'],
        "entity_type": widget.entityType
      };
    } else if (item['type'] == 'create') {
      Navigator.pop(context);
      showAlertDialog(context);
      return;
    } else {
      data = {
        "bookmark_id": widget.entitySave['id'],
        "entity_type": widget.entityType,
        "bookmark_collection_id": item['id']
      };
    }

    if (data != null) {
      var response = await BookmarkApi().bookmarkApi(data);

      if (response != null && mounted) {
        ref
            .read(postControllerProvider.notifier)
            .actionUpdateDetailInPost(widget.type, response,);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã lưu vào ${item['name']}")));
        if (mounted) {
          Navigator.pop(context);
        }

        setState(() {});
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lỗi, vui lòng thử lại sau")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Lưu vào",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.displayLarge!.color),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  FolderItem(
                    handleAction: handleAction,
                    item: const {
                      "icon": Icon(
                        FontAwesomeIcons.plus,
                        size: 20,
                        color: Colors.black87,
                      ),
                      "name": "Tạo bộ sưu tập",
                      "type": "create"
                    },
                  ),
                  FolderItem(handleAction: handleAction, item: const {
                    "type": 'seen_after',
                    "name": "Xem sau",
                    "icon": Icon(
                      FontAwesomeIcons.solidFolder,
                      size: 20,
                      color: Colors.black87,
                    )
                  }),
                  const CrossBar(
                    height: 0.5,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAlbums.length,
                      itemBuilder: ((context, index) =>
                          FolderItem(handleAction: handleAction, item: {
                            ...listAlbums[index],
                            "icon": const Icon(
                              FontAwesomeIcons.solidFolder,
                              size: 20,
                              color: Colors.black87,
                            )
                          }))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends ConsumerStatefulWidget {
  final bool isSavedMenuItem;
  final String type;
  final dynamic entitySave;
  final String entityType;
  const CustomAlertDialog({
    super.key,
    required this.type,
    required this.entitySave,
    required this.entityType,
    required this.isSavedMenuItem,
  });

  @override
  ConsumerState<CustomAlertDialog> createState() => _AlertDialogState();
}

class _AlertDialogState extends ConsumerState<CustomAlertDialog> {
  String name = '';

  handleCreateAndBookmark(name) async {
    var response = await BookmarkApi().createBookmarkAlbum({"name": name});
    if (response != null) {
      if (widget.isSavedMenuItem == true) {
        ref
            .read(savedControllerProvider.notifier)
            .updateAfterAddingNewCollection(name, response['id']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tạo mới thành công")),
          );
          Navigator.pop(context);
        }
      } else {
        var data = {
          "bookmark_id": widget.entitySave['id'],
          "entity_type": widget.entityType,
          "bookmark_collection_id": response['id']
        };
        var res = await BookmarkApi().bookmarkApi(data);

        if (res != null && mounted) {
          ref
              .read(postControllerProvider.notifier)
              .actionUpdateDetailInPost(widget.type, res);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đã lưu vào ${response['name']}")));
          Navigator.pop(context);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lỗi, vui lòng thử lại sau")));
          Navigator.pop(context);
        }
        setState(() {});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lỗi, vui lòng thử lại sau")));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Column(
        children: [
          Text('Tạo bộ sưu tập'),
          TextDescription(description: "Đặt tên cho bộ sưu tập của bạn")
        ],
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: CupertinoTextField(
          autofocus: true,
          placeholder: "Nhập tên bộ sưu tập",
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
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
          onPressed: name.split('').isNotEmpty
              ? () {
                  handleCreateAndBookmark(name);
                }
              : null,
          child: const Text('Tạo'),
        ),
      ],
    );
  }
}

class FolderItem extends StatelessWidget {
  final dynamic item;
  final Function handleAction;
  const FolderItem({
    super.key,
    this.item,
    required this.handleAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleAction(item);
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: greyColor[350],
                shape: BoxShape.circle,
              ),
              child: item['icon'],
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              item['name'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
