import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/Bookmark/bookmark_item.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class SeeAllBookmark extends ConsumerStatefulWidget {
  dynamic bookmarks;

  SeeAllBookmark({super.key, this.bookmarks});
  @override
  SeeAllBookmarkState createState() => SeeAllBookmarkState();
}

class SeeAllBookmarkState extends ConsumerState<SeeAllBookmark> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: const [
            BackIconAppbar(),
            SizedBox(width: 10.0),
            AppBarTitle(title: "Danh sách đã lưu"),
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
                    'Danh sách đã lưu',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              height: height,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.bookmarks.length,
                itemBuilder: (context, index) {
                  var item = convertItem(widget.bookmarks[index]);
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
