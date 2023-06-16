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

import 'item/collection_handle_item.dart';

class SeeAllBookmark extends ConsumerStatefulWidget {
  String? type;
  String? collectionId;
  String? collectionName;

  SeeAllBookmark({
    super.key,
    this.type,
    this.collectionId,
    this.collectionName,
  });
  @override
  SeeAllBookmarkState createState() => SeeAllBookmarkState();
}

class SeeAllBookmarkState extends ConsumerState<SeeAllBookmark> {
  bool isLoading = true;
  final itemList = [
    HandleItem(
      iconData: FontAwesomeIcons.solidPenToSquare,
      title: "Đổi tên bộ sưu tập",
      actionType: 'rename',
    ),
    HandleItem(
      iconData: FontAwesomeIcons.trash,
      title: "Xóa bộ sưu tập",
      actionType: 'delete',
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
      if (widget.type == 'collection_bookmark') {
        Future.delayed(Duration.zero, () => fetchCollectionBookmark());
      } else {
        Future.delayed(Duration.zero, () => fetchAllBookmark());
      }
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

  void fetchAllBookmark() async {
    await ref.read(savedControllerProvider.notifier).fetchAllCollection();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    final cltBookmarks = ref.watch(savedControllerProvider).currentBmBookmarks;
    final allBookmark = ref.watch(savedControllerProvider).bookmarks;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: widget.type == 'collection_bookmark'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const BackIconAppbar(),
                      const SizedBox(width: 10.0),
                      AppBarTitle(title: widget.collectionName!),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: itemList
                                    .map(
                                      (e) => CollectionHandleItem(
                                        item: e,
                                        collectionId: widget.collectionId!,
                                        collectionName: widget.collectionName!,
                                      ),
                                    )
                                    .toList(),
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
              )
            : Row(
                children: const [
                  BackIconAppbar(),
                  SizedBox(width: 10.0),
                  AppBarTitle(title: "Đã lưu"),
                ],
              ),
      ),
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
            isLoading || (cltBookmarks.isEmpty && allBookmark.isEmpty)
                ? const Center(child: CupertinoActivityIndicator())
                : widget.type == 'all' && allBookmark.isEmpty ||
                        widget.type == 'collection_bookmark' &&
                            cltBookmarks.isEmpty
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
                        height: height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.type == 'all'
                              ? allBookmark.length
                              : cltBookmarks.length,
                          itemBuilder: (context, index) {
                            var item = convertItem(
                              widget.type == 'all'
                                  ? allBookmark[index]
                                  : cltBookmarks[index],
                            );
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
