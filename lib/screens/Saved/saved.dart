import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';
import 'package:social_network_app_mobile/screens/Saved/see_all_bookmark.dart';
import 'package:social_network_app_mobile/screens/Saved/see_all_collection.dart';
import 'package:social_network_app_mobile/screens/Saved/item/bookmark_item.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/screens/Saved/item/collection_item.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/Bookmark/bookmark_page.dart';
import 'package:social_network_app_mobile/screens/Saved/item/place_holder.dart';

class Saved extends ConsumerStatefulWidget {
  const Saved({super.key});

  @override
  SavedState createState() => SavedState();
}

class SavedState extends ConsumerState<Saved> {
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () => initializeBookmarks());
    }
  }

  void initializeBookmarks() async {
    await ref.read(savedControllerProvider.notifier).initBookmark();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildCollections(
    dynamic collections,
    double height,
    double width,
    ThemeManager theme,
  ) {
    return Container(
      height: height > width
          ? collections.length <= 2
              ? height * 0.2
              : height * 0.4
          : collections.length <= 2
              ? height * 0.9
              : height * 1.75,
      child: collections.isNotEmpty
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              itemCount: collections.length >= 4 ? 4 : collections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                crossAxisCount: 2,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (context, index) {
                var item = collections[index];
                return CollectionItem(item: item);
              },
            )
          : Column(
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
            ),
    );
  }

  Widget _buildRowAction(ThemeManager theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Bộ sưu tập",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: theme.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) {
                  return const CustomAlertDialog(
                    isSavedMenuItem: true,
                    type: '',
                    entitySave: '',
                    entityType: '',
                  );
                },
              );
            },
            child: const Text(
              "Tạo",
              style: TextStyle(fontSize: 16.0, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarks(bookmarks, double height, double width) {
    return Container(
      height: height > width
          ? height * 0.38 * getRateListView(bookmarks.length)
          : height * 0.75 * getRateListView(bookmarks.length),
      child: bookmarks.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookmarks.length >= 3 ? 3 : bookmarks.length,
              itemBuilder: (context, index) {
                var item = convertItem(bookmarks[index]);
                return BookmarkItem(item: item);
              },
            )
          : Column(
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
            ),
    );
  }

  Widget _buildSeeAllButton(
    void Function() onTap,
    ThemeManager theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ButtonPrimary(
        colorText: Colors.black,
        colorButton: greyColor[300],
        label: "Xem tất cả",
        handlePress: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = pv.Provider.of<ThemeManager>(context);
    var bookmarks = ref.watch(savedControllerProvider).bookmarks;
    var collections = ref.watch(savedControllerProvider).bmCollections;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8.0),
      child: SingleChildScrollView(
        child: isLoading || (bookmarks.isEmpty && collections.isEmpty)
            // ? const Center(child: CupertinoActivityIndicator())
            ? Center(child: SavedWaitingSkeleton())
            : bookmarks.isEmpty && collections.isEmpty
                ? Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/wow-emo-2.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                      ),
                      const Text('Bạn chưa lưu bài viết nào'),
                    ],
                  )
                : collections.isNotEmpty && bookmarks.isNotEmpty
                    ? Column(
                        children: [
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Gần đây',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              )),
                          _buildBookmarks(bookmarks, height, width),
                          _buildSeeAllButton(() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SeeAllBookmark(),
                              ),
                            );
                          }, theme),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Divider(height: 1.0, color: Colors.grey),
                          ),
                          _buildRowAction(theme),
                          _buildCollections(collections, height, width, theme),
                          _buildSeeAllButton(() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SeeAllCollection(
                                  collections: collections,
                                ),
                              ),
                            );
                          }, theme),
                        ],
                      )
                    : collections.isNotEmpty && bookmarks.isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'Bạn chưa lưu bài viết nào',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 17.5),
                              _buildRowAction(theme),
                              _buildCollections(
                                  collections, height, width, theme),
                              _buildSeeAllButton(() {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => SeeAllCollection(
                                      collections: collections,
                                    ),
                                  ),
                                );
                              }, theme),
                            ],
                          )
                        : const SizedBox(),
      ),
    );
  }
}
