import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';
import 'package:social_network_app_mobile/screens/Saved/item/bookmark_item.dart';
import 'package:social_network_app_mobile/screens/Saved/item/place_holder.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class SeeAllBookmark extends ConsumerStatefulWidget {
  SeeAllBookmark({super.key});
  @override
  SeeAllBookmarkState createState() => SeeAllBookmarkState();
}

class SeeAllBookmarkState extends ConsumerState<SeeAllBookmark> {
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () => fetchAllBookmark());
    }
  }

  void fetchAllBookmark() async {
    await ref.read(savedControllerProvider.notifier).fetchAllBookmark();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    final allBookmark = ref.watch(savedControllerProvider).bookmarks;

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
            isLoading
                ? Center(child: BookmarkListSkeleton())
                : allBookmark.isEmpty
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
                          itemCount: allBookmark.length,
                          itemBuilder: (context, index) {
                            var item = convertItem(allBookmark[index]);
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
