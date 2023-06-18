import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';
import 'package:social_network_app_mobile/screens/Saved/item/bookmark_item.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../theme/colors.dart';
import '../../widgets/show_modal_message.dart';
import '../../widgets/text_description.dart';

class HandleItem {
  IconData iconData;
  String title;
  HandleItem({required this.iconData, required this.title});
}

class CollectionItem extends StatelessWidget {
  HandleItem item;
  CollectionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.0,
          backgroundColor: greyColor[350],
          child: Icon(
            item.iconData,
            size: 18.0,
            color: Colors.black,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
      ],
    );
  }
}

class SeeCollectionBookmark extends ConsumerStatefulWidget {
  String? type;
  String? collectionId;
  String? collectionName;

  SeeCollectionBookmark({
    super.key,
    this.collectionId,
    this.collectionName,
  });
  @override
  SeeCollectionBookmarkState createState() => SeeCollectionBookmarkState();
}

class SeeCollectionBookmarkState extends ConsumerState<SeeCollectionBookmark> {
  TextEditingController _controller = TextEditingController();
  bool isLoading = true;
  final itemList = [
    HandleItem(
      iconData: FontAwesomeIcons.solidPenToSquare,
      title: "Đổi tên bộ sưu tập",
    ),
    HandleItem(
      iconData: FontAwesomeIcons.trash,
      title: "Xóa bộ sưu tập",
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () => fetchCollectionBookmark());
    }
  }

  void fetchCollectionBookmark() async {
    await ref
        .read(savedControllerProvider.notifier)
        .fetchBookmarkOfOneCollection(widget.collectionId);
    setState(() {
      isLoading = false;
    });
  }

  void handleDelete(collectionId, BuildContext context) async {
    await ref
        .read(savedControllerProvider.notifier)
        .deleteOneCollection(collectionId);
    if (mounted) {
      Navigator.pop(context);
      showSnackbar(context, "Xóa bộ sưu tập thành công");
      Navigator.pop(context);
    }
  }

  void handleRename(collectionId, String newName, BuildContext context) async {
    await ref
        .read(savedControllerProvider.notifier)
        .renameOneCollection(collectionId, newName);
    if (mounted) {
      Navigator.pop(context);
      showSnackbar(context, "Đổi tên thành công");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    final cltBookmarks = ref.watch(savedControllerProvider).currentCltBookmarks;
    final collections = ref.watch(savedControllerProvider).bmCollections;
    final index = collections.indexWhere(
      (e) => e['id'] == widget.collectionId,
    );
    _controller.text = collections[index]['name'];

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const BackIconAppbar(),
                  const SizedBox(width: 10.0),
                  AppBarTitle(title: collections[index]['name']),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 120.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.5,
                            vertical: 15.0,
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Column(
                                          children: const [
                                            Text('Đổi tên bộ sưu tập'),
                                            TextDescription(
                                              description:
                                                  "Nhập tên mới cho bộ sưu tập này",
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          margin: EdgeInsets.only(top: 8.0),
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
                                            onPressed: _controller.text
                                                    .split('')
                                                    .isNotEmpty
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
                                },
                                child: CollectionItem(item: itemList[0]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showCupertinoDialog(
                                    context: context,
                                    builder: ((context) {
                                      return CupertinoAlertDialog(
                                        content: Container(
                                          margin: EdgeInsets.only(top: 8.0),
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
                                              handleDelete(
                                                widget.collectionId,
                                                context,
                                              );
                                            },
                                            child: const Text('Gỡ, xóa'),
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                },
                                child: CollectionItem(item: itemList[1]),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 25.0,
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text(
                    widget.type == 'collection_bookmark'
                        ? 'Chỉ mình tôi'
                        : 'Danh sách đã lưu',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: widget.type == 'all'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            isLoading || cltBookmarks.isEmpty
                ? const Center(child: CupertinoActivityIndicator())
                : cltBookmarks.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/wow-emo-2.gif",
                              height: 125.0,
                              width: 125.0,
                            ),
                          ),
                          const Text('Bạn chưa lưu mục nào ở đây'),
                        ],
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        margin: const EdgeInsets.symmetric(vertical: 15.0),
                        // height: height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cltBookmarks.length,
                          itemBuilder: (context, idx) {
                            var item = convertItem(cltBookmarks[idx]);
                            return BookmarkItem(item: item);
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
