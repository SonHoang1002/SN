import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  SavedState createState() => SavedState();
}

class SavedState extends State<Saved> {
  List collections = [];
  List bookmarks = [];

  void initBookmark() async {
    // get all bookmark of users
    var bmResult = await BookmarkApi().fetchAllBookmark();

    // get all collection of users
    var cltResult = await BookmarkApi().fetchBookmarkCollection();

    var renderCollections = [];
    for (var i = 0; i < cltResult.length; i++) {
      var collection = cltResult[i];
      var bookmarks = bmResult
          .where((e) =>
              e['bookmark_collection'] != null &&
              e['bookmark_collection']['id'] == collection['id'])
          .toList();

      if (bookmarks.isNotEmpty) {
        var earliest =
            DateTime.parse(bookmarks[0]['created_at']).millisecondsSinceEpoch;
        var index = 0;
        for (var j = 0; j < bookmarks.length; j++) {
          int createAt =
              DateTime.parse(bookmarks[j]['created_at']).millisecondsSinceEpoch;
          if (createAt <= earliest) {
            earliest = createAt;
            index = j;
          }
        }
        collection['imageUrl'] = getBookmarkImageUrl(bmResult[index]);
      }
      renderCollections.add(collection);
    }

    setState(() {
      collections = renderCollections;
      bookmarks = bmResult;
    });
  }

  @override
  void initState() {
    initBookmark();
    super.initState();
  }

  Widget _buildCollections(
    dynamic collections,
    double height,
    ThemeManager theme,
  ) {
    return Container(
      height: height * 0.4,
      child: GridView.builder(
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
          return CardComponents(
            imageCard: SizedBox(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height / 8.5,
                ),
              ),
            ),
            onTap: () {},
            textCard: Container(
              // color: Colors.red,
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
                top: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Chỉ mình tôi',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
            onPressed: () {},
            child: const Text(
              "Tạo",
              style: TextStyle(
                fontSize: 16.0,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarks(bookmarks, double height, ThemeManager theme) {
    return Container(
      height: height * 0.4,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: bookmarks.length >= 3 ? 3 : bookmarks.length,
        itemBuilder: (context, index) {
          var item = convertItem(bookmarks[index]);
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
                      item['imageUrl'],
                      fit: BoxFit.cover,
                      height: height / 10,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          width: double.infinity,
                          child: Text(
                            item['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: item['type'] == 'status'
                                ? "Bài viết của "
                                : "Trang",
                            style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: item['author'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                    onTap: () {},
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
        },
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

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8.0),
      child: SingleChildScrollView(
        child: collections.isEmpty || bookmarks.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : Column(
                children: [
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  _buildBookmarks(bookmarks, height, theme),
                  _buildSeeAllButton(() {}, theme),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: const Divider(height: 1.0, color: Colors.grey),
                  ),
                  _buildRowAction(theme),
                  _buildCollections(collections, height, theme),
                  _buildSeeAllButton(() {}, theme),
                ],
              ),
      ),
    );
  }
}
